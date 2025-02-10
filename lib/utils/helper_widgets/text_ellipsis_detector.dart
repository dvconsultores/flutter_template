import 'package:flutter/material.dart';

class TextEllipsisDetector extends StatefulWidget {
  const TextEllipsisDetector({
    super.key,
    required this.builder,
    required this.text,
  });

  final Widget Function(BuildContext context, bool didOverflow, Text text)
      builder;
  final Text text;

  @override
  State<TextEllipsisDetector> createState() => _TextEllipsisDetectorState();
}

class _TextEllipsisDetectorState extends State<TextEllipsisDetector> {
  BoxConstraints? oldConstraints;

  bool didOverflow = false;

  void detectEllipsis(BoxConstraints constraints) {
    if (oldConstraints?.biggest.width == constraints.biggest.width) return;

    oldConstraints = constraints;

    if (context.findRenderObject() != null) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: widget.text.data!,
          style: widget.text.style,
        ),
        maxLines: 1,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(minWidth: 0, maxWidth: constraints.maxWidth);

      didOverflow = textPainter.didExceedMaxLines;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        detectEllipsis(constraints);
      });

      return widget.builder(context, didOverflow, widget.text);
    });
  }
}
