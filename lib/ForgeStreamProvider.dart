import 'dart:async';

import 'package:dio/dio.dart';
import 'package:forge/ForgeData.dart';
import 'package:forge/ForgeError.dart';
import 'package:forge/ForgeOptions.dart';
import 'package:forge/ForgeProvider.dart';

class ForgeStreamProvider {
  ForgeProvider provider;

  ForgeStreamProvider({ForgeOptions op}) {
    provider = ForgeProvider(op: op);
  }

  Stream<ForgeData<T>> get<T>(String path,
      {Map<String, dynamic> queryParameters,
      Options options,
      CancelToken cancelToken,
      ProgressCallback onReceiveProgress,
      T decode(res)}) {
    var stream = Stream.fromFuture(this.provider.get(path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress));

    return MakeFutrueToStream().ob(stream, StreamController(), decode).stream;
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

    return MakeFutrueToStream()
        .ob(Stream.fromFuture(future), StreamController(), decode)
        .stream;
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
      else {
        return forge;
      }
    } else {
      throw ForgeError(response: res, error: forge.message, code: forge.code);
    }
  }
}

class MakeFutrueToStream {
  StreamController<ForgeData<T>> ob<T>(
      Stream<Response<dynamic>> stream, StreamController<ForgeData<T>> con,
      [T decode(res)]) {
    stream.listen((event) {
      try {
        con.add(ParseData().forgeData(event, decode));
      } catch (e) {
        con.addError(e);
      }
    }, onError: con.addError, onDone: con.close);
    return con;
  }
}
