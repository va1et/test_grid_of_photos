import 'package:dio/dio.dart';
import 'package:flutter_text/data/datasources/photos_remote.dart';
import 'package:flutter_text/data/repositories/photos_repository_impl.dart';
import 'package:flutter_text/domain/repositories/photos_repository.dart';
import 'package:flutter_text/domain/usecases/get_photos.dart';
import 'package:flutter_text/presentation/bloc/photos/photos_bloc.dart';
import 'package:flutter_text/routes/app_routes.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  getIt.registerFactory(() => PhotosBloc(getPhotos: getIt()));
  getIt.registerLazySingleton<PhotosRepository>(
    () => PhotosRepositoryImpl(
      remoteDataSource: getIt(),
      connectionChecker: getIt(),
    ),
  );
  getIt.registerLazySingleton(() => GetPhotos(getIt()));
  getIt.registerLazySingleton<PhotosRemoteData>(
      () => PhotosRemoteDataImpl(httpClient: getIt()));
  getIt.registerLazySingleton(() => Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20))));
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton(() => InternetConnectionChecker());

  getIt.registerLazySingleton(() => createRouter());
}
