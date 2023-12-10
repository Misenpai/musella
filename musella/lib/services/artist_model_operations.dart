import 'package:musella/models/artist_model.dart';
import 'package:spotify/spotify.dart';

class ArtistModelOperations {
  late SpotifyApi spotify;

  ArtistModelOperations() {
    var keyMap = {
      "id": "4c6480b9dad641e0949b71b13d0ca7c0",
      "secret": "d07d2808092846ae9a452961db39b7f2"
    };

    var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    spotify = SpotifyApi(credentials);
  }

  Future<List<ArtistModel>> getArtistModel() async {
    print('Fetching artist data...');
    List<ArtistModel> artistsList = [];

    List<String> artistUris = [
      'spotify:artist:1Cd373x8qzC7SNUg5IToqp',
      'spotify:artist:3hOdow4ZPmrby7Q1wfPLEy',
      'spotify:artist:7EJYadnOoXsnXbvULN7YCR',
    ];

    try {
      for (var uri in artistUris) {
        var artistId = uri.split(':').last; // Extract artist ID from URI
        var artist = await spotify.artists.get(artistId);
        var albums = await spotify.artists.albums(artistId).all();

        String imageURL = artist.images?.first?.url ?? 'default_image_url';
        String artistName = artist.name ?? 'Unknown Artist';
        String albumCount = '${albums.length} Albums';

        int totalTracks = 0;
        for (var album in albums) {
          var tracks = await spotify.albums.getTracks(album.id ?? 'null').all();
          totalTracks += tracks.length;
        }
        String songsCount = '$totalTracks Songs';

        artistsList
            .add(ArtistModel(imageURL, artistName, albumCount, songsCount));
      }
      print('Artist data fetching complete.');
    } catch (e, stackTrace) {
      print('Error fetching artists: $e');
      print('StackTrace: $stackTrace');
    }
    return artistsList;
  }
}
