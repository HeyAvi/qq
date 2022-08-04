part of 'HomeDashBoardBloc.dart';

class HomeDashBoardState extends Equatable {
  final int version;
  const HomeDashBoardState({required this.version});

  @override
  List<Object> get props => [version];

}



class HomeDashBoardInitialState extends HomeDashBoardState {

  const HomeDashBoardInitialState({
    this.context,
    required this.version
  }):super(version: version);

  final BuildContext? context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class HomeDashBoardCompleteState extends HomeDashBoardState {

  const HomeDashBoardCompleteState({
    this.context,
    required this.version,
    required this.contestdata,
    required this.contestUserDataList
  }):super(version: version);

  final BuildContext? context;
  final int version;
  final Contestdata? contestdata;
  final List<ContestUserData>? contestUserDataList;

  @override
  List<Object> get props => [version];
  get getContestdata => contestdata;
  get getContestUserDataList => contestUserDataList;
}

class BottomIndexChangedState extends HomeDashBoardState {

  const BottomIndexChangedState({
    this.context,
    required this.version,
    required this.bottomIndex
  }):super(version: version);

  final BuildContext? context;
  final int version;
  final int bottomIndex;

  @override
  List<Object> get props => [version];
  get getbottomIndex => bottomIndex;
}