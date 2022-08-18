import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/EnterNumberBloc/EnterNumberBloc.dart';
import 'package:qq/repository/EnterNumberRepository.dart';
import 'package:qq/ui/otpVerfication.dart';
import 'package:qq/utils/ColorConstants.dart';

class EnterNumber extends StatelessWidget {
  const EnterNumber({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => EnterNumberBloc(EnterNumberRepository(Dio())),
        child: const EnterNumberStateful(),
      ),
    );
  }
}

class EnterNumberStateful extends StatefulWidget {
  const EnterNumberStateful({Key? key}) : super(key: key);

  @override
  _EnterNumberStatefulState createState() => _EnterNumberStatefulState();
}

class _EnterNumberStatefulState extends State<EnterNumberStateful> {
  String number = '0';
  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<EnterNumberBloc, EnterNumberState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    SizedBox(
                      height: 200.h,
                      width: 280.w,
                      child: Image.asset('assets/login.png'),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      children: [
                        Text(
                          'Enter your mobile number',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.sp, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 6.w, right: 6.w, top: 20.h, bottom: 6.h),
                        ),
                        Text(
                          'You\'ll receive a 4 digit code to verify next',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 30.h),
                          child: Container(
                              height: 50.h,
                              width: 280.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[100]
                                  // border: Border.all(color: (state.mobileNumber.valid) ? Colors.black12 : (state.mobileNumber.value != "" && !state.mobileNumber.valid && state.mobileNumber.value.length > 10) ? Colors.red : Colors.black12, width: 1.w)
                                  ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CountryCodePicker(
                                    onChanged: print,
                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                    initialSelection: 'IN',
                                    favorite: const ['+91', 'IN'],
                                    // optional. Shows only country name and flag
                                    showCountryOnly: false,
                                    // optional. Shows only country name and flag when popup is closed.
                                    showOnlyCountryWhenClosed: false,
                                    // optional. aligns the flag and the Text left
                                    alignLeft: false,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                          controller: phoneNumberController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Mobile Number",
                                            errorMaxLines: 1,
                                            //errorText: (state.mobileNumber != null && state.mobileNumber.valid) ? null : "Invalid Mobile Number",
                                            errorStyle: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.sp),
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            context.read<EnterNumberBloc>().add(
                                                MobileNumberChanged(
                                                    mobileNumber: value));
                                          })),
                                ],
                              )),
                        ),
                        Container(
                          width: 280.w,
                          child: Row(
                            children: [
                              (state.mobileNumber.valid)
                                  ? Text("")
                                  : (state.mobileNumber.value != "" &&
                                          !state.mobileNumber.valid &&
                                          state.mobileNumber.value.length > 10)
                                      ? Text("Invalid Mobile Number",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 12.sp))
                                      : Text("")
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        SubmitButton(),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}

class SubmitButton extends StatefulWidget {
  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnterNumberBloc, EnterNumberState>(
        listener: (context, state) {
          if (state is EnterNumberCompleteState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => otpVerification(
                  state.mobileNumber.value
                ),)
              );
            });
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width.w,
          height: 40.h,
          margin: EdgeInsets.only(left: 60.w, right: 60.w),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: ColorConstants.primaryColor,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.h))),
            onPressed: () {
              BlocProvider.of<EnterNumberBloc>(context).add(SendOTPEvent(
                  context: context,
                  mobileNumber: BlocProvider.of<EnterNumberBloc>(context)
                      .state
                      .mobileNumber
                      .value));
            },
            child: Text(
              'Send OTP ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        )
        );
  }
}
