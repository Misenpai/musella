import 'package:flutter/material.dart';
import 'package:musella/home/home.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:musella/services/songs_model_operations.dart';
import 'package:musella/widgit/music_player.dart';
import 'package:provider/provider.dart';

class ArtistSongPage extends StatefulWidget {
  final String artistName;
  final Function(String, String, String) handleBackFromArtistSongPlayer;

  const ArtistSongPage(
      {Key? key,
      required this.artistName,
      required this.handleBackFromArtistSongPlayer})
      : super(key: key);

  @override
  _ArtistSongPageState createState() => _ArtistSongPageState();
}

class _ArtistSongPageState extends State<ArtistSongPage> {
  late List<SongsModel> songs;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      var songsOperations = SongsModelOperations();

      final loadedSongs =
          await songsOperations.getSongsModel([widget.artistName]);

      if (mounted) {
        setState(() {
          songs = loadedSongs;
          songs.sort((a, b) => a.title.compareTo(b.title));
        });
      }
    } catch (e) {
      print('Error loading songs: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${songs.length} Songs'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            leading: Image.network(song.imageURL),
            title: Text(song.title),
            subtitle: Text('${song.artist} | ${song.duration}'),
            trailing: IconButton(
              icon: Icon(Icons.play_circle_fill, color: Colors.orange),
              onPressed: () {
                widget.handleBackFromArtistSongPlayer(
                  song.imageURL,
                  song.title,
                  song.artist,
                );
                // Navigate to MusicPlayerPage if needed
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MusicPlayerPage(
                      imageURL: song.imageURL,
                      title: song.title,
                      artist: song.artist,
                      audioURL: song.audioURL,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
