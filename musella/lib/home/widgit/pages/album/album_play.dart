import 'package:flutter/material.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/songs_album_model.dart';
import 'package:musella/widgit/music_player.dart';

class AlbumSongPage extends StatefulWidget {
  final String albumName;
  final Function(String, String, String) handleBackFromAlbumSongPlayer;

  const AlbumSongPage({
    super.key,
    required this.albumName,
    required this.handleBackFromAlbumSongPlayer,
  });

  @override
  _AlbumSongPageState createState() => _AlbumSongPageState();
}

class _AlbumSongPageState extends State<AlbumSongPage> {
  late List<SongsModel> songs;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSongs();
  }

  Future<void> _loadSongs() async {
    try {
      var songsOperations = SongsAlbumModelOperations();

      final loadedSongs =
          await songsOperations.getSongsAlbumModel([widget.albumName]);
      print("ALbum loadedSongs  is : $loadedSongs");

      print("name is : ${widget.albumName}");

      if (mounted) {
        setState(() {
          songs = loadedSongs;
          songs.sort((a, b) => a.title.compareTo(b.title));
          isLoading = false; // Set loading to false once songs are loaded
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Set loading to false in case of an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      widget.handleBackFromAlbumSongPlayer(
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
