part of 'WalletBloc.dart';

class WalletState extends Equatable {
  final int version;
  final AmountMoney amountMoney;
  final FormzStatus? status;
  const WalletState({required this.version,this.amountMoney = const AmountMoney.pure(),this.status});


  WalletState copyWith({
    AmountMoney? amountMoney,
    FormzStatus? status,
    int? version
  }) {
    return WalletState(
        version: version ?? this.version,
        amountMoney: amountMoney ?? this.amountMoney,
        status: status ?? this.status
    );
  }


  @override
  List<Object> get props => [version];

}



class WalletInitialState extends WalletState {

  const WalletInitialState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class WalletCompleteState extends WalletState {

  const WalletCompleteState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final int version;

  @override
  List<Object> get props => [version];
}

class GetWalletDataCompleteState extends WalletState {

  const GetWalletDataCompleteState({
    required this.context,
    required this.version,
    required this.wallatDataList,
    required this.sumAmount

  }):super(version: version);

  final BuildContext context;
  final int version;
  final List<Walletdata>? wallatDataList;
  final String sumAmount;

  @override
  List<Object> get props => [version];
  get getWallatDataList => wallatDataList;
}