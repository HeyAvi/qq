// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContestUserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestUserData _$ContestUserDataFromJson(Map<String, dynamic> json) => ContestUserData(
  json['time_taken'] == null ? "" : json['time_taken'] as String,
  json['user_id'] == null ? "" : json['user_id'] as String,
  json['name'] == null ? "" : json['name'] as String,
);

Map<String, dynamic> _$ContestUserDataToJson(ContestUserData instance) => <String, dynamic>{
  'time_taken': instance.time_taken,
  'user_id': instance.user_id,
  'name': instance.name,
};
