import 'package:flutter/material.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:musella/services/songs_model_operations.dart';
import 'package:musella/widgit/music_player.dart';
import 'package:provider/provider.dart';

class ArtistSongPage extends StatefulWidget {
  final String artistName;
  final List<SongsModel>? artistSongs;
  final Function(String, String, String) handleBackFromArtistSongPlayer;

  const ArtistSongPage({
    super.key,
    required this.artistName,
    required this.handleBackFromArtistSongPlayer,
    this.artistSongs,
  });

  @override
  _ArtistSongPageState createState() => _ArtistSongPageState();
}

class _ArtistSongPageState extends State<ArtistSongPage> {
  late List<SongsModel> songs;
  bool isLoading = true;

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

      print("artist name is : ${widget.artistName}");

      if (mounted) {
        setState(() {
          songs = loadedSongs;
          songs.sort((a, b) => a.title.compareTo(b.title));
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? Text('Loading Songs...')
            : Text('${songs.length} Songs'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
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
                      final songIndex = index;
                      widget.handleBackFromArtistSongPlayer(
                        song.imageURL,
                        song.title,
                        song.artist,
                      );

                      musicPlayerService.updateCurrentSong(
                        imageURL: song.imageURL,
                        title: song.title,
                        artist: song.artist,
                        audioURL: song.audioURL,
                        albumSongs: songs,
                        songIndex: songIndex,
                      );
                      musicPlayerService.initializeMusic();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MusicPlayerPage(),
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
