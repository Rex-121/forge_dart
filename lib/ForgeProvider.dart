import 'dart:io';

import 'package:dio/browser_imp.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:forge/ForgeOptions.dart';

class ForgeProviderFactory {

  static Dio Make({ForgeOptions op}) {
    // if (Platform.isAndroid || Platform.isIOS) {
    //   return _ForgeProvider(op: op);
    // }
    return _WebForgeProvider(op: op);
  }

}


class _ForgeProvider extends DioForNative {
  _ForgeProvider({ForgeOptions op}) : super(op);
}

class _WebForgeProvider extends DioForBrowser {
  _WebForgeProvider({ForgeOptions op}) : super(op);
}