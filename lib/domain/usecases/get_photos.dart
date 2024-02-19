import 'package:equatable/equatable.dart';
import 'package:flutter_text/common/errors/failures.dart';
import 'package:flutter_text/data/models/photos_model.dart';
import 'package:flutter_text/domain/models/item.dart';
import 'package:flutter_text/domain/repositories/photos_repository.dart';
import 'package:flutter_text/domain/usecases/usecase.dart';
import 'package:fpdart/fpdart.dart';

class GetPhotos extends UseCase<ResultPhotos, GetPhotosParams> {
  final PhotosRepository photosRepository;

  GetPhotos(this.photosRepository);

  @override
  Future<Either<Failure, ResultPhotos>> call(GetPhotosParams params) async {
    return await photosRepository.getPhotos(params.contToken);
  }
}

class GetPhotosParams extends Equatable {
  final String contToken;

  const GetPhotosParams({
    required this.contToken,
  });

  @override
  List<Object?> get props => [contToken];
}
