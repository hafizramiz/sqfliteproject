import 'package:flutter/material.dart';
import 'package:sqflite_login/utils/database_helper.dart';

import '../models/user.dart';
class SignUpViewModel extends ChangeNotifier{
DatabaseHelper databaseHelper=DatabaseHelper.databaseHelper;
TextEditingController userNameController = TextEditingController();
TextEditingController passwordController = TextEditingController();
final List<String> list = <String>['admin', 'personel'];
String dropdownValue="admin";


setterDropDownValue(String? value){
  dropdownValue=value!;
  notifyListeners();
}


Future<bool> insertUser()async{
  final id = DateTime.now().microsecondsSinceEpoch;

  User user = User(
      id: id,
      user_name: userNameController.text,
      password: passwordController.text,
    user_type: dropdownValue,
  );

  try {
    await databaseHelper.insertUser(user);
    return true;

  } catch (error) {
    return false;
  }
}
}