

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:shimmer/shimmer.dart';

Widget homeShimmerEffect(){
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    enabled: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // First pink container
        _buildTopContainer(),
        // Button with offset
        _buildMidContainerWithButton(),
        // Bottom white container
        _buildBottomContainer(),
      ],
    ),
  );
}


Widget _buildTopContainer() => Flexible(
    flex: 8,
    child: Container(
      decoration: BoxDecoration(
          color: ColorConstants.primaryColor,
          border: Border.all(
            color: ColorConstants.primaryColor,
          ),
          // borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32.h) , bottomRight: Radius.circular(32.h))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
         ]
      ),
    ));

Widget _buildMidContainerWithButton() {
  final buttonHeight = 50.0;
  return Stack(
    children: [
      // Use same background color like the second container
      Container(height: buttonHeight, color: Colors.white),
      // Translate the button
      Transform.translate(
        offset: Offset(0.0, -buttonHeight / 2.0),
        child: Center(
          child: Container(
            width: 180.w,
            //buttonWidth: 60.h,
            height: 40.h,
            color: ColorConstants.primaryColor2,
          ),
        ),
      ),
    ],
  );
}

Widget _buildBottomContainer() => Flexible(
  flex: 6,
  child: Container(
    color: Colors.white,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

        ]
    ),
  ),
);

