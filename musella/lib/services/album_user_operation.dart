import 'dart:convert';

import 'package:musella/models/album_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlbumUserOperations {
  AlbumUserOperations._();

  static final List<AlbumModel> _albumList = [];

  static void addAlbum(
    String imageURL,
    String albumTitle,
    String artistName,
    String year,
    String songsCount,
    String id,
  ) async {
    final newAlbum = AlbumModel(
      imageURL,
      albumTitle,
      artistName,
      year,
      songsCount,
      id
    );

    // Check if the new artist is already present in the list
    int existingIndex = _albumList.indexWhere((album) =>
        album.imageURL == imageURL &&
        album.albumTitle == albumTitle &&
        album.artistName == artistName &&
        album.year == year &&
        album.songsCount == songsCount);

    // If the artist is already present, remove it
    if (existingIndex != -1) {
      _albumList.removeAt(existingIndex);
    }

    // Add the new artist at the beginning of the list
    _albumList.insert(0, newAlbum);

    // Trim the list if it exceeds the maximum allowed size
    if (_albumList.length > 7) {
      _albumList.removeLast();
    }

    await _saveToPrefs();
  }

  static Future<void> loadAlbumList() async {
    final prefs = await SharedPreferences.getInstance();
    String? albumListStr = prefs.getString('albumList');
    if (albumListStr != null) {
      Iterable l = json.decode(albumListStr);
      _albumList.clear();
      _albumList.addAll(
          List<AlbumModel>.from(l.map((model) => AlbumModel.fromJson(model))));
    }
  }

  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String albumListStr =
        json.encode(_albumList.map((e) => e.toJson()).toList());
    await prefs.setString('albumList', albumListStr);
  }

  static List<AlbumModel> getAlbumList() {
    return List.from(_albumList);
  }
}
