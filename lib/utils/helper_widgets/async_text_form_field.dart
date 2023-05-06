import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';

class AsyncTextFormField extends StatefulWidget {
  const AsyncTextFormField({
    super.key,
    this.validator,
    this.onChanged,
    this.validationDebounce = const Duration(milliseconds: 200),
    this.autocorrect = true,
    this.autofillHints,
    this.autofocus = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.buildCounter,
    this.contextMenuBuilder,
    this.controller,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorWidth = 2.0,
    this.decoration,
    this.enableIMEPersonalizedLearning = true,
    this.enableInteractiveSelection,
    this.enableSuggestions = true,
    this.enabled,
    this.expands = false,
    this.focusNode,
    this.initialValue,
    this.inputFormatters,
    this.onTap,
    this.keyboardAppearance,
    this.keyboardType,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.mouseCursor,
    this.obscureText = false,
    this.obscuringCharacter = '•',
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.onTapOutside,
    this.readOnly = false,
    this.restorationId,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.scrollPhysics,
    this.selectionControls,
    this.showCursor,
    this.smartDashesType,
    this.smartQuotesType,
    this.strutStyle,
    this.style,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textInputAction,
  });

  final Future<String?> Function(String? value)? validator;
  final void Function(String value)? onChanged;
  final Duration validationDebounce;
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final AutovalidateMode autovalidateMode;
  final Widget? Function(BuildContext context,
      {required int currentLength,
      required bool isFocused,
      required int? maxLength})? buildCounter;
  final Widget Function(
          BuildContext context, EditableTextState editableTextState)?
      contextMenuBuilder;
  final TextEditingController? controller;
  final Color? cursorColor;
  final double? cursorHeight;
  final Radius? cursorRadius;
  final double cursorWidth;
  final InputDecoration? decoration;
  final bool enableIMEPersonalizedLearning;
  final bool? enableInteractiveSelection;
  final bool enableSuggestions;
  final bool? enabled;
  final bool expands;
  final FocusNode? focusNode;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTap;
  final Brightness? keyboardAppearance;
  final TextInputType? keyboardType;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int maxLines;
  final int? minLines;
  final MouseCursor? mouseCursor;
  final bool obscureText;
  final String obscuringCharacter;
  final void Function()? onEditingComplete;
  final void Function(String value)? onFieldSubmitted;
  final void Function(String? value)? onSaved;
  final void Function(PointerDownEvent pointerDownEvent)? onTapOutside;
  final bool readOnly;
  final String? restorationId;
  final ScrollController? scrollController;
  final EdgeInsets scrollPadding;
  final ScrollPhysics? scrollPhysics;
  final TextSelectionControls? selectionControls;
  final bool? showCursor;
  final SmartDashesType? smartDashesType;
  final SmartQuotesType? smartQuotesType;
  final StrutStyle? strutStyle;
  final TextStyle? style;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;

  @override
  State<AsyncTextFormField> createState() => _AsyncTextFormFieldState();
}

class _AsyncTextFormFieldState extends State<AsyncTextFormField> {
  Timer? _debounce;
  String? validatorMessage;
  bool isValidating = false;
  bool isWaiting = false;

  Future<String?> validate(String value) async {
    setState(() => isValidating = true);
    isValidating = false;
    return widget.validator.isExist ? widget.validator!(value) : null;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void cancelTimer() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.key,
      validator: (value) => validatorMessage,
      onChanged: (value) async {
        isWaiting = true;
        cancelTimer();

        _debounce = Timer(widget.validationDebounce, () async {
          isWaiting = false;
          validatorMessage = await validate(value);
          debugPrint("$validatorMessage");
          setState(() => isValidating = false);
        });

        widget.onChanged.isExist ? widget.onChanged!(value) : null;
      },
      autocorrect: widget.autocorrect,
      autofillHints: widget.autofillHints,
      autofocus: widget.autofocus,
      autovalidateMode: widget.autovalidateMode,
      buildCounter: widget.buildCounter,
      contextMenuBuilder: widget.contextMenuBuilder,
      controller: widget.controller,
      cursorColor: widget.cursorColor,
      cursorHeight: widget.cursorHeight,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth,
      decoration: widget.decoration,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      enableSuggestions: widget.enableSuggestions,
      enabled: widget.enabled,
      expands: widget.expands,
      focusNode: widget.focusNode,
      initialValue: widget.initialValue,
      inputFormatters: widget.inputFormatters,
      onTap: widget.onTap,
      keyboardAppearance: widget.keyboardAppearance,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      maxLengthEnforcement: widget.maxLengthEnforcement,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      mouseCursor: widget.mouseCursor,
      obscureText: widget.obscureText,
      obscuringCharacter: widget.obscuringCharacter,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      onTapOutside: widget.onTapOutside,
      readOnly: widget.readOnly,
      restorationId: widget.restorationId,
      scrollController: widget.scrollController,
      scrollPadding: widget.scrollPadding,
      scrollPhysics: widget.scrollPhysics,
      selectionControls: widget.selectionControls,
      showCursor: widget.showCursor,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      strutStyle: widget.strutStyle,
      style: widget.style,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textCapitalization: widget.textCapitalization,
      textDirection: widget.textDirection,
      textInputAction: widget.textInputAction,
    );
  }
}
