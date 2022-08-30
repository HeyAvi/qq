import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/models/home_countdown_model.dart';

import '../timer_widget/timer_widget.dart';
import '../utils/ColorConstants.dart';
import '../utils/DateTimeFormatter.dart';

class HomeCountdownWidget extends StatefulWidget {
  final HomeCountDown homeCountDown;

  const HomeCountdownWidget({Key? key, required this.homeCountDown})
      : super(key: key);

  @override
  State<HomeCountdownWidget> createState() => _HomeCountdownWidgetState();
}

class _HomeCountdownWidgetState extends State<HomeCountdownWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: false);

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 0.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  @override
  Widget build(BuildContext context) {
    return CountdownTimer(
      endTime: DateFormatter.getUTCRemainingTimeInMills(
          widget.homeCountDown.startDate),
      widgetBuilder: (_, time) {
        if (time == null) {
          widget.homeCountDown.isMove = true;
          return Padding(
            padding: EdgeInsets.only(top: 20.h, bottom: 20.h),
            child: Text(
              'LIVE',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontFamily: "SL",
                  fontWeight: FontWeight.bold),
            ),
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (time.days != null)
              HomeTimer(
                boxWidget: Text(time.days?.toString() ?? '0',
                    style: const TextStyle(
                        color: ColorConstants.orangeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                boxName: 'Days',
              ),
            if (time.hours != null)
              HomeTimer(
                boxWidget: Text(time.hours?.toString() ?? '0',
                    style: const TextStyle(
                        color: ColorConstants.orangeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                boxName: 'Hr',
              ),
            if (time.min != null)
              HomeTimer(
                boxWidget: Text(time.min?.toString() ?? '0',
                    style: const TextStyle(
                        color: ColorConstants.orangeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                boxName: 'Min.',
              ),
            if (time.sec != null)
              HomeTimer(
                boxWidget: Text(time.sec?.toString() ?? '0',
                    style: const TextStyle(
                        color: ColorConstants.orangeColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                boxName: 'Sec.',
                showColon: false,
              ),
          ],
        );
        // return Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Column(
        //       children: [
        //         Card(
        //           child: Container(
        //             width: 30.h,
        //             height: 30.h,
        //             margin: EdgeInsets.all(2.h),
        //             //padding: EdgeInsets.all(8.h),
        //             color: Colors.greenAccent,
        //             child: Center(
        //               child: (time.hours.toString() != "null")
        //                   ? Text(
        //                       time.hours.toString(),
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 20.sp),
        //                     )
        //                   : Text(
        //                       "00",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 20.sp),
        //                     ),
        //             ),
        //           ),
        //         ),
        //         Text(
        //           "HOURS",
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 10.sp,
        //               fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       width: 10.sp,
        //     ),
        //     Column(
        //       children: [
        //         Card(
        //           child: Container(
        //             width: 30.h,
        //             height: 30.h,
        //             margin: const EdgeInsets.all(2),
        //             //padding: EdgeInsets.all(8),
        //             color: const Color(0xffce112c),
        //             child: Center(
        //               child: (time.min.toString() != "null")
        //                   ? Text(
        //                       time.min.toString(),
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 20.sp),
        //                     )
        //                   : Text(
        //                       "00",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 20.sp),
        //                     ),
        //             ),
        //           ),
        //         ),
        //         Text(
        //           "MIN",
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 10.sp,
        //               fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),
        //     SizedBox(
        //       width: 10.w,
        //     ),
        //     Column(
        //       children: [
        //         Card(
        //           child: Container(
        //             width: 30.h,
        //             height: 30.h,
        //             margin: EdgeInsets.all(2.h),
        //             //padding: EdgeInsets.all(8.h),
        //             color: const Color(0xffC77D0A),
        //             child: Center(
        //               child: (time.sec.toString() != "null")
        //                   ? Text(
        //                       time.sec.toString(),
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 20.sp),
        //                     )
        //                   : Text(
        //                       "00",
        //                       textAlign: TextAlign.center,
        //                       style: TextStyle(
        //                           fontWeight: FontWeight.bold,
        //                           color: Colors.white,
        //                           fontSize: 20.sp),
        //                     ),
        //             ),
        //           ),
        //         ),
        //         Text(
        //           "SEC",
        //           style: TextStyle(
        //               color: Colors.white,
        //               fontSize: 10.sp,
        //               fontWeight: FontWeight.bold),
        //         ),
        //       ],
        //     ),
        //   ],
        // );
      },
    );
  }
}
