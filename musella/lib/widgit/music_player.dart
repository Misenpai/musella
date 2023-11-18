import 'package:flutter/material.dart';

class MusicPlayerPage extends StatelessWidget {
  final String imageURL;
  final String title;
  final String artist;

  const MusicPlayerPage({
    Key? key,
    required this.imageURL,
    required this.title,
    required this.artist,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Spacer(),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            artist,
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          Spacer(),
          Image.network(imageURL, fit: BoxFit.cover), // Your image widget here
          Spacer(),
          Slider(
            value: 0.5, // Current playback time in seconds
            min: 0,
            max: 100, // Total song duration in seconds
            onChanged: (value) {
              // Update the state to reflect the new position
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("03:35", style: TextStyle(color: Colors.white)),
                Text("03:50", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Icon(Icons.skip_previous, color: Colors.white),
                onPressed: () {
                  // Logic to skip to the previous song
                },
              ),
              IconButton(
                icon: Icon(Icons.pause_circle_filled,
                    color: Colors.orange, size: 64),
                onPressed: () {
                  // Logic to pause the song
                },
              ),
              IconButton(
                icon: Icon(Icons.skip_next, color: Colors.white),
                onPressed: () {
                  // Logic to skip to the next song
                },
              ),
            ],
          ),
          Spacer(),
          // Your lyrics button here
          Spacer(),
        ],
      ),
    );
  }
}
