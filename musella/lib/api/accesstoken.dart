import 'package:oauth2_client/access_token_response.dart';
import 'package:oauth2_client/spotify_oauth2_client.dart';

Future<void> RemoteService() async {
  AccessTokenResponse? accessToken;
  SpotifyOAuth2Client client = SpotifyOAuth2Client(
    customUriScheme: 'my.music.app',
    //Must correspond to the AndroidManifest's "android:scheme" attribute
    redirectUri:
        'my.music.app://callback', //Can be any URI, but the scheme part must correspond to the customeUriScheme
  );
  var authResp = await client.requestAuthorization(
      clientId: "4c6480b9dad641e0949b71b13d0ca7c0",
      customParams: {
        'show_dialog': 'true'
      },
      scopes: [
        'user-read-private',
        'user-read-playback-state',
        'user-modify-playback-state',
        'user-read-currently-playing',
        'user-read-email'
      ]);
  var authCode = authResp.code;

  accessToken = await client.requestAccessToken(
      code: authCode.toString(),
      clientId: "4c6480b9dad641e0949b71b13d0ca7c0",
      clientSecret: "d07d2808092846ae9a452961db39b7f2");

  // Global variables
  var Access_Token = accessToken.accessToken;
  var Refresh_Token = accessToken.refreshToken;
}
