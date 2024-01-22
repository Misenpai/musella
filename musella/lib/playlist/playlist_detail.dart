import 'package:flutter/material.dart';
import 'package:musella/models/playlist_model.dart';
import 'package:musella/models/playlist_play.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:musella/widgit/music_player.dart';
import 'package:provider/provider.dart';

class PlaylistDetailPage extends StatefulWidget {
  final Function(String, String, String) handleBackFromMusicPlayer;
  final PlaylistModel playlist;
  final List<PlaylistPlayModel> items;
  final List<PlaylistPlayModel>? songToAdd;

  PlaylistDetailPage({
    required this.playlist,
    required this.items,
    this.songToAdd,
    required this.handleBackFromMusicPlayer,
  });

  @override
  _PlaylistDetailPageState createState() => _PlaylistDetailPageState();
}

class _PlaylistDetailPageState extends State<PlaylistDetailPage>
    with AutomaticKeepAliveClientMixin {
  late List<SongsModel> songs;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
    super.build(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.playlist.name),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ListView.builder(
            itemCount: widget.items.length + (widget.songToAdd != null ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == widget.items.length && widget.songToAdd != null) {
                final song = widget.songToAdd!.first;
                print("In Playlist song it is : ${song.title}");
              } else {
                final song = widget.items[index];
                return Dismissible(
                  key: Key(song.title),
                  onDismissed: (direction) {
                    setState(() {
                      widget.items.removeAt(index);
                    });

                    // Show a snackbar with the undo button
                    ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                      SnackBar(
                        content: Text("Song removed from playlist"),
                        action: SnackBarAction(
                          label: "Undo",
                          onPressed: () {
                            // Add the item back to the data source
                            setState(() {
                              widget.items.insert(index, song);
                            });
                          },
                        ),
                      ),
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 16.0),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: ListTile(
                    leading: Image.network(song.imagePath),
                    title: Text(song.title),
                    subtitle: Text(song.artist),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.play_circle_fill,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        final songIndex = index;
                        widget.handleBackFromMusicPlayer(
                          song.imagePath,
                          song.title,
                          song.artist,
                        );

                        print("widget items countis : ${widget.items}");

                        musicPlayerService.updateCurrentSong(
                          imageURL: song.imagePath,
                          title: song.title,
                          artist: song.artist,
                          audioURL: song.audioURL,
                          playlistSongs: widget.items,
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
                  ),
                );
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
