import 'package:musella/models/music.dart';

class MusicOperations {
  MusicOperations._();

  static void addMusic(
      String imageURL, String title, String artist, String audioURL) {
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
  }

  static final List<Music> _musicList = [];

  static List<Music> getMusicList() {
    // Create a copy of the music list to avoid direct manipulation
    List<Music> result = List.from(_musicList);
    return result;
  }
}
