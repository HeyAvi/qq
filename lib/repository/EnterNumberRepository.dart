import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/EnterNumberProvider.dart';

class EnterNumberRepository{

  final Dio client;

  late final EnterNumberProvider provider ;

  EnterNumberRepository(this.client){
    provider = new EnterNumberProvider(client);
  }


  Future<Response?> sendOTP(BuildContext context ,String mobileNumber) => provider.sendOTP(context,mobileNumber);

}