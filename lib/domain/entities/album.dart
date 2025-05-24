import 'package:equatable/equatable.dart';

class Album extends Equatable {
  final int userId;
  final int id;
  final String title;
  final String thumbnailUrl;
  final String url;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.url,
  });

  @override
  List<Object?> get props => [userId, id, title, thumbnailUrl, url];
}
