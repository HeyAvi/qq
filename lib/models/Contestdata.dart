import 'package:json_annotation/json_annotation.dart';

part 'Contestdata.g.dart';

@JsonSerializable()
class Contestdata {


  late String contest_id;
  late String name;
  late String start_date;
  late String end_date;
  late String contest_time;
  late String rules;
  late String winner_zone;
  late String contest_type;
  late String max_participants;
  late String image;
  late String max_winner;
  late String winning_by;
  late String created_at;
  late String updated_at;
  late String deleted_at;
  late String description;

  Contestdata(
      this.contest_id,
      this.name,
      this.start_date,
      this.end_date,
      this.contest_time,
      this.rules,
      this.winner_zone,
      this.contest_type,
      this.max_participants,
      this.image,
      this.max_winner,
      this.winning_by,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.description
      );

  factory Contestdata.fromJson(Map<String,dynamic> json) => _$ContestdataFromJson(json);
  Map<String, dynamic> toJson() => _$ContestdataToJson(this);
}
