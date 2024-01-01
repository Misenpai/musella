class AlbumModel {
  String imageURL;
  String albumTitle;
  String artistName;
  String year;
  String songsCount;
  String id;

  AlbumModel(
    this.imageURL,
    this.albumTitle,
    this.artistName,
    this.year,
    this.songsCount,
    this.id
  );

  AlbumModel.fromJson(Map<String, dynamic> json)
      : imageURL = json['imageURL'],
        albumTitle = json['albumTitle'],
        artistName = json['artistName'],
        year = json['year'],
        songsCount = json['songsCount'],
        id = json['id'];
  Map<String, dynamic> toJson() => {
        'imageURL': imageURL,
        'albumTitle': albumTitle,
        'artistName': artistName,
        'year': year,
        'songsCount': songsCount,
        'id': id,
      };
}
