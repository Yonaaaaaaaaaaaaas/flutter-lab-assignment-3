import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'data/repositories/album_repository_impl.dart';
import 'domain/repositories/album_repository.dart';
import 'presentation/bloc/album/album_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Bloc
  sl.registerFactory(
        () => AlbumBloc(albumRepository: sl()),
  );

  // Repository
  sl.registerLazySingleton<AlbumRepository>(
        () => AlbumRepositoryImpl(client: sl()),
  );

  // External
  sl.registerLazySingleton(() => http.Client());
}