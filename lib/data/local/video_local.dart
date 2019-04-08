import 'package:sqflite/sqflite.dart';
import 'package:flutter_muyi/log/mlog.dart';

class VideoLocal{

  Database db;

  VideoLocal(Database database){
    MLog.d("Video Local init");
   this.db = database;
  }

  Future<int> save(String name) async {
    return db.transaction((trx){
      trx.rawInsert( 'INSERT INTO video(name) VALUES("$name")');
    });
  }

  Future<List<Map>> get() async {
    List<Map> list=    await db.rawQuery('SELECT * FROM user');
    return list;
  }

}