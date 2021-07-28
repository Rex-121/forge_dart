
import 'package:dio/dio.dart';
// import 'package:dio/native_imp.dart';
import 'package:forge/ForgeOptions.dart';

class ForgeProviderFactory {

  static Dio make({ForgeOptions? op})  => Dio(op);

}


// class _ForgeProvider extends DioForNative {
//   _ForgeProvider({ForgeOptions? op}) : super(op);
// }

// class _WebForgeProvider extends DioForBrowser {
//   _WebForgeProvider({ForgeOptions? op}) : super(op);
// }