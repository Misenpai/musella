import 'package:flutter/material.dart';
import 'package:musella/models/playlist_model.dart';
import 'package:musella/models/playlist_play.dart';
import 'package:musella/playlist/playlist.dart';
import 'package:provider/provider.dart';

class PlaylistOperations {
  static void addPlaylist(BuildContext context, String imageURL, String title,
      String artist, String audioURL) async {
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

  static void showAddToPlaylistDialog(BuildContext context, String imageURL,
      String title, String artist, String audioURL) {
    print("Image URL for showaddtoplaylist is : $imageURL");
    print("title for showaddtoplaylist is : $title");
    print("artist for showaddtoplaylist is : $artist");
    print("audioURL for showaddtoplaylist is : $audioURL");
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Playlist'),
          content: const Text(
              'Do you want to add to an existing playlist or create a new one?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToPlaylistPage(
                    context, imageURL, title, artist, audioURL);
              },
              child: const Text('Existing Playlist'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                addPlaylist(context, imageURL, title, artist,
                    audioURL); // Invoke the playlist creation process
              },
              child: const Text('Create New'),
            ),
          ],
        );
      },
    );
  }

  static void _navigateToPlaylistPage(
    BuildContext context,
    String imageURL,
    String title,
    String artist,
    String audioURL,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlaylistPage(
            songToAdd: PlaylistPlayModel(imageURL, title, artist, audioURL),),
      ),
    );
  }
}
