import 'package:flutter_text/common/errors/failures.dart';
import 'package:flutter_text/data/models/photos_model.dart';

import 'package:fpdart/fpdart.dart';

abstract class PhotosRepository {
  Future<Either<Failure, ResultPhotos>> getPhotos(
    String contToken,
  );
  // Future<Either<Failure, List<String>>> getTags();
}
