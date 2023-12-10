import 'package:musella/models/songs_model.dart';
import 'package:spotify/spotify.dart';

class SongsModelOperations {
  late SpotifyApi spotify;

  SongsModelOperations() {
    var keyMap = {
      "id": "4c6480b9dad641e0949b71b13d0ca7c0",
      "secret": "d07d2808092846ae9a452961db39b7f2"
    };

    var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    spotify = SpotifyApi(credentials);
  }

  Future<List<SongsModel>> getSongsModel(List<String> artistNames) async {
    List<SongsModel> songs = [];

    try {
      for (var artistName in artistNames) {
        var searchResults = await spotify.search.get(artistName).first(10);

        for (var page in searchResults) {
          for (var item in page.items!) {
            if (item is Track) {
              String imageURL =
                  item.album?.images?.first?.url ?? 'default_image_url';
              String title = item.name ?? 'Unknown Title';
              String artist = item.artists?.first?.name ?? 'Unknown';
              String duration = _formatDuration(item.duration ?? Duration.zero);

              songs.add(SongsModel(imageURL, title, artist, duration));
            }
          }
        }
      }
    } catch (e) {
      print('Error fetching songs: $e');
    }

    return songs;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }
}
