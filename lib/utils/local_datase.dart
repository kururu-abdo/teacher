import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:teacher_side/models/notification.dart';


class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "notifications.db");
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Notification ("
          "id INTEGER PRIMARY KEY  AUTOINCREMENT ,"
          "time INTEGER  ,"
          "title  TEXT,"
          
          "object TEXT ,"
          "isread BIT ) "
          );
    });
  }

  newNotification(LocalNotification notification) async {
    final db = await database;
    //get the biggest id in the table
 
    var raw = await db.rawInsert(
        "INSERT Into Notification (time,title  ,object ,isread)"
        " VALUES (?,?,?,?)",
        [DateTime.now().millisecondsSinceEpoch,notification.title, notification.object ,   false ]);
    return raw;
  }

updateNotifica(LocalNotification notification) async{
    final db = await database;

int res = await db.update('Notification', notification.toJson(),
        where: "id = ?", whereArgs: <int>[notification.id]);
    return res > 0 ? true : false;
}


   Future<List<LocalNotification>> getAllNotification() async {
    final db = await database;
    var res = await db.query("Notification");
    List<LocalNotification> list =
        res.isNotEmpty ? res.map((c) => LocalNotification.fromJson(c)).toList() : [];
    return list;
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Notification");
  }
}