// ignore_for_file: empty_catches

import 'package:musella/api/credential.dart';
import 'package:musella/models/songs_model.dart';
import 'package:spotify/spotify.dart';

class SongsAlbumModelOperations {
  late SpotifyApi spotify;

  SongsAlbumModelOperations() {

    var credentials = SpotifyApiCredentials(SpotifyCredentials.clientId,
      SpotifyCredentials.clientSecret,);
    spotify = SpotifyApi(credentials);
  }

  Future<List<SongsModel>> getSongsAlbumModel(List<String> albumIds) async {
    List<SongsModel> songs = [];

    try {
      for (var albumId in albumIds) {
        var detailedAlbum = await spotify.albums.get(albumId);
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
