import 'package:flutter/material.dart';
import 'package:musella/home/widgit/header.dart';
import 'package:musella/home/widgit/pages/album/playlist.dart';
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
  late PageController _pageController;

  String? currentImageUrl;
  String? currentTitle;
  String? currentArtist;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(
        _selectedIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void handleBackFromMusicPlayer(String url, String title, String artist) {
    setState(() {
      currentImageUrl = url;
      currentTitle = title;
      currentArtist = artist;
    });
  }

  Widget _buildBody() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              RecentlyPlayed(
                handleBackFromMusicPlayerRecentlyPlayed:
                    handleBackFromMusicPlayer,
              ),
              Artists(
                handleBackFromArtistSongPlayer: handleBackFromMusicPlayer,
              ),
              MostPlayed(
                handleBackFromMusicPlayerMostPlayed: handleBackFromMusicPlayer,
              ),
            ],
          ),
        ),
        SongsPage(handleBackFromMusicPlayer: handleBackFromMusicPlayer),
        ArtistPage(
          handleBackFromArtistSongPlayer: handleBackFromMusicPlayer,
        ),
        AlbumPage(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.music_note, // Choose the appropriate icon
                  color: Colors.orange, // Set the desired color
                ),
                SizedBox(width: 8),
                Text(
                  'Musella',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  AppHeader(
                    onCategorySelected: _onCategorySelected,
                    pageController: _pageController,
                  ),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
            MiniPlayer(
              imageURL: currentImageUrl,
              title: currentTitle,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavigation(),
    );
  }
}
