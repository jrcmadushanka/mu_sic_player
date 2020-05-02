import 'package:Mu_Player/models/Playlist.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DataBaseProvider {

  static const String DATABASE = "mu_player.db";
  static const String TABLE_PLAYLIST = "playlist";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_SONGS = "songs";

  DataBaseProvider._();

  Future<Database> get database async{
    return openDatabase(
      join(await getDatabasesPath(), DATABASE),
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE playlists(id INTEGER PRIMARY KEY, name TEXT, songs BLOB)",
          );
        },
      version: 1
    );
  }

  Future<List<Playlist>> getPlaylists() async {
    final db = await database;
    var playlists = await db.query(TABLE_PLAYLIST, columns: [COLUMN_ID, COLUMN_NAME, COLUMN_SONGS ]);

    List<Playlist> playlistList = List<Playlist>();

    playlists.forEach((currentPlaylist) {
      playlistList.add(Playlist.fromMap(currentPlaylist));
    });

    return playlistList;
  }

  Future<Playlist> insert(Playlist playlist) async {
    final db = await database;
    playlist.id = await db.insert(TABLE_PLAYLIST, playlist.toMap());
    return playlist;
  }

}