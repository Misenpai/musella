// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:audio_service/audio_service.dart';
// import 'package:audio_session/audio_session.dart';
// import 'package:flutter/services.dart';
// import 'package:musella/services/music_player_sevice.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Notification Player',
//       home: NotificationPlayer(),
//     );
//   }
// }

// class NotificationPlayer extends StatefulWidget {
//   @override
//   _NotificationPlayerState createState() => _NotificationPlayerState();
// }

// class _NotificationPlayerState extends State<NotificationPlayer> {
//   late AudioPlayer _player;
//   late AudioService _audioHandler;
//   final _mediaItemExpando = Expando<MediaItem>();

//   @override
//   void initState() {
//     super.initState();
//     _player = AudioPlayer();
//     _audioHandler = await AudioService.init(
//       builder: () => AudioPlayerHandler(_player),
//       config: AudioServiceConfig(
//         androidNotificationChannelId: 'com.example.app_name',
//         androidNotificationChannelName: 'App Name',
//         androidNotificationOngoing: true,
//       ),
//     );

//     // Get the current song information from MusicPlayerService
//     _audioHandler.currentMediaItemStream.listen((mediaItem) {
//       // Update notification with the current song information
//       _audioHandler.setMediaItem(mediaItem);
//     });
//   }

//   // ... other methods for controlling playback

//   @override
//   void dispose() {
//     _audioHandler.stop();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // ... UI elements for controlling playback
//   }
// }

// class AudioPlayerHandler extends BaseAudioHandler {
//   final AudioPlayer _player;

//   AudioPlayerHandler(this._player);

//   @override
//   Future<void> setMediaItem(MediaItem mediaItem) async {
//     // ... set the media item and update notification metadata
//   }

//   // ... other methods for handling audio playback
// }
