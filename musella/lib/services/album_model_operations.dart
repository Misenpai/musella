import 'package:musella/models/album_model.dart';
import 'package:spotify/spotify.dart';

class AlbumModelOperations {
  late SpotifyApi spotify;
  late List<String> albumNames;

  AlbumModelOperations() {
    var keyMap = {
      "id": "4c6480b9dad641e0949b71b13d0ca7c0",
      "secret": "d07d2808092846ae9a452961db39b7f2"
    };

    var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    spotify = SpotifyApi(credentials);
  }

  Future<List<AlbumModel>> getAlbumModel(List<String> albumNames) async {
    // Parallelize API calls
    var albumFetchTasks = albumNames.map((name) => _searchAlbumData(name));
    var albumsData = await Future.wait(albumFetchTasks, eagerError: false);

    // Filter out null values (in case of failed fetches)
    return albumsData.expand((data) => data).toList();
  }

  Future<List<AlbumModel>> _searchAlbumData(String name) async {
    const rateLimitDelay = Duration(milliseconds: 500);
    try {
      await Future.delayed(rateLimitDelay);
      var result =
          await spotify.search.get(name, types: [SearchType.album]).first();
      print('Search Result: $result');

      if (result.isEmpty || result.first.items == null) {
        print('No matching albums found');
        return [];
      }

      var albums = result.first.items!;
      // Print details of each album in the result
      albums.forEach((album) {
        print('Album ID: ${album.id}, Name: ${album.name}');
      });

      // Fetch album data for each album in the result
      var albumFetchTasks = albums.map((album) => _fetchAlbumData(album.id!));
      var albumsData = await Future.wait(albumFetchTasks, eagerError: false);

      // Filter out null values (in case of failed fetches)
      return albumsData.whereType<AlbumModel>().toList();
    } catch (e) {
      print('Error during search or album fetch: $e');
      return []; // Return an empty list in case of an error
    }
  }

  Future<AlbumModel?> _fetchAlbumData(String albumId) async {
    try {
      var album = await spotify.albums.get(albumId);
      var tracks = await spotify.albums.tracks(album.id ?? '').all();

      String imageURL = album.images?.first.url ?? 'default_image_url';
      String albumTitle = album.name ?? 'no album name';
      String artistName = album.artists?.first.name ?? 'no name';
      String year = album.releaseDate == null
          ? 'no release date'
          : DateTime.parse(album.releaseDate!).year.toString();
      String songCount = '${tracks.length} songs';
      print(
        "imageURL is : $imageURL \n albumTitle is : $albumTitle \n artist name is : $artistName \n year is : $year \n song count is : $songCount",
      );

      return AlbumModel(
        imageURL,
        albumTitle,
        artistName,
        songCount,
        year,
      );
    } catch (e) {
      print('Error during album fetch: $e');
      return null; // Return null in case of an error
    }
  }
}
