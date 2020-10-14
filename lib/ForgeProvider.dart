import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:forge/ForgeError.dart';
import 'package:forge/ForgeOptions.dart';
import 'package:forge/ForgeData.dart';

class ForgeProvider extends DioForNative {
  ForgeProvider({ForgeOptions op}) : super(op);
}

class ForgeStreamProvider {
  ForgeProvider provider;

  ForgeStreamProvider({ForgeOptions op}) {
    provider = ForgeProvider(op: op);
  }

  void ob<T>(
      Stream<Response<dynamic>> stream, StreamController<ForgeData<T>> con,
      [T decode(res)]) {
    stream.listen((event) {
      try {
        con.add(ParseData().forgeData(event, decode));
      } catch (e) {
        con.addError(e);
      }
    }, onError: con.addError, onDone: con.close);
  }

  Stream<ForgeData<T>> get<T>(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress,
      T decode(res)}) {
    StreamController<ForgeData<T>> con = StreamController();
    var stream = Stream.fromFuture(this.provider.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress));
    ob(stream, con);
    return con.stream;
  }

  Stream<ForgeData<T>> post<T>(String path,
      {data,
      Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onSendProgress,
      ProgressCallback onReceiveProgress,
      T decode(res)}) {
    var future = this.provider.post(path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress);

    StreamController<ForgeData<T>> con = StreamController();

    ob(Stream.fromFuture(future), con);

    return con.stream;
  }
}

/// 解析数据
class ParseData {
// ignore: missing_return
  ForgeData<T> forgeData<T>(Response res, [T decode(res)]) {
    ForgeData forge;
    try {
      forge = ForgeData.fromJson(res.data, (a) => a);
    } catch (e) {
      throw ForgeError.parseWrong(res);
    }

    if (forge.success) {
      if (decode != null) {
        try {
          return ForgeData.fromJson(res.data, decode);
        } catch (e) {
          throw ForgeError.parseWrong(res);
        }
      }
    } else {
      throw ForgeError(response: res, error: forge.message);
    }
  }
}
