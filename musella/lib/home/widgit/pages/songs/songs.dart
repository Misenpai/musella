import 'package:flutter/material.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/songs_model_operations.dart';

class SongsPage extends StatelessWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SongsModel> songs = SongsModelOperations.getSongsModel();
    songs.sort((a, b) => a.title.compareTo(b.title));

    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${songs.length} Songs',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              InkWell(
                onTap: () {},
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ascending',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      Icons.arrow_downward,
                      color: Colors.orange,
                    )
                  ],
                ),
              )
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songs.length,
              itemBuilder: (context, index) {
                final song = songs[index];
                return ListTile(
                  leading: Image.network(song.imageURL),
                  title: Text(song.title), 
                  subtitle: Text('${song.artist} | ${song.duration}'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.play_circle_fill,
                      color: Colors.orange,
                    ),
                    onPressed: () {},
                  ), 
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
