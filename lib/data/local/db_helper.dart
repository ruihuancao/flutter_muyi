import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_muyi/log/mlog.dart';
class DBHelper{

  static final int db_version = 1;
  static final String db_name = "muyi_db";

  static Future<Database> initDataBase() async {
    MLog.d("init database ");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, db_name);
    MLog.d("database path: $path");
    Database database = await openDatabase(path, version: db_version,
        onCreate: _onCreate,
        onConfigure: _onConfigure,
        onUpgrade: _onUpgrade,
        onDowngrade: _onDowngrade,
        onOpen: _onOpen
    );
    return database;
  }

  static void _onCreate(Database db, int version) async{
    MLog.d("database create");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, name TEXT)");
    await db.execute("""
  CREATE TABLE video_table(
   id INTEGER PRIMARY KEY   AUTOINCREMENT,
   name           TEXT      NOT NULL,
   link           TEXT      NOT NULL,
   category       CHAR(50)  NOT NULL,
   time           TIMESTAMP DEFAULT CURRENT_TIMESTAMP
   )
    """);
  }

  static void _onConfigure(Database db){
    MLog.d("database configure");
  }

  static void _onOpen(Database db){
    MLog.d("database open");
  }

  static void _onUpgrade(Database db, int oldVersion, int newVersion){
    MLog.d("database upgrade");
  }

  static void _onDowngrade(Database db, int oldVersion, int newVersion){
    MLog.d("database downgrade");
  }
}
