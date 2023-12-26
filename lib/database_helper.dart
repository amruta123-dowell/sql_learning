import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflie_learning/screens/note_details_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'models/notes_model.dart';

class DataBaseHelper {
  static DataBaseHelper? _dbHelper;
  Database? _database;
  DataBaseHelper._createInstance();
  factory DataBaseHelper() {
    _dbHelper ??= DataBaseHelper._createInstance();
    return _dbHelper!;
  }
//NAME AND COLUMN NAMES the DB TABLE
  String noteTable = "note_table";
  String colId = "id";
  String colDescription = "description";
  String colPriority = "priority";
  String colDate = "date";
  String colTitle = "title";

//Get the directory path to store the database
  Future<Database> initializeDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = "${directory.path}notes.db";
    Database notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return notesDatabase;
  }

  ///get database
  Future<Database> get getDatabase async {
    return _database ??= await initializeDB();
  }

//Create DB table
  void _createDB(Database db, int newVersion) async {
    await db.execute(
        "CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colPriority INTEGER, $colDate TEXT)");
  }

  //Get all the note details from DB
  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await getDatabase;
    //both methods are correct to get the data
    // var result = await db.rawQuery("SELECT * FROM $noteTable ORDER BY $colPriority ASC");
    var result = await db.query(noteTable, orderBy: "$colPriority ASC");
    return result;
  }

  //Insert data in database
  Future<int> insertNote(Notes noteDetails) async {
    Database db = await getDatabase;
    var result = db.insert(noteTable, noteDetails.toMap());

    return result;
  }

  //update data in database
  Future<int> updateNotes(Notes noteDetails) async {
    Database db = await getDatabase;
    var result = db.update(noteTable, noteDetails.toMap(),
        where: "$colId=?", whereArgs: [noteDetails.id]);
    return result;
  }

  //delete data from database
  Future<int> deleteNotes(int id) async {
    Database db = await getDatabase;
    int result = await db.delete(noteTable, where: "$colId=?", whereArgs: [id]);
    // int result = await db.rawDelete("DELETE FROM $noteTable WHERE $colId=$id");

    return result;
  }

  //get number of note object in database
  Future<int> getCount() async {
    Database db = await getDatabase;
    List<Map<String, dynamic>> x =
        await db.rawQuery("SELECT COUNT (*) FROM $noteTable");
    int result = Sqflite.firstIntValue(x) ?? 0;
    return result;
  }

  ///convert List<Map> into List<Notes>
  Future<List<Notes>> getNoteList() async {
    var noteListModel = await getNoteMapList();
    List<Notes> noteList = <Notes>[];
    for (int i = 0; i < noteListModel.length; i++) {
      noteList.add(Notes.fromMap(noteListModel[i]));
    }
    return noteList;
  }
}
