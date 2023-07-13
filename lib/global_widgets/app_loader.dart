import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class AppLoader {
  static void close() => Navigator.pop(globalNavigatorKey.currentContext!);

  static Future<http.Response> init({
    Future<http.Response>? request,
    http.MultipartRequest? multipartRequest,
  }) async =>
      await showDialog(
        context: globalNavigatorKey.currentContext!,
        builder: (context) => _AppLoader(request, multipartRequest),
      ) ??
      http.Response.bytes([], 200);
}

class _AppLoader extends StatelessWidget {
  const _AppLoader(this.request, this.multipartRequest);
  final Future<http.Response>? request;
  final http.MultipartRequest? multipartRequest;

  @override
  Widget build(BuildContext context) {
    Future<void> init() async => Navigator.pop(
        context,
        request != null
            ? await request
            : await http.Response.fromStream(await multipartRequest!.send()));
    if (request != null || multipartRequest != null) init();

    return WillPopCustom(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    strokeWidth: 8,
                    color: ThemeApp.colors(context).secondary,
                    backgroundColor: ThemeApp.colors(context).primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Processing...",
                  style: Theme.of(context).primaryTextTheme.titleLarge,
                ),
              ],
            ),
          )),
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({
    super.key,
    this.backgroundColor,
    this.color,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 4.0,
    this.value,
    this.valueColor,
    this.defaultColor = false,
  });

  final Color? backgroundColor;
  final Color? color;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final double? value;
  final Animation<Color?>? valueColor;
  final bool defaultColor;

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      key: key,
      backgroundColor: defaultColor
          ? null
          : backgroundColor ?? ThemeApp.colors(context).secondary,
      color: defaultColor ? null : color ?? ThemeApp.colors(context).primary,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      strokeWidth: strokeWidth,
      value: value,
      valueColor: valueColor,
    );
  }
}

extension ImagePrebuilder on Image {
  Widget prebuilder({
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    (Color, Color)? loadingColors,
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
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress?.cumulativeBytesLoaded ==
                loadingProgress?.expectedTotalBytes) {
              // La carga de la imagen se ha completado
              return child;
            }

            // La imagen se está cargando
            return Shimmer.fromColors(
              baseColor: loadingColors?.$1 ?? Colors.grey[400]!,
              highlightColor: loadingColors?.$2 ?? Colors.grey[300]!,
              child: child,
            );
          },
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

extension CachedNetworkImagePrebuilder on CachedNetworkImage {
  Widget prebuilder({
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
    (Color, Color)? loadingColors,
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
          progressIndicatorBuilder: (context, child, loadingProgress) {
            if (loadingProgress.downloaded == loadingProgress.totalSize) {
              // La carga de la imagen se ha completado
              return this;
            }

            // La imagen se está cargando
            return Shimmer.fromColors(
              baseColor: loadingColors?.$1 ?? Colors.grey[400]!,
              highlightColor: loadingColors?.$2 ?? Colors.grey[300]!,
              child: this,
            );
          },
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
