import '../data/song_data.dart';
import 'package:flutter/material.dart';

class MPInheritedWidget extends InheritedWidget {
  final SongData songData;
  final bool isLoading;
  final TabController controller;

  const MPInheritedWidget(this.songData, this.isLoading, this.controller , child)
      : super(child: child);

  static MPInheritedWidget of(BuildContext context) {
    // ignore: deprecated_member_use
    return context.inheritFromWidgetOfExactType(MPInheritedWidget);
  }

  @override
  bool updateShouldNotify(MPInheritedWidget oldWidget) =>
      // TODO: implement updateShouldNotify
      songData != oldWidget.songData || isLoading != oldWidget.isLoading;
}
