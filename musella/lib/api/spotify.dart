// ignore_for_file: avoid_print
import 'package:spotify/spotify.dart';

void main() async {
  var keyMap = {
    "id": "4c6480b9dad641e0949b71b13d0ca7c0",
    "secret": "d07d2808092846ae9a452961db39b7f2"
  };

  var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
  var spotify = SpotifyApi(credentials);

  print('\nPodcast:');
  await spotify.shows
      .get('6i9SWtZPb30xVXWVHSKCqq')
      .then((podcast) => print(podcast.name))
      .onError(
          (error, stackTrace) => print((error as SpotifyException).message));

  print('\nPodcast episode:');
  var episodes = spotify.shows.episodes('18HtQNjc5aGHwOeZ7YZzB2');
  await episodes.first().then((first) => print(first.items!.first)).onError(
      (error, stackTrace) => print((error as SpotifyException).message));

  print('\nArtists:');
  var artists = await spotify.artists.list(['1Cd373x8qzC7SNUg5IToqp']);
  artists.forEach((x) => print(x.name));

  print('\nAlbum:');
  var album = await spotify.albums.get('4KAtLRVIfB0bKnRY01dveY');
  print(album.name);

  print('\nAlbum Tracks:');
  var tracks = await spotify.albums.getTracks(album.id!).all();
  tracks.forEach((track) {
    print(track.name);
  });

  print('\nNew Releases');
  var newReleases = await spotify.browse.getNewReleases().first();
  newReleases.items!.forEach((album) => print(album.name));

  print('\nFeatured Playlist:');
  var featuredPlaylists = await spotify.playlists.featured.all();
  featuredPlaylists.forEach((playlist) {
    print(playlist.name);
  });

  print('\nUser\'s playlists:');
  var usersPlaylists =
      await spotify.playlists.getUsersPlaylists('superinteressante').all();
  usersPlaylists.forEach((playlist) {
    print(playlist.name);
  });

  print("\nSearching for \'Porter Robinson\':");
  var search = await spotify.search.get('Porter Robinson').first(2);

  search.forEach((pages) {
    if (pages.items == null) {
      print('Empty items');
    }
    pages.items!.forEach((item) {
      if (item is PlaylistSimple) {
        print('Playlist: \n'
            'id: ${item.id}\n'
            'name: ${item.name}:\n'
            'collaborative: ${item.collaborative}\n'
            'href: ${item.href}\n'
            'trackslink: ${item.tracksLink!.href}\n'
            'owner: ${item.owner}\n'
            'public: ${item.owner}\n'
            'snapshotId: ${item.snapshotId}\n'
            'type: ${item.type}\n'
            'uri: ${item.uri}\n'
            'images: ${item.images!.length}\n'
            '-------------------------------');
      }
      if (item is Artist) {
        print('Artist: \n'
            'id: ${item.id}\n'
            'name: ${item.name}\n'
            'href: ${item.href}\n'
            'type: ${item.type}\n'
            'uri: ${item.uri}\n'
            'popularity: ${item.popularity}\n'
            '-------------------------------');
      }
      if (item is Track) {
        print('Track:\n'
            'id: ${item.id}\n'
            'name: ${item.name}\n'
            'href: ${item.href}\n'
            'type: ${item.type}\n'
            'uri: ${item.uri}\n'
            'isPlayable: ${item.isPlayable}\n'
            'artists: ${item.artists!.length}\n'
            'availableMarkets: ${item.availableMarkets!.length}\n'
            'discNumber: ${item.discNumber}\n'
            'trackNumber: ${item.trackNumber}\n'
            'explicit: ${item.explicit}\n'
            'popularity: ${item.popularity}\n'
            '-------------------------------');
      }
      if (item is AlbumSimple) {
        print('Album:\n'
            'id: ${item.id}\n'
            'name: ${item.name}\n'
            'href: ${item.href}\n'
            'type: ${item.type}\n'
            'uri: ${item.uri}\n'
            'albumType: ${item.albumType}\n'
            'artists: ${item.artists!.length}\n'
            'availableMarkets: ${item.availableMarkets!.length}\n'
            'images: ${item.images!.length}\n'
            'releaseDate: ${item.releaseDate}\n'
            'releaseDatePrecision: ${item.releaseDatePrecision}\n'
            '-------------------------------');
      }
    });
  });

  var relatedArtists =
      await spotify.artists.relatedArtists('0OdUWJ0sBjDrqHygGUXeCF');
  print('\nRelated Artists: ${relatedArtists.length}');

  credentials = await spotify.getCredentials();
  print('\nCredentials:');
  print('Client Id: ${credentials.clientId}');
  print('Access Token: ${credentials.accessToken}');
  print('Credentials Expired: ${credentials.isExpired}');
}
