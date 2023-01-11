import 'package:flutter/material.dart';
import 'package:sqflite_login/pages/sign_up_page.dart';
import 'package:sqflite_login/utils/database_helper.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper databaseHelper=DatabaseHelper.databaseHelper;
  await databaseHelper.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpPage(),
    );
  }
}
