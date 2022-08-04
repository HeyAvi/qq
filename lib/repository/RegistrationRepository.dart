import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/EnterNumberProvider.dart';
import 'package:qq/dataproviders/OTPVerificationProvider.dart';
import 'package:qq/dataproviders/RegistrationProvider.dart';

class RegistrationRepository{

  final Dio client;

  late final RegistrationProvider provider ;

  RegistrationRepository(this.client){
    provider = new RegistrationProvider(client);
  }


  Future<Response?> register(BuildContext context ,String name,String email, String phone) => provider.register(context,name,email,phone);

}