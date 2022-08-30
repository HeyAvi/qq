import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/utils/ApiConstants.dart';

class HomeDashBoardException implements Exception {
  HomeDashBoardException(error) {
    print(error);
  }
}

class HomeDashBoardProvider {
  HomeDashBoardProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response?> getContestData(BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + "Contest/" + ApiConstants.fetch_contest;

    FormData data;

    data = FormData.fromMap({
      "user_id": userId,
    });

    try {
      Response response = await client.post(apiUrl, data: data);
      //print("getContestData==response===>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getPracticeContestData(
      BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL +
        "Contest/" +
        ApiConstants.fetch_contest_practice;

    FormData data;

    data = FormData.fromMap({
      "user_id": userId,
    });

    try {
      Response response = await client.post(apiUrl, data: data);
      //print("getContestData==response===>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getLastContestData(
      BuildContext context, String date) async {
    apiUrl = ApiConstants.BASE_URL +
        "Contest/" +
        ApiConstants.fetch_contest_result +
        date;
    print("apiurl====>>>" + apiUrl);
    try {
      Response response = await client.get(apiUrl);
      print("getContestData==response===>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }
}
