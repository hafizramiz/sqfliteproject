import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite_login/pages/request_detail.dart';

import '../models/permission.dart';
import '../models/user.dart';
import '../utils/database_helper.dart';

class AdminPageRequests extends StatefulWidget {
  final User user;

  AdminPageRequests({required this.user});

  @override
  State<AdminPageRequests> createState() => _AdminPageRequestsState();
}

class _AdminPageRequestsState extends State<AdminPageRequests> {
  late Future<List<Permission>> myFuture;
  DatabaseHelper databaseHelper = DatabaseHelper.databaseHelper;

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    myFuture = databaseHelper.getPendingPermissionRequestsList();
    print("Build calisti");
    return FutureBuilder<List<Permission>>(
      future: myFuture,
      builder: (context, AsyncSnapshot<List<Permission>> snapshot) {
        if (snapshot.hasData) {
          List<Permission> permissionList = snapshot.data as List<Permission>;
          return Scaffold(
              appBar: AppBar(
                title: Text("Admin: ${widget.user.user_name}"),
              ),
              body: permissionList.isEmpty
                  ? Center(
                      child: Text("There is no request"),
                    )
                  : ListView.builder(
                      itemCount: permissionList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 2,
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RequestDetail(
                                            permission: permissionList[index],
                                            index: index,
                                          ))).then((value) => onGoBack(value));
                            },
                            title: Text(
                                "${index+1} Permission Request "),
                            trailing: Chip(
                              avatar: CircleAvatar(
                                backgroundColor: Colors.grey,
                              ),
                              label: const Text('Pending'),
                            ),
                          ),
                        );
                      }));
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
