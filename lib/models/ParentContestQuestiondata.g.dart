// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ParentContestQuestiondata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ParentContestQuestiondata _$ParentContestQuestiondataFromJson(Map<String, dynamic> json) => ParentContestQuestiondata(
  json['question'] == null ? null : json['question'] as Map<String,dynamic>,
  json['is_submitted'] == null ? false : json['is_submitted'] as bool,
);

Map<String, dynamic> _$ParentContestQuestiondataToJson(ParentContestQuestiondata instance) =>
    <String, dynamic>{
      'question': instance.question,
      'is_submitted': instance.is_submitted,
    };
