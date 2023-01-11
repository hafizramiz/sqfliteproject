
import 'package:flutter/material.dart';
import 'package:sqflite_login/pages/admin_page.dart';
import 'package:sqflite_login/utils/database_helper.dart';

import '../models/user.dart';
import '../pages/personel_page.dart';

class LoginViewModel {
  DatabaseHelper databaseHelper = DatabaseHelper.databaseHelper;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late User recordedUser;
  late User createdUser;

  Future<User> getUser() async {
    final id = DateTime.now().microsecondsSinceEpoch;
     createdUser = User(
        id: id,
        user_name: userNameController.text,
        password: passwordController.text,
       user_type: "belirsiz"
     );

    List<Map<String, dynamic>> result =
        await databaseHelper.getUser(createdUser);
    if (result.isNotEmpty) {
      Map<String, dynamic> json = result[0];
      final User user = User.fromJson(json);
      return user;
    } else {
      throw Exception("There is no user with the same name");
    }

  }
  Future<String>controlAndLogin(BuildContext context)async{
    String loggedIn="";
    try{
      recordedUser=await getUser();
      if (createdUser.user_name == recordedUser.user_name) {
        if (createdUser.password == recordedUser.password) {
          if(recordedUser.user_type=="personel"){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PersonelPage(user: recordedUser,),
                ));
            print("Giris Basarili");
            loggedIn="Giris yapiliyor";
          }else if(recordedUser.user_type=="admin"){
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminPageRequests(user: recordedUser),
                ));
            print("Giris Basarili");
            loggedIn="Giris yapiliyor";
          }else{
            print("Beklenmeyen hata olustu");
          }

        } else {
          print("Wrong password");
          loggedIn="Wrong password";
        }
      }
    }catch(error){
      print(error);
      loggedIn="There is no user with the same name";
    }
    return loggedIn;
  }

}
