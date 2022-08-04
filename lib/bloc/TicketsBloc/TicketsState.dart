part of 'TicketsBloc.dart';

class TicketsState extends Equatable {
  final int version;
  const TicketsState({required this.version});

  @override
  List<Object> get props => [version];

}



class TicketsInitialState extends TicketsState {

  const TicketsInitialState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class TicketsCompleteState extends TicketsState {

  const TicketsCompleteState({
    this.context,
    required this.version,
    required this.ticketDataList,
    required this.contestUserSubmit
  }):super(version: version);

  final BuildContext? context;
  final int version;
  final List<Ticketdata>? ticketDataList;
  final bool contestUserSubmit;

  @override
  List<Object> get props => [version];
  get getWallatDataList => ticketDataList;
}

class BuyTicketsCompleteState extends TicketsState {

  const BuyTicketsCompleteState({
    this.context,
    required this.version,
    required this.isBook
  }):super(version: version);

  final BuildContext? context;
  final int version;
  final bool isBook;

  @override
  List<Object> get props => [version];
}



