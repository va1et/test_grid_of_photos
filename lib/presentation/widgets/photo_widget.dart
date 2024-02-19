import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text/common/theme/theme.dart';
import 'package:flutter_text/domain/models/Image.dart';
import 'package:flutter_text/presentation/pages/photo_info_page.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

class PhotosItemWidget extends StatelessWidget {
  final ImageItem image;
  final ImageItem image2;
  const PhotosItemWidget({Key? key, required this.image, required this.image2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go('/fullphoto:photoId', extra: image2);
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => PhotoInfoPage(image: image2),
        //     ));
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child:
            // ignore: sort_child_properties_last
            ExtendedImage.network(
          image.url,
          fit: BoxFit.cover,
          cache: true,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!, // Базовый цвет
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 120,
                      color: Colors.grey[300]!,
                    ),
                  ),
                );
              case LoadState.completed:
                return Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        shape: BoxShape.rectangle),
                    child: ExtendedRawImage(
                      fit: BoxFit.cover,
                      height: 120,
                      image: state.extendedImageInfo?.image,
                    ));

              case LoadState.failed:
                return GestureDetector(
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Text(
                          "Ошибка при загрузке изображения. Нажмите, чтобы перезагрузить",
                          textAlign: TextAlign.center,
                          style: CustomTextTheme.calloutNS
                              .copyWith(color: Theme.of(context).focusColor),
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    state.reLoadImage();
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
