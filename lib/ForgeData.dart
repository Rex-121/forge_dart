
import 'package:json_annotation/json_annotation.dart';

part 'ForgeData.g.dart';


@JsonSerializable(genericArgumentFactories: true, checked: true)
class ForgeData<T> extends Object {

  /// 状态码
  @JsonKey(name: 'result')
  int? code;

  @JsonKey(name: 'msg')
  String? message;

  @JsonKey(name: 'data')
  T data;

  /// 是否成功
  bool get success => code == 0;

  ForgeData(
    this.code,
    this.message,
    this.data,
  );

  factory ForgeData.fromxJson(Map<String, dynamic> json,
      T Function(Map<String, dynamic> json) fromJsonT) {
    return ForgeData.fromJson(
        json, (json) => fromJsonT((json as Map<String, dynamic>?) ?? {}));
  }

  // factory ForgeData.justValue(Map<String, dynamic> json) {
  //   return ForgeData.fromJson(
  //       json, (json) {
  //         if (json == null) return null;
  //         return null;
  //       });
  // }

  factory ForgeData.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ForgeDataFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ForgeDataToJson(this, toJsonT);
}