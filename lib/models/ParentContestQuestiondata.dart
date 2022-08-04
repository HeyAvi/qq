import 'package:json_annotation/json_annotation.dart';
import 'package:qq/models/ContestQuestiondata.dart';


part 'ParentContestQuestiondata.g.dart';

@JsonSerializable()
class ParentContestQuestiondata {


  late Map<String,dynamic>? question;
  late bool is_submitted;



  ParentContestQuestiondata(
      this.question,
      this.is_submitted,
      );

  factory ParentContestQuestiondata.fromJson(Map<String,dynamic> json) => _$ParentContestQuestiondataFromJson(json);
  Map<String, dynamic> toJson() => _$ParentContestQuestiondataToJson(this);
}
