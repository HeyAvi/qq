import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/EnterNumberProvider.dart';
import 'package:qq/dataproviders/TicketsProvider.dart';

class TicketsRepository{

  final Dio client;

  late final TicketsProvider provider ;

  TicketsRepository(this.client){
    provider = new TicketsProvider(client);
  }


  Future<Response?> buyicketsDataEvent(BuildContext context ,String userId , String no_of_tickets) => provider.buyicketsDataEvent(context,userId,no_of_tickets);

  Future<Response?> getTicketsDataEvent(BuildContext context ,String userId) => provider.getTicketsDataEvent(context,userId);

  Future<Response?> submitContextUserEvent(BuildContext context ,String userId , String contestId, String ticketId) => provider.submitContextUserEvent(context,userId,contestId,ticketId);

}