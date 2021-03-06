import './data/song_data.dart';
import './pages/root_page.dart';
import './pages/favourites.dart';
import './widgets/mp_inherited.dart';
import 'package:flute_music_player/flute_music_player.dart';
import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  SongData songData;
  bool _isLoading = true;
  TabController controller;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    songData.audioPlayer.stop();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    _isLoading = true;

    var songs;
    try {
      songs = await MusicFinder.allSongs();
    } catch (e) {
      print("Failed to get songs: '${e.message}'.");
    }

    if (!mounted) return;

    setState(() {
      songData = new SongData((songs));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MPInheritedWidget(songData, _isLoading, controller, new RootPage());
  }

}
