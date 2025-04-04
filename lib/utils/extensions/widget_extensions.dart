import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/packages/skeletons/skeleton_widgets.dart';

// ? text extension
extension TextExtension on Text {
  Text invertedColor() {
    final color = style?.color ?? Colors.black;
    return Text(
      data ?? "",
      style: style?.copyWith(
          color: Color.fromARGB(
        // ignore: deprecated_member_use
        (color.opacity * 255).round(),
        // ignore: deprecated_member_use
        255 - color.red,
        // ignore: deprecated_member_use
        255 - color.green,
        // ignore: deprecated_member_use
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
        // ignore: deprecated_member_use
        (newColor.opacity * 255).round(),
        // ignore: deprecated_member_use
        255 - newColor.red,
        // ignore: deprecated_member_use
        255 - newColor.green,
        // ignore: deprecated_member_use
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
    bool loading = false,
  }) {
    Widget skeletonLoader(BuildContext context, bool loading) => SizedBox(
          width: width,
          height: height,
          child: Skeleton(
            isLoading: loading,
            duration: shimmerDuration,
            shimmerGradient: shimmerGradient ??
                LinearGradient(colors: [
                  ThemeApp.of(context).colors.primary.withAlpha(128),
                  ThemeApp.of(context).colors.secondary.withAlpha(128),
                ]),
            skeleton: SkeletonAvatar(
              style: SkeletonAvatarStyle(width: width, height: height),
            ),
            child: this,
          ),
        );

    if (loading) {
      return skeletonLoader(ContextUtility.context!, true);
    }

    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(200),
      clipBehavior: clipBehavior,
      child: image is NetworkImage
          ? Image.network(
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
              loadingBuilder: loadingBuilder ??
                  (context, child, loadingProgress) => skeletonLoader(
                      context,
                      loadingProgress?.cumulativeBytesLoaded !=
                          loadingProgress?.expectedTotalBytes),
              errorBuilder: (context, error, stackTrace) => SizedBox(
                width: (width ?? 40),
                height: (height ?? 40),
                child: Align(
                  child: Icon(Icons.error, size: (width ?? 40) / 2),
                ),
              ),
            )
          : Image.file(
              (image as FileImage).file,
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
              errorBuilder: (context, error, stackTrace) => SizedBox(
                width: (width ?? 40),
                height: (height ?? 40),
                child: Align(
                  child: Icon(Icons.error, size: (height ?? 40) / 2),
                ),
              ),
            ),
    );
  }
}

// ? cachedNetworkImage extension
extension CachedNetworkImageExtension on CachedNetworkImage {
  Widget prebuilder({
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    Duration shimmerDuration = const Duration(milliseconds: 1500),
    LinearGradient? shimmerGradient,
    bool loading = false,
  }) {
    Widget skeletonLoader(BuildContext context, bool loading) => SizedBox(
          width: width,
          height: height,
          child: Skeleton(
            isLoading: loading,
            duration: shimmerDuration,
            shimmerGradient: shimmerGradient ??
                LinearGradient(colors: [
                  ThemeApp.of(context).colors.primary.withAlpha(128),
                  ThemeApp.of(context).colors.secondary.withAlpha(128),
                ]),
            skeleton: SkeletonAvatar(
              style: SkeletonAvatarStyle(width: width, height: height),
            ),
            child: this,
          ),
        );

    if (loading) {
      return skeletonLoader(ContextUtility.context!, true);
    }

    return ClipRRect(
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
        progressIndicatorBuilder: progressIndicatorBuilder ??
            (context, child, loadingProgress) => skeletonLoader(context,
                loadingProgress.downloaded != loadingProgress.totalSize),
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
}

// ? Navigator extension
extension NavigatorExtension on Navigator {
  ///* Normal `push` method from `Navigator` with custom transition.
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

  ///* Normal `pushReplacement` method from `Navigator` with custom transition.
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
