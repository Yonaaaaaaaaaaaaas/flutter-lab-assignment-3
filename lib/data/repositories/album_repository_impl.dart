import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/entities/album.dart';
import '../../domain/repositories/album_repository.dart';
import '../models/album_model.dart';

class AlbumRepositoryImpl implements AlbumRepository {
  final http.Client client;

  AlbumRepositoryImpl({required this.client});

  @override
  Future<List<Album>> getAlbums() async {
    try {
      final albumsResponse = await client.get(
          Uri.parse('https://jsonplaceholder.typicode.com/albums'));
      final photosResponse = await client.get(
          Uri.parse('https://jsonplaceholder.typicode.com/photos'));

      if (albumsResponse.statusCode == 200 && photosResponse.statusCode == 200) {
        final List<dynamic> albumsJson = json.decode(albumsResponse.body);
        final List<dynamic> photosJson = json.decode(photosResponse.body);

        final List<Album> albums = [];

        for (var album in albumsJson) {
          final photo = photosJson.firstWhere(
                (p) => p['albumId'] == album['id'],
            orElse: () => {'thumbnailUrl': ''},
          );

          albums.add(Album(
            userId: album['userId'],
            id: album['id'],
            title: album['title'],
            thumbnailUrl: photo['thumbnailUrl'],
          ));
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
  Future<Album> getAlbumDetails(int id) async {
    try {
      final albumResponse = await client.get(
          Uri.parse('https://jsonplaceholder.typicode.com/albums/$id'));
      final photosResponse = await client.get(
          Uri.parse('https://jsonplaceholder.typicode.com/albums/$id/photos'));

      if (albumResponse.statusCode == 200 && photosResponse.statusCode == 200) {
        final albumJson = json.decode(albumResponse.body);
        final photosJson = json.decode(photosResponse.body);

        return Album(
          userId: albumJson['userId'],
          id: albumJson['id'],
          title: albumJson['title'],
          thumbnailUrl: photosJson.isNotEmpty ? photosJson[0]['thumbnailUrl'] : '',
        );
      } else {
        throw Exception('Failed to load album details');
      }
    } catch (e) {
      throw Exception('Failed to fetch album details: $e');
    }
  }
}