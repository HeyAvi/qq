// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Contestdata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contestdata _$ContestdataFromJson(Map<String, dynamic> json) => Contestdata(
    json['contest_id'] == null ? "" : json['contest_id'] as String,
    json['name'] == null ? "" : json['name'] as String,
    json['start_date'] == null ? "" : json['start_date'] as String,
    json['end_date'] == null ? "" : json['end_date'] as String,
    json['contest_time'] == null ? "" : json['contest_time'] as String,
    json['rules'] == null ? "" : json['rules'] as String,
    json['winner_zone'] == null ? "" : json['winner_zone'] as String,
    json['contest_type'] == null ? "" : json['contest_type'] as String,
    json['max_participants'] == null ? "" : json['max_participants'] as String,
    json['image'] == null ? "" : json['image'] as String,
    json['max_winner'] == null ? "" : json['max_winner'] as String,
    json['winning_by'] == null ? "" : json['winning_by'] as String,
    json['created_at'] == null ? "" : json['created_at'] as String,
    json['updated_at'] == null ? "" : json['updated_at'] as String,
    json['deleted_at'] == null ? "" : json['deleted_at'] as String,
    json['description'] == null ? "" : json['description'] as String
);

Map<String, dynamic> _$ContestdataToJson(Contestdata instance) => <String, dynamic>{
  'contest_id': instance.contest_id,
  'name': instance.name,
  'start_date': instance.start_date,
  'end_date': instance.end_date,
  'contest_time': instance.contest_time,
  'rules': instance.rules,
  'winner_zone' : instance.winner_zone,
  'contest_type' : instance.contest_type,
  'max_participants': instance.max_participants,
  'image' : instance.image,
  'max_winner': instance.max_winner,
  'winning_by' : instance.winning_by,
  'created_at' : instance.created_at,
  'updated_at' : instance.updated_at,
  'deleted_at' : instance.deleted_at,
  'description' : instance.description
};
