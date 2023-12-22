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
    List<String> albumUris = [
      'spotify:album:4Hjqdhj5rh816i1dfcUEaM',
      'spotify:album:7AJPV0L05IyIBid97AvwVD',
    ];

    // Parallelize API calls
    var albumFetchTasks = albumUris.map((uri) => _fetchAlbumData(uri));
    var albumsData = await Future.wait(albumFetchTasks, eagerError: false);

    // Filter out null values (in case of failed fetches)
    return albumsData.whereType<AlbumModel>().toList();
  }

  Future<AlbumModel?> _fetchAlbumData(String uri) async {
    try {
      var albumId = uri.split(':').last; // Extract album ID from URI
      var album = await spotify.albums.get(albumId);
      var tracks = await spotify.albums.tracks(album.id!).all();

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
    } catch (e) {
      print('Error fetching album data for $uri: $e');
      return null; // Return null in case of an error
    }
  }
}
