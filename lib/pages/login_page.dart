import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_login/view_model/login_page_view_model.dart';
import 'package:sqflite_login/widgets/text.dart';

class LoginPage extends StatelessWidget{
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Provider<LoginViewModel>(
      create: (context)=>LoginViewModel(),
      builder: (BuildContext context,child){
       return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget("Login"),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextFormUser(context),
                    _buildTextFormPassword(context),
                  ],
                ),
              ),
              _buildLoginButton(context),
              _buildTextButton(context),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildTextFormUser(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        controller: Provider.of<LoginViewModel>(context).userNameController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          } else if (value.length <= 6) {
            return 'You must enter at least 6 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Enter your username",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormPassword(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        controller: Provider.of<LoginViewModel>(context).passwordController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          } else if (value.length <= 6) {
            return 'You must enter at least 6 characters';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: "Enter your password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }


  ElevatedButton _buildLoginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          final result=await Provider.of<LoginViewModel>(context,listen: false).controlAndLogin(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result)),
          );
        }

      },
      child: Text("Login"),
    );
  }

  TextButton _buildTextButton(BuildContext context ) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text("I dont have any account! Create one"),
    );
  }
}
