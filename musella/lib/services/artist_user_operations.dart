

import 'package:musella/models/artist_user.dart';

class ArtistUserOperations {
  ArtistUserOperations._() {}

  static void addArtist(String imageURL, String artistName) {
    final artist = ArtistUser(imageURL, artistName);
    if (_artistList.length >= 7) {
      _artistList.removeLast();
    }
    _artistList.insert(0, artist);
  }

  static final List<ArtistUser> _artistList = [];
  static List<ArtistUser> getArtistList() {
    List<ArtistUser> result = [];
    for (var artist in _artistList) {
      result.add(ArtistUser(artist.imageURL, artist.name));
    }
    return result;
  }
}
