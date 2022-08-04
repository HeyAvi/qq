import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/WalletProvider.dart';

class WalletRepository{

  final Dio client;

  late final WalletProvider provider ;

  WalletRepository(this.client){
    provider = new WalletProvider(client);
  }

  Future<Response?> submitWalletData(BuildContext context ,String amount, String userId , String status) => provider.submitWalletData(context,amount,userId,status);

  Future<Response?> getWalletData(BuildContext context ,String userId ) => provider.getWalletData(context,userId);

}