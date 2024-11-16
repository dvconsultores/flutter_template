import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:universal_html/html.dart' as html;

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
    SchedulerBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
          ThemeApp.of(context).systemUiOverlayStyle.copyWith(
                systemNavigationBarColor: Colors.black,
              ));
    });

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

    PhotoViewHeroAttributes? heroAttributes([int? index]) =>
        widget.photoViewProvider[index ?? 0].heroTag != null
            ? PhotoViewHeroAttributes(
                tag: widget.photoViewProvider[index ?? 0].heroTag!,
              )
            : null;

    Widget customChild([int? index]) => HtmlElementView.fromTagName(
          tagName: "img",
          onElementCreated: (image) {
            image as html.ImageElement;

            final imageProvider =
                widget.photoViewProvider[index ?? 0].imageProvider;
            image.src = imageProvider is CachedNetworkImageProvider
                ? imageProvider.url
                : imageProvider is NetworkImage
                    ? imageProvider.url
                    : null;
          },
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
          "Preview ${widget.photoViewProvider.singleOrNull != null ? 'Image' : 'Images'}",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 17,
                color: Colors.white,
              ),
        ),
      ),
      body: Center(
        child: widget.photoViewProvider.singleOrNull != null

            /// one image
            ? buildWidget(() {
                if (kIsWeb && widget.photoViewProvider.single.isNetworkImage) {
                  return PhotoView.customChild(
                    minScale: .25,
                    heroAttributes: heroAttributes(),
                    childSize: const Size(300, 300),
                    child: customChild(),
                  );
                }

                return PhotoView(
                  minScale: .25,
                  heroAttributes: heroAttributes(),
                  loadingBuilder: loadingBuilder,
                  imageProvider: widget.photoViewProvider.single.imageProvider,
                );
              })

            /// multiple images
            : PhotoViewGallery.builder(
                itemCount: widget.photoViewProvider.length,
                pageController: pageController,
                loadingBuilder: loadingBuilder,
                builder: (context, index) {
                  if (kIsWeb &&
                      widget.photoViewProvider[index].isNetworkImage) {
                    return PhotoViewGalleryPageOptions.customChild(
                      minScale: .25,
                      heroAttributes: heroAttributes(index),
                      childSize: const Size(300, 300),
                      child: customChild(),
                    );
                  }

                  return PhotoViewGalleryPageOptions(
                    minScale: .25,
                    heroAttributes: heroAttributes(index),
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

  bool get isNetworkImage =>
      imageProvider is CachedNetworkImageProvider ||
      imageProvider is NetworkImage;
}
