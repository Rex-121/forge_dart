import 'package:dio/dio.dart';

class ForgeOptions extends BaseOptions {
  ForgeOptions(String baseUrl,
      {contentType: "application/x-www-form-urlencoded",
      Map<String, dynamic> headers})
      : super(baseUrl: baseUrl, contentType: contentType) {
    headers.forEach((key, value) {
      this.headers[key] = value;
    });
  }
}
