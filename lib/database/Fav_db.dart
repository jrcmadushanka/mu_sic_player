

import '../models/Fav_model.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class FavouriteDB {
  static const String DATABASE = "Fav_Songs.db";

  static final FavouriteDB db = FavouriteDB._();

  FavouriteDB._();

  Future<Database> get database async {
    return openDatabase(join(await getDatabasesPath(), DATABASE),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE favourite(id INTEGER PRIMARY KEY, song_id INTEGER)" ,

          );

        }, version: 1);
  }


  Future<void> insertFav(Fav_model Fav_model) async {
    // Get a reference to the database.
    final Database db = await database;

    await db.insert(
      'favourite',
      Fav_model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Fav_model>> songs() async {
    // Get a reference to the database.
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('favourite');

    return List.generate(maps.length, (i) {
      return Fav_model(
        id: maps[i]['id'],
        song_id: maps[i]['song_id'],
      );
    });
  }

  Future<void> updateFav(Fav_model fav_model) async {
    // Get a reference to the database.
    final db = await database;

    await db.update(
      'favourite',
      fav_model.toMap(),

      where: "id = ?",

      whereArgs: [fav_model.id],
    );
  }

  Future<void> deleteFav(int id) async {
    // Get a reference to the database.
    final db = await database;


    await db.delete(
      'favourite',
      where: "id = ?",
      whereArgs: [id],
    );
  }






}
