import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'presentation/bloc/album/album_bloc.dart';
import 'presentation/bloc/album/album_event.dart';
import 'injection_container.dart' as di;
import 'presentation/pages/albums_list_screen.dart';
import 'presentation/pages/album_detail_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BlocProvider(
        create: (context) => di.sl<AlbumBloc>()..add(FetchAlbums()),
        child: const AlbumsListScreen(),
      ),
    ),
    GoRoute(
      path: '/album/:id',
      builder: (context, state) {
        final albumId = int.parse(state.pathParameters['id']!);
        return BlocProvider(
          create: (context) => di.sl<AlbumBloc>()..add(FetchAlbumDetails(albumId)),
          child: AlbumDetailScreen(albumId: albumId),
        );
      },
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Album App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: router,
    );
  }
}