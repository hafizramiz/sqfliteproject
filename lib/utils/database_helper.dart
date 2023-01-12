import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_login/models/user.dart';

import '../models/permission.dart';

class DatabaseHelper {
  late Database database;
  static DatabaseHelper _databaseHelper = DatabaseHelper._privateConstructor();

  factory DatabaseHelper() {
    return _databaseHelper;
  }
  DatabaseHelper._privateConstructor();

  static DatabaseHelper get databaseHelper => _databaseHelper;

  Future<void> open() async {
    final databaseName = "sqfliteLogin.db";
    final dbDirectory = await getDatabasesPath();
    final path = join(dbDirectory, databaseName);
    database = await openDatabase(
      path,
      version: 1,
      onConfigure: _onConfigure,
      onCreate: _createDb,
    );
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  _createDb(Database db, version) async {
    await db.execute('''
        CREATE TABLE user(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        user_name TEXT NOT NULL,
        password TEXT NOT NULL,
        user_type TEXT NOT NULL         
        )
        ''');
    await db.execute('''
        CREATE TABLE permissons(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        start_date TEXT NOT NULL,
        finish_date TEXT NOT NULL,
        number_of_day INTEGER ,
        accept_status INTEGER,
        user_id INTEGER,
        FOREIGN KEY (user_id) REFERENCES user (id)                  
       ON DELETE CASCADE ON UPDATE CASCADE
        )
       ''');
  }

  Future<void> insertUser(User user) async {
    var count = Sqflite.firstIntValue(await database.rawQuery(
        "SELECT COUNT(*) FROM user WHERE user_name = ?", [user.user_name]));
    if (count == 0) {
      await database.insert("user", user.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      throw Exception("There is a user with the same name");
    }
  }

  Future<List<Map<String, dynamic>>> getUser(User user) async {
    List<Map<String, dynamic>> result = await database.query('user',
        where: 'user_name = ?', whereArgs: ['${user.user_name}']);
    return result;
  }

  Future<void> insertPermisson(Permission permission) async {
    var count = Sqflite.firstIntValue(await database.rawQuery(
        "SELECT COUNT(*) FROM permissons WHERE id = ?", [permission.id]));
    if (count == 0) {
      await database.insert("permissons", permission.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      throw Exception("We found a permission with same id");
    }
  }

  Future<List<Permission>> getPermissionRequestsList(User user) async {
    List<Map<String, dynamic>> permissonRequestList = await database
        .query("permissons", where: 'user_id = ?', whereArgs: ['${user.id}']);
    if (permissonRequestList.isNotEmpty) {
      List<Permission> permissonList = permissonRequestList.map((json) {
        Permission permission = Permission.fromJson(json);
        return permission;
      }).toList();
      return permissonList;
    } else {
      return [];
    }
  }

  Future<void> getUserList() async {
    final userList = await database.query("user");
  }

  Future<List<Permission>> getPendingPermissionRequestsList() async {
    List<Map<String, dynamic>> pendingPermissonRequestList = await database
        .query("permissons", where: 'accept_status = ?', whereArgs: ['0']);
    if (pendingPermissonRequestList.isNotEmpty) {
      List<Permission> pendingPermissonList =
          pendingPermissonRequestList.map((json) {
        Permission permission = Permission.fromJson(json);
        return permission;
      }).toList();
      return pendingPermissonList;
    } else {
      return [];
    }
  }

  Future<void> update(Permission permission) async {
    await database.update("permissons", permission.toJson(),
        where: "id = ?", whereArgs: [permission.id]);
  }

  Future<List<Map<String,dynamic>>> getPendingPermissionRequestsInnerJoin(int accept_status) async {
  List<Map<String,dynamic>> requestListWithUserName = await database.rawQuery(
      "SELECT * FROM permissons inner join user on user.id=permissons.user_id WHERE accept_status=? ",[accept_status]);
      return requestListWithUserName;
    }
}
