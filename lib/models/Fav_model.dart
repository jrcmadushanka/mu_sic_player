import '../database/database_provider.dart';
class Fav_model {
   int id;
   int song_id;


  Fav_model({this.id, this.song_id});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'song_id': song_id,
    };
  }

  // Implement toString to make it easier to see information about

  @override
  String toString() {
    return 'Fav_model{id: $id, song_id: $song_id}';
  }
}