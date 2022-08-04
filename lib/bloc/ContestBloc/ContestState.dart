part of 'ContestBloc.dart';

class ContestState extends Equatable {
  final int version;
  final int changedIndex;
  const ContestState({required this.version,required this.changedIndex});

  @override
  List<Object> get props => [version];

}



class ContestInitialState extends ContestState {

  const ContestInitialState({
    this.context,
    required this.version
  }):super(version: version,changedIndex: 0);

  final BuildContext? context;
  final  int version;

  @override
  List<Object> get props => [version];
}

class ContestCompleteState extends ContestState {

  const ContestCompleteState({
    this.context,
    required this.version,
    required this.contestQuestiondataDataList,
    required this.isSubmit,
    required this.isCurrentIndexChanged,
    required this.currentIndex,
    required this.isContestCompleted
  }):super(version: version,changedIndex: 0);

  final BuildContext? context;
  final int version;
  final List<ParentContestQuestiondata>? contestQuestiondataDataList;
  final bool isSubmit;
  final bool isCurrentIndexChanged;
  final int currentIndex;
  final bool isContestCompleted;

  @override
  List<Object> get props => [version];
  get getContestQuestiondataList => contestQuestiondataDataList;
}


