import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/painters/draggable_frame_painter.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/sheets/card_widget.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    this.bottomWidget,
    this.draggableFrameBgColor,
    this.draggableFrameColor,
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
  final Widget? bottomWidget;
  final Color? draggableFrameBgColor;
  final Color? draggableFrameColor;

  static Future<T?> showModal<T>(
    BuildContext context, {
    bool hideBottomNavigationBar = false,
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
    Widget? bottomWidget,
    Color? draggableFrameBgColor,
    Color? draggableFrameColor,
  }) async {
    if (hideBottomNavigationBar) router.hideBottomNavigationBar();

    final value = await showModalBottomSheet<T>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Vars.radius30),
              topRight: Radius.circular(Vars.radius30),
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
                bottomWidget: bottomWidget,
                draggableFrameBgColor: draggableFrameBgColor,
                draggableFrameColor: draggableFrameColor,
                child: child ?? const SizedBox.shrink(),
              ),
    );

    if (hideBottomNavigationBar) router.showBottomNavigationBar();

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        final renderWidget = Column(children: [
          CustomPaint(
              size: Size(double.maxFinite, 36.sp),
              painter: DraggableFramePainter(
                bgColor: draggableFrameBgColor,
                color: draggableFrameColor,
              )),
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
                    EdgeInsets.only(
                      top: 0,
                      left: Vars.gapXLarge,
                      right: Vars.gapXLarge,
                      bottom: Vars.paddingScaffold.bottom,
                    ),
                child: child,
              ),
            )
          else
            Expanded(
              child: Padding(
                padding: padding ??
                    EdgeInsets.only(
                      top: 0,
                      left: Vars.gapXLarge,
                      right: Vars.gapXLarge,
                      bottom: Vars.paddingScaffold.bottom,
                    ),
                child: child,
              ),
            ),
        ]);

        return floatingActionButton != null || bottomWidget != null
            ? Scaffold(
                floatingActionButton: floatingActionButton,
                bottomSheet: bottomWidget,
                body: renderWidget,
              )
            : renderWidget;
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
    this.bottomWidget,
    this.scrollable = true,
    this.draggableFrameBgColor,
    this.draggableFrameColor,
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
  final Widget? bottomWidget;
  final bool scrollable;
  final Color? draggableFrameBgColor;
  final Color? draggableFrameColor;

  static Future<DropdownMenuItem<T>?> showModal<T>(
    BuildContext context, {
    bool hideBottomNavigationBar = false,
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
    Widget? bottomWidget,
    Color? draggableFrameBgColor,
    Color? draggableFrameColor,
  }) async {
    if (hideBottomNavigationBar) router.hideBottomNavigationBar();

    final value = await showModalBottomSheet<DropdownMenuItem<T>>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Vars.radius30),
              topRight: Radius.circular(Vars.radius30),
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
        bottomWidget: bottomWidget,
        scrollable: scrollable,
        draggableFrameBgColor: draggableFrameBgColor,
        draggableFrameColor: draggableFrameColor,
      ),
    );

    if (hideBottomNavigationBar) router.showBottomNavigationBar();

    return value;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        final contentWidget = Column(children: [
          if (topWidget != null)
            topWidget!
          else
            const Gap(Vars.gapXLarge).column,
          items.isEmpty
              ? Align(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Vars.gapMax),
                    child: emptyData ??
                        Text(
                          emptyDataText ?? "No records",
                          style: emptyDataStyle,
                        ),
                  ),
                )
              : ListView.separated(
                  padding: padding ??
                      EdgeInsets.only(
                        top: 0,
                        left: Vars.gapXLarge,
                        right: Vars.gapXLarge,
                        bottom: Vars.paddingScaffold.bottom,
                      ),
                  shrinkWrap: scrollable,
                  physics: scrollable
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
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
                        Future.delayed(Durations.short1, () {
                          if (onTap != null) onTap!(item);
                        });
                      },
                      child: itemBuilder != null
                          ? itemBuilder!(context, index)
                          : CardWidget(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Vars.gapMedium,
                                vertical: Vars.gapXLarge,
                              ),
                              child: item.child,
                            ),
                    );
                  },
                )
        ]);

        return Scaffold(
          floatingActionButton: floatingActionButton,
          bottomSheet: bottomWidget,
          backgroundColor: Colors.transparent,
          body: Column(children: [
            CustomPaint(
                size: Size(double.maxFinite, 36.sp),
                painter: DraggableFramePainter(
                  bgColor: draggableFrameBgColor,
                  color: draggableFrameColor,
                )),
            scrollable
                ? Expanded(child: SingleChildScrollView(child: contentWidget))
                : Expanded(child: contentWidget),
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
    this.bottomWidget,
    this.scrollable = true,
    this.draggableFrameBgColor,
    this.draggableFrameColor,
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
  final Widget? bottomWidget;
  final bool scrollable;
  final Color? draggableFrameBgColor;
  final Color? draggableFrameColor;

  static Future<List<DropdownMenuItem<T>>?> showModal<T>(
    BuildContext context, {
    bool hideBottomNavigationBar = false,
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
    Widget? bottomWidget,
    Color? draggableFrameBgColor,
    Color? draggableFrameColor,
  }) async {
    if (hideBottomNavigationBar) router.hideBottomNavigationBar();

    final value = await showModalBottomSheet<List<DropdownMenuItem<T>>>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.antiAlias,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Vars.radius30),
              topRight: Radius.circular(Vars.radius30),
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
        scrollable: scrollable,
        floatingActionButton: floatingActionButton,
        bottomWidget: bottomWidget,
        draggableFrameBgColor: draggableFrameBgColor,
        draggableFrameColor: draggableFrameColor,
      ),
    );

    if (hideBottomNavigationBar) router.showBottomNavigationBar();

    return value;
  }

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

    Future.delayed(Durations.short1, () {
      if (widget.onComplete != null) widget.onComplete!(selectedItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.colors(context), theme = Theme.of(context);

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

        final contentWidget = Column(children: [
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
          widget.items.isEmpty
              ? Align(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: Vars.gapMax),
                    child: widget.emptyData ??
                        Text(
                          widget.emptyDataText ?? "No records",
                          style: widget.emptyDataStyle,
                        ),
                  ),
                )
              : GridView.count(
                  crossAxisCount: widget.crossAxisCount,
                  childAspectRatio: widget.childAspectRatio,
                  crossAxisSpacing: widget.crossAxisSpacing,
                  mainAxisSpacing: widget.mainAxisSpacing,
                  shrinkWrap: widget.scrollable,
                  physics: widget.scrollable
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  padding: widget.contextPadding ??
                      Vars.paddingScaffold.copyWith(top: 0),
                  children: widget.items
                      .map(
                        (item) => widget.itemBuilder != null
                            ? GestureDetector(
                                onTap: () => onPressed(item),
                                child: widget.itemBuilder!(context, item.child),
                              )
                            : Button(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(Vars.radius10),
                                ),
                                boxShadow: [
                                  if (!isSelected(item)) Vars.boxShadow2
                                ],
                                borderSide: BorderSide(
                                  width: 1.3,
                                  color: isSelected(item)
                                      ? colors.primary
                                      : Colors.transparent,
                                ),
                                bgColor: theme.cardColor,
                                color:
                                    widget.itemforegroundColor ?? colors.text,
                                onPressed: () => onPressed(item),
                                child: item.child,
                              ),
                      )
                      .toList(),
                )
        ]);

        return Scaffold(
          floatingActionButton: widget.floatingActionButton,
          bottomSheet: widget.bottomWidget ??
              (widget.buttonBuilder != null
                  ? widget.buttonBuilder!(context, onComplete)
                  : Button(
                      margin: Vars.paddingScaffold,
                      text: widget.buttonText ?? "Accept",
                      onPressed: onComplete,
                    )),
          backgroundColor: Colors.transparent,
          body: Column(children: [
            CustomPaint(
                size: Size(double.maxFinite, 36.sp),
                painter: DraggableFramePainter(
                  bgColor: widget.draggableFrameBgColor,
                  color: widget.draggableFrameColor,
                )),
            widget.scrollable
                ? Expanded(child: SingleChildScrollView(child: contentWidget))
                : Expanded(child: contentWidget),
          ]),
        );
      },
    );
  }
}
