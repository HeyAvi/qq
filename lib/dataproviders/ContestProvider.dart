import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/utils/ApiConstants.dart';

class ContestException implements Exception {
  ContestException(error) {
    print(error);
  }
}

class ContestProvider {
  ContestProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response?> getContestQuestionDataEvent(
      BuildContext context, String contestId, String userId) async {
    apiUrl = ApiConstants.BASE_URL +
        "Contest/" +
        ApiConstants.fetch_question +
        contestId +
        "/" +
        userId;
    print("apiUrl=====>>" + apiUrl.toString());
    try {
      Response response = await client.get(apiUrl);
      print("getContestQuestionDataEvent==response===>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> submitQuestionDataEvent(
      BuildContext context,
      String contestId,
      String questionId,
      String answerGiven,
      String isAnswerTrue,
      String moves,
      String timeTaken) async {
    UserDataService userDataService = getIt<UserDataService>();
    apiUrl = ApiConstants.BASE_URL + "Contest/" + ApiConstants.contest_answer;
    FormData data;

    data = FormData.fromMap({
      "contest_id": contestId,
      "question_id": questionId,
      "answer_given": answerGiven,
      "is_answer_true": isAnswerTrue,
      "moves": moves,
      "time_taken": timeTaken,
      "user_id": userDataService.userData.user_id
    });

    try {
      Response response = await client.post(apiUrl, data: data);
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response?> getCompleteQuestionDataEvent(
      BuildContext context, String contestId, String userId) async {
    apiUrl = ApiConstants.BASE_URL +
        "Contest/" +
        ApiConstants.complete_contest +
        contestId +
        "/" +
        userId;
    print("apiUrl=====>>" + apiUrl.toString());
    try {
      Response response = await client.get(apiUrl);
      print("getContestQuestionDataEvent==response===>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }
}
