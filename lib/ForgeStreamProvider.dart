import 'dart:async';

import 'package:dio/dio.dart';
import 'package:forge/ForgeData.dart';
import 'package:forge/ForgeError.dart';
import 'package:forge/ForgeInterceptors.dart';
import 'package:forge/ForgeOptions.dart';
import 'package:forge/ForgeProvider.dart';
import 'package:rxdart/subjects.dart';

class ForgeStreamProvider with ForgeMixin {
  late Dio provider;

  ForgeStreamProvider({ForgeOptions? op, List<ForgeInterceptor>? interceptors}) {
    provider = ForgeProviderFactory.Make(op: op);
    this.forgeIntercept = interceptors;
  }

  Stream<ForgeData<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      T decode(res)?}) {
    var stream = Stream.fromFuture(this.provider.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress));

    return MakeFutrueToStream<T>(PublishSubject<ForgeData<T>>(),
            interceptors: forgeInterceptors)
        .ob(stream, decode)
        .stream;
  }

  Stream<ForgeData<T>> post<T>(String path,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      T decode(res)?}) {
    var future = this.provider.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);

    return MakeFutrueToStream<T>(PublishSubject<ForgeData<T>>(),
            interceptors: forgeInterceptors)
        .ob(Stream.fromFuture(future), decode)
        .stream;
  }
}

/// 解析数据
class ParseData {
// ignore: missing_return
  ForgeData<T> forgeData<T>(Response res, [T decode(res)?]) {
    ForgeData forge;
    try {
      forge = ForgeData.fromJson(res.data, (a) => a);
    } catch (e) {
      throw ForgeError.parseWrong(res);
    }

    if (forge.success) {
      if (decode != null) {
        try {
          return ForgeData<T>.fromJson(res.data, decode);
        } catch (e) {
          throw ForgeError.parseWrong(res);
        }
      } else {
        return forge as ForgeData<T>;
      }
    } else {
      throw ForgeError(response: res, error: forge.message, code: forge.code);
    }
  }
}

class MakeFutrueToStream<T> {
  List<ForgeInterceptor>? _interceptors;

  PublishSubject<ForgeData<T>> controller;

  MakeFutrueToStream(this.controller, {List<ForgeInterceptor>? interceptors})
      : _interceptors = interceptors;

  PublishSubject<ForgeData<T>> ob(Stream<Response<dynamic>> stream,
      [T decode(res)?]) {
    stream.listen((event) {
      try {
        _remakeData(ParseData().forgeData(event, decode));
      } catch (e) {
        _remakeError(e);
      }
    }, onError: _remakeError, onDone: controller.close);
    return controller;
  }

  void _remakeError(dynamic error) {
    var newError = error;
    _interceptors?.forEach((element) {
      if (error is DioError) {
        newError = element
            .onError(ForgeError(response: error.response, error: error.error));
      } else {
        newError = element.onError(error);
      }
    });

    controller.addError(newError);
  }

  void _remakeData(ForgeData<T> data) async {
    var newData = data;
    try {
      _interceptors?.forEach((element) {
        newData = element.onData(newData) as ForgeData<T>;
      });
      controller.add(newData);
    } catch (e) {
      _remakeError(e);
    }
  }
}
