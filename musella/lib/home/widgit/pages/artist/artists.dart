import 'package:flutter/material.dart';
import 'package:musella/models/artist_model.dart';
import 'package:musella/services/artist_model_operations.dart'; // Replace with the correct path

class ArtistPage extends StatefulWidget {
  const ArtistPage({Key? key}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();
}

class _ArtistPageState extends State<ArtistPage> {
  late List<ArtistModel> allArtists;
  late List<ArtistModel> displayedArtists;

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initially, the artist list is empty
    allArtists = [];
    displayedArtists = allArtists;
  }

  void filterArtists(String query) {
    setState(() {
      displayedArtists = allArtists
          .where((artist) =>
              artist.artist.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> fetchArtists(List<String> artistNames) async {
    final ArtistModelOperations artistOperations = ArtistModelOperations();
    final List<ArtistModel> artists =
        await artistOperations.getArtistModel(artistNames);

    setState(() {
      allArtists = artists;
      displayedArtists = allArtists;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus the text field to dismiss the keyboard
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  filterArtists(query);
                  fetchArtists([query]);
                },
                decoration: InputDecoration(
                  labelText: 'Search Artists',
                  hintText: 'Enter artist name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (displayedArtists.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${displayedArtists.length} artists',
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
            if (displayedArtists.isNotEmpty)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                    itemCount: displayedArtists.length,
                    itemBuilder: (context, index) {
                      final artist = displayedArtists[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: 15.0),
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
        ),
      ),
    );
  }
}
