import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/album.dart';
import '../../../domain/repositories/album_repository.dart';
import 'album_event.dart';
import 'album_state.dart';

class AlbumBloc extends Bloc<AlbumEvent, AlbumState> {
  final AlbumRepository albumRepository;

  AlbumBloc({required this.albumRepository}) : super(AlbumInitial()) {
    on<FetchAlbums>(_onFetchAlbums);
    on<FetchAlbumDetails>(_onFetchAlbumDetails);
  }

  Future<void> _onFetchAlbums(
      FetchAlbums event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final albums = await albumRepository.getAlbums();
      emit(AlbumsLoaded(albums));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }

  Future<void> _onFetchAlbumDetails(
      FetchAlbumDetails event, Emitter<AlbumState> emit) async {
    emit(AlbumLoading());
    try {
      final album = await albumRepository.getAlbumDetails(event.albumId);
      emit(AlbumDetailsLoaded(album));
    } catch (e) {
      emit(AlbumError(e.toString()));
    }
  }
}