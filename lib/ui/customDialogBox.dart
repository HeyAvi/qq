
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/TicketsBloc/TicketsBloc.dart';
import 'package:qq/models/Ticketdata.dart';
import 'package:qq/repository/TicketsRepository.dart';
import 'package:qq/services/ContestServcie.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/ui/ContestPlay.dart';
import 'package:qq/ui/ContestUser.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/Constants.dart';
import 'package:qq/utils/dialogs/DialogUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CustomDialogBox extends StatelessWidget {

  final String title, descriptions, text;
  final Function(String) onCountSelected;


  const CustomDialogBox({required this.title, required this.descriptions, required this.text,required this.onCountSelected});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (_) => TicketsBloc(TicketsRepository(Dio())),
      child: CustomDialogBoxStateful(title: title,descriptions: descriptions,text: text,onCountSelected: onCountSelected,),
    );
  }
}


class CustomDialogBoxStateful extends StatefulWidget {
  final String title, descriptions, text;
  final Function(String) onCountSelected;

  const CustomDialogBoxStateful({required this.title, required this.descriptions, required this.text,required this.onCountSelected});

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBoxStateful> {

  List<Ticketdata>? ticketDataList;
  String userId = "";
  ContestService contestService =  getIt<ContestService>();
  UserDataService userDataService =  getIt<UserDataService>();

  @override
  void initState() {
    super.initState();
    getSharedPreferencesData();
  }


  Future<void> getSharedPreferencesData() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId").toString();
    context.read<TicketsBloc>().add(GetTicketsDataEvent(context: context, userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TicketsBloc(TicketsRepository(Dio())),
        child:Dialog(
        shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BlocListener<TicketsBloc,TicketsState>(
        listener: (context, state){
          if(state is TicketsCompleteState){
            setState(() {
              ticketDataList = state.ticketDataList;
            });
            if(state.contestUserSubmit){
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => ContestPlay(true),
                  transitionDuration: Duration.zero,
                ),
              );
            }
          }
        },
        child: Container(
          //width: 300.w,
          height: 200.h,//MediaQuery.of(context).size.height.h,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20.w,top: 20.h, right: 10.w,bottom: 15.h),
                //margin: EdgeInsets.only(top: Constants.avatarRadius),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Constants.padding),
                    boxShadow: [
                      BoxShadow(color: Colors.black,offset: Offset(0,10),
                          blurRadius: 10
                      ),
                    ]
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(widget.title,style: TextStyle(fontSize: 22.sp,fontWeight: FontWeight.w600),),
                              ],
                            ),
                            SizedBox(height: 15.h,),
                            Row(
                              children: [
                                Text(widget.descriptions,style: TextStyle(fontSize: 14.sp),textAlign: TextAlign.center,),
                              ],
                            ),
                            SizedBox(height: 22.h,),
                          ],
                        )
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: 120.w,
                              height: 35.h,
                              margin: EdgeInsets.only(left: 15.w,right: 15.w),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: ColorConstants.primaryColor,
                                    onPrimary: Colors.white,
                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.h))
                                ),
                                onPressed: () {
                                  widget.onCountSelected("cancel");
                                },
                                child: Text('Cancel',style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.bold),),
                              ),
                            )
                        ),
                        SizedBox(width: 10.w,),
                        Expanded(
                            flex: 1,
                            child: Container(
                              width: 120.w,
                              height: 35.h,
                              margin: EdgeInsets.only(left: 15.w,right: 15.w),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: ColorConstants.primaryColor,
                                    onPrimary: Colors.white,
                                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.h))
                                ),
                                onPressed: () {
                                  widget.onCountSelected("agree");
                                  Navigator.pop(context);
                                  if(userDataService.totalTickets.toString() == "" || userDataService.totalTickets.toString() == "null" || userDataService.totalTickets.toString() == "0"){
                                    showDialog(context: context,
                                        builder: (BuildContext context) {
                                          return DialogUtil.showTicketInfoDialog("Please purchase a ticket first.",context);
                                        });
                                  }
                                  else{
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation1, animation2) => ContestPlay(true),
                                        transitionDuration: Duration.zero,
                                      ),
                                    );
                                  }
                                },
                                child: Text('Agree',style: TextStyle(color: Colors.white,fontSize: 15.sp,fontWeight: FontWeight.bold),),
                              ),
                            )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ));
  }



}