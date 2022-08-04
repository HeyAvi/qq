import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/OTPVerificationBloc/OTPVerificationBloc.dart';
import 'package:qq/bloc/RegistrationBloc/RegistrationBloc.dart';
import 'package:qq/repository/RegistrationRepository.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/ui/termsAndCondition.dart';
import 'package:qq/utils/ColorConstants.dart';

class Registration extends StatelessWidget {
  String? _mobileNumber;

  Registration(String mobileNumber) {
    _mobileNumber = mobileNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => RegistrationBloc(RegistrationRepository(Dio())),
        child: RegistrationStateful(_mobileNumber),
      ),
    );
  }
}

class RegistrationStateful extends StatefulWidget {
  late String mobileNumbers;

  RegistrationStateful(String? mobileNumber) {
    mobileNumbers = mobileNumber!;
  }

  @override
  _RegistrationStatefulState createState() => _RegistrationStatefulState();
}

class _RegistrationStatefulState extends State<RegistrationStateful> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  bool valuefirst = false;

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController(text: widget.mobileNumbers);
    BlocProvider.of<RegistrationBloc>(context)
        .add(MobileNumberChanged(mobileNumber: widget.mobileNumbers));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.h),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                )),
          ),
        ),
        body: BlocBuilder<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            return SizedBox(
              width: MediaQuery.of(context).size.width.w,
              height: MediaQuery.of(context).size.height.h,
              child: ListView(
                children: [
                  SizedBox(
                    height: 230.h,
                    child: Image.asset('assets/registration.png'),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 40.h, right: 40.h),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 330.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Sign up ",
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28.sp),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 30.sp,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                  ),
                                  SizedBox(
                                      height: 55.h,
                                      width: 200.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: nameController,
                                              decoration: InputDecoration(
                                                hintText: "Enter Name",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.cyan),
                                                ),
                                                errorText: (state.name.valid)
                                                    ? null
                                                    : (state.email
                                                                    .value !=
                                                                "" &&
                                                            !state
                                                                .email.valid &&
                                                            state.name.value ==
                                                                5)
                                                        ? "Invalid Name"
                                                        : null,
                                                errorStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12.sp),
                                              ),
                                              onChanged: (value) {
                                                context
                                                    .read<RegistrationBloc>()
                                                    .add(NameChanged(
                                                        name: value));
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.alternate_email_rounded,
                                    size: 30.sp,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                  ),
                                  SizedBox(
                                      height: 55.h,
                                      width: 200.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: emailController,
                                              decoration: InputDecoration(
                                                hintText: "Enter Email",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.cyan),
                                                ),
                                                errorText: (state.email.valid)
                                                    ? null
                                                    : (state.email
                                                                    .value !=
                                                                "" &&
                                                            !state
                                                                .email.valid &&
                                                            state.email.value
                                                                    .length >
                                                                10 &&
                                                            state.email.value
                                                                    .length <=
                                                                20)
                                                        ? "Invalid Email"
                                                        : null,
                                                errorStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12.sp),
                                              ),
                                              onChanged: (value) {
                                                context
                                                    .read<RegistrationBloc>()
                                                    .add(EmailChanged(
                                                        email: value));
                                              },
                                            ),
                                          )
                                        ],
                                      )),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.phone,
                                    size: 30.sp,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                  ),
                                  SizedBox(
                                      height: 50.h,
                                      width: 200.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              enabled: false,
                                              keyboardType:
                                                  TextInputType.number,
                                              controller: phoneController,
                                              decoration: InputDecoration(
                                                hintText: "Enter Phone",
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.cyan),
                                                ),
                                                errorText: (state
                                                                .mobileNumber !=
                                                            null &&
                                                        state
                                                            .mobileNumber.valid)
                                                    ? null
                                                    : "Invalid Mobile Number.",
                                                errorStyle: TextStyle(
                                                    color: Colors.red,
                                                    fontSize: 12.sp),
                                              ),
                                              onChanged: (value) {
                                                context
                                                    .read<RegistrationBloc>()
                                                    .add(MobileNumberChanged(
                                                        mobileNumber: value));
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10.h),
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Checkbox(
                                        checkColor: Colors.white,
                                        activeColor:
                                            ColorConstants.primaryColor,
                                        value: valuefirst,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            valuefirst = value!;
                                          });
                                        },
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            "By Signing up, you are agree to the ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  WidgetsBinding.instance!
                                                      .addPostFrameCallback(
                                                          (_) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (Context) =>
                                                                TermsCondition()));
                                                  });
                                                },
                                                child: Text(
                                                  "Terms & Conditions ",
                                                  style: TextStyle(
                                                      color: ColorConstants
                                                          .primaryColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12.sp),
                                                ),
                                              ),
                                              Text(
                                                "and ",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp),
                                              ),
                                              Text(
                                                "Privacy Policy ",
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10.h),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        valuefirst
                            ? SubmitButton()
                            : Container(
                          margin: EdgeInsets.only(left: 15.w, right: 15.w),
                          width: MediaQuery.of(context).size.width.w / 1.5.w,
                          height: 40.h,

                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius:  BorderRadius.circular(5.h)),
                                child: Center(
                                  child: Text(
                                    'Continue',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
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
    return BlocListener<RegistrationBloc, RegistrationState>(
      listener: (context, state) {
        if (state is RegistrationCompleteState) {
          WidgetsBinding.instance!.addPostFrameCallback((_) {
            Navigator.push(context,
                MaterialPageRoute(builder: (Context) => Home(false, false)));
          });
        }
      },
      child: InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width.w / 1.5.w,
          height: 40.h,
          decoration: BoxDecoration(
              color: ColorConstants.primaryColor,
              borderRadius: BorderRadius.circular(5.h)),
          child: Center(
            child: Text(
              'Continue',
              style: TextStyle(color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        onTap: () {
          BlocProvider.of<RegistrationBloc>(context).add(RegisterEvent(
              context: context,
              name: BlocProvider.of<RegistrationBloc>(context).state.name.value,
              email:
                  BlocProvider.of<RegistrationBloc>(context).state.email.value,
              phone: BlocProvider.of<RegistrationBloc>(context)
                  .state
                  .mobileNumber
                  .value));
        },
      ),
    );
  }
}
