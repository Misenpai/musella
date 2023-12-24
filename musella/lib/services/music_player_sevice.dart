import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerService with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  bool get isPlaying => player.state == PlayerState.playing;

  Future<void> play(String url) async {
    try {
      print("the song uri is : $url");
      await player.play(UrlSource(url));
      print("Playback started");
      notifyListeners();
    } catch (e) {
      print("Error playing: $e");
    }
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
    notifyListeners();
  }

  // Add other methods and listeners as needed

  void dispose() {
    player.dispose();
    super.dispose();
  }
}