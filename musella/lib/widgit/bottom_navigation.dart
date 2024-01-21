import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  final void Function(int) onItemSelected;
  // ignore: use_key_in_widget_constructors
  const BottomNavigation({Key? key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.playlist_play), label: 'Playlist'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'About Me'),
      ],
      onTap: onItemSelected,
    );
  }
}
