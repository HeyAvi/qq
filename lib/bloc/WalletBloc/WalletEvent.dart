part of 'WalletBloc.dart';


abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}


class SubmitWalletEvent extends WalletEvent {
  const SubmitWalletEvent({required this.context  ,required this.amount,required this.userId , required this.status});

  final String amount,userId,status;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}

class GetWalletDataEvent extends WalletEvent {
  const GetWalletDataEvent({required this.context  ,required this.userId});

  final String userId;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}

class AmountMoneyChanged extends WalletEvent {
  const AmountMoneyChanged({required this.amountMoney});

  final String amountMoney;

  @override
  List<Object> get props => [amountMoney];
}

class RefreshWalletDataEvent extends WalletEvent {
  const RefreshWalletDataEvent({required this.context  ,required this.version , required this.wallatDataList , required this.sumAmount});

  final BuildContext context;
  final int version;
  final List<Walletdata>? wallatDataList;
  final String sumAmount;


  @override
  List<Object> get props => [context];

}
