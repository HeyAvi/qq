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
  DateTime? selectedDate;

  String genderValue = "Male";
  String userId = "";

  @override
  void initState() {
    super.initState();
    userData = userDataService.userData;
    userId = userData.user_id;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
        listener: (BuildContext context, state) {
      if (state is ProfileCompleteState) {
        setState(() {
          UserDataService _userDataService = getIt<UserDataService>();
          userData = _userDataService.userData;
        });
      }
    }, child: BlocBuilder<ProfileBloc, ProfileState>(
      builder: (BuildContext context, ProfileState state) {
        return WillPopScope(
          onWillPop: () async {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => const Home(false, false)),
                (_) => false);
            return false;
          },
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(155),
              child: Column(
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
                                          ApiConstants.IMAGE_URL +
                                              userData.image),
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
                            left: 15,
                            child: GestureDetector(
                              onTap: () {},
                              child: const CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 15,
                                child: Icon(
                                  Icons.camera_alt,
                                  color: ColorConstants.primaryColor,
                                  size: 18,
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
                                  padding: const EdgeInsets.only(
                                      top: 8.0, right: 15.0),
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
                                  onTap: () {
                                    updateUser(
                                        valueType: UserValueType.name,
                                        value: userData.name);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 8,
                                    child: Icon(
                                      Icons.edit,
                                      size: 10,
                                      color: Colors.grey[600],
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    child: Text(
                                      'Mobile No. +91${userData.phone}',
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
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
                ],
              ),
            ),
            extendBody: true,
            backgroundColor: ColorConstants.primaryColor,
            body: NestedScrollView(
                headerSliverBuilder: (context, value) {
                  return [
                    SliverAppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        expandedHeight: 220,
                        toolbarHeight: 0,
                        pinned: true,
                        flexibleSpace:
                            FlexibleSpaceBar(background: basicProfile())),
                  ];
                },
                body: settings()),
            bottomNavigationBar: const BottomNavigationWidget(4),
          ),
        );
      },
    ));
  }

  Widget basicProfile() => Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      flex: 1,
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
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
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
                            backgroundColor: ColorConstants.colorBackground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: const BorderSide(
                                color: Colors.black38,
                                width: 2,
                              ),
                            )),
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Text(
                            'Rankings',
                            style: TextStyle(color: Colors.black),
                          ),
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
                            CircleAvatar(
                                backgroundColor: Colors.white,
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: ImageIcon(
                                      AssetImage(
                                        'assets/icons-logout.png',
                                      ),
                                      color: Colors.black),
                                )),
                            Text(
                              "Log Out",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white),
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
                              alignment: Alignment.centerRight,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    right: 24,
                                  ),
                                  child: Text('D.O.B',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white)),
                                ),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now())
                                            .then((date) {
                                          if (date != null) {
                                            setState(() {
                                              updateUser(
                                                  value: '$date',
                                                  valueType: UserValueType.dob);
                                            });
                                          }
                                        });
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 8,
                                      child: Icon(
                                        Icons.edit,
                                        size: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ))
                              ],
                            ),
                            Text(dob(),
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            // todo update with real values
                            const SizedBox(
                              height: 10,
                            ),
                            Stack(
                              alignment: Alignment.centerRight,
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
                                    onTap: () {
                                      updateUser(
                                          value: userData.email,
                                          valueType: UserValueType.email);
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 8,
                                      child: Icon(
                                        Icons.edit,
                                        size: 10,
                                        color: Colors.grey[600],
                                      ),
                                    ))
                              ],
                            ),
                            Text(userData.email,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white)),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                updateGender(gender: 'male');
                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: ImageIcon(
                                            AssetImage('assets/male-user.png'),
                                            color: Colors.blueAccent)),
                                  ),
                                  if (userData.gender != null &&
                                      userData.gender?.toLowerCase() == 'male')
                                    const CircleAvatar(
                                      child: Icon(
                                        Icons.check,
                                        size: 10,
                                      ),
                                      radius: 8,
                                    )
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                updateGender(gender: 'female');
                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        child: ImageIcon(
                                            AssetImage(
                                                'assets/woman-avatar.png'),
                                            color: Colors.pinkAccent)),
                                  ),
                                  if (userData.gender != null &&
                                      userData.gender?.toLowerCase() ==
                                          'female')
                                    const CircleAvatar(
                                      child: Icon(
                                        Icons.check,
                                        size: 10,
                                      ),
                                      radius: 8,
                                    )
                                ],
                              ),
                            ),
                          ],
                        )
                      ]),
                )
              ],
            ),
          ),
        ],
      );

  Widget settings() => Container(
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
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
                        backgroundColor: ColorConstants.primaryColor,
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
                    children: const [
                      Icon(
                        Icons.remove_circle_outline,
                        color: Colors.red,
                      ),
                      SizedBox(width: 10),
                      Text(
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
                const SafeArea(
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      );

  bool notification = true;
  bool sound = true;

  Future updateUser(
      {required String value, required UserValueType valueType}) async {
    TextEditingController _controller = TextEditingController(text: value);
    String label = '';
    if (valueType == UserValueType.name) {
      label = 'Enter your name';
    }
    if (valueType == UserValueType.email) {
      label = 'Enter your email';
    }
    if (valueType == UserValueType.dob) {
      label = 'Enter your date of birth';
    }

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              title: TextField(
                controller: _controller,
                readOnly: valueType == UserValueType.dob,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: label,
                ),
              ),
              content: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<ProfileBloc>(context).add(
                      UpdateProfileDataEvent(
                          context: context,
                          name: valueType == UserValueType.name
                              ? _controller.text
                              : userData.name,
                          gender: valueType == UserValueType.gender
                              ? _controller.text
                              : userData.gender ?? '',
                          dob: valueType == UserValueType.dob
                              ? _controller.text
                              : userData.dob ?? '',
                          email: valueType == UserValueType.email
                              ? _controller.text
                              : userData.email,
                          image: userData.image,
                          userId: userId));
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
                child: const Text('Submit'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorConstants.primaryColor),
              ),
            ));
  }

  String dob() {
    if (userData.dob != null && userData.dob!.isNotEmpty) {
      List<String> date = userData.dob!.split('-');
      return '${date[2]}-${date[1]}-${date[0]}';
    }
    return 'Update your D.O.B';
  }

  updateGender({required String gender}) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.h),
              ),
              title: Text(
                  'Are you sure you want to change your gender to $gender?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<ProfileBloc>(context).add(
                        UpdateProfileDataEvent(
                            context: context,
                            name: userData.name,
                            gender: gender,
                            dob: userData.dob ?? '',
                            email: userData.email,
                            image: userData.image,
                            userId: userId));
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Yes'),
                )
              ],
            ));
  }
}

enum UserValueType { name, email, dob, gender }
