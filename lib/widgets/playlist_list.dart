import 'dart:io';
import 'package:Mu_Player/data/album.dart';
import 'package:Mu_Player/pages/create_playlist.dart';
import 'package:Mu_Player/pages/now_playing.dart';
import '../data/song_data.dart';
import '../widgets/mp_inherited.dart';
import '../data/globals.dart' as globals;
import 'package:flutter/material.dart';

class PlaylistList extends StatelessWidget {
  final List<MaterialColor> _colors = Colors.primaries;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);
    List<Album> albums = rootIW.songData.albums;

    return Column(children: <Widget>[
      new InkWell(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Icon(
                      Icons.queue,
                      color: Colors.purple,
                    )),
                new Text(
                  "Create a Playlist",
                  style: TextStyle(fontSize: 20, color: Colors.purple),
                  textAlign: TextAlign.center,
                )
              ]),
          onTap: () {
            var newPlaylistName = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: 'Enter paylist name',
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter a name for new play list';
                                    } else {
                                      newPlaylistName = value;
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Add Songs"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) => new CreatePlaylist(newPlaylistName)));
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Tap on background to close.",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 13),
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          }),
      new ListView.builder(
        shrinkWrap: true,
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
      )
    ]);
  }
}
