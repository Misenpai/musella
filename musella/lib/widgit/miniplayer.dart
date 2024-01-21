// ignore_for_file: unnecessary_import

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:musella/widgit/music_player.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  final String? imageURL;
  final String? title;

  // ignore: use_super_parameters
  const MiniPlayer({
    Key? key,
    this.imageURL,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageURL == null || title == null) {
      return SizedBox.shrink();
    }

    Size deviceSize = MediaQuery.of(context).size;
    MusicPlayerService musicPlayerService =
        Provider.of<MusicPlayerService>(context);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createRoute());
      },
      onLongPress: () {
        _showProgressBarModal(context, musicPlayerService);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(5.0),
        ),
        width: deviceSize.width * 0.95,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5.0),
              child: Image.network(
                musicPlayerService.currentImageURL ?? imageURL!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0), // Adjust the padding as needed
                child: Text(
                  musicPlayerService.currentTitle ?? title!,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                musicPlayerService.playNextSong();
              },
              icon: Icon(
                Icons.skip_next,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                musicPlayerService.togglePlayPause();
              },
              icon: Icon(
                musicPlayerService.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProgressBarModal(
      BuildContext context, MusicPlayerService musicPlayerService) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StreamBuilder<Duration>(
                stream: musicPlayerService.player.positionStream,
                builder: (context, snapshot) {
                  Duration currentPosition = snapshot.data ?? Duration.zero;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ProgressBar(
                      progress: currentPosition,
                      total: musicPlayerService.duration ??
                          const Duration(minutes: 4),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the modal
                  },
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          MusicPlayerPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
