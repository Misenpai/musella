import 'package:flutter/material.dart';
import 'package:musella/models/artist_model.dart';
import 'package:musella/services/artist_model_operations.dart'; // Replace with the correct path

class ArtistPage extends StatelessWidget {
  const ArtistPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> artistNames = [
      'Porter Robinson',
      'BoyWithUke',
      'Madeon',
      'Lauv',
      'Powfu',
      'Aries'
    ];
    final ArtistModelOperations artistOperations = ArtistModelOperations();

    return FutureBuilder<List<ArtistModel>>(
      future: artistOperations.getArtistModel(artistNames),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Omitted the CircularProgressIndicator
          return Container();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available.');
        } else {
          List<ArtistModel> artists = snapshot.data!;
          artists.sort((a, b) => a.artist.compareTo(b.artist));

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0), // Adjust the value as needed
                  child: ListView.builder(
                    itemCount: artists.length,
                    itemBuilder: (context, index) {
                      final artist = artists[index];
                      return Container(
                        margin: EdgeInsets.only(
                            bottom: 15.0), // Adjust the value as needed
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(artist.imageURL),
                            radius: 30,
                          ),
                          title: Text(
                            artist.artist,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
