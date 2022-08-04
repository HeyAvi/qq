import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ApiConstants.dart';




class WalletException implements Exception {

  WalletException(error){
    print(error);
  }
}

class WalletProvider {
  WalletProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response?> submitWalletData(BuildContext context, String amount, String userId , String status) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.wallet;

    FormData data;

    data = FormData.fromMap({
      "amount":amount,
      "user_id":userId,
      "status":status
    });

    try {
      Response response = await client.post(apiUrl,data: data);
      print("submitWalletData==response===>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getWalletData(BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.wallet+"/"+userId;

    try {
      Response response = await client.get(apiUrl);
      print("submitWalletData==response===>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

}






