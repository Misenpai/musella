import 'package:flutter/material.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:musella/services/songs_model_operations.dart';
import 'package:musella/widgit/music_player.dart';
import 'package:provider/provider.dart';

class SongsPage extends StatefulWidget {
  final Function(String, String, String) handleBackFromMusicPlayer;

  const SongsPage({super.key, required this.handleBackFromMusicPlayer});

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late List<SongsModel> songs = [];

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      var songsOperations = SongsModelOperations();

      final loadedSongs = await songsOperations.getSongsModel(
          ['Porter Robinson', 'BoyWithUke', 'Powfu', 'David Kushner']);

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
  void dispose() {
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
    musicPlayerService.player.pause(); // Pause the player when navigating back
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${songs.length} Songs',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ascending',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.orange,
                    )
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: Image.network(song.imageURL),
                  title: Text(song.title),
                  subtitle: Text('${song.artist} | ${song.duration}'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.play_circle_fill,
                      color: Colors.orange,
                    ),
                    onPressed: () {
                      widget.handleBackFromMusicPlayer(
                        song.imageURL,
                        song.title,
                        song.artist,
                      );
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
          ),
        ],
      ),
    );
  }
}
