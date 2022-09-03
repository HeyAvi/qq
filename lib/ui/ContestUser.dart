import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/TicketsBloc/TicketsBloc.dart';
import 'package:qq/dataproviders/TicketsProvider.dart';
import 'package:qq/repository/TicketsRepository.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/DataNotAvailable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContestUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => TicketsBloc(TicketsRepository(Dio())),
        child: const ContestUserStateful(),
      ),
    );
  }
}

class ContestUserStateful extends StatefulWidget {
  const ContestUserStateful({Key? key}) : super(key: key);

  @override
  _ContestUserState createState() => _ContestUserState();
}

class _ContestUserState extends State<ContestUserStateful> {
  String userId = "";
  late BuildContext stateContext;
  ContestService contestService = getIt<ContestService>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Container(
              width: MediaQuery.of(context).size.width.w,
              padding: EdgeInsets.only(left: 10.w),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ImageIcon(
                      const AssetImage(
                        "assets/left-arrow.png",
                      ),
                      color: Colors.black,
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Flexible(
                    child: Text(
                      "Tickets",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                        color: const Color(0xff3E3C3C),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leadingWidth: MediaQuery.of(context).size.width.w,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.only(
                  left: 20.w, top: 10.h, right: 20.w, bottom: 30.h),
              child: Column(
                children: [
                  BlocBuilder<TicketsBloc, TicketsState>(
                      builder: (context, state) {
                    stateContext = context;
                    if (state is TicketsCompleteState) {
                      if (state.contestUserSubmit) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (Context) => Home(false, false)));
                        });
                      }
                      return (state.ticketDataList != null &&
                              state.ticketDataList!.isNotEmpty)
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 50.h,
                                  child: Text(
                                    "Please Swipe Right to book a Ticket.",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: ColorConstants.primaryColor,
                                        fontSize: 18.sp),
                                  ),
                                ),
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.ticketDataList!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Dismissible(
                                      key: UniqueKey(),
                                      background:
                                          Container(color: Colors.white),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (direction) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.h)),
                                                //this right here
                                                child: Container(
                                                  height: 200.h,
                                                  width: 300.w,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 0.h,
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            15.h),
                                                        child: Text(
                                                          'Are you sure , you want to participate with this Ticket ?',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Text(
                                                            state
                                                                .ticketDataList![
                                                                    index]
                                                                .ticket_code
                                                                .substring(
                                                                    0, 1),
                                                            style: TextStyle(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationColor:
                                                                    ColorConstants
                                                                        .primaryColor),
                                                          ),
                                                          Text(
                                                            state
                                                                .ticketDataList![
                                                                    index]
                                                                .ticket_code
                                                                .substring(
                                                                    1, 2),
                                                            style: TextStyle(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationColor:
                                                                    ColorConstants
                                                                        .primaryColor),
                                                          ),
                                                          Text(
                                                            state
                                                                .ticketDataList![
                                                                    index]
                                                                .ticket_code
                                                                .substring(
                                                                    2, 3),
                                                            style: TextStyle(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationColor:
                                                                    ColorConstants
                                                                        .primaryColor),
                                                          ),
                                                          Text(
                                                            state
                                                                .ticketDataList![
                                                                    index]
                                                                .ticket_code
                                                                .substring(
                                                                    3, 4),
                                                            style: TextStyle(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                decorationColor:
                                                                    ColorConstants
                                                                        .primaryColor),
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    const ClipboardData(
                                                                        text:
                                                                            "5237"));
                                                              },
                                                              child: ImageIcon(
                                                                const AssetImage(
                                                                  "assets/copy.png",
                                                                ),
                                                                color: Colors
                                                                    .black,
                                                                size: 20.sp,
                                                              ))
                                                        ],
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20.h)),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      BlocProvider.of<TicketsBloc>(
                                                                              stateContext)
                                                                          .add(
                                                                        SubmitContextUserEvent(
                                                                            context:
                                                                                context,
                                                                            userId:
                                                                                userId,
                                                                            ticketId:
                                                                                state.ticketDataList![index].ticket_id,
                                                                            contestId: contestService.contestdata!.contest_id,
                                                                            ticketDataList: state.ticketDataList,
                                                                            status: Status.A),
                                                                      );
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          80.w,
                                                                      height:
                                                                          35.h,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ColorConstants
                                                                            .primaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(30),
                                                                      ),
                                                                      child: Center(
                                                                          child: Text(
                                                                        'Yes',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            color: Colors.white,
                                                                            fontSize: 18.sp),
                                                                      )),
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                          Expanded(
                                                              flex: 1,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  InkWell(
                                                                    onTap: () {
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      width:
                                                                          80.w,
                                                                      height:
                                                                          35.h,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: ColorConstants
                                                                            .primaryColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(30),
                                                                      ),
                                                                      child: Center(
                                                                          child: Text(
                                                                        'No',
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                            color: Colors.white,
                                                                            fontSize: 18.sp),
                                                                      )),
                                                                    ),
                                                                  )
                                                                ],
                                                              )),
                                                          SizedBox(
                                                            width: 10.w,
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      },
                                      child: Container(
                                          margin: EdgeInsets.only(bottom: 15.h),
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 50.h,
                                          color: Colors.grey[100],
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                state.ticketDataList![index]
                                                    .ticket_code
                                                    .substring(0, 1),
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        ColorConstants
                                                            .primaryColor),
                                              ),
                                              Text(
                                                state.ticketDataList![index]
                                                    .ticket_code
                                                    .substring(1, 2),
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        ColorConstants
                                                            .primaryColor),
                                              ),
                                              Text(
                                                state.ticketDataList![index]
                                                    .ticket_code
                                                    .substring(2, 3),
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        ColorConstants
                                                            .primaryColor),
                                              ),
                                              Text(
                                                state.ticketDataList![index]
                                                    .ticket_code
                                                    .substring(3, 4),
                                                style: TextStyle(
                                                    fontSize: 30.sp,
                                                    fontWeight: FontWeight.bold,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    decorationColor:
                                                        ColorConstants
                                                            .primaryColor),
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        const ClipboardData(
                                                            text: "5237"));
                                                  },
                                                  child: ImageIcon(
                                                    const AssetImage(
                                                      "assets/copy.png",
                                                    ),
                                                    color: Colors.black,
                                                    size: 20.sp,
                                                  ))
                                            ],
                                          )),
                                    );
                                  },
                                )
                              ],
                            )
                          : Center(
                              child:
                                  dataNotAvailable("No Tickets are available."),
                            );
                    } else {
                      return const Text("");
                    }
                  })
                ],
              )),
        ));
  }
}
