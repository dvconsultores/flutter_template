import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:skeletons/skeletons.dart';

// ? text extension
extension TextExtension on Text {
  Text invertedColor() {
    final color = style?.color ?? Colors.black;
    return Text(
      data ?? "",
      style: style?.copyWith(
          color: Color.fromARGB(
        (color.opacity * 255).round(),
        255 - color.red,
        255 - color.green,
        255 - color.blue,
      )),
    );
  }
}

// ? icon extension
extension IconExtension on Icon {
  Icon invertedColor() {
    final newColor = color ?? Colors.black;
    return Icon(
      icon,
      color: Color.fromARGB(
        (newColor.opacity * 255).round(),
        255 - newColor.red,
        255 - newColor.green,
        255 - newColor.blue,
      ),
    );
  }
}

// ? image extension
extension ImageExtension on Image {
  Widget prebuilder({
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    Duration shimmerDuration = const Duration(milliseconds: 1500),
    LinearGradient? shimmerGradient,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(200),
        clipBehavior: clipBehavior,
        child: Image.network(
          (image as NetworkImage).url,
          key: key,
          alignment: alignment,
          fit: fit ?? BoxFit.cover,
          centerSlice: centerSlice,
          color: color,
          colorBlendMode: colorBlendMode,
          excludeFromSemantics: excludeFromSemantics,
          filterQuality: filterQuality,
          frameBuilder: frameBuilder,
          gaplessPlayback: gaplessPlayback,
          height: height,
          isAntiAlias: isAntiAlias,
          matchTextDirection: matchTextDirection,
          opacity: opacity,
          repeat: repeat,
          semanticLabel: semanticLabel,
          width: width,
          loadingBuilder: (context, child, loadingProgress) => Skeleton(
            isLoading: loadingProgress?.cumulativeBytesLoaded !=
                loadingProgress?.expectedTotalBytes,
            duration: shimmerDuration,
            shimmerGradient: shimmerGradient ??
                LinearGradient(colors: [
                  ThemeApp.colors(context).primary.withOpacity(.5),
                  ThemeApp.colors(context).secondary.withOpacity(.5),
                ]),
            skeleton: SkeletonAvatar(
              style: SkeletonAvatarStyle(width: width, height: height),
            ),
            child: child,
          ),
          errorBuilder: (context, error, stackTrace) => SizedBox(
            width: (width ?? 40) / 2,
            height: (height ?? 40) / 2,
            child: const Align(
              child: Icon(Icons.error),
            ),
          ),
        ),
      );
}

// ? cachedNetworkImage extension
extension CachedNetworkImageExtension on CachedNetworkImage {
  Widget prebuilder({
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    Duration shimmerDuration = const Duration(milliseconds: 1500),
    LinearGradient? shimmerGradient,
  }) =>
      ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(200),
        clipBehavior: clipBehavior,
        child: CachedNetworkImage(
          key: key,
          imageUrl: imageUrl,
          alignment: alignment,
          fit: fit ?? BoxFit.cover,
          color: color,
          colorBlendMode: colorBlendMode,
          filterQuality: filterQuality,
          height: height,
          matchTextDirection: matchTextDirection,
          repeat: repeat,
          width: width,
          cacheKey: cacheKey,
          cacheManager: cacheManager,
          fadeInCurve: fadeInCurve,
          fadeInDuration: fadeInDuration,
          fadeOutCurve: fadeOutCurve,
          fadeOutDuration: fadeOutDuration,
          httpHeaders: httpHeaders,
          imageBuilder: imageBuilder,
          maxHeightDiskCache: maxHeightDiskCache,
          maxWidthDiskCache: maxWidthDiskCache,
          memCacheHeight: memCacheHeight,
          memCacheWidth: memCacheWidth,
          placeholder: placeholder,
          placeholderFadeInDuration: placeholderFadeInDuration,
          useOldImageOnUrlChange: useOldImageOnUrlChange,
          progressIndicatorBuilder: (context, child, loadingProgress) =>
              Skeleton(
            isLoading: loadingProgress.downloaded != loadingProgress.totalSize,
            duration: shimmerDuration,
            shimmerGradient: shimmerGradient ??
                LinearGradient(colors: [
                  ThemeApp.colors(context).primary.withOpacity(.5),
                  ThemeApp.colors(context).secondary.withOpacity(.5),
                ]),
            skeleton: SkeletonAvatar(
              style: SkeletonAvatarStyle(width: width, height: height),
            ),
            child: this,
          ),
          errorWidget: (context, error, stackTrace) => SizedBox(
            width: (width ?? 40) / 2,
            height: (height ?? 40) / 2,
            child: const Align(
              child: Icon(Icons.error),
            ),
          ),
        ),
      );
}

// ? Navigator extension
extension NavigatorExtension on Navigator {
  ///* Normal `push` method from `Navigator` with custome transition.
  void pushWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) =>
      Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: Tween<double>(begin: begin, end: end).animate(
              CurvedAnimation(parent: animation, curve: curve),
            ),
            child: child,
          ),
        ),
      );

  ///* Normal `pushReplacement` method from `Navigator` with custome transition.
  void pushReplacementWithTransition(
    BuildContext context,
    Widget page, {
    Duration transitionDuration = const Duration(milliseconds: 2500),
    double begin = 0.0,
    double end = 1.0,
    Curve curve = Curves.fastLinearToSlowEaseIn,
  }) =>
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: transitionDuration,
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
            opacity: Tween<double>(begin: begin, end: end).animate(
              CurvedAnimation(parent: animation, curve: curve),
            ),
            child: child,
          ),
        ),
      );
}
