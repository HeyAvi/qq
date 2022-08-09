import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:qq/bloc/WalletBloc/WalletBloc.dart';
import 'package:qq/models/Walletdata.dart';
import 'package:qq/ui/Wallet/AddMoneyToWallet.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/DataNotAvailable.dart';
import 'package:qq/utils/DateTimeFormatter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../repository/WalletRepository.dart';

class Wallet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => WalletBloc(WalletRepository(Dio())),
        child: const WalletStateful(),
      ),
    );
  }
}

class WalletStateful extends StatefulWidget {
  const WalletStateful({Key? key}) : super(key: key);

  @override
  _WalletStatefulState createState() => _WalletStatefulState();
}

class _WalletStatefulState extends State<WalletStateful> {
  String sumAmount = "", userId = "";
  String filteValue = "ALL";
  List<Walletdata>? wallatDataList = List.empty(growable: true);
  late BuildContext builderContext;

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
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Home(false, false),
        ),
        (_) => false);
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.h),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Container(
                width: MediaQuery.of(context).size.width.w,
                padding: EdgeInsets.only(left: 0.w),
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
                        "Wallet",
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
              actions: [
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (Context) => AddMoneyToWallet()));
                    setState(() {
                      getSharedPreferencesData();
                    });
                  },
                  child: Container(
                      padding: EdgeInsets.only(right: 20.w),
                      child: ImageIcon(
                        const AssetImage(
                          "assets/add (1).png",
                        ),
                        color: Colors.black,
                        size: 25.sp,
                      )),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xffEFF1FE),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BlocBuilder<WalletBloc, WalletState>(
                      builder: (context, state) {
                    if (state is GetWalletDataCompleteState) {
                      return (state.sumAmount != "null" &&
                              state.sumAmount != "")
                          ? Text(
                              "Rs. " + state.sumAmount,
                              style: TextStyle(
                                  color: const Color(0xff3E3C3C),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Rs. 0",
                              style: TextStyle(
                                  color: const Color(0xff3E3C3C),
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold),
                            );
                    } else {
                      return const Text("");
                    }
                  }),
                ],
              ),
              Padding(padding: EdgeInsets.all(5.h)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    color: const Color(0xff3B58FB),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.h),
                      onTap: () {},
                      child: Container(
                        width: 140.w,
                        padding: EdgeInsets.all(12.h),
                        child: Padding(
                          padding: EdgeInsets.all(2.h),
                          child: Text(
                            'Withdraw',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp),
                          ),
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.h),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        top: size.width.w / 18.w, bottom: size.width.w / 18.w),
                    width: 270.w,
                    child: Text(
                      '1. Money will be credited within next 48 hours.\n'
                      '\n2.Wallet Money will be erased if you dont withdraw within 3 days',
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                width: size.width.w,
                //height: size.height.h/2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50.h),
                    topLeft: Radius.circular(50.h),
                  ),
                ),
                child: Container(
                  padding: EdgeInsets.all(20.h),
                  child: ListView(
                    shrinkWrap: true,
                    primary: false,
                    physics: const ClampingScrollPhysics(),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                              child: Row(
                            children: [
                              Card(
                                elevation: 0,
                                color: const Color(0xffF8F6F6),
                                child: Container(
                                  width: size.width.w / 3.w,
                                  padding: const EdgeInsets.all(15),
                                  child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Text(
                                      'Transactions',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.h),
                                ),
                              ),
                            ],
                          )),
                          Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () {
                                showMaterialModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30)),
                                    ),
                                    builder: (context) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return SizedBox(
                                            height: 250.h,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 30.w, right: 0.w),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 30.h,
                                                  ),
                                                  RadioListTile(
                                                    value: "ALL",
                                                    groupValue: filteValue,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        filteValue = value!;
                                                        Navigator.pop(context);
                                                        BlocProvider.of<
                                                                    WalletBloc>(
                                                                builderContext)
                                                            .add(RefreshWalletDataEvent(
                                                                context:
                                                                    builderContext,
                                                                version: BlocProvider.of<WalletBloc>(
                                                                            builderContext)
                                                                        .state
                                                                        .version +
                                                                    1,
                                                                wallatDataList:
                                                                    wallatDataList,
                                                                sumAmount:
                                                                    sumAmount));
                                                      });
                                                    },
                                                    title: const Text('ALL'),
                                                  ),
                                                  RadioListTile(
                                                    value: "DEBIT",
                                                    groupValue: filteValue,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        filteValue = value!;
                                                        Navigator.pop(context);
                                                        BlocProvider.of<
                                                                    WalletBloc>(
                                                                builderContext)
                                                            .add(RefreshWalletDataEvent(
                                                                context:
                                                                    builderContext,
                                                                version: BlocProvider.of<WalletBloc>(
                                                                            builderContext)
                                                                        .state
                                                                        .version +
                                                                    1,
                                                                wallatDataList:
                                                                    wallatDataList,
                                                                sumAmount:
                                                                    sumAmount));
                                                      });
                                                    },
                                                    title: const Text('DEBIT'),
                                                  ),
                                                  RadioListTile(
                                                    value: "CREDIT",
                                                    groupValue: filteValue,
                                                    onChanged: (String? value) {
                                                      setState(() {
                                                        filteValue = value!;
                                                        Navigator.pop(context);
                                                        BlocProvider.of<
                                                                    WalletBloc>(
                                                                builderContext)
                                                            .add(RefreshWalletDataEvent(
                                                                context:
                                                                    builderContext,
                                                                version: BlocProvider.of<WalletBloc>(
                                                                            builderContext)
                                                                        .state
                                                                        .version +
                                                                    1,
                                                                wallatDataList:
                                                                    wallatDataList,
                                                                sumAmount:
                                                                    sumAmount));
                                                      });
                                                    },
                                                    title: const Text('CREDIT'),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      });
                                    });
                              },
                              child: Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(5),
                                child: const SizedBox(
                                    height: 20,
                                    child: Icon(
                                      Icons.filter_alt,
                                      size: 25,
                                      color: Colors.pink,
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.h),
                        child: BlocBuilder<WalletBloc, WalletState>(
                          builder: (context, state) {
                            builderContext = context;
                            if (state is GetWalletDataCompleteState) {
                              sumAmount = state.sumAmount;
                              wallatDataList = state.wallatDataList;
                              return (state.wallatDataList != null &&
                                      state.wallatDataList!.length > 0)
                                  ? walletDataListView(state.wallatDataList)
                                  : Center(
                                      child: dataNotAvailable(
                                          "No Transactions have Available."),
                                    );
                            } else {
                              return const Text("");
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ))
            ],
          ),
        ),
        onWillPop: _willPopCallback);
  }

  walletDataListView(List<Walletdata>? wallatDataList) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: wallatDataList!.length,
      itemBuilder: (BuildContext context, int index) {
        if (wallatDataList[index].transaction_type == filteValue) {
          return InkWell(
            onTap: () {},
            child: Container(
                margin: EdgeInsets.fromLTRB(00, 00, 00, 10.h),
                padding: EdgeInsets.all(15.h),
                width: MediaQuery.of(context).size.width.w,
                height: 80.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.h)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25.h,
                          backgroundColor: Colors.grey[100],
                          child: CircleAvatar(
                            radius: 15.h,
                            child: Image.asset(
                              "assets/valid.png",
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.h)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallatDataList[index].transaction_type,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.primaryColor2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Rs " + wallatDataList[index].amount + "/-",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.primaryColor2),
                        ),
                        Text(
                          DateFormatter.getDayMonthYearFormat(
                              wallatDataList[index].created_at),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          DateFormatter.getTime(
                              wallatDataList[index].created_at),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        } else if (filteValue == "ALL") {
          return InkWell(
            onTap: () {},
            child: Container(
                margin: EdgeInsets.fromLTRB(00, 00, 00, 10.h),
                padding: EdgeInsets.all(15.h),
                width: MediaQuery.of(context).size.width.w,
                height: 80.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(20.h)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25.h,
                          backgroundColor: Colors.grey[100],
                          child: CircleAvatar(
                            radius: 15.h,
                            child: Image.asset(
                              "assets/valid.png",
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(5.h)),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              wallatDataList[index].transaction_type,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.primaryColor2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Rs " + wallatDataList[index].amount + "/-",
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: ColorConstants.primaryColor2),
                        ),
                        Text(
                          DateFormatter.getDayMonthYearFormat(
                              wallatDataList[index].created_at),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                        Text(
                          DateFormatter.getTime(
                              wallatDataList[index].created_at),
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                )),
          );
        }
        return const Text("");
      },
    );
  }
}
