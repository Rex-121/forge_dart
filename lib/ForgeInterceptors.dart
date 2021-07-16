import 'package:forge/ForgeData.dart';
import 'package:forge/ForgeError.dart';

abstract class ForgeMixin {
  List<ForgeInterceptor> _interceptors = []; // = ForgeInterceptor();

  List<ForgeInterceptor> get forgeInterceptors => _interceptors;

  set forgeIntercept(List<ForgeInterceptor>? c) {
    _interceptors = c ?? [];
  }
}

typedef ForgeInterceptorErrorCallback = ForgeError Function(ForgeError e);
typedef ForgeInterceptorSuccessCallback = ForgeData Function(ForgeData e);

class ForgeInterceptor {
  final ForgeInterceptorErrorCallback? _onError;
  final ForgeInterceptorSuccessCallback? _onData;

  ForgeInterceptor({
    ForgeInterceptorSuccessCallback? onData,
    ForgeInterceptorErrorCallback? onError,
  })  : _onData = onData,
        _onError = onError;

  ForgeData onData(ForgeData data) {
    if (_onData != null) {
      return _onData!(data);
    }
    return data;
  }

  ForgeError onError(ForgeError e) {
    if (_onError != null) {
      return _onError!(e);
    }
    return e;
  }
}