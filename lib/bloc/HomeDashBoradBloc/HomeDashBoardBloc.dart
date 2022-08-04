import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qq/models/ContestUserData.dart';
import 'package:qq/models/Contestdata.dart';
import 'package:qq/repository/HomeDashBoardRepository.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';


part 'HomeDashBoardEvent.dart';
part 'HomeDashBoardState.dart';

class HomeDashBoardBloc extends Bloc<HomeDashBoardEvent, HomeDashBoardState> {
  HomeDashBoardRepository repository;


  HomeDashBoardBloc(this.repository) : super(const HomeDashBoardInitialState(version: 0)){
    on<FetchContestEvent>(_handleFetchContestEvent, transformer: sequential());
    on<GetLastContestDataEvent>(_handleGetLastContestDataEvent, transformer: sequential());
    on<BottomIndexChange>(_handleBottomIndexChange, transformer: sequential());
  }

  void _handleFetchContestEvent(FetchContestEvent event, Emitter<HomeDashBoardState> emit) async{
    Response? serverAPIResponseDto = await repository.getContestData(event.context,event.userId);
    if(serverAPIResponseDto != null && serverAPIResponseDto.data["status"].toString() == "201"){
      Map<String, dynamic> dataDto = serverAPIResponseDto.data! as Map<String, dynamic>;
      Contestdata newData = Contestdata.fromJson(dataDto["data"]);
      ContestService contestService =  getIt<ContestService>();
      contestService.setContestdata(newData,dataDto["wallet_sum"]["amount"].toString(),dataDto["ticket"]["ticket_id"].toString(),dataDto["contest_x_user"],dataDto["participated"]);
      HomeDashBoardCompleteState completeState = new HomeDashBoardCompleteState(context: event.context , version: state.version+1,contestdata: newData,contestUserDataList: null);
      emit(completeState);
    }else{
      HomeDashBoardCompleteState completeState = new HomeDashBoardCompleteState(context: event.context , version: state.version+1,contestdata: null,contestUserDataList: null);
      emit(completeState);
    }
  }

  void _handleGetLastContestDataEvent(GetLastContestDataEvent event, Emitter<HomeDashBoardState> emit) async{
    Response? serverAPIResponseDto = await repository.getLastContestData(event.context,event.date);
    if(serverAPIResponseDto != null){
      if(serverAPIResponseDto.data["status"].toString() == "200" || serverAPIResponseDto.data["status"].toString() == "201"){
        List<ContestUserData>? contestUserDataList = (serverAPIResponseDto.data!["data"] as List).map((itemWord) => ContestUserData.fromJson(itemWord)).toList();
        HomeDashBoardCompleteState completeState = new HomeDashBoardCompleteState(context: event.context , version: state.version+1,contestdata: event.contestdata,contestUserDataList:contestUserDataList);
        emit(completeState);
      }
      else if(serverAPIResponseDto.data["status"].toString() == "404"){
        HomeDashBoardCompleteState completeState = new HomeDashBoardCompleteState(context: event.context , version: state.version+1,contestdata: event.contestdata,contestUserDataList:null);
        emit(completeState);
      }
    }
  }

  void _handleBottomIndexChange(BottomIndexChange event, Emitter<HomeDashBoardState> emit) async{
      BottomIndexChangedState completeState = new BottomIndexChangedState(context: event.context , version: state.version+1,bottomIndex:event.currentIndex);
      emit(completeState);
  }
}
