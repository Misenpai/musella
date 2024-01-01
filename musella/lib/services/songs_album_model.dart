import 'package:musella/models/songs_model.dart';
import 'package:spotify/spotify.dart';

class SongsAlbumModelOperations {
  late SpotifyApi spotify;

  SongsAlbumModelOperations() {
    var keyMap = {
      "id": "4c6480b9dad641e0949b71b13d0ca7c0",
      "secret": "d07d2808092846ae9a452961db39b7f2"
    };

    var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    spotify = SpotifyApi(credentials);
  }

  Future<List<SongsModel>> getSongsAlbumModel(List<String> albumIds) async {
    List<SongsModel> songs = [];

    try {
      for (var albumId in albumIds) {
        var detailedAlbum = await spotify.albums.get(albumId);
        // Ensure that tracks is treated as an Iterable
        var tracks = detailedAlbum.tracks;
        if (tracks != null) {
          for (var track in tracks) {
            String imageURL =
                detailedAlbum.images?.first.url ?? 'default_image_url';
            String title = track.name ?? 'Unknown Title';
            String artist = track.artists?.first.name ?? 'Unknown';
            String duration = _formatDuration(track.duration ?? Duration.zero);
            String audioURL = _extractTrackId(track.uri);

            songs.add(SongsModel(imageURL, title, artist, duration, audioURL));
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return songs;
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  String _extractTrackId(String? uri) {
    if (uri == null) return 'default_audio_id';
    var parts = uri.split(':');
    return parts.length >= 3 ? parts[2] : 'default_audio_id';
  }
}
