// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ForgeData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgeData<T> _$ForgeDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object json) fromJsonT,
) {
  return ForgeData<T>(
    json['code'] as int,
    json['message'] as String,
    fromJsonT(json['data']),
  );
}

Map<String, dynamic> _$ForgeDataToJson<T>(
  ForgeData<T> instance,
  Object Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': toJsonT(instance.data),
    };
