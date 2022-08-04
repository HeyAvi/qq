// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ContestQuestiondata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContestQuestiondata _$ContestQuestiondataFromJson(Map<String, dynamic> json) => ContestQuestiondata(
  json['question_id'] == null ? "" : json['question_id'] as String,
  json['contest_id'] == null ? "" : json['contest_id'] as String,
  json['content'] == null ? "" : json['content'] as String,
  json['question'] == null ? "" : json['question'] as String,
  json['puzzle_type'] == null ? "" : json['puzzle_type'] as String,
  json['answer'] == null ? "" : json['answer'] as String,
);

Map<String, dynamic> _$ContestQuestiondataToJson(ContestQuestiondata instance) =>
    <String, dynamic>{
      'question_id': instance.question_id,
      'contest_id': instance.contest_id,
      'content': instance.content,
      'question': instance.question,
      'puzzle_type': instance.puzzle_type,
      'answer': instance.answer,
    };
