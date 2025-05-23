import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/album/album_bloc.dart';
import '../bloc/album/album_event.dart';
import '../bloc/album/album_state.dart';

class AlbumDetailScreen extends StatelessWidget {
  final int albumId;

  const AlbumDetailScreen({super.key, required this.albumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Album Details')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumDetailsLoaded) {
            final album = state.album;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: CachedNetworkImage(
                          imageUrl: album.thumbnailUrl,
                          placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text('Title: ${album.title}',
                          style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text('Album ID: ${album.id}'),
                      const SizedBox(height: 10),
                      Text('User ID: ${album.userId}'),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is AlbumError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No details found'));
        },
      ),
    );
  }
}