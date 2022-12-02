import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qq/bloc/TicketsBloc/TicketsBloc.dart';
import 'package:qq/dataproviders/TicketsProvider.dart';
import 'package:qq/models/Ticketdata.dart';
import 'package:qq/repository/TicketsRepository.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/ui/ContestDetails/ContestMainPage.dart';
import 'package:qq/ui/ads_practice_play.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/DateTimeFormatter.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';
import 'dart:math' as math;
import 'package:shared_preferences/shared_preferences.dart';

import 'BuyTickets.dart';

class ContestPlay extends StatelessWidget {
  final bool? isAlreadyBooked;

  const ContestPlay(this.isAlreadyBooked, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => TicketsBloc(TicketsRepository(Dio())),
        child: ContestUserStateful(isAlreadyBooked!),
      ),
    );
  }
}

class ContestUserStateful extends StatefulWidget {
  final bool? isAlreadyBooked;

  const ContestUserStateful(this.isAlreadyBooked, {Key? key}) : super(key: key);

  @override
  _ContestUserState createState() => _ContestUserState();
}

class _ContestUserState extends State<ContestUserStateful> {
  String userId = "";
  late BuildContext stateContext;
  ContestService contestService = getIt<ContestService>();
  bool isMove = false;
  List<Ticketdata>? ticketDataList;

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }

  Future<void> getSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
    context
        .read<TicketsBloc>()
        .add(GetTicketsDataEvent(context: context, userId: userId));
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home(false, false)),
        (route) => false);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          backgroundColor: ColorConstants.colorBackground,
          body: SafeArea(
            child: Container(
                padding: EdgeInsets.only(
                    left: 20.w, top: 20.h, right: 20.w, bottom: 0.h),
                child: BlocListener<TicketsBloc, TicketsState>(
                  listener: (context, state) {
                    if (state is TicketsCompleteState) {
                      setState(() {
                        ticketDataList = state.ticketDataList;
                      });
                      log('contest user submit ${state.contestUserSubmit}');
                      log('$isMove');
                      if (state.contestUserSubmit && isMove) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ContestMainPage()));
                      } else if (state.contestUserSubmit && !isMove) {
                        DialogUtil.showInfoDialog(
                            message: "You're booked for this contest.",
                            context: context,
                            title: 'Successfully Booked',
                            dialogType: DialogType.SUCCES);
                      }
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _willPopCallback();
                            },
                            child: const Icon(
                              Icons.arrow_back_sharp,
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'ONE STEP AWAY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),

                      Center(
                        child: CountdownTimer(
                          endTime: DateFormatter.getUTCRemainingTimeInMills(
                              contestService.contestdata!.start_date),
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              isMove = true;
                              if ((ticketDataList?.isNotEmpty ?? false) &&
                                  isMove) {
                                BlocProvider.of<TicketsBloc>(context).add(
                                  SubmitContextUserEvent(
                                    context: context,
                                    userId: userId,
                                    ticketId: ticketDataList![0].ticket_id,
                                    contestId:
                                        contestService.contestdata!.contest_id,
                                    ticketDataList: ticketDataList,
                                    status: Status.A,
                                  ),
                                );
                              }
                              return Container(
                                  margin: EdgeInsets.only(top: 15.h),
                                  width: 125.w,
                                  padding: EdgeInsets.all(8.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.h),
                                      border: Border.all(
                                          width: 2.h,
                                          color: ColorConstants.primaryColor3)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '00',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            color:
                                                ColorConstants.primaryColor3),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        ':',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                ColorConstants.primaryColor3),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '00',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            color:
                                                ColorConstants.primaryColor3),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        ':',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                ColorConstants.primaryColor3),
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        '00',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20.sp,
                                            color:
                                                ColorConstants.primaryColor3),
                                      ),
                                    ],
                                  ));
                            }
                            return Container(
                                margin: EdgeInsets.only(top: 15.h),
                                width: 125.w,
                                padding: EdgeInsets.all(8.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.h),
                                    border: Border.all(
                                        width: 2.h,
                                        color: ColorConstants.primaryColor3)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    (time.hours.toString() != "null")
                                        ? Text(
                                            time.hours.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: ColorConstants
                                                    .primaryColor3),
                                          )
                                        : Text(
                                            '00',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: ColorConstants
                                                    .primaryColor3),
                                          ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      ':',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.primaryColor3),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    (time.min.toString() != "null")
                                        ? Text(
                                            time.min.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: ColorConstants
                                                    .primaryColor3),
                                          )
                                        : Text(
                                            '00',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: ColorConstants
                                                    .primaryColor3),
                                          ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      ':',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ColorConstants.primaryColor3),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    (time.sec.toString() != "null")
                                        ? Text(
                                            time.sec.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: ColorConstants
                                                    .primaryColor3),
                                          )
                                        : Text(
                                            '00',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.sp,
                                                color: ColorConstants
                                                    .primaryColor3),
                                          ),
                                  ],
                                ));
                          },
                        ),
                      ),
                      // : const Text(""),
                      SizedBox(
                        height: 20.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Transform.rotate(
                            angle: -math.pi / 15,
                            child: Image.asset(
                              "assets/game_controller_one.png",
                              width: MediaQuery.of(context).size.width.w / 1.5,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          RotationTransition(
                            turns: const AlwaysStoppedAnimation(20 / 360),
                            child: Image.asset(
                              "assets/game_controller_two.png",
                              width: MediaQuery.of(context).size.width.w / 1.5,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 120.w,
                                height: 35.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                    // foreground
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.h),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (contestService.userBooked) {
                                      Fluttertoast.showToast(
                                          msg:
                                              'Already booked for another contest');
                                      return;
                                    }

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PracticePlayAds(
                                                  ticketDataList:
                                                      ticketDataList,
                                                )));
                                  },
                                  child: Text(
                                    'Practice Play',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                              flex: 1,
                              child: SizedBox(
                                width: 120.w,
                                height: 35.h,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Colors.indigoAccent,
                                      // foreground
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.h))),
                                  onPressed: () {
                                    if (ticketDataList?.isNotEmpty ?? false) {
                                      BlocProvider.of<TicketsBloc>(context).add(
                                          SubmitContextUserEvent(
                                              context: context,
                                              userId: userId,
                                              ticketId:
                                                  ticketDataList![0].ticket_id,
                                              contestId: contestService
                                                  .contestdata!.contest_id,
                                              ticketDataList: ticketDataList,
                                              status: Status.A));
                                    } else {
                                      DialogUtil.showInfoDialog(
                                          message:
                                              "Please buy some tickets first to enter the contest!",
                                          context: context,
                                          title: 'No tickets available',
                                          onOkTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const BuyTickets()));
                                          },
                                          dialogType: DialogType.ERROR);
                                    }
                                  },
                                  child: Text(
                                    isMove ? 'Play' : 'Join',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 40.w, right: 40.w),
                        child: Text(
                          'Practice Play users are not eligible for any reward & real ranking on leaderboard.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.sp,
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ),
        ));
  }
}
