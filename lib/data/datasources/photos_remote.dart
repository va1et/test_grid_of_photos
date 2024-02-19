import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text/common/errors/exceptions.dart';
import 'package:flutter_text/data/models/photos_model.dart';

void myLongPrint(input) {
  String str = input.toString();

  // print out each chunk of 1000 characters sequentially
  while (str.length > 1000) {
    debugPrint(str.substring(0, 1000));

    // remove the first 1000 characters
    str = str.substring(1000);
  }

  // print the remaining characters
  debugPrint(str);
}

abstract class PhotosRemoteData {
  Future<ResultPhotos> getPhotos(
    String contToken,
  );
}

class PhotosRemoteDataImpl extends PhotosRemoteData {
  static const _apiUrl =
      'https://ru.api.dev.photograf.io/v1/jobEvaluation/images';

  final Dio httpClient;

  PhotosRemoteDataImpl({required this.httpClient});

  @override
  Future<ResultPhotos> getPhotos(
    String contToken,
  ) async {
    try {
      final response =
          await httpClient.get('$_apiUrl?continuationToken=$contToken');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        return ResultPhotos.fromJson(data["result"]);
      }
      if (response.statusCode == 400) {
        throw ServerException('Фото больше нет');
      } else {
        throw ServerException('Response status code is statusCode');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
