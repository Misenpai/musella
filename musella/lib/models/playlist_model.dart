import 'package:flutter/foundation.dart';
import 'package:musella/models/playlist_play.dart';

class PlaylistModel {
  String name;
  List<PlaylistPlayModel> songs;
  String imageUrl;

  PlaylistModel(
      {required this.name, this.songs = const [], required this.imageUrl});
}

class PlaylistsModel extends ChangeNotifier {
  final List<PlaylistModel> _playlists = [];

  List<PlaylistModel> get playlists => _playlists;

  void addPlaylist(PlaylistModel playlist) {
    _playlists.add(playlist);
    notifyListeners();
  }

  void removePlaylist(int index) {
    _playlists.removeAt(index);
    notifyListeners();
  }
}
