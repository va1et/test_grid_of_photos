import 'package:equatable/equatable.dart';
import 'package:flutter_text/data/models/photos_model.dart';

class Item extends Equatable {
  final String id;
  final List<ImageModel> images;
  const Item({
    required this.id,
    required this.images,
  });

  @override
  List<Object?> get props => [
        id,
        images,
      ];
}
