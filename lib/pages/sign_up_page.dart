import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_login/view_model/sign_up_page_view_model.dart';

import '../widgets/text.dart';
import 'login_page.dart';

class SignUpPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpViewModel>(
      create: (context) => SignUpViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextWidget("Sign Up"),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextFormUser(context),
                    _buildTextFormPassword(context),
                    _buildDropdownButton(context),
                    _buildSignUpButton(context),
                    _buildTextButton(context),
                  ],
                ),
              ),
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
        controller: Provider.of<SignUpViewModel>(context).userNameController,
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
        controller: Provider.of<SignUpViewModel>(context).passwordController,
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

  DropdownButton<String> _buildDropdownButton(BuildContext context) {
    return DropdownButton<String>(
      value: Provider.of<SignUpViewModel>(context, listen: false).dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      onChanged: (String? value) {
        Provider.of<SignUpViewModel>(context, listen: false)
            .setterDropDownValue(value);
      },
      items: Provider.of<SignUpViewModel>(context)
          .list
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  ElevatedButton _buildSignUpButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            final bool insertResult =
                await Provider.of<SignUpViewModel>(context, listen: false)
                    .insertUser();
            if (insertResult == true) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Please login with your new account")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("There is a user with the same name"),
                ),
              );
            }
          }
        },
        child: Text("Create Account"));
  }

  TextButton _buildTextButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Text("Already I have Account"),
    );
  }
}
