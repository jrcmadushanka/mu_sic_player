import 'package:Mu_Player/widgets/album_list.dart';
import '../data/song_data.dart';
import 'package:flutter/material.dart';

class CreatePlaylist extends StatelessWidget {
  final String name;

  CreatePlaylist(this.name);

  @override
  Widget build(BuildContext context) {
  return new Scrollbar(child: AlbumList());
  }
}
