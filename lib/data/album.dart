import 'package:flute_music_player/flute_music_player.dart';
// Data model for Albums. This contains mapped album data from the song data

class Album{
  var _id; // Album id
  var _name; // Album name
  var _artist; // Artist of the album
  var _albumArt; // Path to the album art image file
  List<Song> _songs = new List(); // List of song objects

  Album(this._name, this._albumArt, this._artist, this._id);

  // Function to add song to a album.
  void addSong(Song song){
    // Check if the song is already in the album to prevent duplicating of songs
    if (!_songs.contains(song)) {
      _songs.add(song);
    }
  }

  // Function to get list of songs
  List<Song> getSongList(){
    return _songs;
  }

  // Getters for album variables
  int get id => _id;
  String get name => _name;
  String get artist => _artist;
  String get albumArt => _albumArt;
  List<Song> get songs => _songs;
}