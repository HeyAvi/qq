import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qq/bloc/ContestBloc/ContestBloc.dart';
import 'package:qq/models/ContestQuestiondata.dart';
import 'package:qq/models/ParentContestQuestiondata.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/ui/ContestDetails/SlidingPuzzle/Grid.dart';
import 'package:qq/ui/ContestDetails/SlidingPuzzle/Menu.dart';
import 'package:qq/ui/ContestDetails/SlidingPuzzle/MyTitle.dart';
import 'package:qq/utils/ColorConstants.dart';


class Board extends StatefulWidget {

  Map<String,dynamic>? dynamicContent;
  final VoidCallback onIndexChanged;
  List<ParentContestQuestiondata>? contestQuestiondataDataLists;
  int? indexs;

  Board(Map<String,dynamic>? _dynamicContent,List<ParentContestQuestiondata>? contestQuestiondataDataList, int index,{required this.onIndexChanged,}){
    dynamicContent = _dynamicContent;
    contestQuestiondataDataLists = contestQuestiondataDataList;
    indexs = index;
  }

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  var numbers  = [];//[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  int move = 0;

  static const duration = const Duration(seconds: 1);
  int secondsPassed = 0;
  bool isActive = false;
  Timer? timer;
  int startNumber = 10;
  int endNumber = 21;
  ContestService contestService =  getIt<ContestService>();


  @override
  void initState() {
    super.initState();

    var arr = jsonDecode(widget.dynamicContent!["content"]) as List;

    startNumber = int.parse(arr[0].toString());
    endNumber = int.parse(arr[1].toString());

    for(int i=startNumber ; i<=endNumber ; i++){
      numbers.add(i);
    }
    numbers.shuffle();

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (timer == null) {
      timer = Timer.periodic(duration, (Timer t) {
        startTime();
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height,
          color: Colors.grey,
          child: Column(
            children: <Widget>[
              MyTitle(size),
              Expanded(child: Grid(numbers, size, clickGrid),),
              Menu(reset, move, secondsPassed, size),
            ],
          ),
        ),
      ),
        floatingActionButton: Row(
            children: [
              Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 80,
                      ),
                      Container(
                        width: 150,
                        child: FloatingActionButton.extended(
                          backgroundColor: ColorConstants.primaryColor3,
                          onPressed: () => {
                             BlocProvider.of<ContestBloc>(context).add(SubmitQuestionDataEvent(context: context, contestId:contestService.contestdata!.contest_id,questionId:widget.dynamicContent!["question_id"],answerGiven:"yes",isAnswerTrue:"true".toString(),moves:"1",timeTaken:secondsPassed.toString(),contestQuestiondataDataList: widget.contestQuestiondataDataLists,currentIndex: widget.indexs!))
                          },
                          heroTag: null, label: Text("SUBMIT"),
                        ),
                      )
                    ],
                  )
              ),
            ]
        )
    );
  }

  void clickGrid(index) {
    if (secondsPassed == 0) {
      isActive = true;
    }
    if (index - 1 >= 0 && numbers[index - 1] == 0 && index % 4 != 0 ||
        index + 1 < 16 && numbers[index + 1] == 0 && (index + 1) % 4 != 0 ||
        (index - 4 >= 0 && numbers[index - 4] == 0) ||
        (index + 4 < 16 && numbers[index + 4] == 0)) {
      if(this.mounted){
        setState(() {
          move++;
          numbers[numbers.indexOf(0)] = numbers[index];
          numbers[index] = 0;
        });
      }
    }
    checkWin();
  }

  void startTime() {
    if (isActive) {
     if(this.mounted){
       setState(() {
         secondsPassed = secondsPassed + 1;
       });
     }
    }
  }

  void reset() {
    if(this.mounted){
      setState(() {
        numbers.shuffle();
        move = 0;
        secondsPassed = 0;
        isActive = false;
      });
    }
  }

  bool isSorted(List list) {
    int prev = list.first;
    for (var i = 1; i < list.length - 1; i++) {
      int next = list[i];
      if (prev > next) return false;
      prev = next;
    }
    return true;
  }

  void checkWin() {
    if (isSorted(numbers)) {
      isActive = false;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)), //this right here
              child: Container(
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You Win!!",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 220.0,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    }
  }
}
