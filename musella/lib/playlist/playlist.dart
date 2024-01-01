import 'package:flutter/material.dart';

class PlaylistPage extends StatefulWidget {
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  List<Playlist> playlists = [];

  void _addPlaylist() async {
    final TextEditingController controller = TextEditingController();
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create Playlist'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter playlist name"),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  playlists.add(Playlist(
                    name: controller.text,
                    songs: [],
                    imageUrl:
                        'default_playlist_image.png', // Replace with your image asset or URL
                  ));
                });
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _navigateAndDisplaySelection(BuildContext context, int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PlaylistDetailPage(playlist: playlists[index])),
    );

    // If the result is not null, update the playlist with the new songs.
    if (result != null) {
      setState(() {
        playlists[index].songs.addAll(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Playlists')),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(playlist.imageUrl),
              // Placeholder in case of an error or no image.
              onBackgroundImageError: (_, __) {
                setState(() {
                  playlist.imageUrl =
                      'path/to/placeholder_image.png'; // Replace with your placeholder image
                });
              },
            ),
            title: Text(playlist.name),
            subtitle: Text('${playlist.songs.length} songs'),
            onTap: () => _navigateAndDisplaySelection(context, index),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addPlaylist,
        label: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Colors.orange,
      ),
    );
  }
}

// Model for a playlist.
class Playlist {
  String name;
  List<String> songs; // This will hold song names for simplicity.
  String imageUrl;

  Playlist({required this.name, required this.songs, required this.imageUrl});
}

// Placeholder model for a song.
class Song {
  String title;

  Song(this.title);
}

// Playlist detail page where you can add songs to the playlist.
class PlaylistDetailPage extends StatefulWidget {
  final Playlist playlist;

  PlaylistDetailPage({required this.playlist});

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage> {
  final TextEditingController _songController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlist.name),
      ),
      body: ListView.builder(
        itemCount: widget.playlist.songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.playlist.songs[index]),
            // Implement deletion or other song management features here if needed.
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Simple dialog to add a song
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Song'),
                content: TextField(
                  controller: _songController,
                  decoration: InputDecoration(hintText: "Enter song title"),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_songController.text.isNotEmpty) {
                        setState(() {
                          widget.playlist.songs.add(_songController.text);
                          _songController.clear();
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
