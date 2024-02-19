import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_text/domain/models/item.dart';
import 'package:flutter_text/domain/usecases/get_photos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'photos_event.dart';
part 'photos_state.dart';
part 'photos_bloc.freezed.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  List<Item> photoscached = [];
  String tokenSession = '';
  String oldtokenSession = '';
  bool isLoading = false;
  bool _isFirstFetch = true;
  final GetPhotos getPhotos;
  PhotosBloc({
    required this.getPhotos,
  }) : super(const _Loading([])) {
    on<_GetPhotos>(_onPhotosLoadEvent);
  }

  void _onPhotosLoadEvent(
    _GetPhotos event,
    Emitter<PhotosState> emit,
  ) async {
    if (isLoading) {
      return;
    }
    isLoading = true;
    if (_isFirstFetch == false && tokenSession == 'token expired') {
      return emit(_Loading(photoscached));
    }
    emit(_Loading(photoscached));

    final photos = await getPhotos(GetPhotosParams(contToken: tokenSession));

    await photos.fold((failure) async {
      debugPrint('error');
      emit(_Loading(photoscached));
      final errorphotos =
          await getPhotos(GetPhotosParams(contToken: oldtokenSession));
      await errorphotos.fold((failure) async {
        emit(const _LoadingError(
          '',
        ));
      }, (rightphotos) async {
        debugPrint('error to right ${rightphotos.token}');
        _isFirstFetch = false;
        isLoading = false;

        tokenSession = rightphotos.token ?? 'token expired';
        emit(_LoadedSuccess(photoscached));
      });
    }, (hotelRemote) async {
      oldtokenSession = tokenSession;
      tokenSession = hotelRemote.token ?? 'token expired';
      _isFirstFetch = false;
      isLoading = false;
      photoscached.addAll(hotelRemote.images!);
      emit(_LoadedSuccess(photoscached));
    });
  }
}
