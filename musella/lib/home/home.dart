import 'package:flutter/material.dart';
import 'package:musella/aboutme/about_me.dart';
import 'package:musella/home/widgit/header.dart';
import 'package:musella/home/widgit/pages/album/album.dart';
import 'package:musella/home/widgit/pages/artist/artists.dart';

import 'package:musella/home/widgit/pages/songs/songs.dart';
import 'package:musella/home/widgit/pages/suggested/artist.dart';
import 'package:musella/home/widgit/pages/suggested/recent_album.dart';
import 'package:musella/home/widgit/pages/suggested/recently_played.dart';
import 'package:musella/playlist/playlist.dart';
import 'package:musella/widgit/bottom_navigation.dart';
import 'package:musella/widgit/miniplayer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  // ignore: non_constant_identifier_names
  int index_bottom = 0;
  late PageController _pageController;

  String? currentImageUrl;
  String? currentTitle;
  String? currentArtist;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  Widget _buildPageContent() {
    switch (index_bottom) {
      case 0:
        return Column(
          children: [
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
        );
      case 1:
        return PlaylistPage();
      case 2:
        return AboutMePage();
      default:
        return Container();
    }
  }

  void _onCategorySelected(int index) {
    if (mounted) {
      setState(() {
        _selectedIndex = index;
        _pageController.animateToPage(
          _selectedIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void handleBackFromMusicPlayer(String url, String title, String artist) {
    if (mounted) {
      setState(() {
        currentImageUrl = url;
        currentTitle = title;
        currentArtist = artist;
      });
    }
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
              AlbumRecent(
                handleBackFromAlbumPlayerMostPlayed: handleBackFromMusicPlayer,
              ),
            ],
          ),
        ),
        SongsPage(handleBackFromMusicPlayer: handleBackFromMusicPlayer),
        ArtistPage(
          handleBackFromArtistSongPlayer: handleBackFromMusicPlayer,
        ),
        AlbumPage(
          handleBackFromAlbumSongPlayer: handleBackFromMusicPlayer,
        ),
      ],
    );
  }

  void _onBottomNavigationItemTapped(int index) {
    if (mounted) {
      setState(() {
        index_bottom = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
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
      ),
      body: SafeArea(
        child: _buildPageContent(),
      ),
      bottomNavigationBar: BottomNavigation(
        onItemSelected: _onBottomNavigationItemTapped,
      ),
    );
  }
}
