import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:qq/repository/EnterNumberRepository.dart';
import 'package:qq/repository/OTPVerificationRepository.dart';
import 'package:qq/repository/RegistrationRepository.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';
import 'package:qq/utils/validations/Email.dart';
import 'package:qq/utils/validations/MobileNumber.dart';
import 'package:qq/utils/validations/Name.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'RegistrationEvent.dart';
part 'RegistrationState.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationRepository repository;


  RegistrationBloc(this.repository) : super(const RegistrationInitialState(version: 0)){
    on<RegisterEvent>(_handleRegisterEvent, transformer: sequential());
    on<NameChanged>(_handleNameChanged, transformer: sequential());
    on<EmailChanged>(_handleEmailChanged, transformer: sequential());
    on<MobileNumberChanged>(_handleMobileNumberChanged, transformer: sequential());
  }

  void _handleRegisterEvent(RegisterEvent event, Emitter<RegistrationState> emit) async{
    final prefs = await SharedPreferences.getInstance();
    if(state.status!.isValidated){
      DialogUtil.showProgressDialog("",event.context);
      Response? serverAPIResponseDto = await repository.register(event.context,event.name,event.email,event.phone);
      DialogUtil.dismissProgressDialog(event.context);
      if(serverAPIResponseDto != null){
        if(serverAPIResponseDto.data["status"].toString() == "200" || serverAPIResponseDto.data["status"].toString() == "201"){
          prefs.setString("userDataKey", serverAPIResponseDto.data["data"].toString());
          prefs.setString("userId", serverAPIResponseDto.data["id"].toString());
          RegistrationCompleteState completeState = new RegistrationCompleteState(context: event.context , version: state.version+1);
          emit(completeState);
        }
      }
    }
  }


  void _handleNameChanged(NameChanged event, Emitter<RegistrationState> emit){
    final name = Name.dirty(event.name);
    emit(state.copyWith(
        name: name.valid ? name : Name.pure(event.name),
        status: Formz.validate([name]),
        version: state.version +1
    ));
  }

  void _handleEmailChanged(EmailChanged event, Emitter<RegistrationState> emit){
    final email = Email.dirty(event.email);
    emit(state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([state.name,email]),
        version: state.version +1
    ));
  }

  void _handleMobileNumberChanged(MobileNumberChanged event, Emitter<RegistrationState> emit){
    final mobileNumber = MobileNumber.dirty(event.mobileNumber);
    emit(state.copyWith(
        mobileNumber: mobileNumber.valid ? mobileNumber : MobileNumber.pure(event.mobileNumber),
        status: Formz.validate([mobileNumber]),
        version: state.version +1
    ));
  }
}
