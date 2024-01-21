import 'package:flutter/material.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  final String? imageURL;
  final String? title;

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
      // onTap: () {
      //   print(
      //       "Song index miniplayer is : ${musicPlayerService.currentSongIndex}");
      //   Navigator.of(context).push(MaterialPageRoute(
      //     builder: (context) => MusicPlayerPage(
      //       imageURL: imageURL,
      //       title: title,
      //     ),
      //   ));
      // },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: Colors.orange,
        width: deviceSize.width,
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              musicPlayerService.currentImageURL ?? imageURL!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Text(
                musicPlayerService.currentTitle ?? title!,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
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
}
