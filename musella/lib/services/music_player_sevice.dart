import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayerService with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  bool get isPlaying => player.playing;
  String? currentImageURL;
  String? currentTitle;
  String? currentArtist;
  String? currentAudioURL;
  int? currentSongIndex;

  void updateCurrentSong(String? imageURL, String? title, String? artist,
      String? audioURL, int? songIndex) {
    currentImageURL = imageURL;
    currentTitle = title;
    currentArtist = artist;
    currentAudioURL = audioURL;
    currentSongIndex = songIndex;
    notifyListeners();
  }

  Future<void> play(String url) async {
    try {
      await player.setUrl(url);
      await player.play();
      notifyListeners();
    } catch (e) {
      print('Error during play: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.play();
    }
    notifyListeners();
  }

  void dispose() {
    player.dispose();
    super.dispose();
  }
}
