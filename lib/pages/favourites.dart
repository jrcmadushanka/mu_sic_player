import 'dart:io';
import '../data/song_data.dart';
import '../pages/now_playing.dart';
import '../widgets/mp_inherited.dart';
import '../data/globals.dart' as globals;
import 'package:flutter/material.dart';

class Favourites extends StatelessWidget {
  final SongData songData;
  final List<MaterialColor> _colors = Colors.primaries;

  Favourites(this.songData);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Favourites",
            style: TextStyle(color: Colors.purple),
          ),
          backgroundColor: Colors.black,

        ),
        body: ListView.builder(


      itemCount:songData.songs.length,
      itemBuilder: (context, int index) {
        var s = songData.songs[index];
        final MaterialColor color = _colors[index % _colors.length];
        var artFile =
            s.albumArt == null ? null : new File.fromUri(Uri.parse(s.albumArt));

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
                        Icons.music_note,
                        color: Colors.white,
                      ),
                      backgroundColor: color,
                    ),
            ),
            tag: s.title,
          ),
          title: new Text(s.title),
          subtitle: new Text(
            "${s.artist != '<unknown>' ? "by" + s.artist : ""}",
            style: Theme.of(context).textTheme.caption,
          ),
          onTap: () {
            songData.setCurrentIndex(index);
            globals.currentSong = s;
            Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => new NowPlaying(songData, s)));
          },
        );
      },
    ));
  }
}
