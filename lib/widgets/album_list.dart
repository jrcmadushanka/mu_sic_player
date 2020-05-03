import 'dart:io';
import '../data/album.dart';
import '../pages/now_playing.dart';
import '../data/song_data.dart';
import '../widgets/mp_inherited.dart';
import '../data/globals.dart' as globals;
import 'package:flutter/material.dart';

class AlbumList extends StatelessWidget {
  final List<MaterialColor> _colors = Colors.primaries;

  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);
    List<Album> albums = rootIW.songData.albums;

    return new ListView.builder(
      itemCount: albums.length,
      itemBuilder: (context, int index) {
        var album = albums[index];
        final MaterialColor color = _colors[index % _colors.length];
        var artFile = album.albumArt == null
            ? null
            : new File.fromUri(Uri.parse(album.albumArt));

        return new ListTile(
          dense: false,
          leading: new Hero(
            child: new Material(
              borderRadius: new BorderRadius.circular(20.0),
              elevation: 3.0,
              child: artFile != null
                  ? new Image.file(
                      artFile,
                      fit: BoxFit.cover,
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
            "${album.songs.length} Songs ${album.artist != '<unknown>' ? "by" + album.artist : ""}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            SongData songData = new SongData(album.songs);
            songData.setCurrentIndex(0);
            globals.currentSong = songData.songs[0];
            Navigator.push(
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
