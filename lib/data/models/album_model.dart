import 'package:equatable/equatable.dart';

class AlbumModel extends Equatable {
  final int userId;
  final int id;
  final String title;
  final String thumbnailUrl;

  const AlbumModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
  });

  factory AlbumModel.fromJson(Map<String, dynamic> json) {
    return AlbumModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  @override
  List<Object?> get props => [userId, id, title, thumbnailUrl];
}