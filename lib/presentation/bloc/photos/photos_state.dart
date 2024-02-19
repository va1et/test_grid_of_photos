part of 'photos_bloc.dart';

@freezed
class PhotosState with _$PhotosState {
  const factory PhotosState.loading(List<Item> cachedphotos) = _Loading;
  const factory PhotosState.loadingError(String cause) = _LoadingError;
  const factory PhotosState.loadingSuccess(List<Item> photos) = _LoadedSuccess;
}
