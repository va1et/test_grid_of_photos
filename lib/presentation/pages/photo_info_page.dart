import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text/data/models/photos_model.dart';
import 'package:flutter_text/domain/models/Image.dart';
import 'package:photo_view/photo_view.dart';

// class PhotoInfoPage extends StatelessWidget {
//   final ImageItem image;

//   const PhotoInfoPage({Key? key, required this.image}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: Center(
//         child: PhotoView(
//           imageProvider: NetworkImage(image.url),
//           minScale: PhotoViewComputedScale.contained,
//           maxScale: PhotoViewComputedScale.covered * 2,
//           enableRotation: true,
//         ),
//       ),
//     );
//   }
// }

class PhotoInfoPage extends StatefulWidget {
  const PhotoInfoPage({Key? key, required this.image}) : super(key: key);

  final ImageItem image;

  @override
  State<PhotoInfoPage> createState() => _PhotoInfoPageState();
}

class _PhotoInfoPageState extends State<PhotoInfoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late bool _appBarVisible;

  @override
  void initState() {
    super.initState();

    _appBarVisible = true;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 1.0,
      vsync: this,
    );
  }

  void _toggleAppBarVisibility() {
    _appBarVisible = !_appBarVisible;
    _appBarVisible ? _controller.forward() : _controller.reverse();
  }

  Widget _buildImage() {
    return GestureDetector(
      onTap: () => setState(() {
        _toggleAppBarVisibility();
      }),
      child: PhotoView.customChild(
        initialScale: 1.0,
        minScale: PhotoViewComputedScale.contained,
        maxScale: 3.0, // Максимальное увеличение
        backgroundDecoration:
            BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: ExtendedImage.network(
          widget.image.url,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.contain,
          cache: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -70),
      end: const Offset(0.0, 0.0),
    ).animate(_controller);
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _buildImage(),
        SlideTransition(
          position: offsetAnimation,
          child: Container(
            color: const Color(0xFFFFFFFF),
            height: 85,
            child: AppBar(
              backgroundColor: const Color(0xFFFFFFFF),
              shadowColor: const Color(0xFFFFFFFF),
              leading: CupertinoNavigationBarBackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: const Color(0xFF808B9F),
              ),
              // title: const Text("Просмотр изображения"),
            ),
          ),
        ),
      ],
    ));
  }
}
