import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musella/models/album_model.dart';
import 'package:musella/services/album_model_operations.dart';
import 'package:musella/services/album_user_operation.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key? key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late List<AlbumModel> allAlbum;
  late List<AlbumModel> displayedArtistAlbum;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    allAlbum = [];
    displayedArtistAlbum = allAlbum;
  }

  void filterAlbum(String query) {
    setState(() {
      if (query.isEmpty) {
        displayedArtistAlbum = allAlbum;
      } else {
        displayedArtistAlbum = allAlbum
            .where((album) =>
                album.albumTitle.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void navigateToAlbumPage(String albumImage, String albumTitle,
      String artistName, String albumyear, String songsCount) {
    AlbumUserOperations.addAlbum(
        albumImage, albumTitle, artistName, albumyear, songsCount);
  }

  Future<void> fetchAlbum(List<String> albumNames) async {
    final AlbumModelOperations albumModelOperations = AlbumModelOperations();
    final List<AlbumModel> albums =
        await albumModelOperations.getArtistModel(albumNames);
    setState(() {
      allAlbum = albums;
      filterAlbum(searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  filterAlbum(query);
                  fetchAlbum([query]);
                },
                decoration: InputDecoration(
                  labelText: 'Search Albums',
                  hintText: 'Enter Album or Artist Name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            if (displayedArtistAlbum.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${displayedArtistAlbum.length} albums',
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
            if (displayedArtistAlbum.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: displayedArtistAlbum.length,
                  itemBuilder: (context, index) {
                    final album = displayedArtistAlbum[index];
                    print((album.imageURL));
                    return InkWell(
                      onTap: () {
                        navigateToAlbumPage(album.imageURL, album.albumTitle,
                            album.artistName, album.year, album.songsCount);
                      },
                      child: GridTile(
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(album.imageURL, scale: 1),
                                    fit: BoxFit.cover,
                                    onError: (exception, StackTrace) {
                                      print(
                                          "Image failed to load : $exception");
                                    },
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                            Text(
                              album.albumTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${album.artistName} | ${album.year}",
                              style: TextStyle(color: Colors.white70),
                            ),
                            Text(
                              album.songsCount,
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }
}
