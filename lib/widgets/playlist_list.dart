import 'dart:io';
import '../models/Playlist.dart';
import '../database/database_provider.dart';
import '../data/album.dart';
import '../pages/create_playlist.dart';
import '../pages/now_playing.dart';
import '../data/song_data.dart';
import '../widgets/mp_inherited.dart';
import '../data/globals.dart' as globals;
import 'package:flutter/material.dart';

class PlaylistList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PlaylistItems();
  }
}

class PlaylistItems extends StatefulWidget{
  @override
  PlaylistItemsState createState() => PlaylistItemsState();
}

class PlaylistItemsState extends State<PlaylistItems>{
  final List<MaterialColor> _colors = Colors.primaries;
  final _formKey = GlobalKey<FormState>();
  List<Playlist> playlistList;

 @override
  void initState(){
    super.initState();
    print("Calling init");
    initPlatformState();
  }

  _onBack() async {
    initPlatformState();
    print("Calling on back");
  }

  initPlatformState() async {
    print("Getting songs ");
    List<Playlist> list;
    try {
      list = await DataBaseProvider.db.getPlaylists();
    } catch (e) {
      print("Failed to get albums: '${e.message}'.");
      list = [];
    }

    setState(() {
      playlistList = list;
      print(list);
    });
  }


  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);

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
                                      //Navigator.pop(context);
                                      Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (_) =>
                                              new CreatePlaylist(
                                                  newPlaylistName,
                                                  rootIW.songData))).then((val)=>{initPlatformState()});
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
      Expanded(
          child: new ListView.builder(
            shrinkWrap: true,
            addRepaintBoundaries: true,
            itemCount: playlistList.length,
            itemBuilder: (context, int index) {
              var album = playlistList[index];
              final MaterialColor color = _colors[index % _colors.length];
              return new ListTile(
                dense: false,
                leading: new Material(
                    borderRadius: new BorderRadius.circular(20.0),
                    elevation: 3.0,
                    child:  new CircleAvatar(
                      child: new Icon(
                        Icons.library_music,
                        color: Colors.white,
                      ),
                      backgroundColor: color,
                    ),
                  ),
                title: new Text(album.name),
                subtitle: new Text(
                  "${album.songs.length} Songs",
                  style: Theme.of(context).textTheme.caption,
                ),
                onTap: () {
                  //SongData songData = new SongData(album.songs);
                  /*songData.setCurrentIndex(0);
                  globals.currentSong = songData.songs[0];
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                          new NowPlaying(songData, globals.currentSong)));*/
                },
              );
            },
          ))
    ]);
  }

}
