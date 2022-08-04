import 'package:json_annotation/json_annotation.dart';

part 'Userdata.g.dart';

@JsonSerializable()
class Userdata {


  late String user_id;
  late String name;
  late String email;
  late String phone;
  late String is_verified;
  late String app_key;
  late String refer_code;
  late String refer_code_used;
  late String image;
  late String address;
  late String bank;
  late String is_eligible;
  late String created_at;
  late String updated_at;
  late String deleted_at;

  Userdata(
      this.user_id,
      this.name,
      this.email,
      this.phone,
      this.is_verified,
      this.app_key,
      this.refer_code,
      this.refer_code_used,
      this.image,
      this.address,
      this.bank,
      this.is_eligible,
      this.created_at,
      this.updated_at,
      this.deleted_at
      );

  factory Userdata.fromJson(Map<String,dynamic> json) => _$UserdataFromJson(json);
  Map<String, dynamic> toJson() => _$UserdataToJson(this);
}
