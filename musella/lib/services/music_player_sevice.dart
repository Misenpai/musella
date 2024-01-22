// ignore_for_file: library_prefixes, empty_catches

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

  Future<void> initializeMusic() async {
    currentAlbumSongIndex = currentSongIndex!;
    currentPlaylistSongIndex = currentSongIndex!;
    albumSongtemp = albumSong;
    playlistSongtemp = playlistSong;
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
        await play(audioId.toString());
        notifyListeners();
        await player.playerStateStream.firstWhere((position) =>
            position.processingState == ProcessingState.completed);
        await playNextSong();
      }
    } finally {
      yt.close();
    }
  }

  Future<void> playNextSong() async {
    print("is shuffling value : $isShuffling");
    if (isShuffling) {
      try {
        List<dynamic> shuffledSongs = [];
        if (albumSongtemp != null) {
          shuffledSongs.addAll(albumSongtemp!);
          shuffledSongs.shuffle();

          int currentIndex = shuffledSongs.indexWhere((song) =>
              song.audioURL == currentAudioURL &&
              song.imageURL == currentImageURL &&
              song.title == currentTitle &&
              song.artist == currentArtist);

          if (currentIndex == -1) {
            return;
          }

          int nextIndex = (currentIndex + 1) % shuffledSongs.length;

          var nextSong = shuffledSongs[nextIndex];

          currentImageURL = nextSong.imageURL;
          currentTitle = nextSong.title;
          currentArtist = nextSong.artist;
          currentAudioURL = nextSong.audioURL;

          updateCurrentSong(
            imageURL: currentImageURL,
            title: currentTitle,
            artist: currentArtist,
            audioURL: currentAudioURL,
            albumSongs: albumSongtemp,
            songIndex: nextIndex,
          );
          MusicOperations.addMusic(
            currentImageURL ?? '',
            currentTitle ?? '',
            currentArtist ?? '',
            currentAudioURL ?? '',
          );
          await fetchAndPlaySong(nextSong.audioURL);
        } else if (playlistSongtemp != null) {
          shuffledSongs.addAll(playlistSongtemp!);
          shuffledSongs.shuffle();

          int currentIndex = shuffledSongs.indexWhere((song) =>
              song.audioURL == currentAudioURL &&
              song.imagePath == currentImageURL &&
              song.title == currentTitle &&
              song.artist == currentArtist);

          if (currentIndex == -1) {
            return;
          }

          int nextIndex = (currentIndex + 1) % shuffledSongs.length;

          var nextSong = shuffledSongs[nextIndex];

          currentImageURL = nextSong.imagePath;
          currentTitle = nextSong.title;
          currentArtist = nextSong.artist;
          currentAudioURL = nextSong.audioURL;

          updateCurrentSong(
            imageURL: currentImageURL,
            title: currentTitle,
            artist: currentArtist,
            audioURL: currentAudioURL,
            playlistSongs: playlistSongtemp,
            songIndex: nextIndex,
          );
          MusicOperations.addMusic(
            currentImageURL ?? '',
            currentTitle ?? '',
            currentArtist ?? '',
            currentAudioURL ?? '',
          );
          await fetchAndPlaySong(nextSong.audioURL);
        }
      } catch (e) {}
    } else {
      if (albumSongtemp != null &&
          currentAlbumSongIndex < albumSongtemp!.length - 1) {
        currentAlbumSongIndex++;
        SongsModel nextSong = albumSongtemp![currentAlbumSongIndex];
        currentImageURL = nextSong.imageURL;
        currentTitle = nextSong.title;
        currentArtist = nextSong.artist;
        currentAudioURL = nextSong.audioURL;
        currentSongIndex = currentAlbumSongIndex;
        updateCurrentSong(
          imageURL: nextSong.imageURL,
          title: nextSong.title,
          artist: nextSong.artist,
          audioURL: nextSong.audioURL,
          albumSongs: albumSongtemp,
          songIndex: currentAlbumSongIndex,
        );
        MusicOperations.addMusic(
          nextSong.imageURL,
          nextSong.title,
          nextSong.artist,
          nextSong.audioURL,
        );
        await fetchAndPlaySong(nextSong.audioURL);
      }
      if (playlistSongtemp != null &&
          currentPlaylistSongIndex < playlistSongtemp!.length - 1) {
        currentPlaylistSongIndex++;
        PlaylistPlayModel nextSong =
            playlistSongtemp![currentPlaylistSongIndex];
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
          songIndex: currentPlaylistSongIndex,
        );
        MusicOperations.addMusic(
          nextSong.imagePath,
          nextSong.title,
          nextSong.artist,
          nextSong.audioURL,
        );
        await fetchAndPlaySong(nextSong.audioURL);
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
      MusicOperations.addMusic(
        previousSong.imageURL,
        previousSong.title,
        previousSong.artist,
        previousSong.audioURL,
      );
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
      MusicOperations.addMusic(
        previousSong.imagePath,
        previousSong.title,
        previousSong.artist,
        previousSong.audioURL,
      );
      await fetchAndPlaySong(previousSong.audioURL);
    }
  }

  Future<void> shuffleSongs() async {
    isShuffling = !isShuffling;
    notifyListeners();
  }

  Future<void> play(String url) async {
    try {
      await player.setUrl(url);
      await player.play();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> togglePlayPause() async {
    if (isPlaying) {
      player.pause();
    } else {
      player.play();
    }
    notifyListeners();
  }
}
