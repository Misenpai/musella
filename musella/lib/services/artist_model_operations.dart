import 'package:musella/models/artist_model.dart';
import 'package:spotify/spotify.dart';

class ArtistModelOperations {
  late SpotifyApi spotify;

  ArtistModelOperations() {
    var credentials = SpotifyApiCredentials(
        "4c6480b9dad641e0949b71b13d0ca7c0", "d07d2808092846ae9a452961db39b7f2");
    spotify = SpotifyApi(credentials);
  }

  Future<List<ArtistModel>> getArtistModel(List<String> artistNames) async {
    List<ArtistModel> artists = [];

    try {
      for (var artistName in artistNames) {
        await _handleRateLimit(() async {
          var searchResults = await spotify.search.get(artistName).first(1);
          print('Searching for $artistName');

          for (var page in searchResults) {
            for (var item in page.items!) {
              if (item is Artist && item.id != null) {
                print('Found artist: ${item.name}');

                String imageURL = item.images?.first.url ?? 'default_image_url';
                String artist = item.name ?? 'Unknown Artist';

                artists.add(ArtistModel(
                  imageURL,
                  artist,
                ));
              }
            }
          }
        });
      }
    } catch (e) {
      print('Error fetching artists: $e');
    }

    return artists;
  }

  Future<void> _handleRateLimit(Future<void> Function() apiCall,
      {int maxRetries = 3}) async {
    int retries = 0;
    int delaySeconds = 1; // Start with a 1-second delay

    while (retries < maxRetries) {
      try {
        await apiCall();
        return;
      } catch (e) {
        if (retries < maxRetries - 1) {
          // Don't wait on the last retry
          await Future.delayed(Duration(seconds: delaySeconds));
          delaySeconds *= 2; // Double the delay for each retry
        }
        retries++;
      }
    }
  }
}
