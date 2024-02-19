// ignore_for_file: use_super_parameters

import 'dart:convert';

import 'package:flutter_text/data/datasources/photos_remote.dart';
import 'package:flutter_text/domain/models/Image.dart';
import 'package:flutter_text/domain/models/item.dart';

class ResultPhotos {
  ResultPhotos({
    this.token,
    this.images,
  });
  String? token;
  List<PhotosModel>? images;
  factory ResultPhotos.fromRawJson(String str) =>
      ResultPhotos.fromJson(json.decode(str));
  String toRawJson() => json.encode(toJson());

  factory ResultPhotos.fromJson(Map<String, dynamic> json) {
    return ResultPhotos(
        token: json["continuationToken"],
        images: List<PhotosModel>.from(
            json["items"].map((x) => PhotosModel.fromJson(x))));
  }
  Map<String, dynamic> toJson() => {
        "variants": List<dynamic>.from(images!.map((x) => x.toJson())),
        "continuationToken": token
      };
}

class PhotosModel extends Item {
  const PhotosModel({
    required id,
    required images,
  }) : super(
          id: id,
          images: images,
        );
  final String token = '';
  factory PhotosModel.fromRawJson(String str) =>
      PhotosModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PhotosModel.fromJson(Map<String, dynamic> json) {
    return PhotosModel(
        id: json["id"],
        images: List<ImageModel>.from(
            json["variants"].map((x) => ImageModel.fromJson(x))));
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "variants": List<dynamic>.from(images.map((x) => x)),
      };
}

class ImageModel extends ImageItem {
  const ImageModel({required width, required height, required url})
      : super(width: width, height: height, url: url);

  factory ImageModel.fromRawJson(String str) =>
      ImageModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
        width: json["width"], height: json["height"], url: json["url"]);
  }
  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
        "url": url,
      };
}
