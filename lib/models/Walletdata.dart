import 'package:json_annotation/json_annotation.dart';

part 'Walletdata.g.dart';

@JsonSerializable()
class Walletdata {


  late String wallet_id;
  late String user_id;
  late String amount;
  late String transaction_type;
  late String remarks;
  late String response;
  late String status;
  late String created_at;
  late String updated_at;
  late String deleted_at;

  Walletdata(
      this.wallet_id,
      this.user_id,
      this.amount,
      this.transaction_type,
      this.remarks,
      this.response,
      this.status,
      this.created_at,
      this.updated_at,
      this.deleted_at

      );
  
  factory Walletdata.fromJson(Map<String,dynamic> json) => _$WalletdataFromJson(json);
  Map<String, dynamic> toJson() => _$WalletdataToJson(this);
}
