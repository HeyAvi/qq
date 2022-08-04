import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget dataNotAvailable(String message){
  return Column(
    children: [
      Image.asset("assets/datano.png",height: 100.h,width: 100.h,),
      SizedBox(
        height: 0.h,
      ),
      Text(message,style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54,fontSize: 18.sp),),
      SizedBox(
        height: 10.h,
      ),
    ],
  );
}