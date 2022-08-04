import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/bloc/ProfileBloc/ProfileBloc.dart';
import 'package:qq/repository/ProfileRepository.dart';
import 'package:qq/ui/ContestDetails/ContestMainPage.dart';
import 'package:qq/ui/ContestDetails/SoundPuzzle/SoundPuzzle.dart';
import 'package:qq/ui/enterNumber.dart';
import 'package:qq/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child:  Image.asset('assets/qqLogo.png', width: 180.w)
      ),
    );
}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startHome();
  }
  
  Future<void> startHome() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration( milliseconds: 2000));
    if(prefs.getString("userDataKey") != null  && prefs.getString("userDataKey") != ""){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (Context) => Home(false,false)));
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (Context) => SoundPuzzle()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (Context) => EnterNumber()));
    }
  }
}













