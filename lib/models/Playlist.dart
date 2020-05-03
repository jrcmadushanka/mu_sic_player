import 'dart:typed_data';

import '../database/database_provider.dart';

class Playlist {
   int id;
   String name;
   List<int> songs;

  Playlist({this.id, this.name, this.songs});

  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      DataBaseProvider.COLUMN_NAME: name,
      DataBaseProvider.COLUMN_SONGS: Uint8List.fromList(songs),
    };

    if (id != null) {
      map[DataBaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  Playlist.fromMap( Map<String, dynamic> map){
    id = map[DataBaseProvider.COLUMN_ID];
    name = map[DataBaseProvider.COLUMN_NAME];
    songs = new List.from(map[DataBaseProvider.COLUMN_ID]);
  }
}
