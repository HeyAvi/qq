import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/HomeDashBoardProvider.dart';


class HomeDashBoardRepository{

  final Dio client;

  late final HomeDashBoardProvider provider ;

  HomeDashBoardRepository(this.client){
    provider = new HomeDashBoardProvider(client);
  }


  Future<Response?> getContestData(BuildContext context,String userId) => provider.getContestData(context,userId);

  Future<Response?> getLastContestData(BuildContext context,String date) => provider.getLastContestData(context,date);

}