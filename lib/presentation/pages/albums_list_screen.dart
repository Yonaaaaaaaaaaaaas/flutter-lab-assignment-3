import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/album/album_bloc.dart';
import '../bloc/album/album_event.dart';
import '../bloc/album/album_state.dart';

class AlbumsListScreen extends StatelessWidget {
  const AlbumsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          if (state is AlbumLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AlbumsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<AlbumBloc>().add(FetchAlbums());
              },
              child: ListView.builder(
                itemCount: state.albums.length,
                itemBuilder: (context, index) {
                  final album = state.albums[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: CachedNetworkImage(
                        imageUrl: album.thumbnailUrl,
                        placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(album.title),
                      onTap: () => context.go('/album/${album.id}'),
                    ),
                  );
                },
              ),
            );
          } else if (state is AlbumError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AlbumBloc>().add(FetchAlbums());
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No albums found'));
        },
      ),
    );
  }
}