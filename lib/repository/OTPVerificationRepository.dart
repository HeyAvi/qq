import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/EnterNumberProvider.dart';
import 'package:qq/dataproviders/OTPVerificationProvider.dart';

class OTPVerificationRepository{

  final Dio client;

  late final OTPVerificationProvider provider ;

  OTPVerificationRepository(this.client){
    provider = new OTPVerificationProvider(client);
  }


  Future<Response?> verifyOTP(BuildContext context ,String mobileNumber,String otpNumber) => provider.verifyOTP(context,mobileNumber,otpNumber);

  Future<Response?> sendOTP(BuildContext context ,String mobileNumber) => provider.sendOTP(context,mobileNumber);
}