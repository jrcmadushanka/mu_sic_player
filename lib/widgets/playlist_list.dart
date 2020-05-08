// Student ID : IT17037266
// Name : J.R.C. Madushanka
// List all the playlists

import 'package:flute_music_player/flute_music_player.dart';
import '../models/Playlist.dart';
import '../database/database_provider.dart';
import '../pages/create_playlist.dart';
import '../pages/now_playing.dart';
import '../data/song_data.dart';
import '../widgets/mp_inherited.dart';
import '../data/globals.dart' as globals;
import 'package:flutter/material.dart';

// Playlist displaying page under tab view
class PlaylistList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PlaylistItems();
  }
}

class PlaylistItems extends StatefulWidget {
  @override
  PlaylistItemsState createState() => PlaylistItemsState();
}

class PlaylistItemsState extends State<PlaylistItems> {
  final List<MaterialColor> _colors =
      Colors.primaries; // Color list for playlist icons
  final _formKey = GlobalKey<
      FormState>(); // creating global key for forms to use for validations
  List<Playlist> playlistList;
  MPInheritedWidget rootIW;

  @override
  void initState() {
    super.initState();
    print("Calling init");
    initPlatformState(); // Initializing page
  }

  initPlatformState() async {
    print("Getting playlist ");
    List<Playlist> list = [];
    try {
      // Fetching playlist from DB
      list = await DataBaseProvider.db.getPlaylists();
    } catch (e) {
      // Print error to console in case of failure to fetch playlist
      print("Failed to get playlist: '${e.message}'.");
    }

    //Updating states after fetching the db
    setState(() {
      playlistList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    rootIW = MPInheritedWidget.of(context);
    return Column(children: <Widget>[
      new InkWell(
          // Button to navigate to crete play list page
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Create a Playlist",
                  style: TextStyle(fontSize: 20, color: Colors.purple),
                  textAlign: TextAlign.center,
                ),
                new CircleAvatar(
                    backgroundColor: Colors.white,
                    child: new Icon(
                      Icons.playlist_add,
                      color: Colors.purple,
                    ))
              ]),
          onTap: () {
            var newPlaylistName = "";
            showDialog(
                // Dialog box to prompt user to enter the new playlist name
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
                                    // Validating user inputs
                                    if (value.isEmpty) {
                                      // Return error message to display
                                      return 'Please enter a name for new play list';
                                    } else {
                                      // Setting playlist name if validation passed
                                      newPlaylistName = value;
                                      return null;
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  // Name submit button
                                  child: Text("Add Songs"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      //Check form validation status before navigate
                                      _formKey.currentState.save();
                                      Navigator.pop(
                                          context); // Close dialog box
                                      Navigator.of(
                                              context) // Navigate to playlist manager page
                                          .push(new MaterialPageRoute(
                                              builder: (_) =>
                                                  new PlaylistManager(
                                                      newPlaylistName,
                                                      rootIW.songData,
                                                      null)))
                                          // waiting for user to come back to update page states
                                          .then((val) => {initPlatformState()});
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                  // User instructions to close the dialog box
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
      playlistList ==
              null // Display a progress bar until playlist data is fetched from db
          ? new CircularProgressIndicator()
          : Expanded(
              child: new ListView.builder(
              shrinkWrap: true, // Adding shrink wrap to avoid content overflow
              addRepaintBoundaries: true,
              itemCount: playlistList.length,
              itemBuilder: (context, int index) {
                var playlist = playlistList[index]; // Getting playlist by index
                // Getting color from the color list for icon based on song index
                final MaterialColor color = _colors[index % _colors.length];
                return new ListTile(
                    dense: false,
                    leading: new Material(
                      borderRadius: new BorderRadius.circular(20.0),
                      elevation: 3.0,
                      child: new CircleAvatar(
                        child: new Icon(
                          Icons.queue_music,
                          color: Colors.white,
                        ),
                        backgroundColor: color,
                      ),
                    ),
                    title: new Text(playlist.name),
                    subtitle: new Text(
                      //Display number of songs per playlist
                      "${playlist.songs.length} Songs",
                      style: Theme.of(context).textTheme.caption,
                    ),
                    onTap: () {
                      // Getting all song data
                      List<Song> songData = rootIW.songData.songs;
                      List<Song> playlistSongs = [];
                      // Selecting songs from all songs that in playlist
                      songData.forEach((song) => {
                            //Creating Song object list from play list song ids
                            playlist.songs.contains(song.id)
                                ? playlistSongs.add(song)
                                : null
                          });

                      //Creating Song data object from filtered Song list
                      SongData data = new SongData(playlistSongs);
                      data.setCurrentIndex(
                          0); // Setting first song as current song
                      globals.currentSong =
                          data.songs[0]; // Updating global values
                      Navigator.push(
                          // Navigating to player
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  new NowPlaying(data, globals.currentSong)));
                    },
                    trailing: PopupMenuButton<String>(
                      // Popup menu to display playlist options
                      onSelected: (String result) {
                        popupAction(playlist,
                            result); // Calling to popup input action sorting function
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          //Popup item to edit playlist
                          value: "edit",
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: new Icon(
                                      Icons.edit,
                                      color: Colors.purple,
                                    )),
                                new Text(
                                  "Edit Playlist",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.purple),
                                  textAlign: TextAlign.center,
                                )
                              ]),
                        ),
                        PopupMenuItem<String>(
                          //Popup item to delete playlist
                          value: "delete",
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: new Icon(
                                      Icons.delete_sweep,
                                      color: Colors.purple,
                                    )),
                                new Text(
                                  "Delete Playlist",
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.purple),
                                  textAlign: TextAlign.center,
                                )
                              ]),
                        )
                      ],
                    ));
              },
            ))
    ]);
  }

  //Delete or navigate to update page based on user input
  void popupAction(Playlist playList, String action) {
    if (action == 'delete') {
      // Delete playlist by id
      DataBaseProvider.db.deletePlaylist(playList.id);
      initPlatformState();
    } else {
      // Navigate to update playlist page with data of current playlist
      Navigator.of(context)
          .push(new MaterialPageRoute(
              builder: (_) =>
                  new PlaylistManager(null, rootIW.songData, playList)))
          .then((val) => {
                initPlatformState()
              }); //Update widget states after returning to this page
    }
  }
}
