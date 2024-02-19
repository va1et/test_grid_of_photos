import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class Failure extends Equatable {
  final String? cause;

  const Failure([
    this.cause,
  ]);

  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure([super.cause]);
}

class CacheFailure extends Failure {
  const CacheFailure([super.cause]);
}

class TokenFailure extends Failure {
  const TokenFailure([super.cause]);
}
