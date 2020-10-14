import 'package:dio/dio.dart';

class ForgeError implements Exception {
  ForgeError({
    this.response,
    this.error,
  });

  /// Response info, it may be `null` if the request can't reach to
  /// the http server, for example, occurring a dns error, network is not available.
  Response response;

  /// The original error/exception object; It's usually not null when `type`
  /// is DioErrorType.DEFAULT
  dynamic error;

  String get message => (error?.toString() ?? '');

  @override
  String toString() {
    var msg = 'ForgeError : $message';
    if (error is Error) {
      msg += '\n${error.stackTrace}';
    }
    return msg;
  }

  static ForgeError parseWrong([Response res]) => ForgeError(error: "解析错误", response: res);
  
}
