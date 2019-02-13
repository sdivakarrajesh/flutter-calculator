import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';

import 'package:calculator/data/EntryModel.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "pastEntries.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE pastEntriesTable ("
          "id INTEGER PRIMARY KEY,"
          "num1 TEXT,"
          "num2 TEXT,"
          "operation TEXT,"
          "result TEXT"
          ")");
    });
  }

  newEntry(Entry newEntry) async {
    final db = await database;
    //get the biggest id in the table
    var table =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM pastEntriesTable");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into [pastEntriesTable] (id,num1,num2,operation,result)"
        " VALUES (?,?,?,?,?)",
        [
          id,
          newEntry.num1,
          newEntry.num2,
          newEntry.operation,
          newEntry.result
        ]);
    return raw;
  }

  Future<List<Entry>> getAllPastEntries() async {
    final db = await database;
    var res = await db.query("pastEntriesTable");
    List<Entry> list =
        res.isNotEmpty ? res.map((c) => Entry.fromMap(c)).toList() : [];
    return list;
  }

  deleteAllEntries() async {
    final db = await database;
    db.rawDelete("DELETE FROM pastEntriesTable");
  }
}
