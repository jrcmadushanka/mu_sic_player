import 'package:Mu_Player/widgets/album_list.dart';
import '../pages/now_playing.dart';
import '../widgets/mp_inherited.dart';
import '../widgets/mp_lisview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import './main_drawer.dart';
import '../data/globals.dart' as globals;

class Favourites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final rootIWX = MPInheritedWidget.of(context);
    //Goto Now Playing Page
    void goToNowPlaying(Song s, {bool nowPlayTap: false}) {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new NowPlaying(
                rootIWX.songData,
                globals.currentSong,
                nowPlayTap: nowPlayTap,
              )));
    }



    //Shuffle Songs and goto now playing page
    void shuffleSongs() {
      goToNowPlaying(rootIWX.songData.randomSong);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mu Player"),
        backgroundColor: Colors.black,
        bottom: new TabBar(controller: rootIWX.controller, tabs: <Tab>[
          new Tab(icon: new Icon(Icons.music_note, color: Colors.purple)),
          new Tab(icon: new Icon(Icons.library_music, color: Colors.purple))
        ]),
        actions: <Widget>[
          new Container(
            padding: const EdgeInsets.all(20.0),
            child: new Center(
              child: new InkWell(
                  child: new Text("Now Playing"),
                  onTap: () => goToNowPlaying(
                    rootIWX.songData.songs[
                    (rootIWX.songData.currentIndex == null ||
                        rootIWX.songData.currentIndex < 0)
                        ? 0
                        : rootIWX.songData.currentIndex],
                    nowPlayTap: true,
                  )),
            ),
          )
        ],
      ),
      drawer: MainDrawer(),

      // drawer: new MPDrawer(),
      body: new TabBarView(
        controller: rootIWX.controller,
        children: <Widget>[
          rootIWX.isLoading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new MPListView()),
          rootIWX.isLoading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new AlbumList())
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.shuffle), onPressed: () => shuffleSongs()),
    );
  }
}
