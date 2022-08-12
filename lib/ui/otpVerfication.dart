import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:qq/bloc/OTPVerificationBloc/OTPVerificationBloc.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/ui/registration.dart';
import 'package:qq/utils/ColorConstants.dart';
import '../repository/OTPVerificationRepository.dart';

class otpVerification extends StatelessWidget {
  late String mobileNumber;

  otpVerification(String text) {
    mobileNumber = text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OTPVerificationBloc(OTPVerificationRepository(Dio())),
        child: otpVerificationStateful(mobileNumber),
      ),
    );
  }
}

class otpVerificationStateful extends StatefulWidget {
  late String mobileNumber;

  otpVerificationStateful(String text) {
    mobileNumber = text;
  }

  @override
  _otpVerificationStatefulState createState() =>
      _otpVerificationStatefulState();
}

class _otpVerificationStatefulState extends State<otpVerificationStateful> {
  TextEditingController otpController = TextEditingController();
  int _start = 60;
  Timer? _timer;

  void startTimer() {
    _start = 60;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.white,
        body: BlocListener<OTPVerificationBloc, OTPVerificationState>(
            listener: (context, state) {
              if (state is SendOTPCompleteState) {
                startTimer();
              } else if (state is OTPVerificationCompleteState) {
                if (state.registrationRequired) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Registration(widget.mobileNumber)));
                  });
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home(false, false)));
                  });
                }
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height.h,
              width: MediaQuery.of(context).size.width.h,
              margin: EdgeInsets.only(left: 30.w, right: 30.w),
              child: ListView(
                children: [
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    'OTP Verification',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  SizedBox(
                    height: 200.h,
                    width: 280.w,
                    child: Image.asset('assets/number.png'),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      Text(
                        'Enter 4 digits code',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20.sp, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 6.w, right: 6.w, top: 20.h, bottom: 6.h),
                      ),
                      Text(
                        'OTP Send to your mobile no. XXXXXX' +
                            widget.mobileNumber.substring(6, 10) +
                            ".",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  SizedBox(
                    width: 240.w,
                    child: PinCodeTextField(
                      controller: otpController,
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.green.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      obscureText: false,

                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5.h),
                          fieldHeight: 50.h,
                          fieldWidth: 40.w,
                          activeFillColor: Colors.white,
                          activeColor: Colors.white,
                          selectedColor: ColorConstants.primaryColor,
                          selectedFillColor: Colors.white,
                          inactiveColor: Colors.white,
                          inactiveFillColor: Colors.white),
                      cursorColor: Colors.black,
                      animationDuration: const Duration(milliseconds: 300),
                      enableActiveFill: true,

                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10.h,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {},
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Did not get OTP ? ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.normal),
                      ),
                      SizedBox(width: 5,),
                      (_start == 0)
                          ? GestureDetector(
                              onTap: () {
                                BlocProvider.of<OTPVerificationBloc>(context)
                                    .add(SendOTPEvent(
                                        context: context,
                                        mobileNumber: widget.mobileNumber));
                              },
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    fontSize: 18.sp,
                                    color: ColorConstants.primaryColor,
                                    fontWeight: FontWeight.bold),
                              ))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  _start.toString() + " Sec",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width.w / 1.5.w,
                        height: 40.h,
                        margin: EdgeInsets.only(left: 15.w, right: 15.w),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: ColorConstants.primaryColor,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.h))),
                          onPressed: () {
                            BlocProvider.of<OTPVerificationBloc>(context).add(
                                VerifyOTPEvent(
                                    context: context,
                                    mobileNumber: widget.mobileNumber,
                                    otpNumber: otpController.text));
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    super.dispose();
    _timer!.cancel();
  }
}
