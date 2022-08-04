part of 'ContestBloc.dart';


abstract class ContestEvent extends Equatable {
  const ContestEvent();

  @override
  List<Object> get props => [];
}


class GetContestQuestionDataEvent extends ContestEvent {
  const GetContestQuestionDataEvent({required this.context  ,required this.contestId,required this.userId});

  final String contestId;
  final String userId;
  final BuildContext context;


  @override
  List<Object> get props => [context];

}


class SubmitQuestionDataEvent extends ContestEvent {
  const SubmitQuestionDataEvent(
      {required this.context  ,
        required this.contestId,
        required this.questionId,
        required this.answerGiven,
        required this.isAnswerTrue,
        required this.moves,
        required this.timeTaken,
        required this.contestQuestiondataDataList,
        required this.currentIndex
      });

  final String contestId;
  final String questionId;
  final String answerGiven;
  final String isAnswerTrue;
  final String moves;
  final String timeTaken;
  final BuildContext context;
  final List<ParentContestQuestiondata>? contestQuestiondataDataList;
  final int currentIndex;


  @override
  List<Object> get props => [context];

}


class ChangeCurrentIndexEvent extends ContestEvent {
  const ChangeCurrentIndexEvent(
      {required this.context  ,
        required this.contestId,
        required this.questionId,
        required this.answerGiven,
        required this.isAnswerTrue,
        required this.moves,
        required this.timeTaken,
        required this.contestQuestiondataDataList,
        required this.currentIndex
      });

  final String contestId;
  final String questionId;
  final String answerGiven;
  final String isAnswerTrue;
  final String moves;
  final String timeTaken;
  final BuildContext context;
  final List<ParentContestQuestiondata>? contestQuestiondataDataList;
  final int currentIndex;


  @override
  List<Object> get props => [context];

}


class CompleteContestQuestionDataEvent extends ContestEvent {
  const CompleteContestQuestionDataEvent({required this.context  ,required this.contestId,required this.userId,required this.contestQuestiondataDataList});

  final String contestId;
  final String userId;
  final BuildContext context;
  final List<ParentContestQuestiondata>? contestQuestiondataDataList;


  @override
  List<Object> get props => [context];

}
