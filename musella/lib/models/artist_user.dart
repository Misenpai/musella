class ArtistUser {
  String imageURL;
  String name;

  ArtistUser(this.imageURL, this.name);

  ArtistUser.fromJson(Map<String, dynamic> json)
    : imageURL = json['imageURL'],
      name = json['name'];

  Map<String, dynamic> toJson() => {
    'imageURL': imageURL,
    'name': name,
  };
}
