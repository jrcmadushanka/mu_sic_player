import 'dart:io';
import '../models/Playlist.dart';
import '../database/database_provider.dart';
import '../data/song_data.dart';
import 'package:flutter/material.dart';

// Playlist creating and updating page
class PlaylistManager extends StatefulWidget {
  final String name; // Playlist names
  final SongData songData; // All song data from the device
  final Playlist
      playlist; // Playlist object if updating, otherwise this should be null

  PlaylistManager(this.name, this.songData, this.playlist);

  @override
  PlaylistManagerState createState() =>
      PlaylistManagerState(name, songData, playlist);
}

// State for playlist manager
class PlaylistManagerState extends State<PlaylistManager> {
  final SongData songData;
  final List<MaterialColor> _colors =
      Colors.primaries; // Color list for playlist icons
  final Playlist playlist;
  String name;
  List<int> selectedSongs = []; // Store selected song ids

  PlaylistManagerState(this.name, this.songData, this.playlist);

  @override
  void initState() {
    super.initState();

    //Setting current playlist songs and name if updating
    if (playlist != null) {
      selectedSongs = playlist.songs;
      name = playlist.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        // Floating button to save the selected playlist
        floatingActionButton: new FloatingActionButton(
          onPressed: createPlayList,
          backgroundColor: Colors.black,
          child: new Icon(Icons.done_all, size: 30, color: Colors.purple),
        ),
        appBar: new AppBar(
          backgroundColor: Colors.black,
          title: new Text(
            // Setting app bar title with current playlist
            'Select Songs to $name Playlist',
            style: TextStyle(color: Colors.purple),
          ),
        ),
        body: Material(
            // Creating a list view from all songs
            child: new ListView.builder(
          itemCount: songData.songs.length,
          itemBuilder: (context, int index) {
            var song = songData.songs[index];
            // Getting color from the color list for icon based on song index
            final MaterialColor iconColor = _colors[index % _colors.length];

            // Get the album art image for a song
            var albumArt = song.albumArt == null
                ? null
                : new File.fromUri(Uri.parse(song.albumArt));

            return new ListTileTheme(
                dense: false,
                // List item for a single song
                child: new ListTile(
                  leading: new Material(
                    borderRadius: new BorderRadius.circular(20.0),
                    elevation: 3.0,
                    // Display colored icon if album art is not present
                    child: albumArt != null
                        ? new Image.file(
                            albumArt,
                            fit: BoxFit.cover,
                          )
                        : new CircleAvatar(
                            child: new Icon(
                              Icons.music_note,
                              color: Colors.white,
                            ),
                            backgroundColor: iconColor,
                          ),
                  ),
                  title: new Text(song.title),
                  subtitle: new Text(
                    // Hide song artist unknown label returned from flute_player
                    // API if artist name is not present
                    "${song.artist != '<unknown>' ? "by" + song.artist : ""}",
                    style: Theme.of(context).textTheme.caption,
                  ),
                  trailing:
                      // Song selected indicator.
                      // Check if a song is already added to the playlist.
                      // Change icon color to green if the song is selected
                      selectedSongs.contains(song.id)
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.lightGreen,
                            )
                          : Icon(Icons.check_circle),
                  onTap: () {
                    // Select or deselect a song on tap
                    setState(() {
                      if (selectedSongs.contains(song.id)) {
                        // Check if song is already added
                        selectedSongs.remove(song.id);
                      } else {
                        selectedSongs
                            .add(song.id); // Add the song if it's not selected
                      }
                    });
                  },
                ));
          },
        )));
  }

  // Create a new playlist entry of update the existing on user submit
  void createPlayList() async {
    //Update the playlist if current playlist is present
    if (playlist != null) {
      //setting newly selected song data to existing one
      playlist.songs = selectedSongs;

      await DataBaseProvider.db.updatePlaylist(playlist);
    } else {
      // Creating new Playlist object
      Playlist playlist =
          new Playlist(id: null, name: name, songs: selectedSongs);

      await DataBaseProvider.db.insertPlaylist(playlist);
    }
    Navigator.pop(context); // Navigate back to playlist tab
  }
}
