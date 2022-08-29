import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qq/bloc/HomeDashBoradBloc/HomeDashBoardBloc.dart';
import 'package:qq/bloc/ProfileBloc/ProfileBloc.dart';
import 'package:qq/models/ContestUserData.dart';
import 'package:qq/models/Contestdata.dart';
import 'package:qq/models/Userdata.dart';
import 'package:qq/repository/ProfileRepository.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/ui/BottomNavigationWidget.dart';
import 'package:qq/ui/BuyTickets.dart';
import 'package:qq/ui/ContestDetails/ContestMainPage.dart';
import 'package:qq/ui/ProfileScreen.dart';
import 'package:qq/ui/Wallet/Wallet.dart';
import 'package:qq/ui/customDialogBox.dart';
import 'package:qq/ui/widgets/text_with_underline.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/Constants.dart';
import 'package:qq/utils/DataNotAvailable.dart';
import 'package:qq/utils/ShimmerEffect/HomeShimmerEffect.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slidable_button/slidable_button.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../repository/HomeDashBoardRepository.dart';
import '../utils/DateTimeFormatter.dart';
import 'ContestPlay.dart';

class Home extends StatelessWidget {
  final bool? isContestCompleted, isContestOpen;

  const Home(this.isContestCompleted, this.isContestOpen, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => HomeDashBoardBloc(HomeDashBoardRepository(Dio())),
        ),
        BlocProvider(
            create: (context) => ProfileBloc(ProfileRepository(Dio()))),
      ],
      child: HomeStateful(isContestCompleted!, isContestOpen!),
    ));
  }
}

class HomeStateful extends StatefulWidget {
  final bool? isContestCompleted, isContestOpen;

  const HomeStateful(this.isContestCompleted, this.isContestOpen, {Key? key})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeStateful> {
  bool status = false;
  UserDataService userDataService = getIt<UserDataService>();
  ContestService contestService = getIt<ContestService>();
  Userdata? userData;
  String rules = "";
  DateTime selectedDate = DateTime.now();
  int initialLabelIndexs = 0;
  Contestdata? contestdata;
  List<ContestUserData>? contestUserDataList;
  bool isMove = false;
  bool dataInitialized = false;
  String btnName = "BOOKED";
  int backIndex = 0;
  var positions;
  bool isRules = false;
  bool isExpanded = false;

  Future<void> getRulesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isRules = prefs.getBool('rules') ?? false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> setRulesData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rules', isRules);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getRulesData();
    BlocProvider.of<ProfileBloc>(context)
        .add(GetProfileDataEvent(context: context));
    BlocProvider.of<ProfileBloc>(context).stream.listen((event) {
      userData = userDataService.userData;
      context
          .read<HomeDashBoardBloc>()
          .add(FetchContestEvent(context: context, userId: userData!.user_id));
      context.read<HomeDashBoardBloc>().add(GetLastContestDataEvent(
          context: context, date: "", contestdata: null));
      setState(() {});
    });
    Future.delayed(Duration.zero, () {
      if (widget.isContestCompleted! && mounted) {
        DialogUtil.showInfoDialog(
            message: "Contest Submitted Successfully.",
            title: 'Contest Submitted',
            context: context,
            dialogType: DialogType.SUCCES);
      }
      if (widget.isContestOpen == true && (contestService.userBooked)) {
        DialogUtil.showInfoDialog(
            message: "Contest is not live now.",
            title: 'Info',
            context: context,
            dialogType: DialogType.INFO);
      }
      if (widget.isContestOpen == true && !(contestService.userBooked)) {
        DialogUtil.showInfoDialog(
            message: "You're not booked for this contest.",
            context: context,
            title: 'Not Booked Yet',
            dialogType: DialogType.ERROR);
      }
    });
    positions = SlidableButtonPosition.left;
  }

  Future<bool> _willPopCallback() async {
    if (backIndex < 2) {
      backIndex++;
      Fluttertoast.showToast(
          msg: "Please Press again to exit from app.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(' winner zone ${contestdata?.winner_zone}');
    // todo from here use [contestdata.winner_zone]
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        extendBody: true,
          backgroundColor: Colors.white,
          body: BlocListener<HomeDashBoardBloc, HomeDashBoardState>(
              listener: (context, state) {
                if (state is HomeDashBoardCompleteState) {
                  setState(() {
                    dataInitialized = true;
                  });
                  if (state.contestdata != null) {
                    rules = "";
                    setState(() {
                      contestdata = state.contestdata;
                      if (contestService.participated) {
                        setState(() {
                          btnName = "Participated";
                        });
                      }
                    });
                    var parsedListJson =
                        jsonDecode(state.contestdata!.rules) as List;
                    String key1 = " ", value1 = "";
                    for (int i = 0; i < parsedListJson.length; i++) {
                      Map map = parsedListJson[i];
                      map.forEach((key, value) {
                        key1 = key;
                        value1 = value;
                      });
                      rules = rules + key1 + ". " + value1 + "\n";
                    }
                  }
                  if (state.contestUserDataList != null) {
                    setState(() {
                      contestUserDataList = state.contestUserDataList;
                    });
                  } else {
                    setState(() {
                      contestUserDataList = null;
                    });
                  }
                }
              },
              child: (dataInitialized)
                  ? SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // First pink container
                          _buildTopContainer(contestdata),
                          // Button with offset
                          _buildMidContainerWithButton(),
                          // Bottom white container
                          _buildBottomContainer(
                              contestUserDataList, contestdata),
                        ],
                      ),
                    )
                  : homeShimmerEffect()),
          bottomNavigationBar: const BottomNavigationWidget(0)),
    );
  }

  Widget _buildTopContainer(Contestdata? contestdata) => Container(
        padding: const EdgeInsets.only(bottom: 40),
        decoration: BoxDecoration(
          color: ColorConstants.orangeColor,
          border: Border.all(
            color: ColorConstants.primaryColor,
          ),
          borderRadius: isExpanded
              ? null
              : BorderRadius.only(
                  bottomLeft: Radius.circular(30.h),
                  bottomRight: Radius.circular(30.h),
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: Row(
                    children: [
                      InkWell(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wallet()));
                            setState(() {
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(GetProfileDataEvent(context: context));
                              BlocProvider.of<ProfileBloc>(context)
                                  .stream
                                  .listen((event) {
                                userData = userDataService.userData;
                                context.read<HomeDashBoardBloc>().add(
                                    FetchContestEvent(
                                        context: context,
                                        userId: userData!.user_id));
                                context.read<HomeDashBoardBloc>().add(
                                    GetLastContestDataEvent(
                                        context: context,
                                        date: "",
                                        contestdata: null));
                                setState(() {});
                              });
                              Future.delayed(Duration.zero, () {
                                if (widget.isContestCompleted! && mounted) {
                                  DialogUtil.showInfoDialog(
                                      message:
                                          "Contest Submitted Successfully.",
                                      title: 'Contest Submitted',
                                      context: context,
                                      dialogType: DialogType.SUCCES);
                                }
                                if (widget.isContestOpen == true &&
                                    (contestService.userBooked)) {
                                  DialogUtil.showInfoDialog(
                                      message: "Contest is not live now.",
                                      title: 'Info',
                                      context: context,
                                      dialogType: DialogType.INFO);
                                }
                                if (widget.isContestOpen == true &&
                                    !(contestService.userBooked)) {
                                  DialogUtil.showInfoDialog(
                                      message:
                                          "You're not booked for this contest.",
                                      context: context,
                                      title: 'Not Booked Yet',
                                      dialogType: DialogType.ERROR);
                                }
                              });
                              positions = SlidableButtonPosition.left;
                            });
                          },
                          child: (userDataService.walletAmount == "null")
                              ? const TextWithUnderline(text: '₹ 0')
                              : TextWithUnderline(
                                  lineHeight: 0,
                                  underlineHeight: 0.5,
                                  text: '₹ ${userDataService.walletAmount}')),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BuyTickets()));
                        },
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        userDataService.totalTickets,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      RotatedBox(
                                        quarterTurns: 0,
                                        child: Image.asset("assets/tokens.png",
                                            height: 30, width: 30),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                right: 0,
                                top: 0,
                                bottom: 0,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 17,
                                        height: 17,
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            )),
                                      ),
                                      const Text('+',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const ProfileScreen(),
                            transitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: SizedBox(
                          height: 68.h,
                          width: 68.w,
                          child: Image.asset("assets/accountMan.png")),
                    ),
                    Column(
                      children: [
                        const TextWithUnderline(
                          text: 'Rules',
                          lineHeight: 0,
                          fontSize: 11,
                        ),
                        Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: isRules,
                                trackColor: Colors.grey[800],
                                activeColor: Colors.white70,
                                onChanged: (val) {
                                  setState(() {
                                    isRules = val;
                                    setRulesData();
                                  });
                                  if (isRules) {
                                    showDialog(
                                        barrierDismissible: false,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return WillPopScope(
                                            onWillPop: () async {
                                              setState(() {
                                                isRules = false;
                                                setRulesData();
                                              });
                                              return true;
                                            },
                                            child: CustomDialogBox(
                                              title: "Rules",
                                              descriptions: rules,
                                              ruleButton: true,
                                              text: "Yes",
                                              onCountSelected: (string) {
                                                setState(() {
                                                  if (string == "agree") {
                                                    positions =
                                                        SlidableButtonPosition
                                                            .right;
                                                  } else {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      isRules = false;
                                                      setRulesData();
                                                    });
                                                  }
                                                });
                                              },
                                            ),
                                          );
                                        });
                                  }
                                },
                              ),
                            ),
                            Visibility(
                              visible: !isRules,
                              child: const Positioned(
                                  // right: 3,
                                left: 32,
                                  child: Icon(
                                    Icons.check,
                                    size: 16,
                                    color: ColorConstants.primaryColor2,
                                  )),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              ]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20.h,
                ),
                Image.asset(
                  "assets/4-2-treasure-picture-thumb.png",
                  height: 100.h,
                ),
                SizedBox(width: 15.w)
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            SizedBox(
              height: 30.h,
              child: (contestdata != null)
                  ? Text(
                      contestdata.name,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold),
                    )
                  : Text(
                      "No Contest",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold),
                    ),
            ),
            (contestdata != null)
                ? CountdownTimer(
                    endTime: DateFormatter.getUTCRemainingTimeInMills(
                        contestService.contestdata!.start_date),
                    widgetBuilder: (_, time) {
                      if (time == null) {
                        isMove = true;
                        return Padding(
                          padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
                          child: Text('LIVE',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontFamily: "SL",
                                  fontWeight: FontWeight.bold)),
                        );
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Card(
                                child: Container(
                                  width: 30.h,
                                  height: 30.h,
                                  margin: EdgeInsets.all(2.h),
                                  //padding: EdgeInsets.all(8.h),
                                  color: Colors.greenAccent,
                                  child: Center(
                                    child: (time.hours.toString() != "null")
                                        ? Text(
                                            time.hours.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          )
                                        : Text(
                                            "00",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          ),
                                  ),
                                ),
                              ),
                              Text(
                                "HOURS",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.sp,
                          ),
                          Column(
                            children: [
                              Card(
                                child: Container(
                                  width: 30.h,
                                  height: 30.h,
                                  margin: const EdgeInsets.all(2),
                                  //padding: EdgeInsets.all(8),
                                  color: const Color(0xffce112c),
                                  child: Center(
                                    child: (time.min.toString() != "null")
                                        ? Text(
                                            time.min.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          )
                                        : Text(
                                            "00",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          ),
                                  ),
                                ),
                              ),
                              Text(
                                "MIN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            children: [
                              Card(
                                child: Container(
                                  width: 30.h,
                                  height: 30.h,
                                  margin: EdgeInsets.all(2.h),
                                  //padding: EdgeInsets.all(8.h),
                                  color: const Color(0xffC77D0A),
                                  child: Center(
                                    child: (time.sec.toString() != "null")
                                        ? Text(
                                            time.sec.toString(),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          )
                                        : Text(
                                            "00",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          ),
                                  ),
                                ),
                              ),
                              Text(
                                "SEC",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  )
                : SizedBox(
                    height: 30.h,
                  ),
            SizedBox(
              height: 15.h,
            ),
            (contestdata != null)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Entry open till - ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormatter.getTime(contestdata.start_date),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Status - ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                (userData != null &&
                                        userData!.is_eligible == "yes")
                                    ? Text(
                                        " Eligible",
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        " Not Eligible",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const Text(""),
            SizedBox(
              height: 5.h,
            ),
            if (contestdata != null)
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>
                  //             Prices(contestdata.winner_zone)));
                },
                child: Center(
                    child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedContainer(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: isExpanded ? 300 : 40,
                        duration: const Duration(milliseconds: 180),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                          color: Colors.red[800],
                          child: isExpanded
                              ? SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          'Winners & Prizes',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      const Divider(
                                        color: Colors.white,
                                        endIndent: 30,
                                        indent: 30,
                                        height: 0,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          contestdata.winner_zone,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: const [
                                            TextWithUnderline(
                                              text: 'Ranks',
                                              fontSize: 13,
                                              underlineHeight: 0.5,
                                              fontWeight: FontWeight.normal,
                                              lineHeight: 0,
                                            ),
                                            TextWithUnderline(
                                              text: 'Reward',
                                              fontSize: 13,
                                              underlineHeight: 0.5,
                                              fontWeight: FontWeight.normal,
                                              lineHeight: 0,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 210,
                                        child: ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          itemCount:
                                              contestdata.winner_zone.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      CircleAvatar(
                                                        child: Text(
                                                          contestdata
                                                                  .winner_zone[
                                                              index][0],
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 14),
                                                        ),
                                                        radius: 14,
                                                        backgroundColor:
                                                            Colors.red[900],
                                                      ),
                                                      const Text(
                                                        'fs',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: Colors.red[900],
                                                    thickness: 2,
                                                    indent: 5,
                                                    endIndent: 5,
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Column(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Winners & Prizes',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          letterSpacing: 2.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: isExpanded ? 290 : 30,
                      right: 0,
                      left: 0,
                      child: SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: IconButton(
                          iconSize: 15.w,
                          icon: RotatedBox(
                              quarterTurns: isExpanded ? 2 : 0,
                              child: const Icon(
                                  Icons.arrow_drop_down_circle_outlined)),
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                )),
              )
          ],
        ),
      );

  Widget _buildMidContainerWithButton() {
    const buttonHeight = 60.0;
    return (contestdata != null)
        ? (contestService.userBooked)
            ? Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(0.0, -buttonHeight / 2.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          /*if(contestService.participated){
                    DialogUtil.showInfoDialog("You've already participated in this Contest.", context);
                  }
                  else{
                    showDialog(context: context,
                        builder: (BuildContext context){
                          return showContestConfirmationDialog(context);
                        }
                    );
                  }*/
                        },
                        child: Container(
                            height: buttonHeight,
                            width: MediaQuery.of(context).size.width.w / 1.4.w,
                            decoration: BoxDecoration(
                              color: ColorConstants.primaryColor2,
                              borderRadius:
                                  BorderRadius.circular(buttonHeight / 2.0),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 16.0,
                                  offset: const Offset(0.0, 6.0),
                                  color: Colors.black.withOpacity(0.16),
                                ),
                              ],
                            ),
                            //padding: const EdgeInsets.fromLTRB(24.0, 3.0, 24.0, 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 20.h,
                                  width: 20.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.h),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: ColorConstants.primaryColor2,
                                    size: 17,
                                  ),
                                ),
                                SizedBox(width: 10.h),
                                Text(
                                  btnName,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ),
                  )
                ],
              )
            : Stack(
                children: [
                  Transform.translate(
                    offset: const Offset(0.0, -buttonHeight / 2.0),
                    child: Center(
                      child: SlidableButton(
                        width: MediaQuery.of(context).size.width.w / 1.4.w,
                        //buttonWidth: 60.h,
                        height: buttonHeight,
                        isRestart: true,
                        initialPosition: positions,
                        color: ColorConstants.primaryColor2,
                        dismissible: false,
                        label: Center(
                          child: Image.asset(
                            "assets/tokens.png",
                            height: 30.h,
                            width: 30.h,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10.h,
                              ),
                              Expanded(
                                  child: Center(
                                child: Text(
                                  'Swipe To Enter',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                              SizedBox(
                                width: 10.h,
                              )
                            ],
                          ),
                        ),
                        onChanged: isRules
                            ? (position) {
                                if (position == SlidableButtonPosition.right) {
                                  setState(() {
                                    positions = SlidableButtonPosition.right;
                                    if (userDataService.totalTickets
                                                .toString() ==
                                            "" ||
                                        userDataService.totalTickets
                                                .toString() ==
                                            "null" ||
                                        userDataService.totalTickets
                                                .toString() ==
                                            "0") {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return DialogUtil.showTicketInfoDialog(
                                                "Please purchase a ticket first.",
                                                context);
                                          });
                                    } else {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              ContestPlay(true),
                                          transitionDuration: Duration.zero,
                                        ),
                                      );
                                    }
                                  });
                                }
                              }
                            : (position) {
                                setState(() {
                                  if (position ==
                                      SlidableButtonPosition.right) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CustomDialogBox(
                                            title: "Rules",
                                            descriptions: rules,
                                            text: "Yes",
                                            onCountSelected: (string) {
                                              setState(() {
                                                if (string == "agree") {
                                                  positions =
                                                      SlidableButtonPosition
                                                          .right;
                                                } else {
                                                  Navigator.pop(context);
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             Home(false, false)));
                                                }
                                              });
                                            },
                                          );
                                        });
                                  } else {}
                                });
                              },
                      ),
                    ),
                  ),
                ],
              )
        : const SizedBox(
            height: buttonHeight,
          );
  }

  Widget _buildBottomContainer(List<ContestUserData>? contestUserDataList,
          Contestdata? contestdata) =>
      Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ToggleSwitch(
                        cornerRadius: 30.h,
                        activeBgColors: const [
                          [ColorConstants.orangeColor],
                          [ColorConstants.orangeColor]
                        ],
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.white,
                        inactiveFgColor: Colors.black,
                        borderColor: const [Colors.black26],
                        fontSize: 12.sp,
                        borderWidth: 1,
                        radiusStyle: true,
                        minWidth: 92.w,
                        minHeight: 32.h,
                        initialLabelIndex: initialLabelIndexs,
                        totalSwitches: 2,
                        labels: const ['Last Result', 'Date Range'],
                        onToggle: (index) async {
                          initialLabelIndexs = index!;
                          if (index == 0) {
                            BlocProvider.of<HomeDashBoardBloc>(context).add(
                                GetLastContestDataEvent(
                                    context: context,
                                    date: "",
                                    contestdata: contestdata));
                          } else if (index == 1) {
                            DateTime? selected = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2010),
                              lastDate: DateTime.now(),
                            );
                            if (selected != null && selected != selectedDate) {
                              selectedDate = selected;
                            }
                            var arr = selectedDate.toString().split(" ");
                            BlocProvider.of<HomeDashBoardBloc>(context).add(
                                GetLastContestDataEvent(
                                    context: context,
                                    date: arr[0].toString(),
                                    contestdata: contestdata));
                          }
                        },
                      ),
                    ],
                  ),
                  (contestUserDataList != null &&
                          contestUserDataList.isNotEmpty)
                      ? Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: (contestUserDataList.length >= 2)
                                      ? Column(
                                          children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20.h)),
                                            SizedBox(
                                              width: 15.w,
                                              height: 15.h,
                                              child: FittedBox(
                                                child: Image.asset(
                                                  'assets/arrow-up.png',
                                                  color: ColorConstants
                                                      .primaryColor2,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '2',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.sp),
                                            ),
                                            CircleAvatar(
                                              radius: 20.h,
                                              backgroundImage: const AssetImage(
                                                  "assets/userprofile.png"),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              contestUserDataList[1].name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            /*Text('@123', style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12
                      ),),
                      Text('124', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18
                      ),),*/
                                          ],
                                        )
                                      : const Text(""),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: (contestUserDataList.isNotEmpty)
                                      ? Column(
                                          children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 0.h)),
                                            SizedBox(
                                              width: 35.w,
                                              height: 30.h,
                                              child: FittedBox(
                                                child: Image.asset(
                                                  'assets/crown.png',
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            ),
                                            const CircleAvatar(
                                              radius: 35.0,
                                              backgroundImage: AssetImage(
                                                  "assets/userprofile.png"),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              contestUserDataList[0].name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        )
                                      : const Text(""),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: (contestUserDataList.length >= 3)
                                      ? Column(
                                          children: [
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20.h)),
                                            Text(
                                              '3',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.sp),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                              height: 15.h,
                                              child: FittedBox(
                                                child: Image.asset(
                                                    'assets/arrow-down-filled-triangle.png',
                                                    color: Colors.red),
                                              ),
                                            ),
                                            CircleAvatar(
                                              radius: 20.h,
                                              backgroundImage: const AssetImage(
                                                  "assets/userprofile.png"),
                                              backgroundColor:
                                                  Colors.transparent,
                                            ),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text(
                                              contestUserDataList[2].name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            /*Text('@123', style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 12
                      ),),
                      Text('124', style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18
                      ),),*/
                                          ],
                                        )
                                      : const Text(""),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            (contestUserDataList.length > 3)
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(0.0),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: contestUserDataList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding: EdgeInsets.only(top: 5.h),
                                        child: InkWell(
                                            onTap: () {},
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                Text(
                                                  (index + 3).toString() + ".",
                                                  style: TextStyle(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),

                                                CircleAvatar(
                                                  radius: 18.h,
                                                  backgroundImage: const AssetImage(
                                                      "assets/userprofile.png"),
                                                  backgroundColor:
                                                      Colors.transparent,
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.all(2)),
                                                Text(
                                                  contestUserDataList[index + 3]
                                                      .name,
                                                  style: TextStyle(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(5.h)),
                                                SizedBox(
                                                  child: SfSparkLineChart(
                                                    //Enable the trackball
                                                    trackball:
                                                        const SparkChartTrackball(
                                                            activationMode:
                                                                SparkChartActivationMode
                                                                    .tap),
                                                    //Enable marker
                                                    marker: const SparkChartMarker(
                                                        displayMode:
                                                            SparkChartMarkerDisplayMode
                                                                .all),
                                                    //Enable data label
                                                    labelDisplayMode:
                                                        SparkChartLabelDisplayMode
                                                            .all,
                                                    data: const <double>[
                                                      1,
                                                      5,
                                                      -6,
                                                      0,
                                                    ],
                                                  ),
                                                  width: 80.w,
                                                  height: 50.h,
                                                ),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(5.h)),

                                                Container(
                                                  height: 30.h,
                                                  width: 55.w,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.h),
                                                      color: const Color(
                                                        0xffd8efe5,
                                                      )),
                                                  child: Center(
                                                    child: Text(
                                                      '\$930',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: ColorConstants
                                                              .primaryColor2,
                                                          fontSize: 14.sp),
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                //
                                              ],
                                            )),
                                      );
                                    },
                                  )
                                : const Text("")
                          ],
                        )
                      : Center(
                          child: dataNotAvailable(
                              "No Previous results Available."),
                        ),
                ]),
          ));

  showContestConfirmationDialog(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: SizedBox(
        //width: 300.w,
        height: MediaQuery.of(context).size.height.h,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: Constants.padding,
                  top: Constants.padding,
                  right: Constants.padding,
                  bottom: Constants.padding),
              margin: EdgeInsets.only(
                  top: Constants.avatarRadius + Constants.padding),
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Constants.padding),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10),
                  ]),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                      height: 50.h,
                      width: 150.h,
                      decoration: BoxDecoration(
                        color: ColorConstants.primaryColor2,
                        borderRadius: BorderRadius.circular(50.h / 2.0),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 16.0,
                            offset: const Offset(0.0, 6.0),
                            color: Colors.black.withOpacity(0.16),
                          ),
                        ],
                      ),
                      //padding: const EdgeInsets.fromLTRB(24.0, 3.0, 24.0, 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 20.h,
                            width: 20.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.h),
                            ),
                            child: const Icon(
                              Icons.check,
                              color: ColorConstants.primaryColor2,
                              size: 17,
                            ),
                          ),
                          SizedBox(width: 10.h),
                          Text(
                            'BOOKED',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    "You're booked for this contest , do you want to participate ?",
                    style: TextStyle(fontSize: 14.sp),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 22.h,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  if (isMove) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContestMainPage()));
                                  } else {
                                    DialogUtil.showInfoDialog(
                                        message: "Contest is not Live now.",
                                        context: context,
                                        title: 'Info',
                                        dialogType: DialogType.INFO);
                                  }
                                },
                                child: Container(
                                  width: 120.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: ColorConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(30.h),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'Yes',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 18.sp),
                                  )),
                                ),
                              )),
                          SizedBox(width: 10.h),
                          Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 120.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: ColorConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(30.h),
                                  ),
                                  child: Center(
                                      child: Text(
                                    'No',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.white,
                                        fontSize: 18.sp),
                                  )),
                                ),
                              )),
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
