import 'package:musella/models/music.dart';

class MusicOperations {
  MusicOperations._();

  static void addMusic(String imageURL, String title, String artist,String audioURL) {
    final music = Music(imageURL, title, artist,audioURL);
    // Insert the new music at the beginning of the list
    _musicList.insert(0, music);
  }

  static List<Music> _musicList = [];

  static List<Music> getMusicList() {
    List<Music> result = [];
    for (var music in _musicList) {
      result.add(Music(music.imagePath, music.title, music.artist,music.audioURL));
    }
    return result;
  }
}
