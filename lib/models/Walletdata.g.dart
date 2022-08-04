// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Walletdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Walletdata _$WalletdataFromJson(Map<String, dynamic> json) => Walletdata(
  json['wallet_id'] == null ? "" : json['wallet_id'] as String,
  json['user_id'] == null ? "" : json['user_id'] as String,
  json['amount'] == null ? "" : json['amount'] as String,
  json['transaction_type'] == null ? "" : json['transaction_type'] as String,
  json['remarks'] == null ? "" : json['remarks'] as String,
  json['response'] == null ? "" : json['response'] as String,
  json['status'] == null ? "" : json['status'] as String,
  json['created_at'] == null ? "" : json['created_at'] as String,
  json['updated_at'] == null ? "" : json['updated_at'] as String,
  json['deleted_at'] == null ? "" : json['deleted_at'] as String,
);

Map<String, dynamic> _$WalletdataToJson(Walletdata instance) =>
    <String, dynamic>{
      'wallet_id': instance.wallet_id,
      'user_id': instance.user_id,
      'amount': instance.amount,
      'transaction_type': instance.transaction_type,
      'remarks': instance.remarks,
      'response': instance.response,
      'status': instance.status,
      'created_at': instance.created_at,
      'updated_at' : instance.updated_at,
      'deleted_at' : instance.deleted_at
    };
