import 'package:flutter/material.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:musella/services/songs_model_operations.dart';
import 'package:musella/widgit/music_player.dart';
import 'package:provider/provider.dart';

class SongsPage extends StatefulWidget {
  final Function(String, String, String) handleBackFromMusicPlayer;

  const SongsPage({Key? key, required this.handleBackFromMusicPlayer})
      : super(key: key);

  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  late List<SongsModel> songs;
  late List<SongsModel> displayedSongs;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    songs = [];
    displayedSongs = songs;
  }

  Future<void> fetchSongs(List<String> songNames) async {
    final SongsModelOperations songsOperations = SongsModelOperations();
    final List<SongsModel> loadedSongs =
        await songsOperations.getSongsModel(songNames);

    setState(() {
      songs = loadedSongs;
      filterSongs(searchController.text);
    });
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
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);
    musicPlayerService.player.pause(); // Pause the player when navigating back
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initial search for empty query
    fetchSongs([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: TextField(
              controller: searchController,
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
            ),
        ],
      ),
    );
  }
}
