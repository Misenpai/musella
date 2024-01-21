import 'package:musella/api/credential.dart';
import 'package:musella/models/album_model.dart';
import 'package:spotify/spotify.dart';

class AlbumModelOperations {
  late SpotifyApi spotify;
  late List<String> albumNames;

  AlbumModelOperations() {
    var credentials = SpotifyApiCredentials(SpotifyCredentials.clientId,
      SpotifyCredentials.clientSecret,);
    spotify = SpotifyApi(credentials);
  }

  Future<List<AlbumModel>> getArtistModel(List<String> albumNames) async {
    List<AlbumModel> albums = [];
    try {
      for (var albumName in albumNames) {
        var searchResults = await spotify.search.get(albumName).first();

        for (var page in searchResults) {
          for (var item in page.items!) {
            if (item is AlbumSimple) {
              var detailedAlbum = await spotify.albums.get(item.id ?? '');
              String imageURL = item.images?.first.url ?? "No image";
              String albumTitle = item.name ?? "No title";
              String artistName = item.artists?.first.name ?? '';
              String year = item.releaseDate ?? '';
              String songCount = detailedAlbum.tracks != null
                  ? '${detailedAlbum.tracks!.length} songs'
                  : 'No tracks';
              String id = detailedAlbum.id??'';

              albums.add(AlbumModel(
                  imageURL, albumTitle, artistName, year, songCount,id));
            }
          }
        }
      }
    // ignore: empty_catches
    } catch (e) {
    }
    return albums;
  }
}
