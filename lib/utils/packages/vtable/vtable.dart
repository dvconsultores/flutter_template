// Copyright (c) 2023, Devon Carew. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'vtable_copy_action.dart';
import 'vtable_theme.dart';

/// A callback to react to row taps.
typedef ItemTapHandler<T> = void Function(T object);

/// A callback to react to table row selection changes.
typedef OnSelectionChanged<T> = void Function(T? selectedItem);

/// A Flutter table widget featuring virtualization, sorting, and custom cell
/// rendering.
class VTable<T> extends StatefulWidget {
  static const double _vertPadding = 4;
  static const double _horizPadding = 8;

  /// The list of data rows for the table.
  final List<T> items;

  /// The list of columns to display for the table.
  final List<VTableColumn<T>> columns;

  /// The ScrollController used by the data table.
  final ScrollController? scrollController;

  /// Whether the table should initially sort the rows.
  final bool startsSorted;

  /// Whether this table should track and render row selection.
  final bool supportsSelection;

  /// A callback used to react to a double tap on a table row.
  final ItemTapHandler<T>? onDoubleTap;

  /// A callback used to react to table selection changes.
  final OnSelectionChanged<T>? onSelectionChanged;

  /// A optional description of the table.
  ///
  /// If provided, this is displayed in the far left side of the table's
  /// toolbar. E.g., `'234 items'`.
  final String? tableDescription;

  /// An optional set of widgets to display in the left side of the table's
  /// toolbar.
  ///
  /// This is often used as a place to put filter related widgets.
  final List<Widget> filterWidgets;

  /// An optional set of widgets to display in the right side of the table's
  /// toolbar.
  ///
  /// This is often used as a place to display additional table actions.
  final List<Widget> actions;

  /// The delay to use for table tooltips.
  ///
  /// Tooltips are used to display any validation results from a column's
  /// validators.
  final Duration tooltipDelay;

  /// The height to use for table rows.
  final double rowHeight;

  /// The height to use for table headers.
  final double headersHeight;

  /// Whether to include a 'copy to clipboard' action in the toolbar.
  ///
  /// If included, this action will copy the table's contents as CSV to the
  /// system clipboard.
  final bool includeCopyToClipboardAction;

  /// Whether to show column headers.
  final bool showHeaders;

  /// Determines whether a separator should be displayed between the table headers and the table body.
  ///
  /// If set to `true`, a visual separator (such as a line) will be shown below the headers.
  /// If set to `false`, no separator will be displayed.
  final bool showHeadersSeparator;

  /// Whether to show a table toolbar.
  final bool showToolbar;

  /// Show separator between toolbar and table.
  final bool showToolbarSeparator;

  /// Show data table separators.
  final bool showSeparators;

  /// Gap of the rendered rows.
  final double rowGap;

  /// Gap between headers and rows.
  final double gapHeadersVsRows;

  /// Render the body of each row.
  final Widget Function(BuildContext context, Widget child, bool selected)?
      rowsBuilder;

  /// Render the body of headers.
  final Widget Function(BuildContext context, Widget child)? headersBuilder;

  /// Render toolbar body.
  final Widget Function(
    BuildContext context,
    String? description,
    List<Widget> filters,
    List<Widget> actions,
  )? toolbarBuilder;

  /// Padding of the table.
  final EdgeInsets padding;

  /// Construct a new `VTable` instance.
  ///
  /// E.g:
  ///
  /// ```
  /// Widget build(BuildContext context) {
  ///   return VTable<SampleRowData>(
  ///     items: listOfItems,
  ///     columns: [
  ///       VTableColumn(
  ///         label: 'Planet',
  ///         width: 120,
  ///         grow: 0.6,
  ///         transformFunction: (row) => row.name,
  ///       ),
  ///       VTableColumn(
  ///         label: 'Gravity',
  ///         width: 100,
  ///         grow: 0.3,
  ///         transformFunction: (row) => row.gravity.toStringAsFixed(1),
  ///         alignment: Alignment.centerRight,
  ///         compareFunction: (a, b) => a.gravity.compareTo(b.gravity),
  ///         validators: [SampleRowData.validateGravity],
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  const VTable({
    required this.items,
    required this.columns,
    this.scrollController,
    this.startsSorted = false,
    this.supportsSelection = false,
    this.onDoubleTap,
    this.onSelectionChanged,
    this.tableDescription,
    this.filterWidgets = const [],
    this.actions = const [],
    this.tooltipDelay = defaultTooltipDelay,
    this.rowHeight = defaultRowHeight,
    this.headersHeight = defaultHeadersHeight,
    this.includeCopyToClipboardAction = false,
    this.showHeaders = true,
    this.showHeadersSeparator = true,
    this.showToolbar = true,
    this.showToolbarSeparator = true,
    this.showSeparators = true,
    this.rowGap = 0,
    this.gapHeadersVsRows = 0,
    this.rowsBuilder,
    this.headersBuilder,
    this.toolbarBuilder,
    this.padding = EdgeInsets.zero,
    super.key,
  });

  @override
  State<VTable> createState() => _VTableState<T>();
}

class _VTableState<T> extends State<VTable<T>> {
  final scrollController = ScrollController();
  ScrollController get getScrollController =>
      widget.scrollController ?? scrollController;

  late List<T> sortedItems;
  int? sortColumnIndex;
  bool sortAscending = true;
  final ValueNotifier<T?> selectedItem = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    sortedItems = widget.items.toList();

    _performInitialSort();

    selectedItem.addListener(() {
      if (widget.onSelectionChanged != null) {
        widget.onSelectionChanged!(selectedItem.value);
      }
    });
  }

  @override
  void didUpdateWidget(VTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    sortedItems = widget.items;
    _performInitialSort();

    // Clear the selection if the selected item is no longer in the table.
    if (selectedItem.value != null &&
        !sortedItems.contains(selectedItem.value)) {
      selectedItem.value = null;
    }
  }

  void _performInitialSort() {
    if (widget.startsSorted && columns.first.supportsSort) {
      columns.first.sort(sortedItems, ascending: true);
      sortColumnIndex = 0;
    }
  }

  List<VTableColumn<T>> get columns => widget.columns;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (widget.showToolbar) createActionRow(context),
      if (widget.showToolbarSeparator && widget.showToolbar) const Divider(),
      Expanded(
        child: Padding(
          padding: widget.padding,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            Map<VTableColumn, double> colWidths = _layoutColumns(constraints);

            return Column(children: [
              if (widget.showHeaders) createHeaderRow(colWidths),
              SizedBox(height: widget.gapHeadersVsRows),
              Expanded(
                child: createRowsListView(context, colWidths),
              ),
            ]);
          }),
        ),
      ),
    ]);
  }

  Widget createActionRow(BuildContext context) {
    final extraActions = [];

    if (widget.includeCopyToClipboardAction) {
      if (widget.actions.isNotEmpty) {
        extraActions.add(
            const SizedBox(height: toolbarHeight, child: VerticalDivider()));
      }

      extraActions.add(CopyToClipboardAction<T>());
    }

    if (widget.toolbarBuilder != null) {
      return widget.toolbarBuilder!(
        context,
        widget.tableDescription,
        widget.filterWidgets,
        [...widget.actions, ...extraActions],
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 16),
      child: Row(
        children: [
          Text(widget.tableDescription ?? ''),
          const Expanded(child: SizedBox(width: 8)),
          ...widget.filterWidgets,
          const Expanded(child: SizedBox(width: 8)),
          ...widget.actions,
          ...extraActions,
        ],
      ),
    );
  }

  Widget createHeaderRow(Map<VTableColumn<dynamic>, double> colWidths) {
    var sortColumn = sortColumnIndex == null ? null : columns[sortColumnIndex!];

    final headers = Row(
      children: [
        for (var column in columns)
          InkWell(
            onTap: () => trySort(column),
            child: _ColumnHeader(
              title: column.label,
              titleStyle: column.labelStyle,
              titleAlign: column.labelAlign,
              icon: column.icon,
              width: colWidths[column],
              height: widget.headersHeight,
              alignment: column.alignment,
              sortAscending: column == sortColumn ? sortAscending : null,
            ),
          ),
      ],
    );

    return widget.headersBuilder != null
        ? widget.headersBuilder!(context, headers)
        : headers;
  }

  ListView createRowsListView(
    BuildContext context,
    Map<VTableColumn<dynamic>, double> colWidths,
  ) {
    final theme = Theme.of(context);
    final rowSeparator = widget.showSeparators
        ? BoxDecoration(
            border: Border(top: BorderSide(color: theme.dividerColor)),
          )
        : const BoxDecoration();

    final colorScheme = theme.colorScheme;
    final darkMode = colorScheme.brightness == Brightness.dark;

    return ListView.separated(
      controller: getScrollController,
      itemCount: sortedItems.length,
      separatorBuilder: (BuildContext context, int index) =>
          SizedBox(height: widget.rowGap),
      itemBuilder: (BuildContext context, int index) {
        T item = sortedItems[index];
        final selected = item == selectedItem.value;

        final row = Row(
          children: [
            for (var column in columns)
              Padding(
                padding: const EdgeInsets.only(top: 1, right: 1),
                child: SizedBox(
                  height: widget.rowHeight - 1,
                  width: colWidths[column]! - 1,
                  child: Tooltip(
                    message: column.validate(item)?.message ?? '',
                    waitDuration: widget.tooltipDelay,
                    child: Container(
                      alignment: column.alignment ?? Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: VTable._horizPadding,
                        vertical: VTable._vertPadding,
                      ),
                      color: column
                          .validate(item)
                          ?.colorForSeverity(darkMode: darkMode),
                      child: column.widgetFor(context, item),
                    ),
                  ),
                ),
              )
          ],
        );

        return Container(
          key: ValueKey(item),
          color: widget.rowsBuilder == null && selected
              ? Theme.of(context).hoverColor
              : null,
          height: widget.rowHeight,
          child: InkWell(
            onTap: () => _select(item),
            onDoubleTap: () => _doubleTap(item),
            child: DecoratedBox(
              decoration:
                  ((widget.showHeaders && widget.showHeadersSeparator) ||
                          index != 0)
                      ? rowSeparator
                      : const BoxDecoration(),
              child: widget.rowsBuilder != null
                  ? widget.rowsBuilder!(context, row, selected)
                  : row,
            ),
          ),
        );
      },
    );
  }

  void trySort(VTableColumn<T> column) {
    if (!column.supportsSort) {
      return;
    }

    setState(() {
      int newIndex = columns.indexOf(column);
      if (sortColumnIndex == newIndex) {
        sortAscending = !sortAscending;
      } else {
        sortAscending = true;
      }

      sortColumnIndex = newIndex;
      column.sort(sortedItems, ascending: sortAscending);
    });
  }

  Map<VTableColumn, double> _layoutColumns(BoxConstraints constraints) {
    double width = constraints.maxWidth;

    Map<VTableColumn, double> widths = {};
    double minColWidth = 0;
    double totalGrow = 0;

    for (var col in columns) {
      minColWidth += col.width;
      totalGrow += col.grow;

      widths[col] = col.width.toDouble();
    }

    width -= minColWidth;

    if (width > 0 && totalGrow > 0) {
      for (var col in columns) {
        if (col.grow > 0) {
          var inc = width * (col.grow / totalGrow);
          widths[col] = widths[col]! + inc;
        }
      }
    }

    return widths;
  }

  void _select(T item) {
    if (widget.supportsSelection) {
      setState(() {
        if (selectedItem.value != item) {
          selectedItem.value = item;
        } else {
          selectedItem.value = null;
        }
      });
    }
  }

  void _doubleTap(T item) {
    if (widget.onDoubleTap != null) {
      widget.onDoubleTap!(item);
    }
  }
}

class _ColumnHeader extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final TextAlign? titleAlign;
  final double? width;
  final double? height;
  final IconData? icon;
  final Alignment? alignment;
  final bool? sortAscending;

  const _ColumnHeader({
    required this.title,
    this.titleStyle,
    this.titleAlign,
    required this.width,
    required this.height,
    this.icon,
    this.alignment,
    this.sortAscending,
  });

  @override
  Widget build(BuildContext context) {
    var swapSortIconSized = alignment != null && alignment!.x > 0;

    return SizedBox(
      width: width,
      height: height,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: VTable._horizPadding,
          vertical: VTable._vertPadding,
        ),
        //alignment: alignment ?? Alignment.centerLeft,
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            if (sortAscending != null && swapSortIconSized)
              AnimatedRotation(
                turns: sortAscending! ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_up),
              ),
            Expanded(
              child: icon != null
                  ? Tooltip(
                      message: title,
                      child: Align(
                        alignment: alignment ?? Alignment.centerLeft,
                        child: Icon(icon),
                      ),
                    )
                  : Text(
                      title,
                      style: titleStyle ??
                          const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: swapSortIconSized ? TextAlign.end : titleAlign,
                    ),
            ),
            if (sortAscending != null && !swapSortIconSized)
              AnimatedRotation(
                turns: sortAscending! ? 0 : 0.5,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.keyboard_arrow_up),
              ),
          ],
        ),
      ),
    );
  }
}

/// A callback to render a data object (`T`) to a widget.
typedef RenderFunction<T> = Widget? Function(
    BuildContext context, T object, String out);

/// A callback to render a data object to a string.
typedef TransformFunction<T> = String Function(T object);

/// A callback to apply style to a cell based on a data object's properties.
typedef StyleFunction<T> = TextStyle? Function(T object);

/// A callback to compare two table row data objects.
typedef CompareFunction<T> = int Function(T a, T b);

/// A callback to apply validation to a table cell.
///
/// See [ValidationResult] for the possible return values.
typedef ValidationFunction<T> = ValidationResult? Function(T object);

/// The definition of a table's column.
class VTableColumn<T> {
  /// The title of a column.
  final String label;

  /// The TextStyle in the title of a column.
  final TextStyle? labelStyle;

  /// The TextAlign in the title of a column.
  final TextAlign? labelAlign;

  /// An icon for the column; if provided, this will be displayed instead of the
  /// column's title.
  final IconData? icon;

  /// The desired width of a column in pixels.
  final int width;

  /// The grow of a column; this is used to allocate excess table width between
  /// columns.
  final double grow;

  /// The alignment for a column's contents; this will default to
  /// [Alignment.centerLeft].
  final Alignment? alignment;

  /// A callback to convert a cell's contents to a string; if not provided, this
  /// will default to calling `toString` on the row object.
  final TransformFunction<T>? transformFunction;

  /// A callback to allow for custom styling of a cell (bold, italic, ...).
  final StyleFunction<T>? styleFunction;

  /// A callback to compare two row objects; this is used when sorting rows.
  final CompareFunction<T>? compareFunction;

  /// A set of validators for cell contents.
  final List<ValidationFunction<T>> validators;

  /// A callback to support converting a data object to a custom widget.
  final RenderFunction<T>? renderFunction;

  /// Construct a new [VTableColumn intance.
  VTableColumn({
    required this.label,
    this.labelStyle,
    this.labelAlign,
    required this.width,
    this.icon,
    this.alignment,
    this.grow = 0,
    this.transformFunction,
    this.styleFunction,
    this.compareFunction,
    this.validators = const [],
    this.renderFunction,
  });

  Widget widgetFor(BuildContext context, T item) {
    final out = transformFunction != null ? transformFunction!(item) : '$item';

    if (renderFunction != null) {
      Widget? widget = renderFunction!(context, item, out);
      if (widget != null) return widget;
    }

    var style = styleFunction == null ? null : styleFunction!(item);
    return Text(
      out,
      style: style,
      maxLines: 2,
    );
  }

  void sort(List<T> items, {required bool ascending}) {
    if (compareFunction != null) {
      items
          .sort(ascending ? compareFunction : (a, b) => compareFunction!(b, a));
    } else if (transformFunction != null) {
      items.sort((T a, T b) {
        var strA = transformFunction!(a);
        var strB = transformFunction!(b);
        return ascending ? strA.compareTo(strB) : strB.compareTo(strA);
      });
    }
  }

  bool get supportsSort => compareFunction != null || transformFunction != null;

  ValidationResult? validate(T item) {
    if (validators.isEmpty) {
      return null;
    } else if (validators.length == 1) {
      return validators.first(item);
    } else {
      List<ValidationResult> results = [];
      for (var validator in validators) {
        ValidationResult? result = validator(item);
        if (result != null) {
          results.add(result);
        }
      }
      return ValidationResult.combine(results);
    }
  }
}

/// The possible severity results for cell validation.
enum Severity {
  info,
  note,
  warning,
  error,
}

/// A cell validation result; this includes both the severity and a custom
/// message.
///
/// E.g., `ValidationResult('gravity too high', Severity.warning)`.
class ValidationResult {
  final String message;
  final Severity severity;

  ValidationResult(this.message, this.severity);

  factory ValidationResult.error(String message) =>
      ValidationResult(message, Severity.error);

  factory ValidationResult.warning(String message) =>
      ValidationResult(message, Severity.warning);

  factory ValidationResult.note(String message) =>
      ValidationResult(message, Severity.note);

  factory ValidationResult.info(String message) =>
      ValidationResult(message, Severity.info);

  Color colorForSeverity({bool darkMode = true}) {
    if (darkMode) {
      switch (severity) {
        case Severity.info:
          return Colors.grey.shade400;
        case Severity.note:
          return Colors.blue.shade400;
        case Severity.warning:
          return Colors.yellow.shade700;
        case Severity.error:
          return Colors.red.shade400;
      }
    } else {
      switch (severity) {
        case Severity.info:
          return Colors.grey.shade400.withAlpha(127);
        case Severity.note:
          return Colors.blue.shade200.withAlpha(127);
        case Severity.warning:
          return Colors.yellow.shade200.withAlpha(127);
        case Severity.error:
          return Colors.red.shade300.withAlpha(127);
      }
    }
  }

  @override
  String toString() => '$severity $message';

  static ValidationResult? combine(List<ValidationResult> results) {
    if (results.isEmpty) {
      return null;
    } else if (results.length == 1) {
      return results.first;
    } else {
      String message = results.map((r) => r.message).join('\n');
      Severity severity = results
          .map((r) => r.severity)
          .reduce((a, b) => a.index >= b.index ? a : b);
      return ValidationResult(message, severity);
    }
  }
}
