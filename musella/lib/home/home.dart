import 'package:flutter/material.dart';
import 'package:musella/home/widgit/header.dart';
import 'package:musella/home/widgit/pages/album/album.dart';
import 'package:musella/home/widgit/pages/artist/artists.dart';
import 'package:musella/home/widgit/pages/songs/songs.dart';
import 'package:musella/home/widgit/pages/suggested/artist.dart';
import 'package:musella/home/widgit/pages/suggested/most_played.dart';
import 'package:musella/home/widgit/pages/suggested/recently_played.dart';
import 'package:musella/widgit/bottom_navigation.dart';
import 'package:musella/widgit/miniplayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onCategorySelected(int index) {
    setState(
      () {
        _selectedIndex = index;
      },
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 1:
        return SongsPage();
      case 2:
        return ArtistPage();
      case 3:
        return AlbumPage();
      default:
        return SingleChildScrollView(
          child: Column(
            children: const [
              RecentlyPlayed(),
              Artists(),
              MostPlayed(),
            ],
          ),
        );
    }
  }

   String? currentImageUrl;
  String? currentTitle;
  String? currentArtist;

  void handleBackFromMusicPlayer(String url, String title, String artist) {
    setState(() {
      currentImageUrl = url;
      currentTitle = title;
      currentArtist = artist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  AppHeader(onCategorySelected: _onCategorySelected),
                  Expanded(
                    child: _buildBody(),
                  ),
                ],
              ),
            ),
            const MiniPlayer(),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
