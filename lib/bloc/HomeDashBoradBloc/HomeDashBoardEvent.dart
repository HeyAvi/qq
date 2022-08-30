part of 'HomeDashBoardBloc.dart';

abstract class HomeDashBoardEvent extends Equatable {
  const HomeDashBoardEvent();

  @override
  List<Object> get props => [];
}

class FetchContestEvent extends HomeDashBoardEvent {
  const FetchContestEvent({required this.context, required this.userId});

  final BuildContext context;
  final String userId;

  @override
  List<Object> get props => [context];
}

class FetchExampleContestEvent extends HomeDashBoardEvent {
  const FetchExampleContestEvent({required this.context, required this.userId});

  final BuildContext context;
  final String userId;

  @override
  List<Object> get props => [context];
}

class GetLastContestDataEvent extends HomeDashBoardEvent {
  const GetLastContestDataEvent(
      {required this.context, required this.date, required this.contestdata});

  final BuildContext context;
  final String date;
  final Contestdata? contestdata;

  @override
  List<Object> get props => [context];

  get getContestData => contestdata;
}

class BottomIndexChange extends HomeDashBoardEvent {
  const BottomIndexChange({required this.context, required this.currentIndex});

  final BuildContext context;
  final int currentIndex;

  @override
  List<Object> get props => [context];
}
