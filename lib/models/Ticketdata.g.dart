// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Ticketdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticketdata _$TicketdataFromJson(Map<String, dynamic> json) => Ticketdata(
  json['ticket_id'] == null ? "" : json['ticket_id'] as String,
  json['user_id'] == null ? "" : json['user_id'] as String,
  json['ticket_code'] == null ? "" : json['ticket_code'] as String,
  json['is_used'] == null ? "" : json['is_used'] as String,
  json['created_at'] == null ? "" : json['created_at'] as String,
  json['updated_at'] == null ? "" : json['updated_at'] as String,
  json['deleted_at'] == null ? "" : json['deleted_at'] as String,
);

Map<String, dynamic> _$TicketdataToJson(Ticketdata instance) => <String, dynamic>{
      'ticket_id': instance.ticket_id,
      'user_id': instance.user_id,
      'ticket_code': instance.ticket_code,
      'is_used': instance.is_used,
      'created_at': instance.created_at,
      'updated_at' : instance.updated_at,
      'deleted_at' : instance.deleted_at
    };
