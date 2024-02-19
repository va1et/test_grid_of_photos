import 'package:flutter_text/common/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

abstract class UseCaseRight<Type, Params> {
  Future<Type> call(Params params);
}
