import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:album_app/presentation/bloc/album/album_bloc.dart';
import 'package:album_app/presentation/bloc/album/album_event.dart';
import 'package:album_app/presentation/pages/albums_list_screen.dart';
import 'package:album_app/presentation/pages/album_detail_screen.dart';
import '../../../injection_container.dart' as di;

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (_) => di.sl<AlbumBloc>()..add(FetchAlbums()),
        child: const AlbumsListScreen(),
      ),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
        final albumId = int.parse(state.pathParameters['id']!);
        return BlocProvider(
          create: (_) => di.sl<AlbumBloc>()..add(FetchAlbumPhotos(albumId)),
          child: AlbumDetailScreen(albumId: albumId),
        );
      },
    ),
  ],
);
