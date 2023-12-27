import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerService with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  bool get isPlaying => player.state == PlayerState.playing;

  Future<void> play(String url) async {
    try {
      await player.play(UrlSource(url));

      notifyListeners();
    } catch (e) {}
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
