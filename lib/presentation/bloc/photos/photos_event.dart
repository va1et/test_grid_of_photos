part of 'photos_bloc.dart';

@freezed
class PhotosEvent with _$PhotosEvent {
  const factory PhotosEvent.getPhotos() = _GetPhotos;
}
