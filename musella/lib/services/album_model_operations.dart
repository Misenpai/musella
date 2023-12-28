import 'package:musella/models/album_model.dart';
import 'package:spotify/spotify.dart';

class AlbumModelOperations {
  late SpotifyApi spotify;

  AlbumModelOperations() {
    var keyMap = {
      "id": "4c6480b9dad641e0949b71b13d0ca7c0",
      "secret": "d07d2808092846ae9a452961db39b7f2"
    };

    var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    spotify = SpotifyApi(credentials);
  }

  Future<List<AlbumModel>> getAlbumModel() async {
    List<String> albumNames = [
      'Boywithuke'
      // Add more album names as needed
    ];

    // Parallelize API calls
    var albumFetchTasks = albumNames.map((name) => _searchAlbumData(name));
    var albumsData = await Future.wait(albumFetchTasks, eagerError: false);

    // Filter out null values (in case of failed fetches)
    return albumsData.whereType<AlbumModel>().toList();
  }

  Future<AlbumModel?> _searchAlbumData(String name) async {
    try {
      var result =
          await spotify.search.get(name, types: [SearchType.album]).first();
      print(
          "search results are : ${result.runtimeType}, Items: ${result.length}");

      // Take the first album from the search results
      var album = result.first.items!.first;

      if (album != null) {
        var tracks = await spotify.albums.tracks(album.id).all();

        String imageURL = album.images?.first.url ?? 'default_image_url';
        String albumTitle = album.name ?? 'no album name';
        String artistName = album.artists?.first.name ?? 'no name';
        String year = album.releaseDate == null
            ? 'no release date'
            : DateTime.parse(album.releaseDate!).year.toString();
        String songCount = '${tracks.length} songs';

        return AlbumModel(
          imageURL,
          albumTitle,
          artistName,
          songCount,
          year,
        );
      }

      return null; // Return null if no album is found
    } catch (e) {
      return null; // Return null in case of an error
    }
  }
}
