import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musella/models/playlist_play.dart';

class PlaylistUserOperations {
  PlaylistUserOperations._();

  static List<PlaylistPlayModel> _songList = [];

  static Future<void> addSongDetails(
    String imagePath,
    String title,
    String artistname,
    String audioURL,
  ) async {
    final song = PlaylistPlayModel(imagePath, title, artistname, audioURL);
    _songList.insert(0, song);
    await _saveToPrefs();
  }

  static List<PlaylistPlayModel> getPlaylistSongList() {
    return List.from(_songList);
  }

  static Future<void> loadPlaylistSongList() async {
    final prefs = await SharedPreferences.getInstance();
    String? songListStr = prefs.getString('songList');
    if (songListStr != null) {
      Iterable l = json.decode(songListStr);
      _songList.clear();
      _songList.addAll(List<PlaylistPlayModel>.from(
          l.map((model) => PlaylistPlayModel.fromJson(model))));
    }
  }

  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String songListStr = json.encode(_songList.map((e) => e.toJson()).toList());
    await prefs.setString('songList', songListStr);
  }
}
