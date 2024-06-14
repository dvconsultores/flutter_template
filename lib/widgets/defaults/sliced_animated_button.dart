import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';

class SlicedAnimatedButton extends StatelessWidget {
  const SlicedAnimatedButton({
    super.key,
    required this.animation,
    this.onPressed,
    required this.text,
    this.textStyle,
    this.trailing,
    this.loading = false,
    this.disabled = false,
  });
  final AnimationController animation;
  final VoidCallback? onPressed;
  final String text;
  final TextStyle? textStyle;
  final Widget? trailing;
  final bool loading;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final ts = textStyle ??
            TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontFamily: FontFamily.lato("500"),
            ),
        textWidget = Text(text, style: ts);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final size = MediaQuery.of(context).size,
            slide = Tween<double>(begin: 0, end: size.width).animate(
              animation.drive(CurveTween(curve: Curves.elasticInOut)),
            );

        return Button(
          disabled: loading || disabled,
          width: double.maxFinite,
          padding: const EdgeInsets.all(0),
          onPressed: onPressed,
          content: Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.all(Radius.circular(Vars.radius40)),
              child: Stack(children: [
                Positioned.fill(
                  right: slide.value,
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.all(Radius.circular(Vars.radius40)),
                    child: ColoredBox(color: ThemeApp.colors(context).tertiary),
                  ),
                ),
                if (loading)
                  const Center(
                    child: SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textWidget,
                          if (trailing != null) trailing!,
                        ]),
                  ),
              ]),
            ),
          ),
        );
      },
    );
  }
}
