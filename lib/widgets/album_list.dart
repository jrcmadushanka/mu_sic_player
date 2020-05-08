// Student ID : IT17037266
// Name : J.R.C. Madushanka
// List all the albums
import 'dart:io';
import '../data/album.dart';
import '../pages/now_playing.dart';
import '../data/song_data.dart';
import '../widgets/mp_inherited.dart';
import '../data/globals.dart' as globals;
import 'package:flutter/material.dart';

class AlbumList extends StatelessWidget {
  final List<MaterialColor> _colors =
      Colors.primaries; // Color list for album icons

  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);
    List<Album> albums =
        rootIW.songData.albums; // Getting albums from inherited widget

    return new ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, int index) {
        var album = albums[index];
        // Getting color from the color list for icon based on song index
        final MaterialColor color = _colors[index % _colors.length];
        // Getting album art image
        var albumArt = album.albumArt == null
            ? null
            : new File.fromUri(Uri.parse(album.albumArt));

        return new ListTile(
          dense: false,
          leading: new Hero(
            // Creating hero object to display as album art and on the music player
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
                        Icons.library_music,
                        color: Colors.white,
                      ),
                      backgroundColor: color,
                    ),
            ),
            tag: album.id,
          ),
          title: new Text(album.name),
          subtitle: new Text(
            //Display song count of the playlist and artist
            // Hide song artist unknown label returned from flute_player
            // API if artist name is not present
            "${album.songs.length} Songs ${album.artist != '<unknown>' ? "by" + album.artist : ""}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            // Create a Song data object to feed the player
            SongData songData = new SongData(album.songs);
            songData
                .setCurrentIndex(0); // setting current song to the first one
            globals.currentSong = songData.songs[0]; // setting global variables
            Navigator.push(
                // Navigate to player
                context,
                new MaterialPageRoute(
                    builder: (context) =>
                        new NowPlaying(songData, globals.currentSong)));
          },
        );
      },
    );
  }
}
