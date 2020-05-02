import 'package:Mu_Player/data/album.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'globals.dart' as globals;
import 'dart:math';

class SongData {
  List<Song> _songs;
  Map<int,Album> _albums = new Map();
  int _currentSongIndex = -1;
  MusicFinder musicFinder;
  SongData(this._songs) {
    musicFinder = new MusicFinder();
    globals.firstSong = _songs[0];
  }

  List<Song> get songs => _songs;
  List<Album> get albums {

    for(var song in this._songs) {
      if (!_albums.containsKey(song.albumId)) {
        _albums[song.albumId] =(new Album(song.album, song.albumArt, song.artist, song.albumId));
      }
      _albums[song.albumId].addSong(song);
    }

    List<Album> albumList = [];
    _albums.forEach((k, v) => albumList.add(v));
    return albumList;
  }

  int get length => _songs.length;
  int get songNumber => _currentSongIndex + 1;

  setCurrentIndex(int index) {
    _currentSongIndex = index;
  }

  int get currentIndex => _currentSongIndex;

  Song get nextSong {
    if (_currentSongIndex < length) {
      _currentSongIndex++;
    }
    if (_currentSongIndex >= length) return null;
    return _songs[_currentSongIndex];
  }

  Song get randomSong {
    Random r = new Random();
    return _songs[r.nextInt(_songs.length)];
  }

  Song get prevSong {
    if (_currentSongIndex > 0) {
      _currentSongIndex--;
    }
    if (_currentSongIndex < 0) return null;
    return _songs[_currentSongIndex];
  }

  MusicFinder get audioPlayer => musicFinder;
}
