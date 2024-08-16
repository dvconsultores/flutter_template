import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/painters/draggable_frame_painter.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/form_fields/input_field.dart';
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
    this.title,
    this.titleText,
    this.titleStyle,
    this.floatingActionButton,
    this.bottomWidget,
    this.draggableFrameBgColor,
    this.draggableFrameColor,
  });
  final EdgeInsets? padding;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final bool scrollable;
  final Widget child;
  final Widget? title;
  final String? titleText;
  final TextStyle? titleStyle;
  final Widget? floatingActionButton;
  final Widget? bottomWidget;
  final Color? draggableFrameBgColor;
  final Color? draggableFrameColor;

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
    EdgeInsets? padding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    Widget? child,
    Widget? title,
    String? titleText,
    TextStyle? titleStyle,
    Widget? floatingActionButton,
    Widget? bottomWidget,
    Color? draggableFrameBgColor,
    Color? draggableFrameColor,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
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
                title: title,
                titleText: titleText,
                titleStyle: titleStyle,
                floatingActionButton: floatingActionButton,
                bottomWidget: bottomWidget,
                draggableFrameBgColor: draggableFrameBgColor,
                draggableFrameColor: draggableFrameColor,
                child: child ?? const SizedBox.shrink(),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = padding ??
        EdgeInsets.only(
          top: Vars.gapXLarge,
          left: Vars.gapXLarge,
          right: Vars.gapXLarge,
          bottom: Vars.paddingScaffold.bottom,
        );

    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        final renderWidget = Column(children: [
          CustomPaint(
              size: const Size(double.maxFinite, 38),
              painter: DraggableFramePainter(
                bgColor: draggableFrameBgColor,
                color: draggableFrameColor,
              )),

          // title
          if (title != null) ...[
            Gap(p.top).column,
            title!,
          ] else if (titleText != null)
            Padding(
                padding: p.copyWith(bottom: Vars.gapLow),
                child: Text(
                  titleText!,
                  style: titleStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                )),

          // content
          if (scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: p,
                child: child,
              ),
            )
          else
            Expanded(child: Padding(padding: p, child: child)),
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

class BottomSheetList<T> extends StatefulWidget {
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
    this.title,
    this.titleText,
    this.titleStyle,
    this.emptyData,
    this.emptyDataText,
    this.emptyDataStyle,
    this.itemsGap,
    this.floatingActionButton,
    this.bottomWidget,
    this.scrollable = true,
    this.draggableFrameBgColor,
    this.draggableFrameColor,
    this.searchFunction,
    this.searchLabelText,
    this.searchHintText,
  });
  final EdgeInsets? padding;
  final List<DropdownMenuItem<T>> items;
  final Widget Function(BuildContext context, int index)? itemBuilder;
  final void Function(DropdownMenuItem<T> item)? onTap;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Widget? title;
  final String? titleText;
  final TextStyle? titleStyle;
  final Widget? emptyData;
  final String? emptyDataText;
  final TextStyle? emptyDataStyle;
  final double? itemsGap;
  final Widget? floatingActionButton;
  final Widget? bottomWidget;
  final bool scrollable;
  final Color? draggableFrameBgColor;
  final Color? draggableFrameColor;
  final bool Function(int index, DropdownMenuItem<T> element, String search)?
      searchFunction;
  final String? searchLabelText;
  final String? searchHintText;

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
    EdgeInsets? padding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    List<DropdownMenuItem<T>>? items,
    void Function(DropdownMenuItem<T> bottomSheetListItem)? onTap,
    Widget? title,
    String? titleText,
    TextStyle? titleStyle,
    Widget? emptyData,
    String? emptyDataText,
    TextStyle? emptyDataStyle,
    double? itemsGap,
    Widget? floatingActionButton,
    Widget? bottomWidget,
    Color? draggableFrameBgColor,
    Color? draggableFrameColor,
    bool Function(int index, DropdownMenuItem<T> element, String search)?
        searchFunction,
    String? searchLabelText,
    String? searchHintText,
  }) async {
    return await showModalBottomSheet<DropdownMenuItem<T>>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
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
        title: title,
        titleText: titleText,
        titleStyle: titleStyle,
        floatingActionButton: floatingActionButton,
        bottomWidget: bottomWidget,
        scrollable: scrollable,
        draggableFrameBgColor: draggableFrameBgColor,
        draggableFrameColor: draggableFrameColor,
        searchFunction: searchFunction,
        searchLabelText: searchLabelText,
        searchHintText: searchHintText,
      ),
    );
  }

  @override
  State<BottomSheetList<T>> createState() => _BottomSheetListState<T>();
}

class _BottomSheetListState<T> extends State<BottomSheetList<T>> {
  final searchController = TextEditingController();

  List<DropdownMenuItem<T>> get filteredItems {
    if (widget.searchFunction == null) return widget.items;

    return widget.items
        .whereIndexed((index, element) =>
            widget.searchFunction!(index, element, searchController.text))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.padding ??
        EdgeInsets.only(
          top: Vars.gapXLarge,
          left: Vars.gapXLarge,
          right: Vars.gapXLarge,
          bottom: Vars.paddingScaffold.bottom,
        );

    return DraggableScrollableSheet(
      expand: widget.expand,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        final contentWidget = Column(children: [
          // title
          if (widget.title != null) ...[
            Gap(p.top).column,
            widget.title!,
          ] else if (widget.titleText != null)
            Padding(
                padding: p.copyWith(bottom: Vars.gapLow),
                child: Text(
                  widget.titleText!,
                  style: widget.titleStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                )),

          // search
          if (widget.searchFunction != null) ...[
            Padding(
              padding: p,
              child: InputField(
                controller: searchController,
                onChanged: (value) => EasyDebounce.debounce(
                  "setState",
                  Durations.short3,
                  () => setState(() {}),
                ),
                labelText: widget.searchLabelText,
                hintText: widget.searchHintText,
                suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: Vars.buttonHeight / 2,
                        child: VerticalDivider(thickness: 1),
                      ),
                      const Icon(Icons.search_rounded, size: 24),
                      const Gap(Vars.gapMedium).row,
                    ]),
              ),
            ),
            Divider(
              height: 0,
              indent: p.left,
              endIndent: p.right,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],

          // content
          filteredItems.isEmpty
              ? Align(
                  child: Padding(
                    padding: p.copyWith(top: Vars.gapMax, bottom: Vars.gapMax),
                    child: widget.emptyData ??
                        Text(
                          widget.emptyDataText ?? "No records",
                          style: widget.emptyDataStyle,
                        ),
                  ),
                )
              : ListView.separated(
                  padding: p,
                  shrinkWrap: widget.scrollable,
                  physics: widget.scrollable
                      ? const NeverScrollableScrollPhysics()
                      : const ClampingScrollPhysics(),
                  controller: scrollController,
                  itemCount: filteredItems.length,
                  separatorBuilder: (context, index) =>
                      Gap(widget.itemsGap ?? Vars.gapXLarge).column,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];

                    return GestureDetector(
                      onTap: () {
                        clearSnackbars();
                        Navigator.pop<DropdownMenuItem<T>>(context, item);
                        Future.delayed(Durations.short1, () {
                          if (widget.onTap != null) widget.onTap!(item);
                        });
                      },
                      child: widget.itemBuilder != null
                          ? widget.itemBuilder!(context, index)
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
          floatingActionButton: widget.floatingActionButton,
          bottomSheet: widget.bottomWidget,
          backgroundColor: Colors.transparent,
          body: Column(children: [
            CustomPaint(
                size: const Size(double.maxFinite, 38),
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

class BottomSheetListMultiple<T> extends StatefulWidget {
  const BottomSheetListMultiple({
    super.key,
    this.contentPadding,
    this.initialItems,
    required this.items,
    this.itemforegroundColor,
    this.itemBuilder,
    this.onComplete,
    this.expand = false,
    this.initialChildSize = .45,
    this.minChildSize = .2,
    this.maxChildSize = .45,
    this.title,
    this.titleText,
    this.titleStyle,
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
    this.floatingActionButton,
    this.bottomWidget,
    this.scrollable = true,
    this.draggableFrameBgColor,
    this.draggableFrameColor,
    this.searchFunction,
    this.searchLabelText,
    this.searchHintText,
  });

  final EdgeInsets? contentPadding;
  final List<T>? initialItems;
  final List<DropdownMenuItem<T>> items;
  final Color? itemforegroundColor;
  final Widget Function(BuildContext context, Widget item)? itemBuilder;
  final void Function(List<DropdownMenuItem<T>> item)? onComplete;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final Widget? title;
  final String? titleText;
  final TextStyle? titleStyle;
  final Widget? emptyData;
  final String? emptyDataText;
  final TextStyle? emptyDataStyle;
  final Widget Function(BuildContext context, VoidCallback onComplete)?
      buttonBuilder;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final int? maxLenght;
  final int crossAxisCount;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final Widget? floatingActionButton;
  final Widget? bottomWidget;
  final bool scrollable;
  final Color? draggableFrameBgColor;
  final Color? draggableFrameColor;
  final bool Function(int index, DropdownMenuItem<T> element, String search)?
      searchFunction;
  final String? searchLabelText;
  final String? searchHintText;

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
    EdgeInsets? contentPadding,
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
    Widget? title,
    String? titleText,
    TextStyle? titleStyle,
    Widget? emptyData,
    String? emptyDataText,
    TextStyle? emptyDataStyle,
    int crossAxisCount = 2,
    double childAspectRatio = 20 / 4.8,
    double crossAxisSpacing = Vars.gapXLarge,
    double mainAxisSpacing = Vars.gapXLarge,
    Widget? floatingActionButton,
    Widget? bottomWidget,
    Color? draggableFrameBgColor,
    Color? draggableFrameColor,
    bool Function(int index, DropdownMenuItem<T> element, String search)?
        searchFunction,
    String? searchLabelText,
    String? searchHintText,
  }) async {
    return await showModalBottomSheet<List<DropdownMenuItem<T>>>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
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
        titleText: titleText,
        titleStyle: titleStyle,
        contentPadding: contentPadding,
        initialItems: initialItems,
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
        title: title,
        scrollable: scrollable,
        floatingActionButton: floatingActionButton,
        bottomWidget: bottomWidget,
        draggableFrameBgColor: draggableFrameBgColor,
        draggableFrameColor: draggableFrameColor,
        searchFunction: searchFunction,
        searchLabelText: searchLabelText,
        searchHintText: searchHintText,
      ),
    );
  }

  @override
  State<BottomSheetListMultiple<T>> createState() =>
      _BottomSheetListMultipleState<T>();
}

class _BottomSheetListMultipleState<T>
    extends State<BottomSheetListMultiple<T>> {
  final searchController = TextEditingController();

  List<DropdownMenuItem<T>> get filteredItems {
    if (widget.searchFunction == null) return widget.items;

    return widget.items
        .whereIndexed((index, element) =>
            widget.searchFunction!(index, element, searchController.text))
        .toList();
  }

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

    final p = widget.contentPadding ??
        EdgeInsets.only(
          top: Vars.gapXLarge,
          left: Vars.gapXLarge,
          right: Vars.gapXLarge,
          bottom: Vars.paddingScaffold.bottom,
        );

    return DraggableScrollableSheet(
      expand: widget.expand,
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      builder: (context, scrollController) {
        final contentWidget = Column(children: [
          // title
          if (widget.title != null) ...[
            Gap(p.top).column,
            widget.title!,
          ] else if (widget.titleText != null)
            Padding(
                padding: p.copyWith(bottom: Vars.gapLow),
                child: Text(
                  widget.titleText!,
                  style: widget.titleStyle ??
                      const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                )),

          // search
          if (widget.searchFunction != null) ...[
            Padding(
              padding: p,
              child: InputField(
                controller: searchController,
                onChanged: (value) => EasyDebounce.debounce(
                  "setState",
                  Durations.short3,
                  () => setState(() {}),
                ),
                labelText: widget.searchLabelText,
                hintText: widget.searchHintText,
                suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        height: Vars.buttonHeight / 2,
                        child: VerticalDivider(thickness: 1),
                      ),
                      const Icon(Icons.search_rounded, size: 24),
                      const Gap(Vars.gapMedium).row,
                    ]),
              ),
            ),
            Divider(
              height: 0,
              indent: p.left,
              endIndent: p.right,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],

          // content
          filteredItems.isEmpty
              ? Align(
                  child: Padding(
                    padding: p.copyWith(top: Vars.gapMax, bottom: Vars.gapMax),
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
                  padding: p,
                  children: filteredItems
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
                size: const Size(double.maxFinite, 38),
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
