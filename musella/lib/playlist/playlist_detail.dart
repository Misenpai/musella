import 'package:flutter/material.dart';
import 'package:musella/models/playlist_model.dart';
import 'package:musella/models/playlist_play.dart';
import 'package:musella/widgit/music_player.dart';

class PlaylistDetailPage extends StatefulWidget {
  final Function(String, String, String) handleBackFromMusicPlayer;
  final PlaylistModel playlist;
  final List<PlaylistPlayModel> items;
  final PlaylistPlayModel? songToAdd;

  PlaylistDetailPage({
    required this.playlist,
    required this.items,
    this.songToAdd,
    required this.handleBackFromMusicPlayer,
  });

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.name),
      ),
      body: ListView.builder(
        itemCount: widget.items.length + (widget.songToAdd != null ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == widget.items.length && widget.songToAdd != null) {
            final song = widget.songToAdd!;
            return ListTile(
              leading: Image.network(song.imagePath),
              title: Text(song.title),
              subtitle: Text(song.artist),
              trailing: IconButton(
                icon: Icon(
                  Icons.play_circle_fill,
                  color: Colors.orange,
                ),
                onPressed: () {
                  widget.handleBackFromMusicPlayer(
                    song.imagePath,
                    song.title,
                    song.artist,
                  );
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => MusicPlayerPage(
                        imageURL: song.imagePath,
                        title: song.title,
                        artist: song.artist,
                        audioURL: song.audioURL,
                      ),
                    ),
                  );
                },
              ),
              // leading: CircleAvatar(
              //   backgroundImage: NetworkImage(song.imagePath),
              //   onBackgroundImageError: (_, __) =>
              //       AssetImage('assets/placeholder.png'),
              // ),
              // title: Text(song.title),
              // subtitle: Text(song.artist),
              // onTap: () {
              //   // Logic to play music
              // },
            );
          } else {
            // Display the existing playlist items
            final song = widget.items[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(song.imagePath),
                onBackgroundImageError: (_, __) =>
                    AssetImage('assets/placeholder.png'),
              ),
              title: Text(song.title),
              subtitle: Text(
                  '${song.artist} | ${song.audioURL}'), // Adjusted subtitle to include audioURL
              trailing: IconButton(
                icon: Icon(
                  Icons.play_circle_fill,
                  color: Colors.orange,
                ),
                onPressed: () {
                  // Logic to play music
                },
              ),
            );
          }
        },
      ),
    );
  }
}
