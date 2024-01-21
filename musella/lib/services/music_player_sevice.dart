import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musella/models/playlist_play.dart';
import 'package:musella/models/songs_model.dart';
import 'package:musella/services/music_operations.dart';
import 'package:spotify/spotify.dart' as Spotify;
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class MusicPlayerService with ChangeNotifier {
  final AudioPlayer player = AudioPlayer();
  Duration? duration;
  Duration positions = Duration.zero;
  late final StreamSubscription playerStateChangedSubscription;
  int currentAlbumSongIndex = 0;
  int currentPlaylistSongIndex = 0;
  List<SongsModel>? albumSongtemp;
  List<PlaylistPlayModel>? playlistSongtemp;
  bool isShuffling = false;

  String? currentImageURL;
  String? currentTitle;
  String? currentArtist;
  String? currentAudioURL;
  List<SongsModel>? albumSong;
  List<PlaylistPlayModel>? playlistSong;
  int? currentSongIndex;

  bool get isPlaying => player.playing;

  void updateCurrentSong({
    String? imageURL,
    String? title,
    String? artist,
    String? audioURL,
    List<SongsModel>? albumSongs,
    List<PlaylistPlayModel>? playlistSongs,
    int? songIndex,
  }) {
    currentImageURL = imageURL;
    currentTitle = title;
    currentArtist = artist;
    currentAudioURL = audioURL;
    albumSong = albumSongs;
    playlistSong = playlistSongs;
    currentSongIndex = songIndex;
    notifyListeners();
  }

  void initState() {
    initializeMusic();
    playerStateChangedSubscription = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        initializeMusic();
        playNextSong();
      }
    });
  }

  Future<void> initializeMusic() async {
    currentAlbumSongIndex = currentSongIndex!;
    currentPlaylistSongIndex = currentSongIndex!;
    albumSongtemp = albumSong;
    playlistSongtemp = playlistSong;
    print("playlistsongtemp is : $playlistSongtemp");
    MusicOperations.addMusic(
      currentImageURL ?? '',
      currentTitle ?? '',
      currentArtist ?? '',
      currentAudioURL ?? '',
    );
    await fetchAndPlaySong(currentAudioURL);
  }

  Future<void> fetchAndPlaySong(String? audioURL) async {
    if (currentAudioURL == null) return;
    final credentials = Spotify.SpotifyApiCredentials(
        "4c6480b9dad641e0949b71b13d0ca7c0", "d07d2808092846ae9a452961db39b7f2");
    final spotify = Spotify.SpotifyApi(credentials);
    final yt = YoutubeExplode();
    print("Audio URL is : ${currentAudioURL}");
    try {
      final track = await spotify.tracks.get(audioURL ?? '');
      String? songname = track.name;
      String? artistName = track.artists?.first.name;
      if (songname != null) {
        final video = (await yt.search.search('$artistName $songname')).first;
        final videoId = video.id.value;
        duration = video.duration;
        var manifest = await yt.videos.streamsClient.getManifest(videoId);
        var audioId = manifest.audioOnly.first.url;
        play(audioId.toString());
        player.playerStateStream.listen(
          (position) {
            positions = player.position;
          },
        );
        positions = Duration.zero;
      }
    } finally {
      yt.close();
    }
  }

  Future<void> playNextSong() async {
    if (isShuffling) {
      try {
        List<dynamic> shuffledSongs = [];
        if (albumSongtemp != null) {
          shuffledSongs.addAll(albumSongtemp!);
        } else if (playlistSongtemp != null) {
          shuffledSongs.addAll(playlistSongtemp!);
        }
        print("shuffle playlist is : $shuffledSongs");

        shuffledSongs.shuffle();

        print(
            "Current Song - URL: $currentAudioURL, Title: $currentTitle, Artist: $currentArtist");

        int currentIndex = shuffledSongs.indexWhere((song) =>
            (song is SongsModel &&
                song.audioURL == currentAudioURL &&
                song.imageURL == currentImageURL &&
                song.title == currentTitle &&
                song.artist == currentArtist) ||
            (song is PlaylistPlayModel &&
                song.audioURL == currentAudioURL &&
                song.imagePath == currentImageURL &&
                song.title == currentTitle &&
                song.artist == currentArtist));

        print("Current Index: $currentIndex");

        if (currentIndex == -1) {
          print("Error: Current song not found in shuffled list.");
          return;
        }

        int nextIndex = (currentIndex + 1) % shuffledSongs.length;

        var nextSong = shuffledSongs[nextIndex];
        if (nextSong is SongsModel) {
          updateCurrentSong(
            imageURL: nextSong.imageURL,
            title: nextSong.title,
            artist: nextSong.artist,
            audioURL: nextSong.audioURL,
            albumSongs: albumSongtemp,
            songIndex: nextIndex,
          );
        } else if (nextSong is PlaylistPlayModel) {
          updateCurrentSong(
            imageURL: nextSong.imagePath,
            title: nextSong.title,
            artist: nextSong.artist,
            audioURL: nextSong.audioURL,
            playlistSongs: playlistSongtemp,
            songIndex: nextIndex,
          );
        }

        await initializeMusic();
        await fetchAndPlaySong(currentAudioURL);

        print(
            "Next Song - URL: $currentAudioURL, Title: $currentTitle, Artist: $currentArtist");
      } catch (e) {
        print("Error during song shuffling: $e");
      }
    } else {
      if (albumSongtemp != null &&
          currentAlbumSongIndex < albumSongtemp!.length - 1) {
        print("Playing next song from album : $currentAlbumSongIndex");
        currentAlbumSongIndex++;
        SongsModel nextSong = albumSongtemp![currentAlbumSongIndex];
        currentImageURL = nextSong.imageURL;
        currentTitle = nextSong.title;
        currentArtist = nextSong.artist;
        currentAudioURL = nextSong.audioURL;
        updateCurrentSong(
          imageURL: nextSong.imageURL,
          title: nextSong.title,
          artist: nextSong.artist,
          audioURL: nextSong.audioURL,
          albumSongs: albumSongtemp,
          songIndex: currentAlbumSongIndex,
        );
        await initializeMusic();
        await fetchAndPlaySong(nextSong.audioURL);
      }
      if (playlistSongtemp != null &&
          currentPlaylistSongIndex < playlistSongtemp!.length - 1) {
        int nextIndex = currentPlaylistSongIndex + 1;
        PlaylistPlayModel nextSong = playlistSongtemp![nextIndex];

        currentPlaylistSongIndex = nextIndex;
        currentImageURL = nextSong.imagePath;
        currentTitle = nextSong.title;
        currentArtist = nextSong.artist;
        currentAudioURL = nextSong.audioURL;

        updateCurrentSong(
          imageURL: nextSong.imagePath,
          title: nextSong.title,
          artist: nextSong.artist,
          audioURL: nextSong.audioURL,
          playlistSongs: playlistSongtemp,
          songIndex: nextIndex,
        );
        await initializeMusic();
        await fetchAndPlaySong(nextSong.audioURL);
      } else {
        print("No more songs to play");
        print("albumsong is : ${albumSongtemp}");
      }
    }
  }

  Future<void> playPreviousSong() async {
    if (albumSongtemp != null && currentAlbumSongIndex > 0) {
      currentAlbumSongIndex--;
      SongsModel previousSong = albumSongtemp![currentAlbumSongIndex];

      currentImageURL = previousSong.imageURL;
      currentTitle = previousSong.title;
      currentTitle = previousSong.artist;
      currentAudioURL = previousSong.audioURL;

      updateCurrentSong(
        imageURL: previousSong.imageURL,
        title: previousSong.title,
        artist: previousSong.artist,
        audioURL: previousSong.audioURL,
        albumSongs: albumSongtemp,
        songIndex: currentAlbumSongIndex,
      );
      await initializeMusic();
      await fetchAndPlaySong(previousSong.audioURL);
    } else if (playlistSongtemp != null && currentPlaylistSongIndex > 0) {
      currentPlaylistSongIndex--;
      PlaylistPlayModel previousSong =
          playlistSongtemp![currentPlaylistSongIndex];

      currentImageURL = previousSong.imagePath;
      currentTitle = previousSong.title;
      currentTitle = previousSong.artist;
      currentAudioURL = previousSong.audioURL;

      updateCurrentSong(
        imageURL: previousSong.imagePath,
        title: previousSong.title,
        artist: previousSong.artist,
        audioURL: previousSong.audioURL,
        playlistSongs: playlistSongtemp,
        songIndex: currentPlaylistSongIndex,
      );
      await initializeMusic();
      await fetchAndPlaySong(previousSong.audioURL);
    }
  }

  Future<void> shuffleSongs() async {
    isShuffling = !isShuffling;
  }

  Future<void> play(String url) async {
    try {
      await player.setUrl(url);
      await player.play();
      notifyListeners();
    } catch (e) {
      print('Error during play: $e');
    }
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      player.pause();
    } else {
      player.play();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    player.dispose();
    playerStateChangedSubscription.cancel();
    super.dispose();
  }
}
