import 'package:flutter/material.dart';
import 'package:musella/home/widgit/header.dart';
import 'package:musella/home/widgit/pages/suggested/artist.dart';
import 'package:musella/home/widgit/pages/suggested/most_played.dart';
import 'package:musella/home/widgit/pages/suggested/recently_played.dart';
import 'package:musella/widgit/bottom_navigation.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppHeader(),
          RecentlyPlayed(),
          Artists(),
          MostPlayed(),
          BottomNavigation(),
        ],
      ),
    );
  }
}