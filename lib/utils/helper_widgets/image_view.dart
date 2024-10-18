import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageView extends StatefulWidget {
  const ImageView({
    super.key,
    this.initialImage,
    required this.photoViewProvider,
    this.onClose,
  });

  final int? initialImage;
  final List<PhotoViewProvider> photoViewProvider;
  final VoidCallback? onClose;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  late final PageController pageController;

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        ThemeApp.of(context).systemUiOverlayStyle.copyWith(
              systemNavigationBarColor: Colors.black,
            ));

    pageController = PageController(initialPage: widget.initialImage ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingBuilder(BuildContext context, ImageChunkEvent? chunks) =>
        Center(
          child: CircularProgressIndicator(
            value: chunks == null
                ? 0
                : chunks.cumulativeBytesLoaded /
                    (chunks.expectedTotalBytes ?? 0),
          ),
        );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          iconSize: 25,
          splashRadius: 25,
          icon: const Icon(Icons.arrow_back_rounded),
          color: Colors.white,
          onPressed: () => widget.onClose ?? Navigator.pop(context),
        ),
        backgroundColor: Colors.white10,
        centerTitle: true,
        title: Text(
          "Previsualizar ${widget.photoViewProvider.singleOrNull != null ? 'Imagen' : 'Imágenes'}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 17,
                color: Colors.white,
              ),
        ),
      ),
      body: Center(
        child: widget.photoViewProvider.singleOrNull != null
            ? PhotoView(
                minScale: .25,
                heroAttributes: widget.photoViewProvider.single.heroTag != null
                    ? PhotoViewHeroAttributes(
                        tag: widget.photoViewProvider.single.heroTag!,
                      )
                    : null,
                loadingBuilder: loadingBuilder,
                imageProvider: widget.photoViewProvider.first.imageProvider,
              )
            : PhotoViewGallery.builder(
                itemCount: widget.photoViewProvider.length,
                pageController: pageController,
                loadingBuilder: loadingBuilder,
                builder: (context, index) {
                  return PhotoViewGalleryPageOptions(
                    minScale: .25,
                    heroAttributes:
                        widget.photoViewProvider[index].heroTag != null
                            ? PhotoViewHeroAttributes(
                                tag: widget.photoViewProvider[index].heroTag!,
                              )
                            : null,
                    imageProvider:
                        widget.photoViewProvider[index].imageProvider,
                  );
                },
              ),
      ),
    );
  }
}

class PhotoViewProvider {
  const PhotoViewProvider({
    this.heroTag,
    required this.imageProvider,
  });
  final Object? heroTag;
  final ImageProvider<Object> imageProvider;
}
