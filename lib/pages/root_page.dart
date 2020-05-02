import 'package:Mu_Player/widgets/album_list.dart';
import 'package:Mu_Player/widgets/playlist_list.dart';
import 'package:flutter/cupertino.dart';
import '../pages/now_playing.dart';
import '../widgets/mp_inherited.dart';
import '../widgets/mp_lisview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import '../data/globals.dart' as globals;

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rootIW = MPInheritedWidget.of(context);

    //Goto Now Playing Page
    void goToNowPlaying(Song s, {bool nowPlayTap: false}) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new NowPlaying(
                    rootIW.songData,
                    globals.currentSong,
                    nowPlayTap: nowPlayTap,
                  )));
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          "Mu Player",
          style: TextStyle(color: Colors.purple),
        ),
        backgroundColor: Colors.black,
        bottom: new TabBar(controller: rootIW.controller, tabs: <Tab>[
          new Tab(
              icon: new Icon(Icons.music_note, color: Colors.purple),
              child: new Text("Songs")),
          new Tab(
              icon: new Icon(Icons.library_music, color: Colors.purple),
              child: new Text("Albums")),
          new Tab(
              icon: new Icon(Icons.queue_music, color: Colors.purple),
              child: new Text("Playlists"))
        ]),
      ),
      // drawer: new MPDrawer(),
      body: new TabBarView(
        controller: rootIW.controller,
        children: <Widget>[
          rootIW.isLoading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new MPListView()),
          rootIW.isLoading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new AlbumList()),
          rootIW.isLoading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new PlaylistList())
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.play_arrow), backgroundColor: Colors.purple,
          onPressed: () => goToNowPlaying(
                rootIW.songData.songs[(rootIW.songData.currentIndex == null ||
                        rootIW.songData.currentIndex < 0)
                    ? 0
                    : rootIW.songData.currentIndex],
                nowPlayTap: true,
              )),
    );
  }
}
