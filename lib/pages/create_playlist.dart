import 'dart:io';
import '../models/Playlist.dart';
import '../database/database_provider.dart';
import '../data/song_data.dart';
import 'package:flutter/material.dart';

class SongList extends StatefulWidget {
  final String name;
  final SongData songData;
  final Playlist playlist;

  SongList(this.name, this.songData, this.playlist);

  @override
  SongListState createState() => SongListState(name, songData, playlist);
}

class SongListState extends State<SongList> {
  final String name;
  final SongData songData;
  final List<MaterialColor> _colors = Colors.primaries;
  final Playlist playlist;
  List<int> selectedSongs = [];

  SongListState(this.name, this.songData, this.playlist);

  @override
  void initState() {
    super.initState();

    if (playlist != null) {
      selectedSongs = playlist.songs;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: new FloatingActionButton(
          onPressed: createPlayList,
          backgroundColor: Colors.black,
          child: new Icon(Icons.done_all, size: 30, color: Colors.purple),
        ),
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text(
            'Select Songs to $name Playlist',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        body: Material(
            child: new ListView.builder(
            itemCount: songData.songs.length,
            itemBuilder: (context, int index) {
              var s = songData.songs[index];
              final MaterialColor color = _colors[index % _colors.length];
              var artFile = s.albumArt == null
                  ? null
                  : new File.fromUri(Uri.parse(s.albumArt));

            return new ListTileTheme(
                dense: false,
                child: new ListTile(
                  leading: new Material(
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
                  title: new Text(s.title),
                  subtitle: new Text(
                    "${s.artist != '<unknown>' ? "by" + s.artist : ""}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  trailing: selectedSongs.contains(s.id)
                      ? Icon(
                          Icons.check_circle,
                          color: Colors.lightGreen,
                        )
                      : Icon(Icons.check_circle),
                  onTap: () {
                    setState(() {
                      if (selectedSongs.contains(s.id)) {
                        selectedSongs.remove(s.id);
                      } else {
                        selectedSongs.add(s.id);
                      }
                    });
                  },
                ));
          },
        )));
  }

  void createPlayList() async {
    if (playlist != null) {
      playlist.songs = selectedSongs;
      await DataBaseProvider.db.updatePlaylist(playlist);
    } else {
      Playlist playlist =
          new Playlist(id: null, name: name, songs: selectedSongs);

      await DataBaseProvider.db.insertPlaylist(playlist);
    }
    Navigator.pop(context);
  }
}
