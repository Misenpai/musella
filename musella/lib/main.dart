import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musella/aboutme/about_me.dart';
import 'package:musella/home/home.dart';
import 'package:musella/playlist/playlist.dart';
import 'package:musella/services/album_user_operation.dart';
import 'package:musella/services/artist_user_operations.dart';
import 'package:musella/services/music_operations.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await ArtistUserOperations.loadArtistList();
  await MusicOperations.loadMusicList();
  await AlbumUserOperations.loadAlbumList();
  runApp(ChangeNotifierProvider(
    create: (context) => MusicPlayerService(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Musella',
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      darkTheme: ThemeData(brightness: Brightness.dark),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomePage(),
        '/about': (context) => AboutMePage(),
        '/playlist': (context) => PlaylistPage(),
      },
      initialRoute: '/home',
    );
  }
}
