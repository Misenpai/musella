import 'dart:async';
import 'package:flutter/material.dart';
import 'package:musella/models/album_model.dart';
import 'package:musella/services/album_model_operations.dart';

class AlbumPage extends StatefulWidget {
  const AlbumPage({Key? key});

  @override
  State<AlbumPage> createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  late List<AlbumModel> allAlbum;
  late List<AlbumModel> displayedArtistAlbum;
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    allAlbum = [];
    displayedArtistAlbum = allAlbum;
  }

  void filterAndFetchAlbum(String query) {
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

    // Use debounce to delay API calls
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(seconds: 1), () {
      fetchAlbum([query]);
    });
  }

  Future<void> fetchAlbum(List<String> albumNames) async {
    final AlbumModelOperations albumModelOperations = AlbumModelOperations();
    final List<AlbumModel> albums =
        await albumModelOperations.getAlbumModel(albumNames);
    setState(() {
      allAlbum = albums;
      filterAndFetchAlbum(searchController.text);
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
                  filterAndFetchAlbum(query);
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
                    '${displayedArtistAlbum.length} artists',
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
                    return GridTile(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(album.imageURL, scale: 1),
                                  fit: BoxFit.cover,
                                  onError: (exception, StackTrace) {
                                    print("Image failed to load : $exception");
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
                            album.soungsCount,
                            style: TextStyle(color: Colors.white),
                          )
                        ],
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
