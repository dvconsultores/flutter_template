import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/sheets/card_widget.dart';
import 'package:flutter_gap/flutter_gap.dart';

class BottomSheetCard extends StatelessWidget {
  const BottomSheetCard({
    super.key,
    this.padding,
    this.expand = false,
    this.initialChildSize = .45,
    this.minChildSize = .2,
    this.maxChildSize = .45,
    required this.child,
    this.scrollable = true,
    this.topWidget,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });
  final EdgeInsetsGeometry? padding;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool scrollable;
  final Widget child;
  final Widget? topWidget;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  static Future<T?> showModal<T>(
    BuildContext context, {
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    Widget Function(BuildContext context)? builder,
    bool expand = false,
    double initialChildSize = .45,
    double maxChildSize = .45,
    double minChildSize = .2,
    EdgeInsetsGeometry? padding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    Widget? child,
    Widget? topWidget,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
  }) async =>
      await showModalBottomSheet<T>(
        context: context,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor ?? ThemeApp.colors(context).background,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Vars.radius50),
                topRight: Radius.circular(Vars.radius50),
              ),
            ),
        builder: builder ??
            (context) => BottomSheetCard(
                  expand: expand,
                  initialChildSize: initialChildSize,
                  maxChildSize: maxChildSize,
                  minChildSize: minChildSize,
                  padding: padding,
                  scrollable: scrollable,
                  topWidget: topWidget,
                  floatingActionButton: floatingActionButton,
                  bottomNavigationBar: bottomNavigationBar,
                  child: child ?? const SizedBox.shrink(),
                ),
      );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Scaffold(
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          body: Column(children: [
            if (topWidget != null)
              topWidget!
            else
              const Gap(Vars.gapXLarge).column,
            if (scrollable)
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: padding ??
                      Vars.paddingScaffold.copyWith(top: 0, bottom: 0),
                  child: child,
                ),
              )
            else
              Expanded(
                child: Padding(
                  padding: padding ??
                      Vars.paddingScaffold.copyWith(top: 0, bottom: 0),
                  child: child,
                ),
              ),
          ]),
        );
      },
    );
  }
}

class BottomSheetList<T> extends StatelessWidget {
  const BottomSheetList({
    super.key,
    this.padding,
    required this.items,
    this.itemBuilder,
    this.onTap,
    this.expand = false,
    this.initialChildSize = .45,
    this.minChildSize = .2,
    this.maxChildSize = .45,
    this.emptyData,
    this.emptyDataText,
    this.emptyDataStyle,
    this.itemsGap,
    this.topWidget,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });
  final EdgeInsetsGeometry? padding;
  final List<DropdownMenuItem<T>> items;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final void Function(DropdownMenuItem<T> item)? onTap;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Widget? emptyData;
  final String? emptyDataText;
  final TextStyle? emptyDataStyle;
  final double? itemsGap;
  final Widget? topWidget;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  static Future<DropdownMenuItem<T>?> showModal<T>(
    BuildContext context, {
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    Widget Function(BuildContext context, int index)? itemBuilder,
    bool expand = false,
    double initialChildSize = .45,
    double maxChildSize = .45,
    double minChildSize = .2,
    EdgeInsetsGeometry? padding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    List<DropdownMenuItem<T>>? items,
    void Function(DropdownMenuItem<T> bottomSheetListItem)? onTap,
    Widget? emptyData,
    String? emptyDataText,
    TextStyle? emptyDataStyle,
    double? itemsGap,
    Widget? topWidget,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
  }) async =>
      await showModalBottomSheet<DropdownMenuItem<T>>(
        context: context,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor ?? ThemeApp.colors(context).background,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Vars.radius50),
                topRight: Radius.circular(Vars.radius50),
              ),
            ),
        builder: (context) => BottomSheetList<T>(
          items: items ?? [],
          onTap: onTap,
          expand: expand,
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          itemBuilder: itemBuilder,
          emptyData: emptyData,
          emptyDataText: emptyDataText,
          emptyDataStyle: emptyDataStyle,
          padding: padding,
          itemsGap: itemsGap,
          topWidget: topWidget,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Scaffold(
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          body: Column(children: [
            if (topWidget != null)
              topWidget!
            else
              const Gap(Vars.gapXLarge).column,
            Expanded(
              child: items.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: Vars.gapMax),
                      child: emptyData ??
                          Text(
                            emptyDataText ?? "No records",
                            style: emptyDataStyle,
                          ),
                    )
                  : ListView.separated(
                      padding: padding ??
                          Vars.paddingScaffold.copyWith(top: 0, bottom: 0),
                      controller: scrollController,
                      itemCount: items.length,
                      separatorBuilder: (context, index) =>
                          Gap(itemsGap ?? Vars.gapXLarge).column,
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return GestureDetector(
                          onTap: () {
                            clearSnackbars();
                            Navigator.pop<DropdownMenuItem<T>>(context, item);
                            if (onTap != null) onTap!(item);
                          },
                          child: itemBuilder != null
                              ? itemBuilder!(context, index)
                              : CardWidget(
                                  elevation: 5,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: Vars.gapMedium,
                                    vertical: Vars.gapXLarge,
                                  ),
                                  child: item.child,
                                ),
                        );
                      },
                    ),
            ),
          ]),
        );
      },
    );
  }
}

class BottomSheetListMultiple<T> extends StatefulWidget {
  const BottomSheetListMultiple({
    super.key,
    this.contextPadding,
    this.initialItems,
    required this.items,
    this.itemforegroundColor,
    this.itemBuilder,
    this.onComplete,
    this.expand = false,
    this.initialChildSize = .45,
    this.minChildSize = .2,
    this.maxChildSize = .45,
    this.label,
    this.labelText,
    this.labelStyle,
    this.emptyData,
    this.emptyDataText,
    this.emptyDataStyle,
    this.maxLenght,
    this.buttonBuilder,
    this.buttonText,
    this.buttonTextStyle,
    this.crossAxisCount = 2,
    this.childAspectRatio = 20 / 4.8,
    this.crossAxisSpacing = Vars.gapXLarge,
    this.mainAxisSpacing = Vars.gapXLarge,
    this.topWidget,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final EdgeInsetsGeometry? contextPadding;
  final List<T>? initialItems;
  final List<DropdownMenuItem<T>> items;
  final Color? itemforegroundColor;
  final Widget Function(BuildContext context, Widget item)? itemBuilder;
  final void Function(List<DropdownMenuItem<T>> item)? onComplete;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Widget? emptyData;
  final String? emptyDataText;
  final TextStyle? emptyDataStyle;
  final Widget? label;
  final String? labelText;
  final TextStyle? labelStyle;
  final Widget Function(BuildContext context, VoidCallback onComplete)?
      buttonBuilder;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final int? maxLenght;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Widget? topWidget;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  static Future<List<DropdownMenuItem<T>>?> showModal<T>(
    BuildContext context, {
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    Widget Function(BuildContext context, Widget item)? itemBuilder,
    bool expand = false,
    double initialChildSize = .45,
    double maxChildSize = .45,
    double minChildSize = .2,
    EdgeInsetsGeometry? contextPadding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    List<DropdownMenuItem<T>>? items,
    List<T>? initialItems,
    Color? itemforegroundColor,
    void Function(List<DropdownMenuItem<T>> bottomSheetListItem)? onComplete,
    Widget Function(BuildContext context, VoidCallback onComplete)?
        buttonBuilder,
    String? buttonText,
    TextStyle? buttonTextStyle,
    int? maxLenght,
    Widget? emptyData,
    String? emptyDataText,
    TextStyle? emptyDataStyle,
    Widget? label,
    String? labelText,
    TextStyle? labelStyle,
    int crossAxisCount = 2,
    double childAspectRatio = 20 / 4.8,
    double crossAxisSpacing = Vars.gapXLarge,
    double mainAxisSpacing = Vars.gapXLarge,
    Widget? topWidget,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
  }) async =>
      await showModalBottomSheet<List<DropdownMenuItem<T>>>(
        context: context,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        isDismissible: isDismissible,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor ?? ThemeApp.colors(context).background,
        shape: shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Vars.radius50),
                topRight: Radius.circular(Vars.radius50),
              ),
            ),
        builder: (context) => BottomSheetListMultiple<T>(
          items: items ?? [],
          itemforegroundColor: itemforegroundColor,
          itemBuilder: itemBuilder,
          onComplete: onComplete,
          expand: expand,
          initialChildSize: initialChildSize,
          maxChildSize: maxChildSize,
          minChildSize: minChildSize,
          buttonBuilder: buttonBuilder,
          buttonText: buttonText,
          buttonTextStyle: buttonTextStyle,
          maxLenght: maxLenght,
          emptyData: emptyData,
          emptyDataText: emptyDataText,
          emptyDataStyle: emptyDataStyle,
          label: label,
          labelText: labelText,
          labelStyle: labelStyle,
          contextPadding: contextPadding,
          initialItems: initialItems,
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          topWidget: topWidget,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
        ),
      );

  @override
  State<BottomSheetListMultiple<T>> createState() =>
      _BottomSheetListMultipleState<T>();
}

class _BottomSheetListMultipleState<T>
    extends State<BottomSheetListMultiple<T>> {
  late final selectedItems = widget.items
      .where((element) => (widget.initialItems ?? []).contains(element.value))
      .toList();

  void onComplete() {
    Navigator.pop<List<DropdownMenuItem<T>>>(context, selectedItems);
    if (widget.onComplete != null) {
      widget.onComplete!(selectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSelected(DropdownMenuItem<T> item) =>
        selectedItems
            .singleWhereOrNull((element) => element.value == item.value) !=
        null;

    return DraggableScrollableSheet(
      expand: widget.expand,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        void onPressed(DropdownMenuItem<T> item) => setState(() {
              if (isSelected(item)) {
                return selectedItems
                    .removeWhere((element) => element.value == item.value);
              }

              if (widget.maxLenght == null ||
                  selectedItems.length < widget.maxLenght!) {
                selectedItems.add(item);
              }
            });

        return Scaffold(
          floatingActionButton: widget.floatingActionButton,
          bottomNavigationBar: widget.bottomNavigationBar,
          body: Column(children: [
            if (widget.topWidget != null)
              widget.topWidget!
            else
              const Gap(Vars.gapXLarge).column,
            if (widget.label != null)
              widget.label!
            else if (widget.labelText != null)
              Padding(
                  padding: Vars.paddingScaffold
                      .copyWith(top: 0, bottom: Vars.gapXLarge),
                  child: Text(
                    widget.labelText!,
                    style: widget.labelStyle ??
                        const TextStyle(fontWeight: FontWeight.w700),
                  )),
            Expanded(
              child: widget.items.isEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.symmetric(vertical: Vars.gapMax),
                      child: widget.emptyData ??
                          Text(widget.emptyDataText ?? "No records",
                              style: widget.emptyDataStyle),
                    )
                  : GridView.count(
                      crossAxisCount: widget.crossAxisCount,
                      childAspectRatio: widget.childAspectRatio,
                      crossAxisSpacing: widget.crossAxisSpacing,
                      mainAxisSpacing: widget.mainAxisSpacing,
                      physics: const BouncingScrollPhysics(),
                      padding: widget.contextPadding ??
                          Vars.paddingScaffold.copyWith(top: 0),
                      children: widget.items
                          .map(
                            (item) => widget.itemBuilder != null
                                ? GestureDetector(
                                    onTap: () => onPressed(item),
                                    child: widget.itemBuilder!(
                                        context, item.child),
                                  )
                                : Button(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(Vars.radius10)),
                                    boxShadow: [
                                      if (!isSelected(item)) Vars.boxShadow2
                                    ],
                                    borderSide: BorderSide(
                                      width: 1.3,
                                      color: isSelected(item)
                                          ? ThemeApp.colors(context).primary
                                          : Colors.transparent,
                                    ),
                                    bgColor: Colors.white,
                                    color: widget.itemforegroundColor,
                                    onPressed: () => onPressed(item),
                                    child: item.child,
                                  ),
                          )
                          .toList(),
                    ),
            ),
            if (widget.buttonBuilder != null)
              widget.buttonBuilder!(context, onComplete)
            else
              Button(
                margin: Vars.paddingScaffold,
                text: widget.buttonText ?? "Accept",
                onPressed: onComplete,
              ),
          ]),
        );
      },
    );
  }
}
