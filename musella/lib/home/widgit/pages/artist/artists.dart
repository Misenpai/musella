import 'package:flutter/material.dart';
import 'package:musella/models/artist_model.dart';
import 'package:musella/services/artist_model_operations.dart';

class ArtistPage extends StatelessWidget {
  const ArtistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final artistModelOperations = ArtistModelOperations();
    return Scaffold(
      body: FutureBuilder<List<ArtistModel>>(
        future: artistModelOperations.getArtistModel(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No artists found'));
          }

          List<ArtistModel> artists = snapshot.data!;
          artists.sort(
            (a, b) => a.artist.compareTo(b.artist),
          );

          return Column(
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
                  // Rest of your Row's children...
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
          );
        },
      ),
    );
  }
}
