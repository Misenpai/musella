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

  Future<List<AlbumModel>> getArtistModel(List<String> albumNames) async {
    List<AlbumModel> albums = [];
    try {
      for (var albumName in albumNames) {
        var searchResults = await spotify.search.get(albumName).first();

        print('Search Result: $searchResults');
        for (var page in searchResults) {
          for (var item in page.items!) {
            if (item is AlbumSimple) {
              var detailedAlbum = await spotify.albums.get(item.id ?? '');
              print("Detailed Album is : $detailedAlbum");
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
    } catch (e) {
      print('Error fetching data: $e');
    }
    return albums;
  }
}
