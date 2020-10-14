import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge/ForgeData.dart';
import 'package:forge/ForgeOptions.dart';
import 'package:forge/ForgeProvider.dart';

import 'ApiAddress.dart';
import 'testData.dart';

ForgeOptions httpOptions =
    ForgeOptions(host, headers: {"carrierId": "102", "authority": authority});

void main() {
  test("Wrong Psw", () async {
    ForgeProvider http = ForgeProvider(op: httpOptions);

    var params = {'loginName': "17191220337", "pwd": "fad"};

    Response response = await http.post("/user/checkPass", data: params);

    ForgeData data = ForgeData.fromJson(response.data, (a) => a);

    print(data.success);

    expect(data.success, false);
  });

  test("JustATitle", () async {
    Map<String, dynamic> k = {
      "data": {"title": "JustATitle"},
      "code": 1024,
      "message": "",
      "success": true
    };

    TestingData data =
        ForgeData<TestingData>.fromJson(k, (a) => TestingData.fromJson(a)).data;

    expect(data.title, "JustATitle");
  });

  test("AsString", () async {
    Map<String, dynamic> k = {
      "data": "string",
      "code": 1024,
      "message": "var",
      "success": true
    };

    String data = ForgeData<String>.fromJson(k, (a) => a).data;

    expect(data, "string");
  });

  test("RX", () async {
    ForgeStreamProvider http = ForgeStreamProvider(op: httpOptions);

    var params = {'loginName': phone, "pwd": "fad"};

    http.post("/user/checkPass", data: params).listen((event) {
      print(event);
    }, onDone: () {
      print("done");
    }, onError: (e) {
      print(e);
    });

    await Future.delayed(Duration(minutes: 29));
  });

  test("Stream", () async {
    ForgeStreamProvider http = ForgeStreamProvider(op: httpOptions);

    var params = {'loginName': "17191220337", "pwd": "fad"};

    http.post("/user/checkPass", data: params).listen((event) {
      print(event);
    }, onError: (e) {
      print("error " + e.message);
    }, onDone: () {
      print("done");
    });

    await Future.delayed(Duration(minutes: 10));
    // print(z.)
  }, timeout: Timeout(Duration(seconds: 12)));
}
