import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qq/models/ParentContestQuestiondata.dart';
import 'package:qq/repository/ContestRepository.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';

part 'ContestEvent.dart';
part 'ContestState.dart';

class ContestBloc extends Bloc<ContestEvent, ContestState> {
  ContestRepository repository;

  ContestBloc(this.repository) : super(const ContestInitialState(version: 0)) {
    on<GetContestQuestionDataEvent>(_handleGetContestQuestionDataEvent,
        transformer: sequential());
    on<SubmitQuestionDataEvent>(_handleSubmitQuestionDataEvent,
        transformer: sequential());
    on<ChangeCurrentIndexEvent>(_handleChangeCurrentIndexEvent,
        transformer: sequential());
    on<CompleteContestQuestionDataEvent>(
        _handleCompleteContestQuestionDataEvent,
        transformer: sequential());
  }

  void _handleGetContestQuestionDataEvent(
      GetContestQuestionDataEvent event, Emitter<ContestState> emit) async {
    Response? serverAPIResponseDto =
        await repository.getContestQuestionDataEvent(
            event.context, event.contestId, event.userId);
    print("serverAPIResponseDto===>>>" + serverAPIResponseDto.toString());
    if (serverAPIResponseDto != null) {
      List<ParentContestQuestiondata>? contestQuestiondataDataList =
          (serverAPIResponseDto.data!["data"] as List)
              .map((itemWord) => ParentContestQuestiondata.fromJson(itemWord))
              .toList();
      ContestCompleteState completeState = ContestCompleteState(
          context: event.context,
          version: state.version + 1,
          contestQuestiondataDataList: contestQuestiondataDataList,
          isSubmit: false,
          currentIndex: 0,
          isCurrentIndexChanged: false,
          isContestCompleted: false);
      emit(completeState);
    } else {
      ContestCompleteState completeState = ContestCompleteState(
          context: event.context,
          version: state.version + 1,
          contestQuestiondataDataList: null,
          isSubmit: false,
          currentIndex: 0,
          isCurrentIndexChanged: false,
          isContestCompleted: false);
      emit(completeState);
    }
  }

  void _handleSubmitQuestionDataEvent(
      SubmitQuestionDataEvent event, Emitter<ContestState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response? serverAPIResponseDto = await repository.submitQuestionDataEvent(
        event.context,
        event.contestId,
        event.questionId,
        event.answerGiven,
        event.isAnswerTrue,
        event.moves,
        event.timeTaken);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null) {
      if (serverAPIResponseDto.data["status"].toString() == "200" ||
          serverAPIResponseDto.data["status"].toString() == "201") {
        ContestCompleteState completeState = ContestCompleteState(
            context: event.context,
            version: state.version + 1,
            contestQuestiondataDataList: event.contestQuestiondataDataList,
            isSubmit: true,
            currentIndex: event.currentIndex,
            isCurrentIndexChanged: false,
            isContestCompleted: false);
        emit(completeState);
      } else if (serverAPIResponseDto.data["status"].toString() == "404") {
        ContestState completeState = ContestState(
            version: state.version + 1, changedIndex: event.currentIndex);
        emit(completeState);
      }
    }
  }

  void _handleChangeCurrentIndexEvent(
      ChangeCurrentIndexEvent event, Emitter<ContestState> emit) async {
    ContestCompleteState completeState = ContestCompleteState(
        context: event.context,
        version: state.version + 1,
        contestQuestiondataDataList: event.contestQuestiondataDataList,
        isSubmit: true,
        currentIndex: event.currentIndex,
        isCurrentIndexChanged: true,
        isContestCompleted: false);
    emit(completeState);
  }

  void _handleCompleteContestQuestionDataEvent(
      CompleteContestQuestionDataEvent event,
      Emitter<ContestState> emit) async {
    Response? serverAPIResponseDto =
        await repository.getCompleteQuestionDataEvent(
            event.context, event.contestId, event.userId);
    print("serverAPIResponseDto===>>>" + serverAPIResponseDto.toString());
    if (serverAPIResponseDto != null) {
      ContestCompleteState completeState = ContestCompleteState(
          context: event.context,
          version: state.version + 1,
          contestQuestiondataDataList: event.contestQuestiondataDataList,
          isSubmit: false,
          currentIndex: 0,
          isCurrentIndexChanged: false,
          isContestCompleted: true);
      emit(completeState);
    }
  }
}
