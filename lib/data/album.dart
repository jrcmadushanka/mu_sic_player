import 'package:flute_music_player/flute_music_player.dart';

class Album{
  var _id;
  var _name;
  var _artist;
  var _albumArt;
  List<Song> _songs = new List();

  Album(this._name, this._albumArt, this._artist, this._id);

  void addSong(Song song){
    _songs.add(song);
  }

  List<Song> getSongList(){
    return _songs;
  }

  int get id => _id;
  String get name => _name;
  String get artist => _artist;
  String get albumArt => _albumArt;
  List<Song> get songs => _songs;
}