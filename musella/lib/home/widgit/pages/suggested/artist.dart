import 'package:flutter/material.dart';
import 'package:musella/home/widgit/pages/artist/artist_song.dart';
import 'package:musella/models/artist_user.dart';
import 'package:musella/services/artist_user_operations.dart';

class Artists extends StatelessWidget {
  final Function(String, String, String) handleBackFromArtistSongPlayer;
  const Artists({super.key, required this.handleBackFromArtistSongPlayer});

  @override
  Widget build(BuildContext context) {
    final List<ArtistUser> artists = ArtistUserOperations.getArtistList();

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
                  'Recent Artists',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 180,
            child: artists.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: artists.length,
                    itemBuilder: (context, index) {
                      final artist = artists[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ArtistSongPage(
                                    artistName: artist.name,
                                    handleBackFromArtistSongPlayer:
                                        handleBackFromArtistSongPlayer,
                                  )));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 16,
                              right: index == artists.length - 1 ? 16 : 0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 75,
                                backgroundImage: NetworkImage(artist.imageURL),
                              ),
                              SizedBox(height: 8),
                              Text(
                                artist.name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
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
                'Open an artist first',
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
