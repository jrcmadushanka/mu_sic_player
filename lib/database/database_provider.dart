// Student ID : IT17037266
// Name : J.R.C. Madushanka
//Data base provider to initiate the sqflite database connection and perform
// data base functionalities.

import '../models/Playlist.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DataBaseProvider {
  static const String DATABASE = "mu_player.db"; // Database name for the app
  static const String TABLE_PLAYLIST =
      "playlists"; // Table name for save playlists
  // Playlist table column names
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_SONGS = "songs";

  // Final database provider to access the data base
  static final DataBaseProvider db = DataBaseProvider._();

  DataBaseProvider._();

  // Getter function to initialize the database connection and tables
  Future<Database> get database async {
    //Using getDatabasesPath function from path.dart file to get the data
    // base path from the device
    return openDatabase(join(await getDatabasesPath(), DATABASE),
        onCreate: (db, version) {
      return db.execute(
        // Raw query for database creation. Using id field as the primary key
        "CREATE TABLE $TABLE_PLAYLIST($COLUMN_ID INTEGER PRIMARY KEY, $COLUMN_NAME TEXT, $COLUMN_SONGS String)",
      );
    }, version: 1); // Database version = 1 for the 1.0v of the Mu Player
  }

  // Function for return all the playlists from the DB
  Future<List<Playlist>> getPlaylists() async {
    final db = await database;
    var playlists = await db
        .query(TABLE_PLAYLIST, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_SONGS]);
    List<Playlist> playlistList = List<Playlist>();

    //Mapping the fetched data in to Playlist objects and create a list.
    playlists.forEach((currentPlaylist) {
      playlistList.add(Playlist.fromMap(currentPlaylist));
    });

    print(playlistList);
    return playlistList; // Returning mapped list of Playlists
  }

  // Function for insert new Playlists to the DB
  Future<Playlist> insertPlaylist(Playlist playlist) async {
    final db = await database;
    // Sqflite insert function for insert data to the DB
    // Using toMap function created in playlist model to create a map from the
    // Playlist Object
    playlist.id = await db.insert(TABLE_PLAYLIST, playlist.toMap());
    return playlist;
  }

  // Function to delete a playlist from the DB by the playlist id
  Future<void> deletePlaylist(int id) async {
    final db = await database;
    //Use Sqflite delete function with whereArgs property
    await db.delete(TABLE_PLAYLIST, where: COLUMN_ID + " = ?", whereArgs: [id]);
  }

  // Function to update a playlist.
  Future<void> updatePlaylist(Playlist playlist) async {
    final db = await database;
    // Using sqflite update function to update a existing record from the db
    await db.update(
      TABLE_PLAYLIST,
      playlist.toMap(), // Converting playlist object to a map
      where: COLUMN_ID + " = ?",
      whereArgs: [playlist.id], // Playlist id to update
    );
  }
}
