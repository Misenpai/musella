import 'package:musella/models/artist_user.dart';

class ArtistUserOperations {
  ArtistUserOperations._() {}
  static List<ArtistUser> getArtistUser() {
    return <ArtistUser>[
      ArtistUser(
          'https://discord.onl/wp-content/uploads/2023/08/Casual-Boywithuke-Server.jpg',
          'Boywithuke'),
      ArtistUser(
          'https://b.thumbs.redditmedia.com/lQWo1vNQCTd5FCTTIw9B784LvZUwHXUSp3k_pyzEfyk.png',
          'Porter Robinson'),
      ArtistUser(
          'https://images.crunchbase.com/image/upload/c_thumb,h_256,w_256,f_auto,g_faces,z_0.7,q_auto:eco,dpr_1/ptgfi7ayybd148ghc4o3',
          'Polo G')
    ];
  }
}
