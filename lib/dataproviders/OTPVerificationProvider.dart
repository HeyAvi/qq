import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ApiConstants.dart';




class OTPVerificationException implements Exception {

  OTPVerificationException(error){
    print(error);
  }
}

class OTPVerificationProvider {
  OTPVerificationProvider(this.client);

  final Dio client;

  String apiUrl = "";

  //Get Server Config
  Future<Response?> verifyOTP(BuildContext context, String mobileNumber,String otpNumber) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.verify_otp;
    FormData data;

    data = FormData.fromMap({
       "phone":mobileNumber,
       "otp":otpNumber
    });

    try {
      Response response = await client.post(apiUrl,data: data);
      print("response===verifyOTP=>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> sendOTP(BuildContext context, String mobileNumber) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.user_by_mobile + mobileNumber;

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }


}
