import 'package:musella/models/album_model.dart';

class AlbumModelOperations {
  AlbumModelOperations._() {}
  static List<AlbumModel> getAlbumModel() {
    return <AlbumModel>[
      AlbumModel(
          'Nurture',
          'Porter Robinson',
          'https://st.cdjapan.co.jp/pictures/s/11/34/SICX-154.jpg?v=1',
          '14 songs',
          '2021'),
      AlbumModel(
          'Fever Dreams',
          'BoyWithUke',
          'https://e-cdn-images.dzcdn.net/images/cover/3800215eee0089eb807ef3cf489ed0ae/256x256-000000-80-0-0.jpg',
          '11 songs',
          '2021'),
      AlbumModel(
          'Lucid Dreams',
          'BoyWithUke',
          'https://is1-ssl.mzstatic.com/image/thumb/Music126/v4/1a/a2/c0/1aa2c0b5-ab3b-9d19-fce2-48a587b3c937/23UMGIM86999.rgb.jpg/256x256bb.jpg',
          '14 songs',
          '2023'),
      AlbumModel(
          'Good Faith',
          'Madeon',
          'https://e-cdn-images.dzcdn.net/images/cover/27443cda11b566a6679cdad635593600/256x256-000000-80-0-0.jpg',
          '10 songs',
          '2019'),
      AlbumModel(
          'だから僕は音楽を辞めた (That’s Why I Gave Up on Music)',
          'ヨルシカ (Yorushika)',
          'https://st.cdjapan.co.jp/pictures/s/00/10/DUED-1266.jpg?v=1',
          '14 songs',
          '2019'),
      AlbumModel(
          'Open α Door',
          'Aimer',
          'https://photo-resize-zmp3.zmdcdn.me/w256_r1x1_jpeg/cover/b/b/6/0/bb601cff1f047c719e777cbb01c38854.jpg',
          '12 songs',
          '2023'),
    ];
  }
}
