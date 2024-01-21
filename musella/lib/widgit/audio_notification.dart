import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:musella/services/music_player_sevice.dart';

// Ensure you initialize this plugin in your main() function
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initNotifications() async {
  // Configure notification channels (required for Android 8.0+)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'music_playback',
    'Music Playback',
    description: 'Notifications for music playback control',
    importance: Importance.low, // Adjust importance as needed
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Initialize the plugin for both Android and iOS
  const InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    iOS: IOSInitializationSettings(),
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

void displayNowPlayingNotification() async {
  final MusicPlayerService musicPlayerService = MusicPlayerService();
  final bool isPlaying = musicPlayerService.isPlaying;

  final String title = musicPlayerService.currentTitle ?? 'Unknown Title';
  final String artist = musicPlayerService.currentArtist ?? 'Unknown Artist';
  final String imageUrl = musicPlayerService.currentImageURL ?? '';

  // Assuming you have play and pause icons in your drawable resources
  final DrawableResourceAndroidBitmap playIcon =
      DrawableResourceAndroidBitmap('@drawable/ic_play');
  final DrawableResourceAndroidBitmap pauseIcon =
      DrawableResourceAndroidBitmap('@drawable/ic_pause');

  // Determine the correct icon to use
  final DrawableResourceAndroidBitmap icon = isPlaying ? pauseIcon : playIcon;

  final androidDetails = AndroidNotificationDetails(
    'music_playback',
    'Music Playback',
    channelDescription: 'Notifications for currently playing songs',
    importance: Importance.low,
    priority: Priority.low,
    ongoing: true,
    showProgress: true,
    maxProgress: 100,
    largeIcon: icon,
    styleInformation: BigPictureStyleInformation(
      DrawableResourceAndroidBitmap(imageUrl),
      contentTitle: title,
      summaryText: artist,
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
      largeIcon: DrawableResourceAndroidBitmap(imageUrl),
      hideExpandedLargeIcon: true,
    ),
  );

  final notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    artist,
    notificationDetails,
    payload: 'NowPlaying',
  );
}
