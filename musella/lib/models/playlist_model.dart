import 'package:flutter/foundation.dart';
import 'package:musella/models/playlist_play.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PlaylistModel {
  String name;
  List<PlaylistPlayModel> songs;
  String imageUrl;

  PlaylistModel({
    required this.name,
    this.songs = const [],
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'songs': songs.map((song) => song.toJson()).toList(),
      'imageUrl': imageUrl,
    };
  }

  PlaylistModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        songs = List<PlaylistPlayModel>.from(
            json['songs'].map((model) => PlaylistPlayModel.fromJson(model))),
        imageUrl = json['imageUrl'];
}

class PlaylistsModel extends ChangeNotifier {
  final List<PlaylistModel> _playlists = [];

  List<PlaylistModel> get playlists => _playlists;

  void addPlaylist(PlaylistModel playlist) async {
    _playlists.add(playlist);
    _saveToPrefs();
    await savePlaylists();
    notifyListeners();
  }

  void removePlaylist(int index) async {
    _playlists.removeAt(index);
    _saveToPrefs();
    notifyListeners();
    await savePlaylists();
  }

  void addSongToPlaylist(int playlistIndex, PlaylistPlayModel song) async {
    if (playlistIndex >= 0 && playlistIndex < _playlists.length) {
      _playlists[playlistIndex].songs.add(song);
      _saveToPrefs();
      notifyListeners();
      await savePlaylists();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String playlistsStr =
        json.encode(_playlists.map((playlist) => playlist.toJson()).toList());
    await prefs.setString('playlists', playlistsStr);
  }

  Future<void> loadPlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    String? playlistsStr = prefs.getString('playlists');
    if (playlistsStr != null) {
      Iterable l = json.decode(playlistsStr);
      _playlists.clear();
      _playlists.addAll(List<PlaylistModel>.from(
          l.map((model) => PlaylistModel.fromJson(model))));
      notifyListeners();
    }
  }

  Future<void> savePlaylists() async {
    final prefs = await SharedPreferences.getInstance();
    String playlistsStr =
        json.encode(_playlists.map((e) => e.toJson()).toList());
    await prefs.setString('playlists', playlistsStr);
  }

  
}
