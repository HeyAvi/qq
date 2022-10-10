import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/ContestBloc/ContestBloc.dart';
import 'package:qq/models/ParentContestQuestiondata.dart';
import 'package:qq/repository/ContestRepository.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/ui/ContestDetails/JigsawPuzzle/JigsawPuzzleTwo.dart';
import 'package:qq/ui/ContestDetails/SlidingPuzzle/Board.dart';
import 'package:qq/ui/ContestDetails/SoundPuzzle/SoundPuzzle.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/utils/DataNotAvailable.dart';
import 'package:qq/utils/DateTimeFormatter.dart';

class ContestMainPage extends StatelessWidget {
  final ContestExampleService? contestExampleService;

  const ContestMainPage({Key? key, this.contestExampleService})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ContestBloc(ContestRepository(Dio())),
        child: ContestMainSateful(
          contestExampleService: contestExampleService,
        ),
      ),
    );
  }
}

class ContestMainSateful extends StatefulWidget {
  final ContestExampleService? contestExampleService;

  const ContestMainSateful({Key? key, this.contestExampleService})
      : super(key: key);

  @override
  _ContestMainState createState() => _ContestMainState();
}

class _ContestMainState extends State<ContestMainSateful>
    with TickerProviderStateMixin {
  TabController? _cardController;
  late TabPageSelector _tabPageSelector;
  List<ParentContestQuestiondata> contestQuestiondataDataList = [];
  bool isSubmit = false;
  int currentIndex = 0;
  ContestService contestService = getIt<ContestService>();
  UserDataService userDataService = getIt<UserDataService>();
  double value = 0;
  bool isTimeFinished = false;
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    value = double.parse(DateFormatter.getUTCRemainingTimeInMills(
            widget.contestExampleService?.contestdata?.start_date.toString() ??
                contestService.contestdata!.start_date)
        .toString());
    BlocProvider.of<ContestBloc>(context).add(GetContestQuestionDataEvent(
        context: context,
        contestId: widget.contestExampleService?.contestdata?.contest_id ??
            contestService.contestdata!.contest_id,
        userId: userDataService.userData.user_id));
  }

  void h() {
    BlocProvider.of<ContestBloc>(context).add(GetContestQuestionDataEvent(
        context: context,
        contestId: widget.contestExampleService?.contestdata?.contest_id ??
            contestService.contestdata!.contest_id,
        userId: userDataService.userData.user_id));
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(
            false,
            false,
          ),
        ),
        (route) => false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leadingWidth: 60,
              toolbarHeight: 500,
              centerTitle: true,
              leading: Container(
                width: 500,
                padding: const EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: () {
                    if (_cardController == null) {
                      _willPopCallback();
                      return;
                    }
                    if (isSubmit) {
                      _cardController?.animateTo(
                          (currentIndex + 1) %
                              contestQuestiondataDataList.length,
                          duration: const Duration(seconds: 10));
                      return;
                    }

                    if (_cardController?.index == 0) {
                      _willPopCallback();
                    }
                  },
                  child: Row(
                    children: const [
                      ImageIcon(
                        AssetImage(
                          "assets/left-arrow.png",
                        ),
                        color: Colors.black,
                        size: 20,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                    ],
                  ),
                ),
              ),
              title: Text(
                widget.contestExampleService == null
                    ? "Solve the Puzzle"
                    : "Practice Questions ",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xff3E3C3C),
                ),
              )),
        ),
        body: BlocListener<ContestBloc, ContestState>(
          listener: (context, state) {
            if (state is ContestCompleteState) {
              if (state.isContestCompleted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Home(true, false)));
                });
              }
              if (state.isCurrentIndexChanged == false) {
                _cardController = TabController(
                    vsync: this,
                    length: state.contestQuestiondataDataList?.length ?? 0);
                _tabPageSelector = TabPageSelector(controller: _cardController);
                contestQuestiondataDataList =
                    state.contestQuestiondataDataList ?? [];
                isSubmit = state.isSubmit;
                currentIndex = state.currentIndex;
                if (currentIndex < contestQuestiondataDataList.length - 1) {
                  BlocProvider.of<ContestBloc>(context).add(
                      GetContestQuestionDataEvent(
                          context: context,
                          contestId: widget.contestExampleService?.contestdata
                                  ?.contest_id ??
                              contestService.contestdata!.contest_id,
                          userId: userDataService.userData.user_id));
                }
                setState(() {});
              } else if (state.isCurrentIndexChanged == true) {
                {
                  currentIndex = state.currentIndex;
                  setState(() {});
                }
              }
            }
          },
          child: Column(
            children: [
              (contestQuestiondataDataList.isNotEmpty)
                  ? Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: SizedBox(
                        height: 60.h,
                        child: Center(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: contestQuestiondataDataList.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.only(top: 10.h),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                (contestQuestiondataDataList[
                                                                    index]
                                                                .question![
                                                            "puzzle_type"] ==
                                                        "jigsaw")
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 30.w,
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              child: Center(
                                                                child:
                                                                    Image.asset(
                                                                  "assets/jigsawpuzzle.png",
                                                                  height: 10.h,
                                                                  width: 10.w,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: (contestQuestiondataDataList[
                                                                              index]
                                                                          .is_submitted)
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .grey),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                                (contestQuestiondataDataList[
                                                                    index]
                                                                .question![
                                                            "puzzle_type"] ==
                                                        "sound")
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                            width: 30.w,
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              child: Center(
                                                                child: Image.asset(
                                                                    "assets/audio.png",
                                                                    height:
                                                                        10.h,
                                                                    width: 10.w,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: (contestQuestiondataDataList[
                                                                              index]
                                                                          .is_submitted)
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .grey),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                                (contestQuestiondataDataList[
                                                                    index]
                                                                .question![
                                                            "puzzle_type"] ==
                                                        "slide")
                                                    ? Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 30.w,
                                                            child: Container(
                                                              width: 20,
                                                              height: 20,
                                                              child: Center(
                                                                child: Image.asset(
                                                                    "assets/slide_puzzle.png",
                                                                    height:
                                                                        10.h,
                                                                    width: 10.w,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              decoration: BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color: (contestQuestiondataDataList[
                                                                              index]
                                                                          .is_submitted)
                                                                      ? Colors
                                                                          .green
                                                                      : Colors
                                                                          .grey),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : const SizedBox(),
                                              ],
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Card(
                                                  color:
                                                      (contestQuestiondataDataList[
                                                                  index]
                                                              .is_submitted)
                                                          ? Colors.green
                                                          : Colors.grey,
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child: Container(
                                                    // width: 40.w,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10,
                                                        vertical: 3),
                                                    child: Text(
                                                      contestQuestiondataDataList[
                                                              index]
                                                          .question![
                                                              "puzzle_type"]
                                                          .toString(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                //SizedBox(width: 35.w,)
                                              ],
                                            )
                                          ],
                                        ),
                                        Container(
                                            height: 50.h,
                                            margin:
                                                EdgeInsets.only(bottom: 20.h),
                                            child: Center(
                                              child: ((index + 1) <
                                                      contestQuestiondataDataList
                                                          .length)
                                                  ? Container(
                                                      width: 50.w,
                                                      height: 2.h,
                                                      margin: EdgeInsets.only(
                                                          left: 1.w,
                                                          right: 1.w),
                                                      color:
                                                          (contestQuestiondataDataList[
                                                                      index]
                                                                  .is_submitted)
                                                              ? Colors.green
                                                              : Colors.grey)
                                                  : const SizedBox(),
                                            ))
                                      ],
                                    ));
                              }),
                        ),
                      ),
                    )
                  : const Text(""),
              /*SizedBox(
                 height: 100.h,
                 width: 120.w,
                 child: CountDownProgressIndicator(
                   //controller: _controller,
                   valueColor: Colors.red,
                   backgroundColor: Colors.grey,
                   initialPosition: 0,
                   duration: DateFormatter.getUTCRemainingTimeInSeconds(contestService.contestdata!.end_date),
                   timeFormatter: (seconds) {
                     return Duration(seconds: seconds)
                         .toString()
                         .split('.')[0]
                         .padLeft(8, '0');
                   },
                   text: 'hh:mm:ss',
                   onComplete: () => null,
                 ),
               ),*/

              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (contestService.contestdata != null)
                        ? CountdownTimer(
                            endTime: DateFormatter.getUTCRemainingTimeInMills(
                                widget.contestExampleService?.contestdata
                                        ?.end_date ??
                                    contestService.contestdata!.end_date),
                            widgetBuilder: (_, time) {
                              DateTime endTime = DateTime.parse(widget
                                      .contestExampleService
                                      ?.contestdata
                                      ?.end_date ??
                                  contestService.contestdata!.end_date);
                              DateTime now = DateTime.now();
                              DateTime startTime = DateTime.parse(widget
                                      .contestExampleService
                                      ?.contestdata
                                      ?.start_date ??
                                  contestService.contestdata!.start_date);
                              double total = endTime
                                  .difference(startTime)
                                  .inSeconds
                                  .toDouble();
                              double remaining =
                                  endTime.difference(now).inSeconds.toDouble();
                              _progress = (total - remaining) / total;
                              print('${_progress * 100}% <<< progress');
                              if (time == null) {
                                _progress = 1;
                                isTimeFinished = true;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Home(false, false)));
                                return Padding(
                                  padding:
                                      EdgeInsets.only(top: 20.h, bottom: 20.h),
                                  child: Text('CLOSED',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp,
                                          fontFamily: "SL",
                                          fontWeight: FontWeight.bold)),
                                );
                              }
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 4.0, left: 2, top: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    (time.hours.toString() != "null")
                                        ? Text(
                                            time.hours.toString() + " hours",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp),
                                          )
                                        : Text(
                                            "00 hours",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp),
                                          ),
                                    SizedBox(width: 3.w),
                                    (time.min.toString() != "null")
                                        ? Text(
                                            time.min.toString() + " min",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp),
                                          )
                                        : Text(
                                            "00 min",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp),
                                          ),
                                    SizedBox(width: 3.w),
                                    (time.sec.toString() != "null")
                                        ? Text(
                                            time.sec.toString() + " sec",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp),
                                          )
                                        : Text(
                                            "00 sec",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 10.sp),
                                          ),
                                    Text(
                                      " Remaining",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 10.sp),
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : const Text(""),
                    Container(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      height: 6.h,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: LinearProgressIndicator(
                        value: _progress,
                        backgroundColor: Colors.grey[300],
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Expanded(child: contestQuestionsView(contestQuestiondataDataList))
            ],
          ),
        ),
      ),
    );
  }

  Widget contestQuestionsView(
      List<ParentContestQuestiondata> contestQuestiondataDataList) {
    print(contestQuestiondataDataList.length);
    print(' ==CD==-- $currentIndex $isSubmit');
    if (isSubmit && currentIndex == contestQuestiondataDataList.length - 1) {
      BlocProvider.of<ContestBloc>(context).add(
          CompleteContestQuestionDataEvent(
              context: context,
              contestId:
                  widget.contestExampleService?.contestdata?.contest_id ??
                      contestService.contestdata!.contest_id,
              userId: userDataService.userData.user_id,
              contestQuestiondataDataList: contestQuestiondataDataList));
    } else if (isSubmit) {
      _cardController?.animateTo(
          (currentIndex + 1) % contestQuestiondataDataList.length,
          duration: const Duration(seconds: 10));
    }
    print('${contestQuestiondataDataList.length} ==CD==-- $currentIndex');
    return (contestQuestiondataDataList.isNotEmpty &&
            currentIndex != contestQuestiondataDataList.length - 1)
        ? TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _cardController,
            children: contestQuestiondataDataList.isEmpty
                ? <Widget>[]
                : contestQuestiondataDataList.map((dynamicContent) {
                    print(
                        'val ${((dynamicContent.is_submitted == false || (dynamicContent.is_submitted == true && widget.contestExampleService != null)) && dynamicContent.question!["puzzle_type"] == "jigsaw")}');
                    if (((dynamicContent.is_submitted == false) &&
                        dynamicContent.question!["puzzle_type"] == "jigsaw")) {
                      return JigsawPuzzleTwo(
                        dynamicContent.question,
                        contestQuestiondataDataList,
                        _cardController!.index,
                        contestExampleService: widget.contestExampleService,
                        onIndexChanged: () {
                          //_cardController.animateTo((_cardController.index + 1) % contestQuestiondataDataList.length, duration: Duration(seconds: 10));
                        },
                      );
                    } else if (((dynamicContent.is_submitted == false) &&
                        dynamicContent.question!["puzzle_type"] == "sound")) {
                      return SoundPuzzle(
                        dynamicContent.question,
                        contestQuestiondataDataList,
                        _cardController!.index,
                        contestExampleService: widget.contestExampleService,
                        onIndexChanged: () {
                          //_cardController.animateTo((_cardController.index + 1) % contestQuestiondataDataList.length, duration: Duration(seconds: 10));
                        },
                      );
                    } else if (((dynamicContent.is_submitted == false) &&
                        dynamicContent.question!["puzzle_type"] == "slide")) {
                      return Board(
                        dynamicContent.question,
                        contestQuestiondataDataList,
                        _cardController!.index,
                        contestExampleService: widget.contestExampleService,
                        onIndexChanged: () {
                          // _cardController.animateTo((_cardController.index + 1) % contestQuestiondataDataList.length, duration: Duration(seconds: 10));
                        },
                      );
                    } else {
                      currentIndex = currentIndex + 1;
                      //BlocProvider.of<ContestBloc>(context).add(ChangeCurrentIndexEvent(context: context, contestId:"5",questionId:dynamicContent.question!["question_id"],answerGiven:"",isAnswerTrue:"true",moves:"",timeTaken:"",contestQuestiondataDataList: contestQuestiondataDataList,currentIndex: currentIndex));
                      _cardController?.animateTo(
                          (_cardController!.index + 1) %
                              contestQuestiondataDataList.length,
                          duration: const Duration(seconds: 10));
                      return const Text("");
                    }
                    return const Text("");
                  }).toList(),
          )
        : Center(
            child:
                dataNotAvailable("No Questions are Available in this contest."),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _cardController?.dispose();
  }
}
