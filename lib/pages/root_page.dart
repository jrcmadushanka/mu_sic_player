import 'package:Mu_Player/widgets/album_list.dart';
import '../pages/now_playing.dart';
import '../widgets/mp_inherited.dart';
import '../widgets/mp_lisview.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';
import './main_drawer.dart';
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



    //Shuffle Songs and goto now playing page
    void shuffleSongs() {
      goToNowPlaying(rootIW.songData.randomSong);
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Mu Player"),
        backgroundColor: Colors.black,
        bottom: new TabBar(controller: rootIW.controller, tabs: <Tab>[
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
                        rootIW.songData.songs[
                            (rootIW.songData.currentIndex == null ||
                                    rootIW.songData.currentIndex < 0)
                                ? 0
                                : rootIW.songData.currentIndex],
                        nowPlayTap: true,
                      )),
            ),
          )
        ],
      ),
      drawer: MainDrawer(),

      // drawer: new MPDrawer(),
      body: new TabBarView(
        controller: rootIW.controller,
        children: <Widget>[
          rootIW.isLoading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new MPListView()),
          rootIW.isLoading
              ? new Center(child: new CircularProgressIndicator())
              : new Scrollbar(child: new AlbumList())
        ],
      ),
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.shuffle), onPressed: () => shuffleSongs()),
    );
  }
}
