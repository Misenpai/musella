import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:flutter/material.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/playlist/playlist_operation.dart';
import 'package:musella/services/music_operations.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:provider/provider.dart';
import 'package:spotify/spotify.dart' as Spotify;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

// ignore: must_be_immutable
class MusicPlayerPage extends StatefulWidget {
  String? imageURL;
  String? title;
  String? artist;
  String? audioURL;
  final List<SongsModel>? albumSongs;

  MusicPlayerPage({
    super.key,
    this.imageURL,
    this.title,
    this.artist,
    this.audioURL,
    this.albumSongs,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  Duration? duration;
  Duration _postion = Duration.zero;
  late final StreamSubscription _playerStateChangedSubscription;
  late MusicPlayerService musicPlayerService;
  int currentSongIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    initializeMusic();
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
    _playerStateChangedSubscription =
        musicPlayerService.player.onPlayerStateChanged.listen((state) {
      setState(() {});
    });
    musicPlayerService.player.onPlayerComplete.listen((event) {
      _playNextSong();
    });
  }

  Future<void> initializeMusic() async {
    MusicOperations.addMusic(
      widget.imageURL ?? '',
      widget.title ?? '',
      widget.artist ?? '',
      widget.audioURL ?? '',
    );
    await _fetchAndPlaySong(widget.audioURL);
  }

  Future<void> _fetchAndPlaySong(String? audioURL) async {
    if (widget.audioURL == null) return;
    final credentials = Spotify.SpotifyApiCredentials(
        "4c6480b9dad641e0949b71b13d0ca7c0", "d07d2808092846ae9a452961db39b7f2");
    final spotify = Spotify.SpotifyApi(credentials);
    final yt = YoutubeExplode();
    final stopwatch = Stopwatch()..start();
    print("Audio URL is : ${widget.audioURL}");
    try {
      final track = await spotify.tracks.get(audioURL ?? '');
      String? songname = track.name;
      String? artistName = track.artists?.first.name;
      if (songname != null) {
        final video = (await yt.search.search('$artistName $songname')).first;
        final videoId = video.id.value;
        duration = video.duration;
        var manifest = await yt.videos.streamsClient.getManifest(videoId);
        var audioId = manifest.audioOnly.first.url;
        print("audio id is : $audioId");
        final playStopwatch = Stopwatch()..start();
        musicPlayerService.play(audioId.toString());
        print('Time to play the song: ${playStopwatch.elapsed}');
        musicPlayerService.player.onPositionChanged.listen(
          (position) {
            setState(() {
              _postion = position;
            });
          },
        );
        setState(() {
          _postion = Duration.zero;
        });
      }
    } finally {
      yt.close();
      print("Time to get the song from Youtube : ${stopwatch.elapsed}");
    }
  }

  Future<void> _playNextSong() async {
    if (widget.albumSongs != null &&
        currentSongIndex < widget.albumSongs!.length - 1) {
      currentSongIndex++;
      SongsModel nextSong = widget.albumSongs![currentSongIndex];
      print("Next song playing name is : ${nextSong.title}");

      setState(() {
        widget.imageURL = nextSong.imageURL;
        widget.title = nextSong.title;
        widget.artist = nextSong.artist;
        widget.audioURL = nextSong.audioURL;
      });
      await _fetchAndPlaySong(nextSong.audioURL);
    }
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerService = Provider.of<MusicPlayerService>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.playlist_add, color: Colors.white),
            onPressed: () {
              PlaylistOperations.showAddToPlaylistDialog(
                context,
                widget.imageURL ?? '',
                widget.title ?? '',
                widget.artist ?? '',
                widget.audioURL ?? '',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Spacer(),
          Text(
            widget.title ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.artist ?? '',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.network(widget.imageURL ?? '', fit: BoxFit.cover),
          ),
          Spacer(),
          StreamBuilder(
            stream: musicPlayerService.player.onPlayerStateChanged,
            builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ProgressBar(
                  progress: _postion,
                  total: duration ?? const Duration(minutes: 4),
                  onSeek: (duration) {
                    musicPlayerService.player.seek(duration);
                  },
                  timeLabelTextStyle: TextStyle(color: Colors.white),
                  thumbColor: Colors.white,
                  progressBarColor: Colors.white,
                  bufferedBarColor: Colors.white38,
                  baseBarColor: Colors.white10,
                ),
              );
            },
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.replay_5, color: Colors.white, size: 32.0),
                onPressed: () {
                  musicPlayerService.player.seek(
                    _postion - Duration(seconds: 5),
                  );
                },
              ),
              Consumer<MusicPlayerService>(
                builder: (context, musicPlayerService, child) {
                  return IconButton(
                    icon: Icon(
                      musicPlayerService.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      color: Colors.orange,
                      size: 64,
                    ),
                    onPressed: () {
                      context.read<MusicPlayerService>().togglePlayPause();
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white, size: 32.0),
                onPressed: () {
                  musicPlayerService.player.seek(
                    _postion + Duration(seconds: 10),
                  );
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
