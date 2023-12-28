import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class MusicPlayerService with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  bool get isPlaying => player.state == PlayerState.playing;

  Future<void> play(String url) async {
    try {
      final stopwatch = Stopwatch()..start();

      await player.play(UrlSource(url));
      print('Time to play the song from music_player: ${stopwatch.elapsed}');

      notifyListeners();
    } catch (e) {
      print('Error during play: $e');
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

  void dispose() {
    player.dispose();
    super.dispose();
  }
}
