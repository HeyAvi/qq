import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/ContestBloc/ContestBloc.dart';
import 'package:qq/models/ParentContestQuestiondata.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/ui/widgets/text_with_underline.dart';
import 'package:qq/utils/ApiConstants.dart';
import 'package:qq/utils/ColorConstants.dart';

import '../../live_player_layout.dart';

class SoundPuzzle extends StatefulWidget {
  Map<String, dynamic>? dynamicContent;
  final VoidCallback onIndexChanged;
  List<ParentContestQuestiondata>? contestQuestiondataDataLists;
  int? indexs;
  final ContestExampleService? contestExampleService;

  SoundPuzzle(
    Map<String, dynamic>? _dynamicContent,
    List<ParentContestQuestiondata>? contestQuestiondataDataList,
    int index, {
    required this.onIndexChanged,
    required this.contestExampleService,
  }) {
    dynamicContent = _dynamicContent;
    contestQuestiondataDataLists = contestQuestiondataDataList;
    indexs = index;
  }

  @override
  _SoundPuzzleState createState() => _SoundPuzzleState();
}

class _SoundPuzzleState extends State<SoundPuzzle> {
  ContestService contestService = getIt<ContestService>();
  AudioPlayer audioPlayer = AudioPlayer();
  String soundUrl =
      ""; //"https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3";
  bool clickPlay = false;

  int _start = 7200;
  int seconds = 0;
  late Timer _timer;
  int totalDuration = 0;
  int currentDuration = 0;

  void startTimer() async {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) async {
        currentDuration = await audioPlayer.getCurrentPosition();
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
            seconds++;
          });
        }
      },
    );
  }

  play() async {
    int result = await audioPlayer.play(soundUrl);
    if (result == 1) {
      // success
    }
  }

  pause() async {
    int result = await audioPlayer.pause();
    if (result == 1) {
      // success
    }
  }

  @override
  void initState() {
    super.initState();
    soundUrl = ApiConstants.IMAGE_URL + widget.dynamicContent!["content"];
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    print(totalDuration);
    print(currentDuration);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30.h,
            ),
            /* Center(
              child: Container(
                  width: 100,
                  height: 100,
                  alignment: Alignment.center,
                  child: (clickPlay) ? GestureDetector(onTap: (){
                    if(this.mounted){
                      setState(()  {
                        clickPlay = false;
                        pause();
                      });
                    }
                  },child: Icon(Icons.pause, size: 40,color: Colors.white,)):GestureDetector(onTap: (){
                    if(this.mounted){
                      setState(() {
                        clickPlay = true;
                        play();
                      });
                    }
                  },child: Icon(Icons.play_arrow, size: 40,color: Colors.white,)),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorConstants.primaryColor3,
                  )),
            ),*/
            Center(
                child: Container(
                    width: 150,
                    height: 150,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.black87),
                    child: Center(
                      child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          child: (clickPlay)
                              ? GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        clickPlay = false;
                                        pause();
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.pause,
                                    size: 40,
                                    color: Colors.white,
                                  ))
                              : GestureDetector(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        clickPlay = true;
                                        play();
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                    color: Colors.white,
                                  )),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: <Color>[
                                Color(0XFFC04848),
                                Color((0XFF480048))
                              ],
                            ),
                          )),
                    ))),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                (widget.dynamicContent != null)
                    ? Text(
                        widget.dynamicContent!["question"],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Color(0xff3E3C3C),
                        ),
                      )
                    : const Text(""),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: const Center(
                  child: SizedBox(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        // border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(10.0)),
                        // labelText: "Name of the Song",
                        hintText: "Name of the Song",
                        hintStyle: TextStyle(
                          fontSize: 12,
                        ),
                        //suffixIcon: Icon(Icons.wallet_giftcard_sharp, color: ColorConstants.primaryColor3)
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    BlocProvider.of<ContestBloc>(context).add(
                        SubmitQuestionDataEvent(
                            context: context,
                            contestId: widget.contestExampleService?.contestdata
                                    ?.contest_id ??
                                contestService.contestdata!.contest_id,
                            questionId: widget.dynamicContent!["question_id"],
                            answerGiven: "yes",
                            isAnswerTrue: "true",
                            moves: "1",
                            timeTaken: seconds.toString(),
                            contestQuestiondataDataList:
                                widget.contestQuestiondataDataLists,
                            currentIndex: widget.indexs!));
                  },
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const LivePlayerLayout(),
    );
  }
}
