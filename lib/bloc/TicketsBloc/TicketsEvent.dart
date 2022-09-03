part of 'TicketsBloc.dart';


abstract class TicketsEvent extends Equatable {
  const TicketsEvent();

  @override
  List<Object> get props => [];
}

class GetTicketsDataEvent extends TicketsEvent {
  const GetTicketsDataEvent({required this.context  ,required this.userId});

  final String userId;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}

class BuyicketsDataEvent extends TicketsEvent {
  const BuyicketsDataEvent({required this.context  ,required this.userId,required this.no_of_tickets});

  final String userId;
  final String no_of_tickets;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}


class SubmitContextUserEvent extends TicketsEvent {
  const SubmitContextUserEvent({required this.context  ,required this.userId,required this.contestId,required this.ticketId,required this.ticketDataList,
  required this.status,
});

  final String userId;
  final String ticketId;
  final String contestId;
  final BuildContext context;
  final List<Ticketdata>? ticketDataList;
  final Status status;



  @override
  List<Object> get props => [context];
  get getWallatDataList => ticketDataList;
}