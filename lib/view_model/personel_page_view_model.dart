import 'package:flutter/material.dart';
import 'package:sqflite_login/models/permission.dart';
import 'package:sqflite_login/utils/datetime_helper.dart';

import '../models/user.dart';
import '../utils/database_helper.dart';

class PersonelViewModel {
  DatabaseHelper databaseHelper = DatabaseHelper.databaseHelper;
  TextEditingController startDateController = TextEditingController();
  TextEditingController finishDateController = TextEditingController();
  TextEditingController numberOfDayController = TextEditingController();
  late final numberOfDay;

  setStartDateController(DateTime startDate) {
    final stringDate = DatetimeHelper.toStringFromDateTime(startDate);
    startDateController.text = stringDate;
  }

  setFinishDateController(DateTime finishDate) {
    final stringDate = DatetimeHelper.toStringFromDateTime(finishDate);
    finishDateController.text = stringDate;
  }

  setNumberOfDayController(String startDate, String finishDate) {
    DateTime formatedStartDate = DatetimeHelper.toDatetimeFromString(startDate);
    DateTime formatedFinishDate =
        DatetimeHelper.toDatetimeFromString(finishDate);
    numberOfDay = DatetimeHelper.diffirenceBetweenTwoDate(
        formatedStartDate, formatedFinishDate);
    numberOfDayController.text = numberOfDay.toString();
  }

  Future<String> insertPermission(User user) async {
    /// Creating object
    Permission permission = Permission(
        id: DateTime.now().microsecondsSinceEpoch,
        start_date: startDateController.text,
        finish_date: finishDateController.text,
        number_of_day: numberOfDay,
        accept_status: 0,
        user_id: user.id);
    try {
      await databaseHelper.insertPermisson(permission);
      return "We are creating new permission";
    } catch (error) {
      print(error);
      return "There is a permission with same id";
    }
  }
}
