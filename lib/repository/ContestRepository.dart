import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qq/dataproviders/WalletProvider.dart';

import '../dataproviders/ContestProvider.dart';

class ContestRepository{

  final Dio client;

  late final ContestProvider provider ;

  ContestRepository(this.client){
    provider = new ContestProvider(client);
  }

  Future<Response?> getContestQuestionDataEvent(BuildContext context ,String contestId,String userId) => provider.getContestQuestionDataEvent(context,contestId,userId);

  Future<Response?> submitQuestionDataEvent(BuildContext context ,String contestId,String questionId,String answerGiven,String isAnswerTrue,String moves,String timeTaken) => provider.submitQuestionDataEvent(context,contestId,questionId,answerGiven,isAnswerTrue,moves,timeTaken);

  Future<Response?> getCompleteQuestionDataEvent(BuildContext context ,String contestId,String userId) => provider.getCompleteQuestionDataEvent(context,contestId,userId);

}