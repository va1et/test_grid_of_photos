// ignore: file_names

import 'package:equatable/equatable.dart';

class ImageItem extends Equatable {
  final int width;
  final int height;
  final String url;
  const ImageItem({
    required this.width,
    required this.height,
    required this.url,
  });

  @override
  List<Object?> get props => [
        width,
        height,
        url,
      ];
}
