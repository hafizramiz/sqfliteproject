import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sqflite_login/models/permission.dart';
import 'package:sqflite_login/utils/database_helper.dart';

class RequestDetail extends StatefulWidget {
  final Permission permission;
  final int index;

  RequestDetail({required this.permission,required this.index});

  @override
  State<RequestDetail> createState() => _RequestDetailState();
}

class _RequestDetailState extends State<RequestDetail> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  late Future<List<Map<String, dynamic>>> myFuture;

  @override
  void initState() {
    myFuture = databaseHelper.getPendingPermissionRequestsInnerJoin(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: myFuture,
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasData) {
          List<Map<String, dynamic>> permissionListWithUserName =
              snapshot.data as List<Map<String, dynamic>>;
          return Scaffold(
            appBar: AppBar(
              title: Text("Request Detail"),
            ),
            body: Column(
              children: [
                ListTile(
                  title: Text("Personel UserName"),
                  trailing:
                      Text("${permissionListWithUserName[widget.index]["user_name"]}"),
                ),
                ListTile(
                  title: Text("Start of Day"),
                  trailing: Text("${widget.permission.start_date}"),
                ),
                ListTile(
                  title: Text("Finish of Day"),
                  trailing: Text("${widget.permission.finish_date}"),
                ),
                ListTile(
                  title: Text("Number of Day"),
                  trailing: Text("${widget.permission.number_of_day}"),
                ),
                SizedBox(
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await onTap(accept_status: 1);
                          Navigator.pop(context);
                        },
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.green,
                          ),
                          label: const Text('Accept'),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await onTap(accept_status: 2);
                          Navigator.pop(context);
                        },
                        child: Chip(
                          avatar: CircleAvatar(
                            backgroundColor: Colors.red,
                          ),
                          label: const Text('Reject'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
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

  Future<void> onTap({required int accept_status}) async {
    Permission permission = Permission(
        id: widget.permission.id,
        start_date: widget.permission.start_date,
        finish_date: widget.permission.finish_date,
        number_of_day: widget.permission.number_of_day,
        accept_status: accept_status,
        user_id: widget.permission.user_id);
    await databaseHelper.update(permission);
  }
}
