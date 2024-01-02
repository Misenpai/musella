import 'package:flutter/material.dart';
import 'package:musella/models/playlist_model.dart';
import 'package:musella/models/playlist_play.dart';
import 'package:musella/playlist/playlist_detail.dart';
import 'package:provider/provider.dart';

class PlaylistPage extends StatefulWidget {
  final PlaylistPlayModel? songToAdd;

  PlaylistPage({Key? key, this.songToAdd}) : super(key: key);
  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  void _addPlaylist(BuildContext context) async {
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
                Provider.of<PlaylistsModel>(context, listen: false).addPlaylist(
                  PlaylistModel(
                    name: controller.text,
                    imageUrl:
                        'default_playlist_image.png', // Replace with your image asset or URL
                  ),
                );
                Navigator.of(context).pop();
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void handleBackFromMusicPlayer(String url, String title, String artist) {
    if (mounted) {
      setState(() {
        widget.songToAdd?.imagePath = url;
        widget.songToAdd?.title = title;
        widget.songToAdd?.artist = artist;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final playlists = Provider.of<PlaylistsModel>(context).playlists;

    return Scaffold(
      appBar: AppBar(title: Text('Playlists')),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return Dismissible(
            key: Key(playlist.name), // Ensure the key is unique for each item
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              Provider.of<PlaylistsModel>(context, listen: false)
                  .removePlaylist(index);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(playlist.imageUrl),
              ),
              title: Text(playlist.name),
              subtitle: Text('${playlist.songs.length} songs'),
              onTap: () {
                print(
                    "Song to add widgit contains image as  : ${widget.songToAdd?.imagePath}");
                print(
                    "Song to add widgit contains artist is : ${widget.songToAdd?.artist}");
                print(
                    "Song to add widgit contains title is : ${widget.songToAdd?.title}");
                print(
                    "Song to add widgit contains audioURL is : ${widget.songToAdd?.audioURL}");

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PlaylistDetailPage(
                        playlist: playlist,
                        items: playlist.songs,
                        songToAdd: widget.songToAdd,
                        handleBackFromMusicPlayer: handleBackFromMusicPlayer),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addPlaylist(context),
        label: Icon(Icons.add),
        shape: CircleBorder(),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
