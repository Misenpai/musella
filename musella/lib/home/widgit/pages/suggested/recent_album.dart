import 'package:flutter/material.dart';
import 'package:musella/home/widgit/pages/album/album_play.dart';
import 'package:musella/models/album_model.dart';
import 'package:musella/services/album_user_operation.dart';

class AlbumRecent extends StatelessWidget {
  final Function(String, String, String) handleBackFromAlbumPlayerMostPlayed;
  const AlbumRecent(
      {super.key, required this.handleBackFromAlbumPlayerMostPlayed});

  @override
  Widget build(BuildContext context) {
    final List<AlbumModel> albums = AlbumUserOperations.getAlbumList();

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
                  'Recent Album',
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
            child: albums.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: albums.length,
                    itemBuilder: (context, index) {
                      final album = albums[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AlbumSongPage(
                                    albumName: album.id,
                                    handleBackFromAlbumSongPlayer:
                                        handleBackFromAlbumPlayerMostPlayed,
                                  )));
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
                                  album.imageURL,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                album.albumTitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "${album.artistName} | ${album.year}",
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
                'Open an album first',
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
