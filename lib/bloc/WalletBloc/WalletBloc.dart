import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:qq/models/Walletdata.dart';
import 'package:qq/repository/WalletRepository.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';
import 'package:qq/utils/validations/AmountMoney.dart';


part 'WalletEvent.dart';
part 'WalletState.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletRepository repository;


  WalletBloc(this.repository) : super(const WalletInitialState(version: 0)){
    on<SubmitWalletEvent>(_handleSubmitWalletEvent, transformer: sequential());
    on<GetWalletDataEvent>(_handleGetWalletDataEvent, transformer: sequential());
    on<AmountMoneyChanged>(_handleAmountMoneyChanged, transformer: sequential());
    on<RefreshWalletDataEvent>(_handleRefreshWalletDataEvent, transformer: sequential());
  }

  void _handleSubmitWalletEvent(SubmitWalletEvent event, Emitter<WalletState> emit) async{
    if(state.status!.isValidated){
      DialogUtil.showProgressDialog("",event.context);
      Response? serverAPIResponseDto = await repository.submitWalletData(event.context,event.amount,event.userId,event.status);
      DialogUtil.dismissProgressDialog(event.context);
      if(serverAPIResponseDto != null){
        WalletCompleteState completeState = new WalletCompleteState(context: event.context , version: state.version+1);
        emit(completeState);
      }
    }
  }

  void _handleGetWalletDataEvent(GetWalletDataEvent event, Emitter<WalletState> emit) async{
    Response? serverAPIResponseDto = await repository.getWalletData(event.context,event.userId);
    print("serverAPIResponseDto===>>>"+serverAPIResponseDto.toString());
    if(serverAPIResponseDto != null){
      List<Walletdata>? walletDataList = (serverAPIResponseDto.data!["data"] as List).map((itemWord) => Walletdata.fromJson(itemWord)).toList();
      GetWalletDataCompleteState completeState = new GetWalletDataCompleteState(context: event.context , version: state.version+1,wallatDataList: walletDataList,sumAmount: serverAPIResponseDto.data!["sum"]["amount"]);
      emit(completeState);
    }
    else{
      GetWalletDataCompleteState completeState = new GetWalletDataCompleteState(context: event.context , version: state.version+1,wallatDataList: null,sumAmount: "");
      emit(completeState);
    }
  }


  void _handleAmountMoneyChanged(AmountMoneyChanged event, Emitter<WalletState> emit){
    final amountMoney = AmountMoney.dirty(event.amountMoney);
    emit(state.copyWith(
        amountMoney: amountMoney.valid ? amountMoney : AmountMoney.pure(event.amountMoney),
        status: Formz.validate([amountMoney]),
        version: state.version +1
    ));
  }

  void _handleRefreshWalletDataEvent(RefreshWalletDataEvent event, Emitter<WalletState> emit) async{
      GetWalletDataCompleteState completeState = new GetWalletDataCompleteState(context: event.context , version: state.version+1,wallatDataList: event.wallatDataList,sumAmount: event.sumAmount);
      emit(completeState);
  }
}
