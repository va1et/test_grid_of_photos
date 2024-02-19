import 'package:flutter_text/common/errors/exceptions.dart';
import 'package:flutter_text/common/errors/failures.dart';
import 'package:flutter_text/data/datasources/photos_remote.dart';
import 'package:flutter_text/data/models/photos_model.dart';
import 'package:flutter_text/domain/repositories/photos_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PhotosRepositoryImpl implements PhotosRepository {
  final PhotosRemoteData remoteDataSource;
  final InternetConnectionChecker connectionChecker;

  PhotosRepositoryImpl({
    required this.remoteDataSource,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, ResultPhotos>> getPhotos(
    String contToken,
  ) async {
    if (await connectionChecker.hasConnection) {
      try {
        final photosList = await remoteDataSource.getPhotos(contToken);
        return Right(photosList);
      } on ServerException {
        return const Left(ServerFailure());
      }
    } else {
      return const Left(ServerFailure());
    }
  }
}
