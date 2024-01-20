import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musella/models/playlist_play.dart';
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
  final List<PlaylistPlayModel>? playlistSongs;
  int? currentSongIndex;

  MusicPlayerPage({
    super.key,
    this.imageURL,
    this.title,
    this.artist,
    this.audioURL,
    this.albumSongs,
    this.playlistSongs,
    this.currentSongIndex,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  Duration? duration;
  Duration _postion = Duration.zero;
  late final StreamSubscription _playerStateChangedSubscription;
  late MusicPlayerService musicPlayerService;
  int currentAlbumSongIndex = 0;
  int currentPlaylistSongIndex = 0;
  bool isShuffling = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    currentAlbumSongIndex = widget.currentSongIndex!;
    currentPlaylistSongIndex = widget.currentSongIndex!;
    initializeMusic();
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);

    _playerStateChangedSubscription =
        musicPlayerService.player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        initializeMusic();
        _playNextSong();
      }
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
        musicPlayerService.player.playerStateStream.listen(
          (position) {
            setState(() {
              _postion = musicPlayerService.player.position;
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
    if (isShuffling) {
      final musicPlayerService =
          Provider.of<MusicPlayerService>(context, listen: false);
      List<dynamic> shuffledSongs = [];
      if (widget.albumSongs != null) {
        shuffledSongs.addAll(widget.albumSongs!);
      }
      if (widget.playlistSongs != null) {
        shuffledSongs.addAll(widget.playlistSongs!);
      }

      shuffledSongs.shuffle();
      int currentIndex = shuffledSongs.indexWhere((song) =>
          song.audioURL == widget.audioURL &&
          song.imageURL == widget.imageURL &&
          song.title == widget.title &&
          song.artist == widget.artist);
      int nextIndex = (currentIndex + 1) % shuffledSongs.length;
      var nextSong = shuffledSongs[nextIndex];

      setState(() {
        widget.imageURL = nextSong.imageURL;
        widget.title = nextSong.title;
        widget.artist = nextSong.artist;
        widget.audioURL = nextSong.audioURL;
      });
      musicPlayerService.updateCurrentSong(
        widget.imageURL,
        widget.title,
        widget.artist,
        widget.audioURL,
        currentPlaylistSongIndex,
      );
      await initializeMusic();
      await _fetchAndPlaySong(widget.audioURL);
    } else {
      if (widget.albumSongs != null &&
          currentAlbumSongIndex < widget.albumSongs!.length - 1) {
        currentAlbumSongIndex++;
        SongsModel nextSong = widget.albumSongs![currentAlbumSongIndex];
        setState(() {
          widget.imageURL = nextSong.imageURL;
          widget.title = nextSong.title;
          widget.artist = nextSong.artist;
          widget.audioURL = nextSong.audioURL;
        });
        Provider.of<MusicPlayerService>(context, listen: false)
            .updateCurrentSong(nextSong.imageURL, nextSong.title,
                nextSong.artist, nextSong.audioURL, currentAlbumSongIndex);
        await initializeMusic();
        await _fetchAndPlaySong(nextSong.audioURL);
      }

      if (widget.playlistSongs != null &&
          currentPlaylistSongIndex < widget.playlistSongs!.length - 1) {
        int nextIndex = currentPlaylistSongIndex + 1;
        PlaylistPlayModel nextSong = widget.playlistSongs![nextIndex];
        setState(() {
          currentPlaylistSongIndex = nextIndex;
          widget.imageURL = nextSong.imagePath;
          widget.title = nextSong.title;
          widget.artist = nextSong.artist;
          widget.audioURL = nextSong.audioURL;
        });
        Provider.of<MusicPlayerService>(context, listen: false)
            .updateCurrentSong(nextSong.imagePath, nextSong.title,
                nextSong.artist, nextSong.audioURL, currentPlaylistSongIndex);
        await initializeMusic();
        await _fetchAndPlaySong(nextSong.audioURL);
      }
    }
  }

  Future<void> _playPreviousSong() async {
    if (widget.albumSongs != null && currentAlbumSongIndex > 0) {
      currentAlbumSongIndex--;
      SongsModel previousSong = widget.albumSongs![currentAlbumSongIndex];

      setState(() {
        widget.imageURL = previousSong.imageURL;
        widget.title = previousSong.title;
        widget.artist = previousSong.artist;
        widget.audioURL = previousSong.audioURL;
      });
      Provider.of<MusicPlayerService>(context, listen: false).updateCurrentSong(
          previousSong.imageURL,
          previousSong.title,
          previousSong.artist,
          previousSong.audioURL,
          currentAlbumSongIndex);
      await initializeMusic();
      await _fetchAndPlaySong(previousSong.audioURL);
    } else if (widget.playlistSongs != null && currentPlaylistSongIndex > 0) {
      currentPlaylistSongIndex--;
      PlaylistPlayModel previousSong =
          widget.playlistSongs![currentPlaylistSongIndex];

      setState(() {
        widget.imageURL = previousSong.imagePath;
        widget.title = previousSong.title;
        widget.artist = previousSong.artist;
        widget.audioURL = previousSong.audioURL;
      });
      Provider.of<MusicPlayerService>(context, listen: false).updateCurrentSong(
          previousSong.imagePath,
          previousSong.title,
          previousSong.artist,
          previousSong.audioURL,
          currentPlaylistSongIndex);
      await initializeMusic();
      await _fetchAndPlaySong(previousSong.audioURL);
    }
  }

  Future<void> _shuffleSongs() async {
    setState(() {
      isShuffling = !isShuffling;
    });
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                IconButton(
                  icon: Icon(Icons.shuffle,
                      color: isShuffling ? Colors.orange : Colors.white),
                  onPressed: () {
                    _shuffleSongs();
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<Duration>(
            stream: musicPlayerService.player.positionStream,
            builder: (context, snapshot) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ProgressBar(
                  progress: snapshot.data!,
                  total: duration ?? const Duration(minutes: 4),
                  onSeek: (duration) {
                    musicPlayerService.player.seek(duration);
                  },
                  timeLabelTextStyle: TextStyle(color: Colors.white),
                  thumbColor: Colors.white,
                  progressBarColor: Colors.orange,
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
                icon:
                    Icon(Icons.skip_previous, color: Colors.white, size: 32.0),
                onPressed: () {
                  _playPreviousSong();
                },
              ),
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
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white, size: 32.0),
                onPressed: () {
                  _playNextSong();
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
