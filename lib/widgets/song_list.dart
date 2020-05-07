import 'dart:io';
import '../data/song_data.dart';
import '../pages/now_playing.dart';
import '../widgets/mp_inherited.dart';
import '../data/globals.dart' as globals;
import 'package:flutter/material.dart';

class SongListView extends StatelessWidget {
  // Color list for playlist icons
  final List<MaterialColor> _colors = Colors.primaries;
  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);// Getting context from inherited widgets
    SongData songData = rootIW.songData; // Getting all songs
    return new ListView.builder(
      itemCount: songData.songs.length,
      itemBuilder: (context, int index) {
        var song = songData.songs[index];
        final MaterialColor iconColor = _colors[index % _colors.length];
        var albumArt =
            song.albumArt == null ? null : new File.fromUri(Uri.parse(song.albumArt));

        return new ListTile(
          dense: false,
          leading: new Hero( // Creating hero object to display as album art and on the music player
            child: new Material(
              borderRadius: new BorderRadius.circular(20.0),
              elevation: 3.0,
              // Display colored icon if album art is not present
              child: albumArt != null
                  ? new Image.file(
                albumArt,
                fit: BoxFit.cover,
                width: 40,
              )
                  : new CircleAvatar(
                child: new Icon(
                  Icons.music_note,
                  color: Colors.white,
                ),
                backgroundColor: iconColor,
              ),
            ),
            tag: song.title,
          ),
          title: new Text(song.title),
          subtitle: new Text(
            // Hide song artist unknown label returned from flute_player
            // API if artist name is not present
            "${song.artist != '<unknown>' ? "by" + song.artist : ""}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            songData.setCurrentIndex(index); // Setting selected song index as current song
            globals.currentSong = song; // Updating global values
            Navigator.push( // Navigate to now player
                context,
                new MaterialPageRoute(
                    builder: (context) => new NowPlaying(songData, song)));
          },
        );
      },
    );
  }
}
