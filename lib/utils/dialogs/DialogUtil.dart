import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:qq/ui/BuyTickets.dart';
import 'package:qq/utils/ColorConstants.dart';
import 'package:qq/utils/dialogs/ProgressDialog.dart';

class DialogUtil {
  static late BuildContext dialogContext;

  static showProgressDialog(String message, BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: ProgressDialog(message));
      },
    );
  }

  static dismissProgressDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static showSuccessDialog(String message, BuildContext context) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      headerAnimationLoop: false,
      dialogType: DialogType.SUCCES,
      showCloseIcon: true,
      title: 'Success',
      desc: message,
      btnOkOnPress: () {
        debugPrint('OnClcik');
      },
      btnOkIcon: Icons.check_circle,
      onDissmissCallback: (type) {},
    ).show();
  }

  static showInfoDialog(
      {required String title,
      required String message,
      required BuildContext context,
      DialogType? dialogType,
      Function()? onOkTap,
      Function(DismissType)? dismissTap}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.LEFTSLIDE,
      headerAnimationLoop: false,
      dialogType: dialogType ?? DialogType.INFO,
      showCloseIcon: true,
      title: title,
      desc: message,
      btnOkOnPress: onOkTap,
      btnOkIcon: null,
      onDissmissCallback: dismissTap,
    ).show();
  }

  static showTicketInfoDialog(String message, BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          //overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            SizedBox(
              height: 220,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    const Text(
                      'Info !!!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      message,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BuyTickets()));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: ColorConstants.primaryColor
                      ) ,
                      child: const Text(
                        'Add Ticket',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
