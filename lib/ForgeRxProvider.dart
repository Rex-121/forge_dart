import 'dart:async';

import 'package:dio/dio.dart';
import 'package:forge/ForgeData.dart';
import 'package:forge/ForgeInterceptors.dart';
import 'package:forge/ForgeOptions.dart';
import 'package:forge/ForgeProvider.dart';
import 'package:forge/ForgeStreamProvider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ForgeRxProvider with ForgeMixin {
  Dio provider;

  ForgeRxProvider({ForgeOptions op, List<ForgeInterceptor> interceptors}) {
    provider = ForgeProviderFactory.Make(op: op);
    this.forgeIntercept = interceptors;
  }

  PublishSubject<ForgeData<T>> get<T>(String path,
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

    return MakeFutrueToStream(PublishSubject<ForgeData<T>>(),
            interceptors: forgeInterceptors)
        .ob(stream, decode);
  }

  PublishSubject<ForgeData<T>> post<T>(String path,
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

    return MakeFutrueToStream(PublishSubject<ForgeData<T>>(),
            interceptors: forgeInterceptors)
        .ob(Stream.fromFuture(future), decode);
  }
}
