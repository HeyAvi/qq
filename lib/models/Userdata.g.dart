// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Userdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Userdata _$UserdataFromJson(Map<String, dynamic> json) => Userdata(
    json['user_id'] == null ? "" : json['user_id'] as String,
    json['name'] == null ? "" : json['name'] as String,
    json['email'] == null ? "" : json['email'] as String,
    json['phone'] == null ? "" : json['phone'] as String,
    json['is_verified'] == null ? "" : json['is_verified'] as String,
    json['app_key'] == null ? "" : json['app_key'] as String,
    json['refer_code'] == null ? "" : json['refer_code'] as String,
    json['refer_code_used'] == null ? "" : json['refer_code_used'] as String,
    json['image'] == null ? "" : json['image'] as String,
    json['address'] == null ? "" : json['address'] as String,
    json['bank'] == null ? "" : json['bank'] as String,
    json['is_eligible'] == null ? "" : json['is_eligible'] as String,
    json['created_at'] == null ? "" : json['created_at'] as String,
    json['updated_at'] == null ? "" : json['updated_at'] as String,
    json['deleted_at'] == null ? "" : json['deleted_at'] as String,
);

Map<String, dynamic> _$UserdataToJson(Userdata instance) => <String, dynamic>{
  'user_id': instance.user_id,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'is_verified': instance.is_verified,
  'app_key' : instance.app_key,
  'refer_code' : instance.refer_code,
  'refer_code_used': instance.refer_code_used,
  'image' : instance.image,
  'address' : instance.address,
  'bank' : instance.bank,
  'is_eligible' : instance.is_eligible,
  'created_at' : instance.created_at,
  'updated_at' : instance.updated_at,
  'deleted_at' : instance.deleted_at
};
