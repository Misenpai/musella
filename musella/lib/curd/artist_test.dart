class ArtistUserDatabase {
  int? id;
  String imageURL;
  String artistName;

  ArtistUserDatabase({this.id, required this.imageURL, required this.artistName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imageURL': imageURL,
      'artistName': artistName,
    };
  }

  factory ArtistUserDatabase.fromMap(Map<String, dynamic> map) {
    return ArtistUserDatabase(
      id: map['id'],
      imageURL: map['imageURL'],
      artistName: map['artistName'],
    );
  }
}
