
import 'package:intl/intl.dart';
class DatetimeHelper{

  static String toStringFromDateTime(DateTime myDate) {
    String formatedDate = DateFormat("dd-MM-yyyy").format(myDate);
    return formatedDate;
  }

  static DateTime toDatetimeFromString(String myStringDate){
    DateTime formatedDate=DateFormat("dd-MM-yyyy").parse(myStringDate);
    return formatedDate;
  }

  static int diffirenceBetweenTwoDate(DateTime formatedStartDate, DateTime formatedFinishDate){
    DateTime dt1 = DateTime.parse("$formatedStartDate");
    DateTime dt2 = DateTime.parse("$formatedFinishDate");
    Duration diff = dt2.difference(dt1);
    print(diff.inDays.runtimeType);
    return diff.inDays;
  }
}