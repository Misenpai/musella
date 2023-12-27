import 'package:musella/models/artist_user.dart';

class ArtistUserOperations {
  ArtistUserOperations._();

  static void addArtist(String imageURL, String artistName) {
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
  }

  static final List<ArtistUser> _artistList = [];

  static List<ArtistUser> getArtistList() {
    // Create a copy of the artist list to avoid direct manipulation
    List<ArtistUser> result = List.from(_artistList);
    return result;
  }
}
