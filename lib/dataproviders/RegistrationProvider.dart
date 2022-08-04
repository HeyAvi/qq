import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ApiConstants.dart';




class RegistrationException implements Exception {

  OTPVerificationException(error){
    print(error);
  }
}

class RegistrationProvider {
  RegistrationProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response?> register(BuildContext context, String name,String email, String phone) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.users;
    FormData data;

    data = FormData.fromMap({
      "name":name,
      "email":email,
      "phone":phone
    });

    try {
      Response response = await client.post(apiUrl,data: data);
      print("response====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

}






