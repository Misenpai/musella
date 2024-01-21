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
  late MusicPlayerService musicPlayerService;
  late List<SongsModel> songs;
  late List<SongsModel> displayedSongs;

  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    songs = [];
    displayedSongs = songs;
  }

  Future<void> fetchSongs(List<String> songNames) async {
    if (songNames.isNotEmpty) {
      final SongsModelOperations songsOperations = SongsModelOperations();
      final List<SongsModel> loadedSongs =
          await songsOperations.getSongsModel(songNames);

      setState(() {
        songs = loadedSongs;
        filterSongs(searchController.text);
      });
    }
  }

  void filterSongs(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedSongs = songs;
      } else {
        displayedSongs = songs
            .where((song) =>
                song.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();

    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
    // Initial search for empty query
    fetchSongs([]);
  }

  @override
  Widget build(BuildContext context) {
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);

    return GestureDetector(
      onTap: () {
        _searchFocusNode.unfocus(); // Unfocus the focus node
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: TextField(
                controller: searchController,
                focusNode: _searchFocusNode, // Assign the focus node
                onChanged: (query) {
                  filterSongs(query);
                  fetchSongs([query]);
                },
                decoration: InputDecoration(
                  labelText: 'Search Songs',
                  hintText: 'Enter song name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (displayedSongs.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${displayedSongs.length} Songs',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            if (displayedSongs.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    itemCount: displayedSongs.length,
                    itemBuilder: (context, index) {
                      final song = displayedSongs[index];
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

                            musicPlayerService.updateCurrentSong(
                              imageURL: song.imageURL,
                              title: song.title,
                              artist: song.artist,
                              audioURL: song.audioURL,
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
                ),
              ),
          ],
        ),
      ),
    );
  }
}
