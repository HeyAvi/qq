import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qq/models/Ticketdata.dart';
import 'package:qq/repository/TicketsRepository.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';

part 'TicketsEvent.dart';

part 'TicketsState.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  TicketsRepository repository;

  TicketsBloc(this.repository) : super(const TicketsInitialState(version: 0)) {
    on<BuyicketsDataEvent>(_handleBuyicketsDataEvent,
        transformer: sequential());
    on<GetTicketsDataEvent>(_handleGetTicketsDataEvent,
        transformer: sequential());
    on<SubmitContextUserEvent>(_handleSubmitContextUserEvent,
        transformer: sequential());
  }

  void _handleBuyicketsDataEvent(
      BuyicketsDataEvent event, Emitter<TicketsState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response? serverAPIResponseDto = await repository.buyicketsDataEvent(
        event.context, event.userId, event.no_of_tickets);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        serverAPIResponseDto.data["status"].toString() == "201") {
      BuyTicketsCompleteState completeState = BuyTicketsCompleteState(
          context: event.context, version: state.version + 1, isBook: true);
      emit(completeState);
    } else {
      DialogUtil.showInfoDialog(
          title: 'Info',
          message: serverAPIResponseDto!.data["messages"].toString(),
          context: event.context,
          );
      TicketsState currentState = TicketsState(version: state.version + 1);
      emit(currentState);
    }
  }

  void _handleGetTicketsDataEvent(
      GetTicketsDataEvent event, Emitter<TicketsState> emit) async {
    Response? serverAPIResponseDto =
        await repository.getTicketsDataEvent(event.context, event.userId);
    print("serverAPIResponseDto===>>>" + serverAPIResponseDto.toString());
    if (serverAPIResponseDto != null) {
      List<Ticketdata>? ticketDataList =
          (serverAPIResponseDto.data!["data"] as List)
              .map((itemWord) => Ticketdata.fromJson(itemWord))
              .toList();
      TicketsCompleteState completeState = TicketsCompleteState(
          context: event.context,
          version: state.version + 1,
          ticketDataList: ticketDataList,
          contestUserSubmit: false);
      emit(completeState);
    } else {
      TicketsCompleteState completeState = TicketsCompleteState(
          context: event.context,
          version: state.version + 1,
          ticketDataList: null,
          contestUserSubmit: false);
      emit(completeState);
    }
  }

  void _handleSubmitContextUserEvent(
      SubmitContextUserEvent event, Emitter<TicketsState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response? serverAPIResponseDto = await repository.submitContextUserEvent(
        event.context, event.userId, event.contestId, event.ticketId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null) {
      Navigator.of(event.context, rootNavigator: true).pop();
      if (serverAPIResponseDto.data!["status"].toString() == "200") {
        DialogUtil.showSuccessDialog("", event.context);
      } else if (serverAPIResponseDto.data!["status"].toString() == "404") {
        //DialogUtil.showSuccessDialog("error", event.context);
      }
      TicketsCompleteState completeState = TicketsCompleteState(
          context: event.context,
          version: state.version + 1,
          ticketDataList: event.ticketDataList,
          contestUserSubmit: true);
      emit(completeState);
    }
  }
}
