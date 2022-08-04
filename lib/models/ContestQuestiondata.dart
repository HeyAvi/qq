import 'package:json_annotation/json_annotation.dart';

part 'ContestQuestiondata.g.dart';

@JsonSerializable()
class ContestQuestiondata {


  late String question_id;
  late String contest_id;
  late String content;
  late String question;
  late String puzzle_type;
  late String answer;


  ContestQuestiondata(
      this.question_id,
      this.contest_id,
      this.content,
      this.question,
      this.puzzle_type,
      this.answer,
      );

  factory ContestQuestiondata.fromJson(Map<String,dynamic> json) => _$ContestQuestiondataFromJson(json);
  Map<String, dynamic> toJson() => _$ContestQuestiondataToJson(this);
}
