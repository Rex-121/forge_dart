// import 'dart:async';

// import 'package:dio/dio.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge/ForgeData.dart';
// import 'package:forge/ForgeData.dart';
import 'package:forge/ForgeOptions.dart';
import 'package:forge/ForgeProvider.dart';
import 'package:forge/ForgeStreamProvider.dart';
// import 'package:forge/ForgeData.dart';
// import 'package:forge/ForgeOptions.dart';
// import 'package:forge/ForgeProvider.dart';
// import 'package:forge/ForgeRxProvider.dart';
// import 'package:forge/ForgeStreamProvider.dart';

import 'ApiAddress.dart';
import 'testData.dart';
// import 'testData.dart';

ForgeOptions httpOptions = ForgeOptions(host);

void main() {
  test("Wrong Psw", () async {
    // var dio = Dio();
    // final response = await dio.get(
    //     'http://appcourse.roobo.com.cn/student/v1/course/5463/lesson/6867/round/list');
    // print(response.data);
    Dio http = ForgeProviderFactory.Make(op: httpOptions);

    // var params = {'loginName': "17191220337", "pwd": "fad"};

    Response response = await http.get("/course/5463/lesson/6867/round/list");
    print(response.data);

    ForgeData data = ForgeData.fromJson(response.data, (a) => a);

    print(data.success);
    print(data.data);
    print(data.message);
    print(data.code);

    // expect(data.success, false);
  });

  test("JustATitle", () async {
    Map<String, dynamic> k = {
      "data": {"title": "JustATitle"},
      "code": 1024,
      "message": "",
      "success": true
    };

    TestingData? data =
        ForgeData<TestingData?>.fromxJson(k, (a) => TestingData.fromJson(a))
            .data;

    expect(data?.title, "JustATitle");
  });

  test("AsString", () async {
    Map<String, dynamic> k = {
      "data": "string",
      "code": 1024,
      "message": "var",
      "success": true
    };

    String data = ForgeData<String>.fromJson(k, (a) => a as String).data;

    print(data);
    // print(data ==("string"));
    expect(data, "string");
  });

  test("RX", () async {
    ForgeStreamProvider http = ForgeStreamProvider(op: httpOptions);

    // var params = {'loginName': phone, "pwd": "fad"};

    http.get("/course/5463/lesson/6867/round/list").listen((event) {
      print(event);
    }, onDone: () {
      print("done");
    }, onError: (e) {
      print(e);
    });

    await Future.delayed(Duration(minutes: 29));
  });

  // test("Stream", () async {
  //   ForgeStreamProvider http = ForgeStreamProvider(op: httpOptions);

  //   var params = {'loginName': phone, "pwd": "fad"};

  //   http.post("/user/checkPass", data: params).listen((event) {
  //     print(event);
  //   }, onError: (e) {
  //     print("error " + e.message);
  //   }, onDone: () {
  //     print("done");
  //   });

  //   await Future.delayed(Duration(minutes: 10));
  //   // print(z.)
  // }, timeout: Timeout(Duration(seconds: 12)));

  // test("Rx", () async {

  //   ForgeRxProvider http = ForgeRxProvider(op: httpOptions);

  //   var params = {'loginName': phone, "pwd": "f1eee8efd4d339bb0b21e8be4f786b12"};

  //   http.post("/user/checkPass", data: params).listen((event) {
  //     print(event);
  //   }, onError: (e) {
  //     print("error " + e.message);
  //   }, onDone: () {
  //     print("done");
  //   });

  //   await Future.delayed(Duration(minutes: 10));
  //   // print(z.)
  // }, timeout: Timeout(Duration(seconds: 12)));
}
