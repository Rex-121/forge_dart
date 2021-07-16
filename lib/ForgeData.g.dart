// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ForgeData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForgeData<T> _$ForgeDataFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) {
  return $checkedNew('ForgeData', json, () {
    final val = ForgeData<T>(
      $checkedConvert(json, 'code', (v) => v as int?),
      $checkedConvert(json, 'msg', (v) => v as String?),
      $checkedConvert(json, 'data', (v) => fromJsonT(v)),
    );
    return val;
  }, fieldKeyMap: const {'message': 'msg'});
}

Map<String, dynamic> _$ForgeDataToJson<T>(
  ForgeData<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.message,
      'data': toJsonT(instance.data),
    };
