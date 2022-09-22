import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ApiConstants.dart';

class TicketsException implements Exception {
  TicketsException(error) {
    print(error);
  }
}

class TicketsProvider {
  TicketsProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response?> buyicketsDataEvent(
      BuildContext context, String userId, String noOfTickets) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.tickets;
    print("apiUrl===>>>" + apiUrl);

    FormData data;

    data = FormData.fromMap({"user_id": userId, "no_of_tickets": noOfTickets});

    try {
      Response response = await client.post(apiUrl, data: data);
      print("submitWalletData==response===>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getTicketsDataEvent(
      BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.tickets + "/" + userId;

    try {
      Response response = await client.get(apiUrl);
      print("submitWalletData==response===>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> submitContextUserEvent(
    BuildContext context,
    String userId,
    String contestId,
    String? ticketId,
      {
    required Status status,
  }) async {
    apiUrl = ApiConstants.BASE_URL + "Contest/" + ApiConstants.contest_user;

    FormData data;

    data = FormData.fromMap({
      "contest_id": contestId,
      "ticket_id": ticketId,
      "user_id": userId,
      "status": status.name
    });

    try {
      Response response = await client.post(apiUrl, data: data);
      print("submitContextUserEvent==response===>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }
}

enum Status { A, P }
