import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/HomeDashBoradBloc/HomeDashBoardBloc.dart';
import 'package:qq/bloc/ProfileBloc/ProfileBloc.dart';
import 'package:qq/models/Contestdata.dart';
import 'package:qq/models/Userdata.dart';
import 'package:qq/repository/HomeDashBoardRepository.dart';
import 'package:qq/repository/ProfileRepository.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/ui/ContestPlay.dart';
import 'package:qq/ui/customerSupport.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/ui/notificationScreen.dart';
import 'package:qq/ui/profile_screen.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/DateTimeFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BottomNavigationWidget extends StatelessWidget {
  final int bottomIndex;

  const BottomNavigationWidget(this.bottomIndex, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        create: (_) => HomeDashBoardBloc(HomeDashBoardRepository(Dio())),
      ),
      BlocProvider(create: (context) => ProfileBloc(ProfileRepository(Dio()))),
    ], child: BottomNavigationWidgetStateful(bottomIndex));
  }
}

class BottomNavigationWidgetStateful extends StatefulWidget {
  final int bottomIndex;

  const BottomNavigationWidgetStateful(this.bottomIndex, {Key? key})
      : super(key: key);

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidgetStateful>
    with SingleTickerProviderStateMixin {
  bool isMove = false;
  ContestService contestService = getIt<ContestService>();
  ContestExampleService contestExampleService = getIt<ContestExampleService>();
  int? _page;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  UserDataService userDataService = getIt<UserDataService>();
  Contestdata? contestdata;
  Userdata? userData;

  void setLockIcon({bool isMove = true}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMove', isMove);
  }

  void getLockIcon() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isMove = prefs.getBool('isMove') ?? false;
  }

  @override
  void initState() {
    super.initState();
    getLockIcon();
    BlocProvider.of<ProfileBloc>(context)
        .add(GetProfileDataEvent(context: context));
    BlocProvider.of<ProfileBloc>(context).stream.listen((event) {
      userData = userDataService.userData;
      if (mounted) {
        BlocProvider.of<HomeDashBoardBloc>(context).add(
            FetchContestEvent(context: context, userId: userData!.user_id));
        setState(() {});
      }
    });
    BlocProvider.of<HomeDashBoardBloc>(context).stream.listen((event) {
      if (mounted) {
        setState(() {
          contestdata = contestService.contestdata;
        });
      }
    });
    BlocProvider.of<HomeDashBoardBloc>(context).add(
        BottomIndexChange(context: context, currentIndex: widget.bottomIndex));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeDashBoardBloc, HomeDashBoardState>(
      listener: (context, state) {
        if (state is BottomIndexChangedState) {
          setState(() {
            _page = state.bottomIndex;
          });
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          (contestdata != null && contestdata!.start_date != "")
              ? CountdownTimer(
                  endTime: DateFormatter.getUTCRemainingTimeInMills(
                      contestService.contestdata!.start_date),
                  widgetBuilder: (_, time) {
                    print('date ${contestService.contestdata!.start_date}');
                    if (time == null) {
                      isMove = true;
                      setLockIcon(isMove: true);
                      return const SizedBox();
                    }
                    return const SizedBox();
                  },
                )
              : const SizedBox.shrink(),
          CurvedNavigationBar(
            key: _bottomNavigationKey,
            backgroundColor: Colors.transparent,
            color: const Color(0xFFF5F5F5),
            height: 50.h,
            index: widget.bottomIndex,
            items: <Widget>[
              ImageIcon(
                const AssetImage(
                  "assets/home (2).png",
                ),
                color: Colors.black,
                size: 20.sp,
              ),
              Icon(
                Icons.list_alt_outlined,
                color: Colors.black,
                size: 20.sp,
              ),
              (!isMove)
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          "assets/qqLogo.png",
                          width: 36.w,
                          height: 36.h,
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 44.w, bottom: 28.h),
                            child: ImageIcon(
                              const AssetImage('assets/lock.png'),
                              color: ColorConstants.primaryColor,
                              size: 18.sp,
                            )),
                      ],
                    )
                  : Image.asset(
                      "assets/qqLogo.png",
                      height: 36.h,
                      width: 36.w,
                    ),
              ImageIcon(
                const AssetImage(
                  "assets/notification.png",
                ),
                color: Colors.black,
                size: 20.sp,
              ),
              ImageIcon(
                const AssetImage(
                  "assets/userHome.png",
                ),
                color: Colors.black,
                size: 20.sp,
              ),
            ],
            onTap: (index) async {
              setState(() {
                changeNavigation(index);
              });
            },
          )
        ],
      ),
    );
  }

  Future<void> changeNavigation(int index) async {
    if (index == 4) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _page = index;
        BlocProvider.of<HomeDashBoardBloc>(context)
            .add(BottomIndexChange(context: context, currentIndex: _page!));
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const ProfileScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
    if (index == 3) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _page = index;
        BlocProvider.of<HomeDashBoardBloc>(context)
            .add(BottomIndexChange(context: context, currentIndex: _page!));
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const NotificationScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
    if (index == 2) {
      await Future.delayed(const Duration(milliseconds: 500));
      // if (isMove &&
      //     contestService.participated == false &&
      //     (contestService.userBooked)) {
      //   setState(() {
      //     _page = index;
      //     BlocProvider.of<HomeDashBoardBloc>(context)
      //         .add(BottomIndexChange(context: context, currentIndex: _page!));
      //   });
      //   Navigator.push(
      //     context,
      //     PageRouteBuilder(
      //       pageBuilder: (context, animation1, animation2) => ContestMainPage(),
      //       transitionDuration: Duration.zero,
      //     ),
      //   );
      // } else
      //
      if (isMove &&
              contestService.participated == false &&
              (contestService.userBooked) ||
          isMove &&
              contestExampleService.participated == false &&
              (contestExampleService.userBooked) == false) {
        setState(() {
          _page = index;
          BlocProvider.of<HomeDashBoardBloc>(context)
              .add(BottomIndexChange(context: context, currentIndex: _page!));
        });
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const ContestPlay(false),
            transitionDuration: Duration.zero,
          ),
        );
      } else {
        setState(() {
          _page = 0;
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const Home(false, true),
              transitionDuration: Duration.zero,
            ),
          );
        });
      }
    }

    if (index == 1) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _page = index;
        BlocProvider.of<HomeDashBoardBloc>(context)
            .add(BottomIndexChange(context: context, currentIndex: _page!));
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const CustomerSupport(),
          transitionDuration: Duration.zero,
        ),
      );
    }
    if (index == 0) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _page = index;
        BlocProvider.of<HomeDashBoardBloc>(context)
            .add(BottomIndexChange(context: context, currentIndex: _page!));
      });
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const Home(false, false),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }
}
