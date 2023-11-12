import 'package:musella/models/music.dart';

class MusicOperations {
  MusicOperations._() {}
  static List<Music> getMusic() {
    return <Music>[
      Music(
          'https://is1-ssl.mzstatic.com/image/thumb/Music116/v4/72/65/33/726533bf-25f1-094e-d818-3c85167664a0/23UMGIM58540.rgb.jpg/256x256bb.jpg',
          'Steal The Show',
          'Lauv'),
      Music(
          'https://c-cl.cdn.smule.com/rs-s88/arr/a0/e0/c92cc2bf-56ca-429c-b39f-288d70f1cbf9.jpg',
          'Shelter',
          'Porter Robinson & Madeon'),
      Music(
          'https://static.myfigurecollection.net/upload/items/1/1075080-d3811.jpg',
          'Kaikai Kitan',
          'Eve'),
    ];
  }
}
