// ignore_for_file: deprecated_member_use, use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_text/common/theme/theme.dart';
import 'package:flutter_text/data/models/photos_model.dart';

import 'package:flutter_text/presentation/bloc/photos/photos_bloc.dart';
import 'package:flutter_text/presentation/widgets/photo_widget.dart';
import 'package:shimmer/shimmer.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({Key? key}) : super(key: key);

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  ImageModel findOptimalImage(
      List<ImageModel> images, double screenWidth, double screenHeight) {
    List<ImageModel> filteredImages = images
        .where(
            (image) => image.width > screenWidth && image.height > screenHeight)
        .toList();

    if (filteredImages.isEmpty) {
      // Если нет изображений, подходящих по размеру, выбираем изображение максимального размера
      return images
          .reduce((a, b) => a.width * a.height > b.width * b.height ? a : b);
    } else {
      // Выбираем изображение с минимальными размерами из подходящих
      return filteredImages
          .reduce((a, b) => a.width * a.height < b.width * b.height ? a : b);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(
            //size: 20,
            color: Theme.of(context).primaryColor, //change your color here
          ),
          backgroundColor: const Color(0xFFFFFFFF),
          shadowColor: const Color(0xFFFFFFFF),
          title: RichText(
              text: TextSpan(children: <TextSpan>[
            TextSpan(
              text: "Фотографии",
              style: CustomTextTheme.headline1NS
                  .copyWith(color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ])),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: BlocBuilder<PhotosBloc, PhotosState>(builder: (context, state) {
          return state.when(
              loading: (st) {
                if (st.isNotEmpty) {
                  return Column(children: [
                    Expanded(
                        child: NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (scrollInfo.metrics.maxScrollExtent ==
                                  scrollInfo.metrics.pixels) {
                                BlocProvider.of<PhotosBloc>(context)
                                    .add(const PhotosEvent.getPhotos());
                              }
                              return false;
                            },
                            child: GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 0,
                                        mainAxisSpacing: 0),
                                itemCount: st.length,
                                itemBuilder: (context, index) {
                                  return PhotosItemWidget(
                                    image2: st[index].images[0],
                                    image: findOptimalImage(
                                        st[index].images,
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        MediaQuery.of(context).size.height *
                                            0.13),
                                  );
                                })))
                  ]);
                } else {
                  return const _LoadingPhotosStatePage();
                }
              },
              loadingError: (st) => const _ErrorPhotosStatePage(),
              loadingSuccess: (st) {
                return Column(children: [
                  Expanded(
                      child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            if (scrollInfo.metrics.maxScrollExtent ==
                                scrollInfo.metrics.pixels) {
                              BlocProvider.of<PhotosBloc>(context)
                                  .add(const PhotosEvent.getPhotos());
                            }
                            return false;
                          },
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 0,
                                      mainAxisSpacing: 0),
                              itemCount: st.length,
                              itemBuilder: (context, index) {
                                return PhotosItemWidget(
                                  image2: findOptimalImage(
                                      st[index].images,
                                      MediaQuery.of(context).size.width,
                                      MediaQuery.of(context).size.height),
                                  image: findOptimalImage(
                                      st[index].images,
                                      MediaQuery.of(context).size.width * 0.25,
                                      MediaQuery.of(context).size.height *
                                          0.13),
                                );
                              })))
                ]);
              });
        }));

    // );
  }
}

class _ShimmerNewsCardLoading extends StatelessWidget {
  const _ShimmerNewsCardLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Container(
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
        ));
  }
}

class _LoadingPhotosStatePage extends StatelessWidget {
  const _LoadingPhotosStatePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 21,
      itemBuilder: (context, index) => const _ShimmerNewsCardLoading(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 0, crossAxisSpacing: 0),
    );
  }
}

class _ErrorPhotosStatePage extends StatelessWidget {
  const _ErrorPhotosStatePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * .8,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .2,
                  ),
                  const Image(
                    image: AssetImage('assets/images/NoConnection.png'),
                    height: 125.0,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: const Text(
                        'Не удалось загрузить данные',
                        textAlign: TextAlign.center,
                        style: CustomTextTheme.calloutNS,
                      )),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .05,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .6,
                    child: const Text(
                      'Проверьте подключение к интернету и повторите попытку',
                      textAlign: TextAlign.center,
                      style: CustomTextTheme.calloutNS,
                    ),
                  ),
                ],
              ))),
    );
  }
}
