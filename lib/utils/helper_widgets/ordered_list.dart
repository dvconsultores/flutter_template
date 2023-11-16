import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/helper_widgets/gap.dart';

class OrderedList extends StatelessWidget {
  const OrderedList(
    this.texts, {
    super.key,
    this.spacing = 5.0,
    this.separation = 5.0,
    this.markdown,
    this.markdownSeparator,
    this.fontSize,
    this.fontSizeMarkdown,
    this.color,
    this.colorMarkdown,
    this.fontWeight,
    this.fontWeightMarkdown,
    this.textStyle,
    this.textStyleMarkdown,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });
  final List<String> texts;
  final double spacing;
  final double separation;
  final Object? markdown;
  final Object? markdownSeparator;
  final double? fontSize;
  final double? fontSizeMarkdown;
  final Color? color;
  final Color? colorMarkdown;
  final FontWeight? fontWeight;
  final FontWeight? fontWeightMarkdown;
  final TextStyle? textStyle;
  final TextStyle? textStyleMarkdown;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  static Widget item(
    List<OrderedListItem> orderedListItems, {
    double spacing = 5.0,
    double separation = 5.0,
    Object? markdown,
    Object? markdownSeparator,
    double? fontSize,
    double? fontSizeMarkdown,
    Color? color,
    Color? colorMarkdown,
    FontWeight? fontWeight,
    FontWeight? fontWeightMarkdown,
    TextStyle? textStyle,
    TextStyle? textStyleMarkdown,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    final widgetList = <Widget>[];
    int counter = 0;
    for (final item in orderedListItems) {
      // * Add list item
      counter++;
      widgetList.add(OrderedListItem(
        item.text,
        id: item.id ?? ValueKey(counter),
        markdown: item.markdown ?? markdown,
        markdownSeparator: item.markdownSeparator ?? markdownSeparator,
        separation: item.separation ?? separation,
        fontSize: item.fontSize ?? fontSize,
        fontSizeMarkdown: item.fontSizeMarkdown ?? fontSizeMarkdown,
        color: item.color ?? color,
        colorMarkdown: item.colorMarkdown ?? colorMarkdown,
        fontWeight: item.fontWeight ?? fontWeight,
        fontWeightMarkdown: item.fontWeightMarkdown ?? fontWeightMarkdown,
        textStyle: item.textStyle ?? textStyle,
        textStyleMarkdown: item.textStyleMarkdown ?? textStyleMarkdown,
        mainAxisAlignment: item.mainAxisAlignment ?? mainAxisAlignment,
        crossAxisAlignment: item.crossAxisAlignment ?? crossAxisAlignment,
      ));

      // * Add space between items
      widgetList.add(SizedBox(height: spacing));
    }

    return Column(children: widgetList);
  }

  @override
  Widget build(BuildContext context) {
    final widgetList = <Widget>[];
    int counter = 0;
    for (final text in texts) {
      // * Add list item
      counter++;
      widgetList.add(OrderedListItem(
        text,
        id: ValueKey(counter),
        markdown: markdown,
        markdownSeparator: markdownSeparator,
        separation: separation,
        fontSize: fontSize,
        fontSizeMarkdown: fontSizeMarkdown,
        color: color,
        colorMarkdown: colorMarkdown,
        fontWeight: fontWeight,
        fontWeightMarkdown: fontWeightMarkdown,
        textStyle: textStyle,
        textStyleMarkdown: textStyleMarkdown,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
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
    this.id,
    this.markdown,
    this.markdownSeparator,
    this.separation,
    this.fontSize,
    this.fontSizeMarkdown,
    this.color,
    this.colorMarkdown,
    this.fontWeight,
    this.fontWeightMarkdown,
    this.textStyle,
    this.textStyleMarkdown,
    this.mainAxisAlignment,
    this.crossAxisAlignment,
  });

  /// This is a custome markdown for the list.
  final Object? markdown;

  /// Only can be used without custom markdown.
  final Object? markdownSeparator;
  final double? separation;
  final ValueKey? id;
  final String text;
  final double? fontSize;
  final double? fontSizeMarkdown;
  final Color? color;
  final Color? colorMarkdown;
  final FontWeight? fontWeight;
  final FontWeight? fontWeightMarkdown;
  final TextStyle? textStyle;
  final TextStyle? textStyleMarkdown;
  final MainAxisAlignment? mainAxisAlignment;
  final CrossAxisAlignment? crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        children: [
          markdown is Widget
              ? markdown as Widget
              : Text(
                  markdown != null
                      ? "$markdown "
                      : "${id?.value}${markdownSeparator is String ? '.' : ''}",
                  style: textStyleMarkdown ??
                      textStyle?.copyWith(
                        fontSize: fontSizeMarkdown,
                        fontWeight: fontWeightMarkdown,
                        color: colorMarkdown,
                      ),
                ),
          if (markdownSeparator is Widget) markdownSeparator as Widget,
          Gap(separation ?? 5.0).row,
          Expanded(
              child: Text(
            text,
            style: textStyle?.copyWith(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: color,
                ) ??
                TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: color,
                ),
          )),
        ]);
  }
}
