import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qq/ui/BuyTickets.dart';
import 'package:qq/ui/home.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/dialogs/ProgressDialog.dart';

class DialogUtil{
  static late BuildContext dialogContext;

  static showProgressDialog(String message,BuildContext context){
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProgressDialog(message);
      },
    );
  }

  static dismissProgressDialog(BuildContext context){
    Navigator.pop(context);
  }

  static showSuccessDialog(String message,BuildContext context){
    return AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      showCloseIcon: true,
      title: 'Succes',
      desc: message,
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.check_circle,
      onDissmissCallback: (type) {

      },
    ).show();
  }


  static showInfoDialog(String message , BuildContext context){
    return AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      showCloseIcon: true,
      title: 'Info',
      desc: message,
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.info_outline,
      onDissmissCallback: (type) {

      },
    ).show();
  }

  static showTicketInfoDialog(String message , BuildContext context){
    return Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0)
        ),
        child: Stack(
          //overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    Text('Info !!!', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    SizedBox(height: 5,),
                    Text(message, style: TextStyle(fontSize: 20),),
                    SizedBox(height: 20,),
                    RaisedButton(onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (Context)=>BuyTickets()));
                    },
                      color: ColorConstants.primaryColor,
                      child: Text('Add Ticket', style: TextStyle(color: Colors.white),),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: ColorConstants.primaryColor,
                  radius: 60,
                  child: Icon(Icons.info_outline, color: Colors.white, size: 50,),
                )
            ),
          ],
        )
    );
  }

}