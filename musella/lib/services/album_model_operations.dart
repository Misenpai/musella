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
    List<AlbumModel> albumList = [];
    List<String> albumUris = [
      'spotify:album:4Hjqdhj5rh816i1dfcUEaM',
      'spotify:album:7AJPV0L05IyIBid97AvwVD',
    ];

    try {
      for (var uri in albumUris) {
        var albumId = uri.split(':').last; // Extract album ID from URI
        var album = await spotify.albums.get(albumId);
        var tracks = await spotify.albums.tracks(album.id!).all();

        String imageURL = album.images?.first?.url ?? 'default_image_url';
        String albumTitle = album.name ?? 'no album name';
        String artistName = album.artists?.first.name ?? 'no name';
        String year = album.releaseDate == null
            ? 'no release date'
            : DateTime.parse(album.releaseDate!).year.toString();
        String songCount = '${tracks.length} songs';

        albumList.add(AlbumModel(
          imageURL,
          albumTitle,
          artistName,
          songCount,
          year,
        ));
      }
    } on FormatException catch (formatException) {
      print('Error parsing response: $formatException');
    } catch (e) {
      print('Error fetching album details: $e');
    }

    return albumList;
  }
}
