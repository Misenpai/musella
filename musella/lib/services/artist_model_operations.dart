import 'package:musella/models/artist_model.dart';

class ArtistModelOperations {
  ArtistModelOperations._() {}
  static List<ArtistModel> getArtistModel() {
    return <ArtistModel>[
      ArtistModel(
          'https://b.thumbs.redditmedia.com/lQWo1vNQCTd5FCTTIw9B784LvZUwHXUSp3k_pyzEfyk.png',
          '2 Albums',
          'Porter Robinson',
          '29 Songs'),
      ArtistModel(
          'https://styles.redditmedia.com/t5_5utgd6/styles/profileIcon_2zwlogx6zgsb1.jpg?width=256&height=256&frame=1&auto=webp&crop=256:256,smart&s=bd42a6e6116278ffee75e51901f375d9ca244778',
          '4 Albums',
          'BoyWithUke',
          '62 Songs'),
      ArtistModel(
          'https://na.cdn.beatsaver.com/bbcd94bc0835cd5ad6b0869303c1d0197bbd1730.jpg',
          '8 8 Albums',
          'Madeon',
          '108 Songs'),
      ArtistModel(
          'https://cachedimages.podchaser.com/256x256/aHR0cHM6Ly9jcmVhdG9yLWltYWdlcy5wb2RjaGFzZXIuY29tLzgyNWE3MTkxYmY1NmIzNmVmYzg5MzAxZTE1YzQ0ZmRmLmpwZWc%3D/aHR0cHM6Ly93d3cucG9kY2hhc2VyLmNvbS9pbWFnZXMvbWlzc2luZy1pbWFnZS5wbmc%3D',
          '22 Albums',
          'Lauv',
          '250 Songs'),
      ArtistModel(
          'https://c-cl.cdn.smule.com/rs-s-sf-4/arr/9c/35/a16f1579-a9aa-469e-8080-ef1445ccd49a.jpg',
          '13 Albums',
          'Powfu',
          '251 Songs'),
      ArtistModel('https://discord.onl/wp-content/uploads/2023/08/Aries.jpg',
          '5 Albums', 'Aries', '134 Songs'),
    ];
  }
}
