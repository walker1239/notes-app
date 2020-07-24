import 'dart:async';
import 'dart:io';
import 'package:clinicapp/data/notes.dart';
import 'package:clinicapp/data/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseNotes {
  DatabaseNotes._();
  static final DatabaseNotes db = DatabaseNotes._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "bath.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute("""CREATE TABLE Notes (
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            realized TEXT
          )""");
        await db.execute("""
          CREATE TABLE User (
            id INTEGER PRIMARY KEY,
            email TEXT,
            api TEXT
          )""");
      }
    );
  }
  
  newUser(User newUser) async {
    final db = await database;
    var result = await db.rawQuery("SELECT * FROM User WHERE id=1");
    if(!result.isNotEmpty){
      var raw = await db.rawInsert(
        "INSERT Into User (id,email,api)"
        " VALUES (?,?,?)",
        [1,newUser.userEmail,newUser.userApi]);
      return raw;
    }
    else{
      User blocked = User(
        userEmail: newUser.userEmail,
        userApi: newUser.userApi
      );
      var resp = await db.update("User", blocked.toMap(),
          where: "id = 1");
      return resp;
    }
  }

  getUser() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM User WHERE id=1");
    return res.isNotEmpty ? User.fromMap(res.first) : null;
  }

  deleteUser() async {
    final db = await database;
    await db.delete(
      'User',
      where: "id = ?",
      whereArgs: [1],
    );
  }

  newNote(Notes newNote) async {
    final db = await database;
    var raw = await db.rawInsert(
      "INSERT Into Notes (id,title,description,realized)"
      " VALUES (?,?,?,?)",
      [newNote.idNote,newNote.title,newNote.description,newNote.realized]);
    return raw;
  }

  getNotes() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Notes");
    List<Notes> list =
        res.isNotEmpty ? res.map((c) => Notes.fromMap(c)).toList() : [];
    return list;
  }

  deleteNote(int id) async {
    final db = await database;
    await db.delete(
      'Notes',
      where: "id = ?",
      whereArgs: [id],
    );
  }
  
  deleteNotes() async {
    final db = await database;
    final raw = await db.rawDelete('DELETE FROM Notes');
    return raw;
  }

  updateNote(Notes newNote) async {
    final db = await database;
    var res = await db.update("User", newNote.toMap(),
        where: "id = ?", whereArgs: [newNote.idNote]);
    return res;
  }
}