

import 'package:json_annotation/json_annotation.dart';

part 'testData.g.dart';

@JsonSerializable()
class TestingData {

@JsonKey()
String title;

TestingData(this.title);

factory TestingData.fromJson(
          Map<String, dynamic> srcJson) =>
      _$TestingDataFromJson(srcJson);

  Map<String, dynamic> toJson() =>
      _$TestingDataToJson(this);

}