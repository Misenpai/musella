import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:musella/aboutme/about_me.dart';
import 'package:musella/home/home.dart';
import 'package:musella/services/music_player_sevice.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
      },
      initialRoute: '/home',
    );
  }
}