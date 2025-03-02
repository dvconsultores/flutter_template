import 'package:collection/collection.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/painters/draggable_frame_painter.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/button_aspect.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/form_fields/input_field.dart';
import 'package:flutter_detextre4/widgets/sheets/card_widget.dart';
import 'package:flutter_gap/flutter_gap.dart';

BoxConstraints _defaultConstraints(BuildContext context) =>
    BoxConstraints(maxWidth: Vars.getDesignSize(ContextUtility.context!).width);

class BottomSheetCard extends StatefulWidget {
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
    this.backgroundColor = Colors.transparent,
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
  final Color? backgroundColor;

  static Future<T?> showModal<T>(
    BuildContext context, {
    Key? key,
    bool hideBottomNavigationBar = false,
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
    BoxConstraints? constraints,
  }) async {
    final value = await showModalBottomSheet<T>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      constraints: constraints ?? _defaultConstraints(context),
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Vars.radius50),
              topRight: Radius.circular(Vars.radius50),
            ),
          ),
      builder: builder ??
          (context) => BottomSheetCard(
                key: key,
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
                child: child ?? const SizedBox.shrink(),
              ),
    );

    return value;
  }

  @override
  State<BottomSheetCard> createState() => _BottomSheetCardState();
}

class _BottomSheetCardState extends State<BottomSheetCard> {
  late final mainProvider = MainProvider.read(context);

  @override
  void initState() {
    mainProvider.setCurrentNavContext = context;
    super.initState();
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
        final renderWidget = Column(children: [
          CustomPaint(
            size: const Size(double.maxFinite, 38),
            painter: DraggableFramePainter(bgColor: widget.backgroundColor),
          ),

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

          // content
          if (widget.scrollable)
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                padding: p,
                child: widget.child,
              ),
            )
          else
            Expanded(child: Padding(padding: p, child: widget.child)),
        ]);

        return widget.floatingActionButton != null ||
                widget.bottomWidget != null
            ? Scaffold(
                floatingActionButton: widget.floatingActionButton,
                bottomNavigationBar: widget.bottomWidget,
                backgroundColor: widget.backgroundColor,
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
    this.searchFunction,
    this.searchLabelText,
    this.searchHintText,
    this.backgroundColor = Colors.transparent,
  });
  final EdgeInsets? padding;
  final List<DropdownMenuItem<T>> items;
  final Widget Function(BuildContext context, Widget child)? itemBuilder;
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
  final bool Function(int index, String search)? searchFunction;
  final String? searchLabelText;
  final String? searchHintText;
  final Color? backgroundColor;

  static Future<T?> showModal<T>(
    BuildContext context, {
    Key? key,
    bool hideBottomNavigationBar = false,
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    bool expand = false,
    double initialChildSize = .45,
    double maxChildSize = .45,
    double minChildSize = .2,
    EdgeInsets? padding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    List<DropdownMenuItem<T>>? items,
    Widget Function(BuildContext context, Widget child)? itemBuilder,
    Widget? title,
    String? titleText,
    TextStyle? titleStyle,
    Widget? emptyData,
    String? emptyDataText,
    TextStyle? emptyDataStyle,
    double? itemsGap,
    Widget? floatingActionButton,
    Widget? bottomWidget,
    bool Function(int index, String search)? searchFunction,
    String? searchLabelText,
    String? searchHintText,
    BoxConstraints? constraints,
  }) async {
    final value = await showModalBottomSheet<T>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      constraints: constraints ?? _defaultConstraints(context),
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Vars.radius50),
              topRight: Radius.circular(Vars.radius50),
            ),
          ),
      builder: (context) => BottomSheetList<T>(
        key: key,
        items: items ?? [],
        itemBuilder: itemBuilder,
        expand: expand,
        initialChildSize: initialChildSize,
        maxChildSize: maxChildSize,
        minChildSize: minChildSize,
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
        searchFunction: searchFunction,
        searchLabelText: searchLabelText,
        searchHintText: searchHintText,
      ),
    );

    return value;
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
            widget.searchFunction!(index, searchController.text))
        .toList();
  }

  late final mainProvider = MainProvider.read(context);

  @override
  void initState() {
    mainProvider.setCurrentNavContext = context;
    super.initState();
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
        final listView = ListView.separated(
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
                Navigator.pop<T>(context, item.value);
                if (item.onTap != null) item.onTap!();
              },
              child: widget.itemBuilder != null
                  ? widget.itemBuilder!(context, item.child)
                  : item.child,
            );
          },
        );

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
              : widget.scrollable
                  ? listView
                  : Expanded(child: listView)
        ]);

        return Scaffold(
          floatingActionButton: widget.floatingActionButton,
          bottomNavigationBar: widget.bottomWidget,
          backgroundColor: widget.backgroundColor,
          body: Column(children: [
            CustomPaint(
              size: const Size(double.maxFinite, 38),
              painter: DraggableFramePainter(bgColor: widget.backgroundColor),
            ),
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
    this.searchFunction,
    this.searchLabelText,
    this.searchHintText,
    this.backgroundColor = Colors.transparent,
  });

  final EdgeInsets? contentPadding;
  final List<T>? initialItems;
  final List<DropdownMenuItem<T>> items;
  final Widget Function(BuildContext context, Widget child, bool isSelected)?
      itemBuilder;
  final void Function(List<T> item)? onComplete;
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
  final bool Function(int index, String search)? searchFunction;
  final String? searchLabelText;
  final String? searchHintText;
  final Color? backgroundColor;

  static Future<List<T>?> showModal<T>(
    BuildContext context, {
    Key? key,
    bool hideBottomNavigationBar = false,
    ShapeBorder? shape,
    Color? backgroundColor,
    bool isScrollControlled = true,
    bool expand = false,
    double initialChildSize = .45,
    double maxChildSize = .45,
    double minChildSize = .2,
    EdgeInsets? contentPadding,
    bool scrollable = true,
    Clip? clipBehavior,
    bool isDismissible = true,
    required List<DropdownMenuItem<T>> items,
    Widget Function(BuildContext context, Widget child, bool isSelected)?
        itemBuilder,
    List<T>? initialItems,
    void Function(List<T> bottomSheetListItem)? onComplete,
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
    bool Function(int index, String search)? searchFunction,
    String? searchLabelText,
    String? searchHintText,
    BoxConstraints? constraints,
  }) async {
    final value = await showModalBottomSheet<List<T>>(
      context: context,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      constraints: constraints ?? _defaultConstraints(context),
      backgroundColor:
          backgroundColor ?? Theme.of(context).dialogTheme.backgroundColor,
      shape: shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Vars.radius50),
              topRight: Radius.circular(Vars.radius50),
            ),
          ),
      builder: (context) => BottomSheetListMultiple<T>(
        key: key,
        items: items,
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
        searchFunction: searchFunction,
        searchLabelText: searchLabelText,
        searchHintText: searchHintText,
      ),
    );

    return value;
  }

  @override
  State<BottomSheetListMultiple<T>> createState() =>
      _BottomSheetListMultipleState<T>();
}

class _BottomSheetListMultipleState<T>
    extends State<BottomSheetListMultiple<T>> {
  final searchController = TextEditingController();

  late final List<T> selectedItems = widget.items
      .map((e) => e.value!)
      .where((element) => (widget.initialItems ?? []).contains(element))
      .toList();

  bool isSelected(T? value) =>
      selectedItems.singleWhereOrNull((element) => element == value) != null;

  List<DropdownMenuItem<T>> get filteredItems {
    if (widget.searchFunction == null) return widget.items;

    return widget.items
        .whereIndexed((index, element) =>
            widget.searchFunction!(index, searchController.text))
        .toList();
  }

  void onComplete() {
    Navigator.pop<List<T>>(context, selectedItems);

    if (widget.onComplete != null) widget.onComplete!(selectedItems);
  }

  late final mainProvider = MainProvider.read(context);

  @override
  void initState() {
    mainProvider.setCurrentNavContext = context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onPressed(T value) => setState(() {
          if (isSelected(value)) {
            return selectedItems.removeWhere((element) => element == value);
          }

          if (widget.maxLenght == null ||
              selectedItems.length < widget.maxLenght!) {
            selectedItems.add(value);
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
        final gridView = GridView.count(
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
              .map((item) => GestureDetector(
                    onTap: () => onPressed(item.value as T),
                    child: widget.itemBuilder != null
                        ? widget.itemBuilder!(
                            context,
                            item.child,
                            isSelected(item.value),
                          )
                        : item.child,
                  ))
              .toList(),
        );

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
                      const TextStyle(fontWeight: FontWeight.w700),
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
              : widget.scrollable
                  ? gridView
                  : Expanded(child: gridView)
        ]);

        return Scaffold(
          floatingActionButton: widget.floatingActionButton,
          bottomNavigationBar: widget.bottomWidget ??
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
              painter: DraggableFramePainter(bgColor: widget.backgroundColor),
            ),
            widget.scrollable
                ? Expanded(child: SingleChildScrollView(child: contentWidget))
                : Expanded(child: contentWidget),
          ]),
        );
      },
    );
  }
}

class BottomDropdownItem extends StatelessWidget {
  const BottomDropdownItem({
    super.key,
    this.color,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(
      horizontal: Vars.gapMedium,
      vertical: Vars.gapXLarge,
    ),
    this.margin = const EdgeInsets.all(0),
    this.constraints,
    this.width,
    this.height,
    this.elevation = 12.5,
    this.shadowColor = Colors.black54,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(Vars.radius15)),
    ),
    this.clipBehavior,
    required this.child,
  });

  final Color? color;
  final void Function()? onTap;
  final EdgeInsets? padding;
  final EdgeInsetsGeometry? margin;
  final double elevation;
  final BoxConstraints? constraints;
  final double? width;
  final double? height;
  final Color? shadowColor;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CardWidget(
      padding: padding,
      clipBehavior: clipBehavior,
      color: color,
      constraints: constraints,
      elevation: elevation,
      height: height,
      margin: margin,
      onTap: onTap,
      shadowColor: shadowColor,
      shape: shape,
      width: width,
      child: child,
    );
  }
}

class BottomDropdownItemMultiple extends StatelessWidget {
  const BottomDropdownItemMultiple({
    super.key,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(Vars.radius10),
    ),
    this.color,
    this.borderSide,
    this.boxShadow = const [Vars.boxShadow2],
    this.selectedColor,
    this.isSelected = false,
    required this.child,
  });
  final BorderRadius borderRadius;
  final Color? color;
  final BorderSide? borderSide;
  final List<BoxShadow> boxShadow;
  final Color? selectedColor;
  final bool isSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = ThemeApp.of(context).colors, theme = Theme.of(context);

    return ButtonAspect(
      borderRadius: borderRadius,
      boxShadow: [if (!isSelected) ...boxShadow],
      borderSide: borderSide ??
          BorderSide(
            width: 1.3,
            color: isSelected
                ? (selectedColor ?? colors.primary)
                : Colors.transparent,
          ),
      bgColor: color ?? theme.cardColor,
      child: child,
    );
  }
}
