import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
// ignore: library_prefixes
import 'package:spotify/spotify.dart' as Spotify;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayerPage extends StatefulWidget {
  final String imageURL;
  final String title;
  final String artist;
  final String audioURL;

  const MusicPlayerPage({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.artist,
    required this.audioURL,
  }) : super(key: key);

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  bool _isPlaying = false;
  late final player = AudioPlayer();
  Duration? duration;
  Duration _postion = Duration.zero;

  @override
  void initState() {
    print(widget.audioURL);
    final credentials = Spotify.SpotifyApiCredentials(
        "4c6480b9dad641e0949b71b13d0ca7c0", "d07d2808092846ae9a452961db39b7f2");
    final spotify = Spotify.SpotifyApi(credentials);
    spotify.tracks.get(widget.audioURL).then((track) async {
      String? songname = track.name;
      if (songname != null) {
        print(songname);
        final yt = YoutubeExplode();
        final video = (await yt.search.search(songname)).first;
        final videoId = video.id.value;
        duration = video.duration;
        setState(() {});
        var manifest = await yt.videos.streamsClient.getManifest(videoId);
        var audioId = manifest.audioOnly.first.url;
        player.play(UrlSource(audioId.toString()));
        player.onPositionChanged.listen((postion) {
          setState(() {
            _postion = postion;
          });
        });
      }
    });
    super.initState();
    // You can start playing the audio here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Handle back button pressed
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Spacer(),
          Text(
            widget.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.artist,
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          Spacer(),
          Image.network(widget.imageURL, fit: BoxFit.cover),
          Spacer(),
          StreamBuilder(
              stream: player.onPlayerStateChanged,
              builder: (context, snapshot) {
                return ProgressBar(
                  progress: _postion,
                  total: duration ?? const Duration(minutes: 4),
                  onSeek: (duration) {
                    player.seek(duration);
                  },
                  timeLabelTextStyle: TextStyle(color: Colors.white),
                  thumbColor: Colors.white,
                  progressBarColor: Colors.white,
                  bufferedBarColor: Colors.white38,
                  baseBarColor: Colors.white10,
                );
              }),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  // Implement skipping to the previous song if needed
                },
              ),
              IconButton(
                  icon: Icon(
                    player.state == PlayerState.playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.orange,
                    size: 64,
                  ),
                  onPressed: () async {
                    if (player.state == PlayerState.playing) {
                      await player.pause();
                    } else {
                      await player.resume();
                    }
                    setState(() {});
                  }),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  // Implement skipping to the next song if needed
                },
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
