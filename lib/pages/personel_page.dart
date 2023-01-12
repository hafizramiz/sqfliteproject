import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_login/pages/permission_requests_page.dart';
import 'package:sqflite_login/view_model/personel_page_view_model.dart';

import '../models/user.dart';

class PersonelPage extends StatelessWidget {
  final User user;
  PersonelPage({required this.user});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Provider<PersonelViewModel>(
      create: (context) => PersonelViewModel(),
      builder: (BuildContext context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Personel: ${user.user_name}"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PermissionRequestsPage(user),
                    ),
                  );
                },
                child: Text("My permisson requests"),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: TextFormField(
                        controller: Provider.of<PersonelViewModel>(context)
                            .startDateController,
                        onTap: () async {
                          final startDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2024),
                          ) as DateTime;
                          Provider.of<PersonelViewModel>(context, listen: false)
                              .setStartDateController(startDate);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select start date";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Select start date"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: TextFormField(
                        controller: Provider.of<PersonelViewModel>(context)
                            .finishDateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select finish date";
                          } else {
                            return null;
                          }
                        },
                        onTap: () async {
                          final finishDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2024),
                          ) as DateTime;
                          Provider.of<PersonelViewModel>(context, listen: false)
                              .setFinishDateController(finishDate);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            hintText: "Select finish date"),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            final startDateControllerText =
                                Provider.of<PersonelViewModel>(context,
                                        listen: false)
                                    .startDateController
                                    .text;
                            final finishDateControllerText =
                                Provider.of<PersonelViewModel>(context,
                                        listen: false)
                                    .finishDateController
                                    .text;

                            if (startDateControllerText.isNotEmpty &&
                                finishDateControllerText.isNotEmpty) {
                              Provider.of<PersonelViewModel>(context,
                                      listen: false)
                                  .setNumberOfDayController(
                                      startDateControllerText,
                                      finishDateControllerText);
                            }
                          },
                          child: Text("Click and calculate number of day"),
                        ),
                        SizedBox(
                          width: 100,
                          height: 80,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: TextFormField(
                              controller:
                                  Provider.of<PersonelViewModel>(context)
                                      .numberOfDayController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please write number of day";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: "0",
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final insertResult = await Provider.of<PersonelViewModel>(
                            context,
                            listen: false)
                        .insertPermission(user);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(insertResult)),
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PermissionRequestsPage(user),
                      ),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        );
      },
    );
  }
}
