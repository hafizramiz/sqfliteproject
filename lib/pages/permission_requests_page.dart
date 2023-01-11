import 'package:flutter/material.dart';
import 'package:sqflite_login/models/permission.dart';
import 'package:sqflite_login/models/user.dart';
import 'package:sqflite_login/utils/database_helper.dart';

class PermissionRequestsPage extends StatefulWidget {
  final User user;

  PermissionRequestsPage(this.user);

  @override
  State<PermissionRequestsPage> createState() => _PermissionRequestsPageState();
}

class _PermissionRequestsPageState extends State<PermissionRequestsPage> {
  late   Future<List<Permission>> myFuture;
  DatabaseHelper databaseHelper = DatabaseHelper.databaseHelper;
  @override
  void initState() {
    myFuture= databaseHelper.getPermissionRequestsList(widget.user);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Permission>>(
      future: myFuture,
      builder: (context , AsyncSnapshot<List<Permission>> snapshot){
        if(snapshot.hasData){
          List<Permission>permissionList=snapshot.data as List<Permission>;
          return Scaffold(
            appBar: AppBar(
              title: Text("Permission Request Detail"),
            ),
            body:ListView.builder(
              itemCount: permissionList.length,
                itemBuilder: (BuildContext context,int index){
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text("Permission Request $index"),
                    subtitle: Text("Number of Day: ${permissionList[index].number_of_day}"),
                    trailing: _buildCard(permissionList, index),
                  ),
                );
                })
          );
        }else if(snapshot.hasError){
          return Center(child: Text("Error"),);
        }else{
          return Center(child: CircularProgressIndicator(),);
        }

      },
    );
  }

  Widget _buildCard(List<Permission> permissionList, int index) {
    switch(permissionList[index].accept_status){
      case 0:
      return Chip(
        avatar: CircleAvatar(
          backgroundColor: Colors.grey,
        ),
        label: const Text('Pending'),
      );
      case 1:
      return Chip(
        avatar: CircleAvatar(
          backgroundColor: Colors.green,
        ),
        label: const Text('Accepted'),
      );
      case 2:
      return Chip(
        avatar: CircleAvatar(
          backgroundColor: Colors.red,
        ),
        label: const Text('Rejected'),
      );
      default:
        return Card();
  }
}
}
