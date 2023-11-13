import 'package:flutter/material.dart';
import 'package:musella/models/artist_model.dart';
import 'package:musella/services/artist_model_operations.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ArtistModel> artists = ArtistModelOperations.getArtistModel();
    artists.sort(
      (a, b) => a.artist.compareTo(b.artist),
    );
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${artists.length} artists',
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
          Expanded(
            child: ListView.builder(
              itemCount: artists.length,
              itemBuilder: (context, index) {
                final artist = artists[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(artist.imageURL),
                    radius: 30,
                  ),
                  title: Text(
                    artist.artist,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${artist.album} | ${artist.songs}',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
