import 'package:json_annotation/json_annotation.dart';

part 'Ticketdata.g.dart';

@JsonSerializable()
class Ticketdata {


  late String ticket_id;
  late String user_id;
  late String ticket_code;
  late String is_used;
  late String created_at;
  late String updated_at;
  late String deleted_at;

  Ticketdata(
      this.ticket_id,
      this.user_id,
      this.ticket_code,
      this.is_used,
      this.created_at,
      this.updated_at,
      this.deleted_at

      );

  factory Ticketdata.fromJson(Map<String,dynamic> json) => _$TicketdataFromJson(json);
  Map<String, dynamic> toJson() => _$TicketdataToJson(this);
}
