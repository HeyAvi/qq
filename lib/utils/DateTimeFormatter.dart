import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

class DateFormatter {

  static String getDayMonthYearFormat(String end_date) {
    String end_date1 = "";
    print("end_date===>>>"+end_date);
    var arr = end_date.split(" ");
    var arr1 = arr[0].split("-");
    var arr2 = arr[1].split(":");
    end_date1 = Jiffy({
      "year":int.parse(arr1[0]),
      "month":int.parse(arr1[1]),
      "day":int.parse(arr1[2]),
      "hour": int.parse(arr2[0]),
      "minutes":int.parse(arr2[1]),
    }).yMMMd;
    return end_date1;
  }

  static String getTime(String end_date) {
    String toReturn = "";
    if(end_date != "") {
      var arr = end_date.split(" ");
      var arr1 = arr[0].split("-");
      var arr2 = arr[1].split(":");
      toReturn = Jiffy({
        "year": int.parse(arr1[2]),
        "month": int.parse(arr1[1]),
        "day": int.parse(arr1[0]),
        "hour": int.parse(arr2[0]),
        "minutes": int.parse(arr2[1]),
      }).jm;
    }
    return toReturn;
  }

  static int getUTCRemainingTimeInMills(String dateStr)  {

    DateFormat dateFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(dateStr);

    int utcRemainingTime = dateTime.millisecondsSinceEpoch ;
    print("run time===>>>"+utcRemainingTime.toString());
    return utcRemainingTime;
  }

  static int getUTCRemainingTimeInSeconds(String dateStr)  {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime dateTime = dateFormat.parse(dateStr);
    final toDayDate = DateTime.now();
    var different = dateTime.difference(toDayDate).inSeconds;
    return different;
  }
}