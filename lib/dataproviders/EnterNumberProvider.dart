import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ApiConstants.dart';




class EnterNumberException implements Exception {

  EnterNumberException(error){
    print(error);
  }
}

class EnterNumberProvider {
  EnterNumberProvider(this.client);

  final Dio client;

  String apiUrl = "";


  Future<Response?> sendOTP(BuildContext context, String mobileNumber) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.user_by_mobile + mobileNumber;

    try {
      Response response = await client.get(apiUrl);
      print("response=====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }


}
