import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qq/repository/EnterNumberRepository.dart';
import 'package:qq/repository/OTPVerificationRepository.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'OTPVerificationEvent.dart';
part 'OTPVerificationState.dart';

class OTPVerificationBloc extends Bloc<OTPVerificationEvent, OTPVerificationState> {
  OTPVerificationRepository repository;


  OTPVerificationBloc(this.repository) : super(const OTPVerificationInitialState(version: 0)){
    on<VerifyOTPEvent>(_handleVerifyOTPEvent, transformer: sequential());
    on<SendOTPEvent>(_handleSendOTPEvent, transformer: sequential());
  }

  void _handleVerifyOTPEvent(VerifyOTPEvent event, Emitter<OTPVerificationState> emit) async{
    final prefs = await SharedPreferences.getInstance();
    bool registrationRequired = false;
    DialogUtil.showProgressDialog("",event.context);
    Response? serverAPIResponseDto = await repository.verifyOTP(event.context,event.mobileNumber,event.otpNumber);
    DialogUtil.dismissProgressDialog(event.context);
    if(serverAPIResponseDto != null){
      if(serverAPIResponseDto.data["status"].toString() == "200" || serverAPIResponseDto.data["status"].toString() == "201"){
        if(serverAPIResponseDto.data["user_status"] == 1){
          registrationRequired = true;
        }
        else{
          prefs.setString("userDataKey", serverAPIResponseDto.data["data"].toString());
          prefs.setString("userId", serverAPIResponseDto.data["id"].toString());
        }
        OTPVerificationCompleteState completeState = OTPVerificationCompleteState(context: event.context , version: state.version+1,registrationRequired :registrationRequired);
        emit(completeState);
      }
    }
  }

  void _handleSendOTPEvent(SendOTPEvent event, Emitter<OTPVerificationState> emit) async{
      DialogUtil.showProgressDialog("",event.context);
      Response? serverAPIResponseDto = await repository.sendOTP(event.context,event.mobileNumber);
      DialogUtil.dismissProgressDialog(event.context);
      if(serverAPIResponseDto != null){
        SendOTPCompleteState completeState = SendOTPCompleteState(context: event.context , version: state.version+1);
        emit(completeState);
      }
  }

}
