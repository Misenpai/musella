import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

import 'package:musella/models/playlist_play.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/playlist/playlist_operation.dart';

import 'package:musella/services/music_player_sevice.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class MusicPlayerPage extends StatefulWidget {
  // String? imageURL;
  // String? title;
  // String? artist;
  // String? audioURL;
  // final List<SongsModel>? albumSongs;
  // final List<PlaylistPlayModel>? playlistSongs;
  // int? currentSongIndex;

  // MusicPlayerPage({
  //   super.key,
  //   this.imageURL,
  //   this.title,
  //   this.artist,
  //   this.audioURL,
  //   this.albumSongs,
  //   this.playlistSongs,
  //   this.currentSongIndex,
  // });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
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
                musicPlayerService.currentImageURL ?? '',
                musicPlayerService.currentTitle ?? '',
                musicPlayerService.currentArtist ?? '',
                musicPlayerService.currentAudioURL ?? '',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Spacer(),
          Text(
            musicPlayerService.currentTitle ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            musicPlayerService.currentArtist ?? '',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Image.network(musicPlayerService.currentImageURL ?? '',
                fit: BoxFit.cover),
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
                      color: musicPlayerService.isShuffling
                          ? Colors.orange
                          : Colors.white),
                  onPressed: () {
                    musicPlayerService.shuffleSongs();
                  },
                ),
              ],
            ),
          ),
          StreamBuilder<Duration>(
            stream: musicPlayerService.player.positionStream,
            builder: (context, snapshot) {
              Duration currentPosition = snapshot.data ?? Duration.zero;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ProgressBar(
                  progress: currentPosition,
                  total:
                      musicPlayerService.duration ?? const Duration(minutes: 4),
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
                  musicPlayerService.playPreviousSong();
                },
              ),
              IconButton(
                icon: Icon(Icons.replay_5, color: Colors.white, size: 32.0),
                onPressed: () {
                  musicPlayerService.player.seek(
                    musicPlayerService.positions - Duration(seconds: 5),
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
                      musicPlayerService.togglePlayPause();
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.forward_10, color: Colors.white, size: 32.0),
                onPressed: () {
                  musicPlayerService.player.seek(
                    musicPlayerService.positions + Duration(seconds: 10),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white, size: 32.0),
                onPressed: () {
                  musicPlayerService.playNextSong();
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
