import 'package:json_annotation/json_annotation.dart';

part 'ContestUserData.g.dart';

@JsonSerializable()
class ContestUserData {


  late String time_taken;
  late String user_id;
  late String name;

  ContestUserData(
      this.time_taken,
      this.user_id,
      this.name,
      );

  factory ContestUserData.fromJson(Map<String,dynamic> json) => _$ContestUserDataFromJson(json);
  Map<String, dynamic> toJson() => _$ContestUserDataToJson(this);
}
