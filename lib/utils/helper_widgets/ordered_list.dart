import 'package:flutter/material.dart';

class OrderedList extends StatelessWidget {
  const OrderedList(
    this.texts, {
    super.key,
    this.spacing = 5.0,
    this.symbol,
    this.counterSeparator,
    this.fontSize,
    this.fontSizeMarkdown,
    this.color,
    this.colorMarkdown,
    this.fontWeight,
    this.fontWeightMarkdown,
  });
  final List<dynamic> texts;
  final double spacing;
  final String? symbol;
  final String? counterSeparator;
  final double? fontSize;
  final double? fontSizeMarkdown;
  final Color? color;
  final Color? colorMarkdown;
  final FontWeight? fontWeight;
  final FontWeight? fontWeightMarkdown;

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    int counter = 0;
    for (final text in texts) {
      // * Add list item
      counter++;
      widgetList.add(OrderedListItem(
        text,
        markdown: symbol ?? counter,
        counterSeparator: counterSeparator,
        fontSize: fontSize,
        fontSizeMarkdown: fontSizeMarkdown,
        color: color,
        colorMarkdown: colorMarkdown,
        fontWeight: fontWeight,
        fontWeightMarkdown: fontWeightMarkdown,
      ));
      // * Add space between items
      widgetList.add(SizedBox(height: spacing));
    }

    return Column(children: widgetList);
  }
}

class OrderedListItem extends StatelessWidget {
  const OrderedListItem(
    this.text, {
    super.key,
    required this.markdown,
    this.counterSeparator,
    this.fontSize,
    this.fontSizeMarkdown,
    this.color,
    this.colorMarkdown,
    this.fontWeight,
    this.fontWeightMarkdown,
  });

  /// This is a custome markdown for the list.
  final dynamic markdown;

  /// Only can be used without custom markdown.
  final String? counterSeparator;
  final String text;
  final double? fontSize;
  final double? fontSizeMarkdown;
  final Color? color;
  final Color? colorMarkdown;
  final FontWeight? fontWeight;
  final FontWeight? fontWeightMarkdown;

  @override
  Widget build(BuildContext context) {
    final symbolExist = markdown.runtimeType == String;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          symbolExist ? "$markdown " : "$markdown${counterSeparator ?? '.'} ",
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeightMarkdown ?? fontWeight,
            color: colorMarkdown ?? color,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
