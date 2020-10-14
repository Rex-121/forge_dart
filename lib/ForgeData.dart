
import 'package:json_annotation/json_annotation.dart';

part 'ForgeData.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ForgeData<T> extends Object {
  @JsonKey()
  /// 状态码
  int code;


  @JsonKey()
  /// 
  String message;

  @JsonKey(name: 'data', nullable: true)
  T data;

  /// 是否成功
  bool get success => code == 0;

  ForgeData(
    this.code,
    this.message,
    this.data,
  );

  factory ForgeData.fromJson(
          Map<String, dynamic> srcJson, T Function(Object) fromJsonT) =>
      _$ForgeDataFromJson(srcJson, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$ForgeDataToJson(this, toJsonT);
}