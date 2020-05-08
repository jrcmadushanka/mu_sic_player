// Student ID : IT17037266
// Name : J.R.C. Madushanka
// Root page with tab view

import '../widgets/album_list.dart';
import '../widgets/playlist_list.dart';
import 'package:flutter/cupertino.dart';
import '../pages/now_playing.dart';
import '../widgets/mp_inherited.dart';
import '../widgets/song_list.dart';
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
        // Initializing Tab bar
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
        // Tab bar controller created from the main page
        controller: rootIW.controller,
        // Page list for the tab view
        children: <Widget>[
          rootIW.isLoading // Showing a progress bar until song data is loading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new SongListView()),
          rootIW.isLoading // Showing a progress bar until album data is loading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new AlbumList()),
          rootIW.isLoading // Showing a progress bar until playlist data is loading
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
