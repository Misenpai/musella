import 'package:flutter/material.dart';
import 'package:musella/models/music.dart';
import 'package:musella/services/music_operations.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:musella/widgit/music_player.dart';
import 'package:provider/provider.dart';

class RecentlyPlayed extends StatelessWidget {
  final Function(String, String, String)
      handleBackFromMusicPlayerRecentlyPlayed;
  const RecentlyPlayed({
    super.key,
    required this.handleBackFromMusicPlayerRecentlyPlayed,
  });

  @override
  Widget build(BuildContext context) {
    final List<Music> albums = MusicOperations.getMusicList();
    final musicPlayerService =
        Provider.of<MusicPlayerService>(context, listen: false);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 8,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Recently Played',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 200,
            child: albums.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      return GestureDetector(
                        onTap: () {
                          final songIndex = index;
                          handleBackFromMusicPlayerRecentlyPlayed(
                            album.imagePath,
                            album.title,
                            album.artist,
                          );

                          musicPlayerService.updateCurrentSong(
                            imageURL: album.imagePath,
                            title: album.title,
                            artist: album.artist,
                            audioURL: album.audioURL,
                            songIndexAlbum: songIndex,
                          );
                          musicPlayerService.initState();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MusicPlayerPage(),
                            ),
                          );
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16,
                              right: index == albums.length - 1 ? 16 : 0),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  album.imagePath,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                album.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                album.artist,
                                style: TextStyle(color: Colors.grey),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      shrinkWrap: true,
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                'https://i.pinimg.com/564x/43/f9/21/43f921fff911cfa8aa64c636931e3880.jpg',
                height: 140,
              ),
              SizedBox(height: 16),
              Text(
                'Play a song first',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
