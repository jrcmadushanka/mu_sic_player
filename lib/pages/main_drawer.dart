
import 'package:flute_music_player/flute_music_player.dart';
import 'package:mu_player/data/song_data.dart';
import '../database/Fav_db.dart';
import '../models/Fav_model.dart';
import '../pages/favourites.dart';
import 'package:flutter/material.dart';
import '../models/Playlist.dart';

class MainDrawer extends StatelessWidget {
  final SongData songData;

   MainDrawer(this.songData);


  @override
  Widget build(BuildContext context){
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 20,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/music_record.png'),
                        fit: BoxFit.fill

                      )
                    ),
                  ),
                  Text(
                    'MU Player',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.all(20),
            leading: Icon(Icons.favorite),
            title: Text(
              'Favourites',
              style: TextStyle(
                fontSize: 20
              ),
            ),
            onTap: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favourites(songData),
                ));
            },
          ),
        ],
      ),

    );
  }
}