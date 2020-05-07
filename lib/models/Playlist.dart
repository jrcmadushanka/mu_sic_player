import '../database/database_provider.dart';
// Database model for playlists

class Playlist {
   int id; // Playlist id
   String name; // Playlist name
   List<int> songs; // Song id list of the the playlist

  Playlist({this.id, this.name, this.songs});

  // Mapping playlist object data
  Map<String, dynamic> toMap(){
    var map = <String, dynamic> {
      DataBaseProvider.COLUMN_NAME: name,
      // Converting song id list to a comma separated string
      DataBaseProvider.COLUMN_SONGS: songs.join(',')
    };

    // Checking if the id is null before assigning it since the newly
    // created objects doesn't contain a id
    if (id != null) {
      map[DataBaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  // Converting data base map to a playlist object
  Playlist.fromMap( Map<String, dynamic> map){
    id = map[DataBaseProvider.COLUMN_ID];
    name = map[DataBaseProvider.COLUMN_NAME];
    // Converting comma separated song id list to string array
    List<String> idStrings = map[DataBaseProvider.COLUMN_SONGS].split(",");
    List<int> ids = [];
    // Parsing integer song ids from the string array
    idStrings.forEach((sid) => {
      ids.add(int.tryParse(sid))
    });
    songs = ids;
  }
}
