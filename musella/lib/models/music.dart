class Music {
  String imagePath;
  String title;
  String artist;
  String audioURL;
  Music(this.imagePath, this.title, this.artist, this.audioURL);

  Music.fromJson(Map<String, dynamic> json)
      : imagePath = json['imagePath'],
        title = json['title'],
        artist = json['artist'],
        audioURL = json['audioURL'];
  Map<String, dynamic> toJson() => {
        'imagePath': imagePath,
        'title': title,
        'artist': artist,
        'audioURL': audioURL,
      };
}
