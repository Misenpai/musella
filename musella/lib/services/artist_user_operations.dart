import 'dart:convert';

import 'package:musella/models/artist_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArtistUserOperations {
  ArtistUserOperations._();

  static final List<ArtistUser> _artistList = [];

  static void addArtist(String imageURL, String artistName) async {
    final newArtist = ArtistUser(imageURL, artistName);

    // Check if the new artist is already present in the list
    int existingIndex = _artistList.indexWhere(
        (artist) => artist.name == artistName && artist.imageURL == imageURL);

    // If the artist is already present, remove it
    if (existingIndex != -1) {
      _artistList.removeAt(existingIndex);
    }

    // Add the new artist at the beginning of the list
    _artistList.insert(0, newArtist);

    // Trim the list if it exceeds the maximum allowed size
    if (_artistList.length > 7) {
      _artistList.removeLast();
    }

    await _saveToPrefs();
  }

  static Future<void> loadArtistList() async {
    final prefs = await SharedPreferences.getInstance();
    String? artistListStr = prefs.getString('artistList');
    if (artistListStr != null) {
      Iterable l = json.decode(artistListStr);
      _artistList.clear();
      _artistList.addAll(List<ArtistUser>.from(l.map((model) => ArtistUser.fromJson(model))));
    }
  }

  static Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String artistListStr = json.encode(_artistList.map((e) => e.toJson()).toList());
    await prefs.setString('artistList', artistListStr);
  }

  static List<ArtistUser> getArtistList() {
    return List.from(_artistList);
  }
}