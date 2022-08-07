import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:qq/models/Userdata.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/ui/BottomNavigationWidget.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/ui/splashScreen.dart';
import 'package:qq/utils/ApiConstants.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/ProfileBloc/ProfileBloc.dart';
import '../repository/ProfileRepository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(ProfileRepository(Dio())),
      child: const ProfileScreenStateFul(),
    );
  }
}

class ProfileScreenStateFul extends StatefulWidget {
  const ProfileScreenStateFul({Key? key}) : super(key: key);

  @override
  _ProfileScreenStateFulState createState() => _ProfileScreenStateFulState();
}

class _ProfileScreenStateFulState extends State<ProfileScreenStateFul> {
  UserDataService userDataService = getIt<UserDataService>();
  late Userdata userData;
  late var prefs;
  DateTime selectedDate = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  String genderValue = "Male";
  String userId = "";

  void initState() {
    super.initState();
    userData = userDataService.userData;

    userId = userData.user_id;
    nameController = TextEditingController(text: userData.name);
    emailController = TextEditingController(text: userData.email);
    mobileNumberController = TextEditingController(text: userData.phone);

    getSharedPreernces();
  }

  Future<void> getSharedPreernces() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height.h / 2.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Home(false, false)));
                            },
                            child: Container(
                                margin: const EdgeInsets.all(20),
                                child: const ImageIcon(
                                  AssetImage(
                                    "assets/cancel.png",
                                  ),
                                  color: Colors.black,
                                  size: 35,
                                ))),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 5.w,
                        ),
                        Column(
                          children: [
                            const Text(
                              "Total Participates",
                              style:
                                  TextStyle(fontSize: 15, color: Colors.grey),
                            ),
                            Text(userDataService.totalParticipation),
                          ],
                        ),
                        Expanded(
                          child: (userData.image != "")
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundColor: ColorConstants.primaryColor,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: NetworkImage(
                                        ApiConstants.IMAGE_URL +
                                            userData.image),
                                    backgroundColor: Colors.transparent,
                                  ),
                                )
                              : const CircleAvatar(
                                  radius: 64,
                                  backgroundColor: ColorConstants.primaryColor,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage:
                                        AssetImage('assets/userprofile.png'),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                        ),
                        GestureDetector(
                          onTap: () {
                            prefs.setString("userDataKey", "");
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SplashScreen()));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                "Log Out",
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              const Padding(padding: EdgeInsets.all(2)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  ImageIcon(
                                    AssetImage("assets/logout.png"),
                                    size: 20,
                                    color: Colors.pink,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        )
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    (userData.name != "")
                        ? Text(
                            userData.name,
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )
                        : const Text(""),
                    const Padding(
                      padding: EdgeInsets.all(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Share.share(
                                'https://play.google.com/store/apps/details?id=com.example.qq');
                          },
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Container(
                              width: 50,
                              padding: const EdgeInsets.all(15),
                              child: const SizedBox(
                                  height: 20,
                                  child: ImageIcon(
                                    AssetImage("assets/share.png"),
                                    size: 20,
                                    color: Colors.pink,
                                  )),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){},
                          borderRadius: BorderRadius.circular(50),

                          child: Padding(
                            padding: const EdgeInsets.all(0.1),
                            child: Card(
                              color: ColorConstants.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Container(
                                width: 180,
                                padding: const EdgeInsets.all(13),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 25,
                                        child:
                                            Image.asset("assets/first-rank.png")),
                                    const Text(
                                      'Rank',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 0,
                          child: Container(
                            width: 50,
                            padding: const EdgeInsets.all(15),
                            child: const SizedBox(
                              height: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const TabBar(
                      tabs: [
                        Tab(
                          child: Text(
                            "Basic Info",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Settings",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height.h / 1.5.h,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Expanded(
                          child: Align(
                        alignment: Alignment.topCenter,
                        child: TabBarView(
                          physics: const ClampingScrollPhysics(),
                          children: [
                            basicInfo(context),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: ListView(
                                shrinkWrap: true,
                                children: [
                                  ListTile(
                                    onTap: () {},
                                    leading:
                                        const Icon(Icons.notifications_active),
                                    title: const Text('Notification'),
                                    trailing: Switch(
                                        value: notification,
                                        activeColor:
                                            ColorConstants.primaryColor,
                                        onChanged: (v) {
                                          setState(() {
                                            notification = v;
                                          });
                                        }),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    leading: const Icon(Icons.volume_up),
                                    title: const Text('Sounds'),
                                    trailing: Switch(
                                        value: sound,
                                        activeColor:
                                            ColorConstants.primaryColor,
                                        onChanged: (v) {
                                          setState(() {
                                            sound = v;
                                          });
                                        }),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  Text(
                                    'Do you like our App ?',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp),
                                  ),
                                  ListTile(
                                    onTap: () {},
                                    title: Text(
                                      'Be a part of our reviewing customers by rating our app.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]),
                                    ),
                                    subtitle: SizedBox(
                                      width: 200,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                ColorConstants.primaryColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.h),
                                            )),
                                        onPressed: () {
                                          setState(() {
                                            Fluttertoast.showToast(
                                                msg: 'Rate us');
                                          });
                                        },
                                        child: const Text(
                                          'RATE US',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                        backgroundColor: Colors.yellow[100],
                                        radius: 30,
                                        child: const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 50,
                                        )),
                                  ),
                                  SizedBox(
                                    height: 30.h,
                                  ),
                                  const ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Text(
                                      'Support',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Icon(Icons.navigate_next),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  const ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Icon(Icons.navigate_next),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  const ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Text(
                                      'Terms and Conditions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Icon(Icons.navigate_next),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  const ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Text(
                                      'Delete Account',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    ),
                                    trailing: Icon(Icons.navigate_next),
                                  ),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                    ],
                  ))
            ],
          ),
          bottomNavigationBar: const BottomNavigationWidget(4)),
    );
  }

  bool notification = true;
  bool sound = true;

  basicInfo(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {},
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Container(
              height: 45.h,
              width: 280.w,
              decoration: BoxDecoration(
                  color: const Color(0xffefefef),
                  border: Border.all(color: Colors.black12, width: 1.w)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15.h),
                  Expanded(
                      child: TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            errorMaxLines: 1,
                            //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                          keyboardType: TextInputType.text,
                          onChanged: (value) {})),
                ],
              )),
          SizedBox(
            height: 10.h,
          ),
          Container(
              height: 45.h,
              width: 280.w,
              decoration: BoxDecoration(
                  color: const Color(0xffefefef),
                  border: Border.all(color: Colors.black12, width: 1.w)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15.h),
                  Expanded(
                      child: TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email Id",
                            errorMaxLines: 1,
                            //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {})),
                ],
              )),
          SizedBox(
            height: 10.h,
          ),
          Container(
              height: 45.h,
              width: 280.w,
              decoration: BoxDecoration(
                  color: const Color(0xffefefef),
                  border: Border.all(color: Colors.black12, width: 1.w)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 15.h),
                  Expanded(
                      child: TextFormField(
                          enabled: false,
                          controller: mobileNumberController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Mobile Number.",
                            errorMaxLines: 1,
                            //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
                            errorStyle:
                                TextStyle(color: Colors.red, fontSize: 12.sp),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {})),
                ],
              )),
          SizedBox(
            height: 10.h,
          ),
          Container(
              height: 45.h,
              width: 280.w,
              decoration: BoxDecoration(
                  color: const Color(0xffefefef),
                  border: Border.all(color: Colors.black12, width: 1.w)),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                genderValue = "Male";
                              });
                            },
                            child: Card(
                              elevation: 1.h,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.h),
                              ),
                              child: Container(
                                  height: 30.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: (genderValue == "Male")
                                          ? ColorConstants.primaryColor
                                          : Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 2.h,
                                          bottom: 2.h,
                                          left: 15.h,
                                          right: 15.h),
                                      child: Center(
                                        child: Text(
                                          'Male',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'RoMedium',
                                              color: Colors.black,
                                              fontSize: 12.sp),
                                        ),
                                      ))),
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                genderValue = "FeMale";
                              });
                            },
                            child: Card(
                              elevation: 1.h,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.h),
                              ),
                              child: Container(
                                  height: 30.h,
                                  width: 100.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(
                                      color: (genderValue == "FeMale")
                                          ? ColorConstants.primaryColor
                                          : Colors.white,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Padding(
                                      padding: EdgeInsets.only(
                                          top: 2.h,
                                          bottom: 2.h,
                                          left: 15.h,
                                          right: 15.h),
                                      child: Center(
                                        child: Text(
                                          'FeMale',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'RoMedium',
                                              color: Colors.black,
                                              fontSize: 12.sp),
                                        ),
                                      ))),
                            ),
                          )
                        ],
                      ))
                ],
              )),
          SizedBox(
            height: 10.h,
          ),
          Container(
              height: 45.h,
              width: 280.w,
              decoration: BoxDecoration(
                  color: const Color(0xffefefef),
                  border: Border.all(color: Colors.black12, width: 1.w)),
              child: GestureDetector(
                onTap: () async {
                  DateTime? selected = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2010),
                    lastDate: DateTime.now(),
                  );
                  setState(() {
                    selectedDate = selected!;
                    if (selectedDate != null) {
                      dateOfBirthController = TextEditingController(
                          text: DateFormat("dd-MM-yyyy").format(selectedDate));
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 15.h),
                    Expanded(
                        child: TextFormField(
                            enabled: false,
                            controller: dateOfBirthController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Date of Birth",
                              errorMaxLines: 1,
                              //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
                              errorStyle:
                                  TextStyle(color: Colors.red, fontSize: 12.sp),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {})),
                  ],
                ),
              )),
          Container(
            margin: EdgeInsets.only(top: 15.h),
            child: Container(
              width: 170.w,
              padding: EdgeInsets.all(10.h),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20.h)),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: ColorConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.h))),
                onPressed: () {
                  BlocProvider.of<ProfileBloc>(context).add(
                      UpdateProfileDataEvent(
                          context: context,
                          name: nameController.text,
                          gender: genderValue,
                          dob: dateOfBirthController.text,
                          email: emailController.text,
                          image: "",
                          userId: userId));
                },
                child: Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.white, fontSize: 18.sp),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
