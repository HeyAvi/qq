import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qq/bloc/TicketsBloc/TicketsBloc.dart';
import 'package:qq/bloc/WalletBloc/WalletBloc.dart';
import 'package:qq/models/Ticketdata.dart';
import 'package:qq/repository/TicketsRepository.dart';
import 'package:qq/repository/WalletRepository.dart';
import 'package:qq/ui/Wallet/Wallet.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/DataNotAvailable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyTickets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => TicketsBloc(TicketsRepository(Dio())),
        ),
        BlocProvider(
          create: (context) => WalletBloc(WalletRepository(Dio())),
        ),
      ],
      child: const BuyTicketsStateful(),
    ));
  }
}

class BuyTicketsStateful extends StatefulWidget {
  const BuyTicketsStateful({Key? key}) : super(key: key);

  @override
  _BuyTicketsState createState() => _BuyTicketsState();
}

class _BuyTicketsState extends State<BuyTicketsStateful> {
  TextEditingController ticketController = TextEditingController();
  String userId = "";
  List<Ticketdata>? ticketDataList = [];
  String ticketValue = "", ticketsMoney = "";
  double walletAmount = 0.0;
  bool dataGet = false;

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }

  Future<void> getSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
    BlocProvider.of<WalletBloc>(context)
        .add(GetWalletDataEvent(context: context, userId: userId));
    context
        .read<TicketsBloc>()
        .add(GetTicketsDataEvent(context: context, userId: userId));
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home(false, false)));
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    print(ticketDataList);
    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            setState(() {
              FocusScope.of(context).unfocus();
            });
          },
          child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(45.h),
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
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (Context) => Home(false, false)));
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
                            "Buy Ticket",
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
                        left: 20.w, top: 0.h, right: 20.w, bottom: 30.h),
                    child: Column(
                      children: [
                        BlocListener<WalletBloc, WalletState>(
                            listener: (context, state) {
                              setState(() {
                                if (state is GetWalletDataCompleteState) {
                                  dataGet = true;
                                  String val = state.sumAmount.toString();
                                  walletAmount =
                                      double.parse(val.isEmpty ? '0' : val);
                                }
                              });
                            },
                            child: const Visibility(
                              visible: false,
                              child: Text(""),
                            )),
                        (dataGet == true)
                            ? (walletAmount <= 0.0)
                                ? Row(
                                    children: [
                                      SizedBox(width: 5.w),
                                      Expanded(
                                        child: Text(
                                          'Insufficient wallet balance.',
                                          style: TextStyle(
                                              fontSize: 15.sp,
                                              color: Colors.red),
                                        ),
                                      ),
                                      InkWell(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 0.h),
                                          width: 100.w,
                                          padding: EdgeInsets.all(5.h),
                                          decoration: BoxDecoration(
                                              color:
                                                  ColorConstants.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(20.h)),
                                          child: Center(
                                            child: Text(
                                              'Add Money',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp),
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation1,
                                                      animation2) =>
                                                  Wallet(),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                      ),
                                      SizedBox(width: 5.w),
                                    ],
                                  )
                                : const Text("")
                            : const Text(""),
                        RotatedBox(
                          quarterTurns: 1,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.rotationY(pi),
                            child: SizedBox(
                              width: 150.w,
                              height: 120.h,
                              child: Image.asset("assets/ticket-flight.png"),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Text(
                          ticketValue.toString() +
                              " Tickets = " +
                              ticketsMoney +
                              " ₹",
                          style: TextStyle(
                              color: ColorConstants.primaryColor2,
                              fontSize: 16.sp),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width.w,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width
                                                .w /
                                            1.3.w,
                                        child: TextField(
                                            keyboardType: TextInputType.number,
                                            controller: ticketController,
                                            // enabled: (walletAmount <= 0.0)
                                            //     ? false
                                            //     : true,
                                            onChanged: (value) {
                                              setState(() {
                                                ticketValue = value;
                                                if (ticketValue != null &&
                                                    ticketValue != "") {
                                                  ticketsMoney = (int.parse(
                                                              ticketValue
                                                                  .toString()) *
                                                          5)
                                                      .toString();
                                                } else {
                                                  ticketsMoney = "";
                                                }
                                              });
                                            },
                                            decoration: InputDecoration(
                                              labelText: "How many tickets?",
                                              labelStyle:
                                                  const TextStyle(color: Colors.grey),
                                              //prefixIcon: Icon(Icons.people),
                                              border: OutlineInputBorder(
                                                  //Outline border type for TextFeild
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.w,
                                                  )),
                                              enabledBorder: OutlineInputBorder(
                                                  //Outline border type for TextFeild
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.w,
                                                  )),
                                              focusedBorder: OutlineInputBorder(
                                                  //Outline border type for TextFeild
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(20)),
                                                  borderSide: BorderSide(
                                                    color: Colors.grey,
                                                    width: 1.w,
                                                  )),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, right: 26.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                title: Text(
                                                  "Apply Promo Code",
                                                  style: TextStyle(
                                                      fontSize: 16.sp),
                                                ),
                                                content: const TextField(
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(20),
                                                      ),
                                                    ),
                                                    labelText:
                                                        "Enter your Promo Code",
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("No"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text("Yes"),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              'Applied Promo!');
                                                      // Navigator.push(
                                                      //   context,
                                                      //   // PageRouteBuilder(
                                                      //   //   pageBuilder: (context, animation1,
                                                      //   //           animation2) =>
                                                      //   //       TicketConfirm(
                                                      //   //         ticketValue: ticketValue,
                                                      //   //       ),
                                                      //   //   transitionDuration: Duration.zero,
                                                      //   // ),
                                                      // );
                                                    },
                                                  ),
                                                ],
                                              ));
                                    },
                                    child: Text('Apply Promo Code',
                                        style: TextStyle(
                                            letterSpacing: 1.0,
                                            fontSize: 11.sp)),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(5.h)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'T&C Apply.',
                              style: TextStyle(
                                  fontSize: 15.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 2.w,
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: Text(
                                  'Read More',
                                  style: TextStyle(
                                    letterSpacing: 1.w,
                                    decoration: TextDecoration.underline,
                                    decorationStyle: TextDecorationStyle.solid,
                                    decorationColor: Colors.green,
                                    fontSize: 14.sp,
                                    decorationThickness: 2.w,
                                    color: Colors.black87,
                                  ),
                                ))
                          ],
                        ),
                        Padding(padding: EdgeInsets.all(5.h)),
                        SizedBox(
                            width: MediaQuery.of(context).size.width.w / 1.3.w,
                            height: 40.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(top: 5.h, bottom: 5.h),
                                primary: ColorConstants.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.h),
                                ),
                              ),
                              onPressed: () {
                                if (walletAmount <= 0.0) {
                                  Fluttertoast.showToast(
                                      msg: 'Low wallet balance');
                                  return;
                                }
                                BlocProvider.of<TicketsBloc>(context).add(
                                  BuyicketsDataEvent(
                                      context: context,
                                      userId: userId,
                                      no_of_tickets: ticketController.text),
                                );
                                ticketController.text = "";
                              },
                              child: Center(
                                child: Text(
                                  'Buy Tickets',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        Padding(padding: EdgeInsets.all(10.h)),
                        Container(
                          width: MediaQuery.of(context).size.width.w,
                          height: 2.h,
                          color: Colors.grey,
                        ),
                        Padding(padding: EdgeInsets.all(5.h)),
                        Text(
                          "${ticketDataList?.length ?? 0} Ticket codes are left",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(padding: EdgeInsets.all(10.h)),
                        BlocListener<TicketsBloc, TicketsState>(
                          listener: (context, state) {
                            if (state is TicketsCompleteState) {
                              setState(() {
                                ticketDataList = state.ticketDataList;
                                print('Thhhhh ${state.ticketDataList} ${ticketDataList?.length}');
                              });
                            } else if (state is BuyTicketsCompleteState) {
                              if (state.isBook) {
                                if (mounted) {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Home(false, false)));
                                  });
                                }
                              }
                            }
                          },
                          child: (ticketDataList != null &&
                                  ticketDataList!.isNotEmpty)
                              ? SizedBox(
                            height: MediaQuery.of(context).size.height.h / 1.6,
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: ticketDataList?.length ?? 0,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      print(ticketDataList?.length);
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                                            child: Container(
                                                width:
                                                    MediaQuery.of(context).size.width,
                                                height: 50.h,
                                                color: Colors.grey[100],
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Text(
                                                      ticketDataList![index]
                                                          .ticket_code
                                                          .substring(0, 1),
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.bold,
                                                          decoration: TextDecoration
                                                              .underline,
                                                          decorationColor:
                                                              ColorConstants
                                                                  .primaryColor),
                                                    ),
                                                    Text(
                                                      ticketDataList![index]
                                                          .ticket_code
                                                          .substring(1, 2),
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.bold,
                                                          decoration: TextDecoration
                                                              .underline,
                                                          decorationColor:
                                                              ColorConstants
                                                                  .primaryColor),
                                                    ),
                                                    Text(
                                                      ticketDataList![index]
                                                          .ticket_code
                                                          .substring(2, 3),
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.bold,
                                                          decoration: TextDecoration
                                                              .underline,
                                                          decorationColor:
                                                              ColorConstants
                                                                  .primaryColor),
                                                    ),
                                                    Text(
                                                      ticketDataList![index]
                                                          .ticket_code
                                                          .substring(3, 4),
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          fontWeight: FontWeight.bold,
                                                          decoration: TextDecoration
                                                              .underline,
                                                          decorationColor:
                                                              ColorConstants
                                                                  .primaryColor),
                                                    ),
                                                  ],
                                                )),
                                          );
                                    },
                                  ),
                              )
                              : dataNotAvailable("No Tickets are Available."),
                        )
                      ],
                    )),
              )),
        ),
        onWillPop: _willPopCallback);
  }
}
