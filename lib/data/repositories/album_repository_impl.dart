import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/entities/album.dart';
import '../../domain/repositories/album_repository.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final http.Client client;

  AlbumRepositoryImpl({required this.client});

  @override
  Future<List<Album>> getAlbums() async {
    try {
      final albumsResponse = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/albums'),
      );
      final photosResponse = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/photos'),
      );

      if (albumsResponse.statusCode == 200 &&
          photosResponse.statusCode == 200) {
        final List<dynamic> albumsJson = json.decode(albumsResponse.body);
        final List<dynamic> photosJson = json.decode(photosResponse.body);

        final List<Album> albums = [];

        for (var album in albumsJson) {
          final photo = photosJson.firstWhere(
            (p) => p['albumId'] == album['id'],
            orElse: () => {'thumbnailUrl': '', 'url': ''},
          );

          albums.add(
            Album(
              userId: album['userId'],
              id: album['id'],
              title: album['title'],
              thumbnailUrl: photo['thumbnailUrl'],
              url: photo['url'],
            ),
          );
        }
        return albums;
      } else {
        throw Exception('Failed to load albums');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  @override
  Future<List<Album>> getAlbumPhotos(int albumId) async {
    try {
      final response = await client.get(
        Uri.parse(
          'https://jsonplaceholder.typicode.com/albums/$albumId/photos',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> photosJson = json.decode(response.body);
        return photosJson
            .map(
              (photo) => Album(
                userId: photo['albumId'],
                id: photo['id'],
                title: photo['title'],
                thumbnailUrl: photo['thumbnailUrl'],
                url: photo['url'],
              ),
            )
            .toList();
      } else {
        throw Exception('Failed to load album photos');
      }
    } catch (e) {
      throw Exception('Failed to fetch album photos: $e');
    }
  }
}
