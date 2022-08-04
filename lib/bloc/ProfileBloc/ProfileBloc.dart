// ignore_for_file: unused_local_variable

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qq/models/Userdata.dart';
import 'package:qq/repository/ProfileRepository.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';




part 'ProfileEvent.dart';
part 'ProfileState.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileRepository repository;


  ProfileBloc(this.repository) : super(const ProfileInitialState(version: 0)){
    on<GetProfileDataEvent>(_handleGetProfileDataEvent, transformer: sequential());
    on<UpdateProfileDataEvent>(_handleUpdateProfileDataEvent, transformer: sequential());
  }

  void _handleGetProfileDataEvent(GetProfileDataEvent event, Emitter<ProfileState> emit) async{
    Response? serverAPIResponseDto = await repository.getProfileData(event.context);
    if(serverAPIResponseDto != null && serverAPIResponseDto.data["status"].toString() == "200"){
      Map<String, dynamic> dataDto = serverAPIResponseDto.data! as Map<String, dynamic>;
      Userdata newData = Userdata.fromJson(dataDto["data"]);
      UserDataService userDataService =  getIt<UserDataService>();
      userDataService.setUserdata(newData,dataDto["wallet"]["amount"].toString(),dataDto["tickets"]["ticket_id"].toString(),dataDto["total_contest"]["contest_x_user_id"].toString());
      print(userDataService.userData.toString());
      ProfileCompleteState completeState = new ProfileCompleteState(context: event.context , version: state.version+1);
      emit(completeState);
    }
  }


  void _handleUpdateProfileDataEvent(UpdateProfileDataEvent event, Emitter<ProfileState> emit) async{
    DialogUtil.showProgressDialog("",event.context);
    Response? serverAPIResponseDto = await repository.updateProfileData(event.context,event.name,event.gender,event.dob,event.email,event.image,event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if(serverAPIResponseDto != null){
      Map<String, dynamic> dataDto = serverAPIResponseDto.data! as Map<String, dynamic>;
      Userdata newData = Userdata.fromJson(dataDto["data"]);
      UserDataService userDataService =  getIt<UserDataService>();
      userDataService.setUserdata(newData,userDataService.walletAmount,userDataService.totalTickets,userDataService.totalParticipation);
      print(userDataService.userData.toString());
      DialogUtil.showInfoDialog("Profile Updated Successfully.",event.context);
      ProfileCompleteState completeState = new ProfileCompleteState(context: event.context , version: state.version+1);
      emit(completeState);
    }
  }

}
