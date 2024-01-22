import 'dart:convert';

import 'package:musella/models/music.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicOperations {
  MusicOperations._();

  static void addMusic(
      String imageURL, String title, String artist, String audioURL) async {
    final newMusic = Music(imageURL, title, artist, audioURL);

    // Check if the new music is already present in the list
    int existingIndex = _musicList.indexWhere((music) =>
        music.title == title &&
        music.artist == artist &&
        music.audioURL == audioURL);

    // If the music is already present, remove it
    if (existingIndex != -1) {
      _musicList.removeAt(existingIndex);
    }

    // Add the new music at the beginning of the list
    _musicList.insert(0, newMusic);

    // Trim the list if it exceeds the maximum allowed size
    if (_musicList.length > 7) {
      _musicList.removeLast();
    }
    await _saveToPrefs();
  }

  static final List<Music> _musicList = [];

  static List<Music> getMusicList() {
    List<Music> result = List.from(_musicList);
    return result;
  }

  static Future<void> loadMusicList() async {
    final prefs = await SharedPreferences.getInstance();
    String? musicListStr = prefs.getString('musicList');
    if (musicListStr != null) {
      Iterable l = json.decode(musicListStr);
      _musicList.clear();
      _musicList
          .addAll(List<Music>.from(l.map((model) => Music.fromJson(model))));
    }
  }

  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String artistListStr =
        json.encode(_musicList.map((e) => e.toJson()).toList());
    await prefs.setString('musicList', artistListStr);
  }
}
