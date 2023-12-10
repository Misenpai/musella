import 'package:flutter/material.dart';
import 'package:musella/models/album_model.dart';
import 'package:musella/services/album_model_operations.dart';

class AlbumPage extends StatelessWidget {
  const AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final albumModelOperations = AlbumModelOperations();

    return Scaffold(
      body: FutureBuilder<List<AlbumModel>>(
        future: albumModelOperations.getAlbumModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for the data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message if there is an error loading the data
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // Show message if there are no albums
            return Center(child: Text('No albums found'));
          }

          // Data is loaded, assign it to the albums list
          List<AlbumModel> albums = snapshot.data!;
          // Sort the albums by title
          albums.sort((a, b) => a.albumTitle.compareTo(b.albumTitle));
          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: albums.length,
                  itemBuilder: (context, index) {
                    final album = albums[index];
                    return GridTile(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(album.imageURL),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                          Text(
                            album.albumTitle,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${album.artistName} | ${album.year}',
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            album.soungsCount,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
