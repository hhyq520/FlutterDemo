import 'dart:developer';
import 'dart:io';

import 'package:flutter_stander/model/result_bean.dart';
import 'package:flutter_stander/model/tuihuo_bean.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
class DBManger {
  static String dbName="stander.db";
  static Future<String> _createNewDb(String dbName) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dbName);
    if (await new Directory(dirname(path)).exists()) {
//      await deleteDatabase(path);
    } else {
      try {
        await new Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    return path;
  }

  static createTuohuo() async {
    String sql_createTable =
        'CREATE TABLE tuihuo_table (id INTEGER PRIMARY KEY, '
        'billcode TEXT,signMan Text,scanTime Text,scanMan Text,employCode Text,'
        'sendMan Text,errMsg Text,imgPath Text,isImgUpload INTEGER,isDataUpload INTEGER)';
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);

    await db.execute(sql_createTable);
    await db.close();
  }

  static Future addTuihuo(TuiHuoBean enity) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql =
        "INSERT INTO tuihuo_table(billcode,signMan,scanTime,scanMan,employCode,sendMan,errMsg,imgPath,isImgUpload,isDataUpload) VALUES('${enity.billcode}','${enity.signMan}','${enity.scanTime}','${enity.scanMan}','${enity.employCode}','${enity.sendMan}','${enity.errMsg}',"
        "'${enity.imgPath}',${enity.isImgUpload},${enity.isDataUpload})";
    await db.transaction((txn) async {
      int id = await txn.rawInsert(sql);
    });
    await db.close();
  }

  static Future<bool> deleteTuihuo(List<String> billcodes) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);

    String sql = "DELETE FROM tuihuo_table WHERE billcode = ?";
    for(String billcode in billcodes ) {
      int count = await db.rawDelete(sql, [billcode]);
    }
    await db.close();

//    if (count == 1) {
//      return true;
//    } else {
//      return false;
//    }
  }

  static update(TuiHuoBean enity) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql = "UPDATE tuihuo_table SET billcode = ? WHERE id = ?";
    int count = await db.rawUpdate(sql, [enity.billcode,enity.id]);
    print(count);
    await db.close();
  }

  static updateImgdata(String billcode) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql = "UPDATE tuihuo_table SET isImgUpload = 1 WHERE billcode = ?";
    int count = await db.rawUpdate(sql, [billcode]);
    print(count);
    await db.close();
  }

   static Future updateDatas(List<ResultBean> list) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql = "UPDATE tuihuo_table SET isDataUpload = ? WHERE id = ?";
    String sql1 = "UPDATE tuihuo_table SET isDataUpload = 0 and errMsg = ? WHERE id = ?";
    for (ResultBean info in list){
      if (info.isSuccess){
        await db.rawUpdate(sql, [1,int.parse(info.id)]);
      }else{
        await db.rawUpdate(sql1, [info.msg,int.parse(info.id)]);
      }
    }
    await db.close();
  }



  static Future<int> queryNum(String billcode,String employCode) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql_query_count = 'SELECT COUNT(*) FROM tuihuo_table WHERE billcode = ? and employCode = ?';
    int count = Sqflite.firstIntValue(await db.rawQuery(sql_query_count,[billcode,employCode]));
    await db.close();
    return count;
  }

  static Future<List<Map>> query() async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql_query = 'SELECT * FROM tuihuo_table';
    List<Map> list = await db.rawQuery(sql_query);
    await db.close();
    return list;
  }

  static Future<List<Map>> queryBean(String billcode,String employCode) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql_query = 'SELECT * FROM tuihuo_table WHERE billcode = ? and employCode = ?';
    List<Map> list = await db.rawQuery(sql_query,[billcode,employCode]);
    await db.close();
    return list;
  }

  static Future<List<Map>> queryNotUpload(String employCode) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql_query = 'SELECT * FROM tuihuo_table WHERE isDataUpload = 0 and employCode = ?';
    List<Map> list = await db.rawQuery(sql_query,[employCode]);
    await db.close();
    return list;
  }

  static Future<List<Map>> queryNotUploadImgs(String employCode) async {
    String dbPath = await _createNewDb(dbName);
    Database db = await openDatabase(dbPath);
    String sql_query = 'SELECT * FROM tuihuo_table WHERE isDataUpload = 1 and employCode = ? and isImgUpload = 0';
    List<Map> list = await db.rawQuery(sql_query,[employCode]);
    await db.close();
    return list;
  }
}