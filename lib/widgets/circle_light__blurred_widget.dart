import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';

class CircleLightBlurredWidget extends StatelessWidget {
  const CircleLightBlurredWidget({
    super.key,
    this.blur = 100,
    this.color,
  });
  final double blur;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(200)),
        child: ColoredBox(
          color: color ?? ThemeApp.colors(context).secondary.withOpacity(.66),
        ),
      ),
    );
  }
}
