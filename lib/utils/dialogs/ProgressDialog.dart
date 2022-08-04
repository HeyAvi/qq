import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qq/utils/ColorConstants.dart';

class ProgressDialog extends StatefulWidget {

  ProgressDialog(data){
    message = data;
  }


  String? message;

  @override
  _ProgressDialogState createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<ProgressDialog> with SingleTickerProviderStateMixin{

  AnimationController? animationController;


  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
  }


  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.black45,
        insetPadding: EdgeInsets.symmetric(horizontal: 0,vertical:0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Padding(
                padding:  EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SpinKitThreeBounce(
                      color: ColorConstants.primaryColor,
                      size: 50.0,
                      controller: animationController,
                    ),
                    SizedBox(
                      height: 0,
                    ),
                    // Text(message!, style: TextStyle(color: ColorsHelper.colorBlack,fontSize: 25.sp,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }
}