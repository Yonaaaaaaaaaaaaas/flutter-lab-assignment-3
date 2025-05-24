import '../entities/album.dart';

abstract class AlbumRepository {
  Future<List<Album>> getAlbums();
  Future<List<Album>> getAlbumPhotos(int albumId);
}
