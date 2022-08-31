import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qq/models/Userdata.dart';
import 'package:qq/services/ServicesLocator.dart';
import 'package:qq/services/UserDataServcie.dart';
import 'package:qq/ui/BottomNavigationWidget.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/ui/splashScreen.dart';
import 'package:qq/utils/ApiConstants.dart';
import 'package:qq/utils/ColorConstants.dart';
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

    getSharedPreferences();
  }

  Future<void> getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: ColorConstants.primaryColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          basicProfile(),
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            minChildSize: 0.45,
            builder: (BuildContext context, ScrollController scrollController) {
              return settings(controller: scrollController);
            },
          )
        ],
      ),
      bottomNavigationBar: const BottomNavigationWidget(4),
    );
  }

  Widget basicProfile() => Column(
    children: [
      SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Home(false, false)));
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      Row(
        children: [
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: (userData.image != "")
                    ? CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundImage: NetworkImage(
                              ApiConstants.IMAGE_URL + userData.image),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 47.5,
                          backgroundImage:
                              AssetImage('assets/userprofile.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                left: 30,
                child: GestureDetector(
                  onTap: () {},
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 15,
                    child: Icon(
                      Icons.camera_alt,
                      color: ColorConstants.primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, right: 15.0),
                      child: (userData.name.isNotEmpty)
                          ? Text(
                              ' ' +
                                  userData.name
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  userData.name.substring(1),
                              style: const TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            )
                          : const Text(""),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 8,
                        child: Icon(
                          Icons.edit,
                          size: 12,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Mobile No. +91${userData.phone}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (userData.is_verified == 'YES')
                        const CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 10,
                          child: Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      const SizedBox(height: 20),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userDataService.totalParticipation,
                        style: const TextStyle(
                            fontSize: 30, color: Colors.white),
                      ),
                      const Text(
                        'Total Entries',
                        style:
                            TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          height: 60,
                          child: Opacity(
                            opacity: 0.5,
                            child: VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(8.0),
                                  side: const BorderSide(
                                    color: Colors.black38,
                                    width: 2,
                                  ),
                                ),
                                primary: ColorConstants.orangeColor),
                            onPressed: () {},
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              child: Text('Rankings'),
                            )),
                        const SizedBox(
                          height: 60,
                          child: Opacity(
                            opacity: 0.5,
                            child: VerticalDivider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () async {
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SplashScreen(),
                        ),
                        (_) => false,
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Padding(padding: EdgeInsets.all(2)),
                        Icon(Icons.logout, color: Colors.white),
                        Text(
                          "Log Out",
                          style: TextStyle(
                              fontSize: 12, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 24,
                              ),
                              child: const Text('D.O.B',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 8,
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            )
                          ],
                        ),
                        const Text('userData  (X Years)',
                            style: TextStyle(
                                fontSize: 14, color: Colors.white)),
                        // todo update with real values
                        const SizedBox(
                          height: 10,
                        ),
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(
                                right: 20,
                              ),
                              child: Text('E-mail',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 8,
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            )
                          ],
                        ),
                        Text(userData.email,
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {
                              // todo add update function
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0),
                              child: const Text('Update',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              primary: ColorConstants.colorBackground,
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(4.0),
                              child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.male,
                                      color: Colors.blueAccent)),
                            ),
                            CircleAvatar(
                              child: Icon(
                                Icons.check,
                                size: 10,
                              ),
                              radius: 8,
                            )
                          ],
                        ),
                        const SizedBox(width: 10),
                        const CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(Icons.female,
                                color: ColorConstants.primaryColor)),
                      ],
                    )
                  ]),
            )
          ],
        ),
      ),
    ],
  );

  Widget settings({required ScrollController controller}) => Container(
        decoration: const BoxDecoration(
          color: ColorConstants.colorBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            controller: controller,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  height: 6,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.notifications_active),
                  title: const Text('Notification'),
                  trailing: Switch(
                      value: notification,
                      activeColor: ColorConstants.primaryColor,
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
                      activeColor: ColorConstants.primaryColor,
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
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Do you like our Game ?',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.sp),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    'Be a part of gaming revolution and rate us on ${Platform.isAndroid ? 'Google Play' : 'App Store'}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[600]),
                  ),
                  subtitle: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: ColorConstants.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.h),
                        )),
                    onPressed: () {
                      setState(() {
                        Fluttertoast.showToast(msg: 'Rate us');
                      });
                    },
                    child: const Text(
                      'RATE US',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.navigate_next),
                ),
                const Divider(
                  thickness: 2,
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Delete Account',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.navigate_next),
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
          ),
        ),
      );

  bool notification = true;
  bool sound = true;

// basicInfo(BuildContext context) {
//   return BlocListener<ProfileBloc, ProfileState>(
//     listener: (context, state) {},
//     child: Column(
//       children: [
//         SizedBox(
//           height: 20.h,
//         ),
//         Container(
//             height: 45.h,
//             width: 280.w,
//             decoration: BoxDecoration(
//                 color: const Color(0xffefefef),
//                 border: Border.all(color: Colors.black12, width: 1.w)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(width: 15.h),
//                 Expanded(
//                     child: TextFormField(
//                         controller: nameController,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "Name",
//                           errorMaxLines: 1,
//                           //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
//                           errorStyle:
//                               TextStyle(color: Colors.red, fontSize: 12.sp),
//                         ),
//                         keyboardType: TextInputType.text,
//                         onChanged: (value) {})),
//               ],
//             )),
//         SizedBox(
//           height: 10.h,
//         ),
//         Container(
//             height: 45.h,
//             width: 280.w,
//             decoration: BoxDecoration(
//                 color: const Color(0xffefefef),
//                 border: Border.all(color: Colors.black12, width: 1.w)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(width: 15.h),
//                 Expanded(
//                     child: TextFormField(
//                         controller: emailController,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "Email Id",
//                           errorMaxLines: 1,
//                           //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
//                           errorStyle:
//                               TextStyle(color: Colors.red, fontSize: 12.sp),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         onChanged: (value) {})),
//               ],
//             )),
//         SizedBox(
//           height: 10.h,
//         ),
//         Container(
//             height: 45.h,
//             width: 280.w,
//             decoration: BoxDecoration(
//                 color: const Color(0xffefefef),
//                 border: Border.all(color: Colors.black12, width: 1.w)),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(width: 15.h),
//                 Expanded(
//                     child: TextFormField(
//                         enabled: false,
//                         controller: mobileNumberController,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                           hintText: "Mobile Number.",
//                           errorMaxLines: 1,
//                           //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
//                           errorStyle:
//                               TextStyle(color: Colors.red, fontSize: 12.sp),
//                         ),
//                         keyboardType: TextInputType.number,
//                         onChanged: (value) {})),
//               ],
//             )),
//         SizedBox(
//           height: 10.h,
//         ),
//         Container(
//             height: 45.h,
//             width: 280.w,
//             decoration: BoxDecoration(
//                 color: const Color(0xffefefef),
//                 border: Border.all(color: Colors.black12, width: 1.w)),
//             child: Row(
//               children: [
//                 Expanded(
//                     flex: 1,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               genderValue = "Male";
//                             });
//                           },
//                           child: Card(
//                             elevation: 1.h,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.h),
//                             ),
//                             child: Container(
//                                 height: 30.h,
//                                 width: 100.w,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   border: Border.all(
//                                     color: (genderValue == "Male")
//                                         ? ColorConstants.primaryColor
//                                         : Colors.white,
//                                     width: 1.0,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                     padding: EdgeInsets.only(
//                                         top: 2.h,
//                                         bottom: 2.h,
//                                         left: 15.h,
//                                         right: 15.h),
//                                     child: Center(
//                                       child: Text(
//                                         'Male',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontFamily: 'RoMedium',
//                                             color: Colors.black,
//                                             fontSize: 12.sp),
//                                       ),
//                                     ))),
//                           ),
//                         )
//                       ],
//                     )),
//                 Expanded(
//                     flex: 1,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               genderValue = "FeMale";
//                             });
//                           },
//                           child: Card(
//                             elevation: 1.h,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(5.h),
//                             ),
//                             child: Container(
//                                 height: 30.h,
//                                 width: 100.w,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.rectangle,
//                                   border: Border.all(
//                                     color: (genderValue == "FeMale")
//                                         ? ColorConstants.primaryColor
//                                         : Colors.white,
//                                     width: 1.0,
//                                   ),
//                                 ),
//                                 child: Padding(
//                                     padding: EdgeInsets.only(
//                                         top: 2.h,
//                                         bottom: 2.h,
//                                         left: 15.h,
//                                         right: 15.h),
//                                     child: Center(
//                                       child: Text(
//                                         'FeMale',
//                                         textAlign: TextAlign.center,
//                                         style: TextStyle(
//                                             fontFamily: 'RoMedium',
//                                             color: Colors.black,
//                                             fontSize: 12.sp),
//                                       ),
//                                     ))),
//                           ),
//                         )
//                       ],
//                     ))
//               ],
//             )),
//         SizedBox(
//           height: 10.h,
//         ),
//         Container(
//             height: 45.h,
//             width: 280.w,
//             decoration: BoxDecoration(
//                 color: const Color(0xffefefef),
//                 border: Border.all(color: Colors.black12, width: 1.w)),
//             child: GestureDetector(
//               onTap: () async {
//                 DateTime? selected = await showDatePicker(
//                   context: context,
//                   initialDate: selectedDate,
//                   firstDate: DateTime(2010),
//                   lastDate: DateTime.now(),
//                 );
//                 setState(() {
//                   selectedDate = selected!;
//                   if (selectedDate != null) {
//                     dateOfBirthController = TextEditingController(
//                         text: DateFormat("dd-MM-yyyy").format(selectedDate));
//                   }
//                 });
//               },
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   SizedBox(width: 15.h),
//                   Expanded(
//                       child: TextFormField(
//                           enabled: false,
//                           controller: dateOfBirthController,
//                           decoration: InputDecoration(
//                             border: InputBorder.none,
//                             hintText: "Date of Birth",
//                             errorMaxLines: 1,
//                             //errorText: (state.mobileNumber != null && state.mobileNumber!.valid) ? null : "Invalid Mobile Number",
//                             errorStyle:
//                                 TextStyle(color: Colors.red, fontSize: 12.sp),
//                           ),
//                           keyboardType: TextInputType.number,
//                           onChanged: (value) {})),
//                 ],
//               ),
//             )),
//         Container(
//           margin: EdgeInsets.only(top: 15.h),
//           child: Container(
//             width: 170.w,
//             padding: EdgeInsets.all(10.h),
//             decoration:
//                 BoxDecoration(borderRadius: BorderRadius.circular(20.h)),
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                   primary: ColorConstants.primaryColor,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.h))),
//               onPressed: () {
//                 BlocProvider.of<ProfileBloc>(context).add(
//                     UpdateProfileDataEvent(
//                         context: context,
//                         name: nameController.text,
//                         gender: genderValue,
//                         dob: dateOfBirthController.text,
//                         email: emailController.text,
//                         image: "",
//                         userId: userId));
//               },
//               child: Text(
//                 'UPDATE',
//                 style: TextStyle(color: Colors.white, fontSize: 18.sp),
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
}
