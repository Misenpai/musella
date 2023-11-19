import 'package:flutter/material.dart';
import 'package:musella/models/music.dart';
import 'package:musella/services/music_operations.dart';
import 'package:musella/widgit/music_player.dart';

class MostPlayed extends StatelessWidget {
  final Function(String, String, String) handleBackFromMusicPlayerMostPlayed;
  const MostPlayed(
      {super.key, required this.handleBackFromMusicPlayerMostPlayed});

  @override
  Widget build(BuildContext context) {
    final List<Music> albums = MusicOperations.getMusic();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Most Played',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'See All',
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: albums.length,
              itemBuilder: (context, index) {
                final album = albums[index];
                return GestureDetector(
                  onTap: () {
                    handleBackFromMusicPlayerMostPlayed(
                      album.imagePath,
                      album.title,
                      album.artist,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => MusicPlayerPage(
                          imageURL: album.imagePath,
                          title: album.title,
                          artist: album.artist,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 16, right: index == albums.length - 1 ? 16 : 0),
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
                              color: Colors.white, fontWeight: FontWeight.bold),
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
}
