import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef OnCodeEnteredCompletion = void Function(String value);
typedef OnCodeChanged = void Function(String value);
typedef HandleControllers = void Function(
    List<TextEditingController?> controllers);

class OtpTextField extends StatefulWidget {
  OtpTextField({
    super.key,
    this.showCursor = true,
    this.numberOfFields = 4,
    this.fieldWidth = 40.0,
    this.fieldHeight = 58.0,
    this.textStyle,
    this.clearText = false,
    this.styles = const [],
    this.keyboardType = TextInputType.number,
    this.borderWidth = 2.0,
    this.cursorColor,
    this.disabledBorderColor,
    this.enabledBorderColor,
    this.borderColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.filledBorderColor,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.handleControllers,
    this.onSubmit,
    this.obscureText = false,
    this.showFieldAsBox = false,
    this.enabled = true,
    this.autoFocus = false,
    this.filled = false,
    this.fillColor = const Color(0xFFFFFFFF),
    this.readOnly = false,
    this.decoration,
    this.onCodeChanged,
    this.borderRadius = const BorderRadius.all(Radius.circular(4.0)),
    this.inputFormatters,
    this.gap = 10,
    this.loading = false,
    this.loadingColor,
  })  : assert(numberOfFields > 0),
        assert(styles.isNotEmpty
            ? styles.length == numberOfFields
            : styles.isEmpty);

  final bool showCursor;
  final int numberOfFields;
  final double fieldWidth;
  final double fieldHeight;
  final double borderWidth;
  final Color? enabledBorderColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;
  final Color? disabledBorderColor;
  final Color? borderColor;
  final Color? filledBorderColor;
  final Color? cursorColor;
  final TextInputType keyboardType;
  final TextStyle? textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final OnCodeEnteredCompletion? onSubmit;
  final OnCodeEnteredCompletion? onCodeChanged;
  final HandleControllers? handleControllers;
  final bool obscureText;
  final bool showFieldAsBox;
  final bool enabled;
  final bool filled;
  final bool autoFocus;
  final bool readOnly;
  final bool clearText;
  final Color fillColor;
  final BorderRadius borderRadius;
  final InputDecoration? decoration;
  final List<TextStyle?> styles;
  final List<TextInputFormatter>? inputFormatters;
  final double gap;
  final bool loading;
  final Color? loadingColor;

  @override
  State<StatefulWidget> createState() => _OtpTextFieldState();
}

class _OtpTextFieldState extends State<OtpTextField> {
  List<String?> _verificationCode = [];
  List<FocusNode?> _focusNodes = [];
  List<TextEditingController?> _textControllers = [];

  @override
  void initState() {
    _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    _focusNodes = List<FocusNode?>.filled(widget.numberOfFields, null);
    _textControllers = List<TextEditingController?>.filled(
      widget.numberOfFields,
      null,
    );

    super.initState();
  }

  @override
  void didUpdateWidget(covariant OtpTextField oldWidget) {
    if (oldWidget.clearText != widget.clearText && widget.clearText == true) {
      for (var controller in _textControllers) {
        controller?.clear();
      }
      _verificationCode = List<String?>.filled(widget.numberOfFields, null);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    for (var controller in _textControllers) {
      controller?.dispose();
    }
    for (var nodes in _focusNodes) {
      nodes?.removeListener(updateState);
    }
    super.dispose();
  }

  void updateState() => setState(() {});

  InputBorder checkBorder(Color color) => widget.showFieldAsBox
      ? OutlineInputBorder(
          borderSide: BorderSide(width: widget.borderWidth, color: color),
          borderRadius: widget.borderRadius,
        )
      : UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: widget.borderWidth),
        );

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields =
        List.generate(widget.numberOfFields * 2 - 1, (int i) {
      if (i.isOdd) {
        return SizedBox(width: widget.gap);
      } else {
        int index = i ~/ 2;
        addFocusNodeToEachTextField(index: index);
        addTextEditingControllerToEachTextField(index: index);
        if (widget.styles.isNotEmpty) {
          return _buildTextField(
            context: context,
            index: index,
            style: widget.styles[index],
          );
        }
        if (widget.handleControllers != null) {
          widget.handleControllers!(_textControllers);
        }
        return _buildTextField(context: context, index: index);
      }
    });
    return Row(
      mainAxisAlignment: widget.mainAxisAlignment,
      crossAxisAlignment: widget.crossAxisAlignment,
      children: textFields,
    );
  }

  void addFocusNodeToEachTextField({required int index}) {
    if (_focusNodes[index] == null) _focusNodes[index] = FocusNode();

    _focusNodes[index]?.addListener(updateState);
  }

  void addTextEditingControllerToEachTextField({required int index}) {
    if (_textControllers[index] == null) {
      _textControllers[index] = TextEditingController();
    }
  }

  void moveCursorToEnd(int index) {
    if ((_textControllers[index]?.text.length ?? 0) == 0) return;

    _textControllers[index]?.selection =
        const TextSelection.collapsed(offset: 1);
  }

  String replaceSecondValue({
    required String value,
    required int indexOfTextField,
  }) {
    if (value.length <= 1) return value;

    //just replace value if input have 2 length
    _textControllers[indexOfTextField]?.text = value[1];
    return value[1];
  }

  void changeFocusToNextNodeWhenValueIsEntered({
    required String value,
    required int indexOfTextField,
  }) {
    //only change focus to the next textField if the value entered has a length greater than one
    if (value.isNotEmpty) {
      //if the textField in focus is not the last textField,
      // change focus to the next textField
      if (indexOfTextField + 1 != widget.numberOfFields) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField + 1]);
      } else {
        //if the textField in focus is the last textField, unFocus after text changed
        _focusNodes[indexOfTextField]?.unfocus();
      }
    }
  }

  void changeFocusToPreviousNodeWhenValueIsRemoved({
    required String value,
    required int indexOfTextField,
  }) {
    //only change focus to the previous textField if the value entered has a length zero
    if (value.isEmpty) {
      //if the textField in focus is not the first textField,
      // change focus to the previous textField
      if (indexOfTextField != 0) {
        //change focus to the next textField
        FocusScope.of(context).requestFocus(_focusNodes[indexOfTextField - 1]);
      }
    }
  }

  void onSubmit({required List<String?> verificationCode}) {
    if (verificationCode.every((String? code) => code != null && code != '')) {
      if (widget.onSubmit != null) {
        widget.onSubmit!(verificationCode.join());
      }
    }
  }

  void onCodeChanged({required String verificationCode}) {
    if (widget.onCodeChanged != null) {
      widget.onCodeChanged!(verificationCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return generateTextFields(context);
  }

  Color get errorBorder =>
      widget.errorBorderColor ?? Theme.of(context).colorScheme.error;

  Color get focusedBorder =>
      widget.focusedBorderColor ?? Theme.of(context).focusColor;

  Color get enabledBorder =>
      widget.enabledBorderColor ?? Theme.of(context).colorScheme.outline;

  Color get disabledBorder =>
      widget.disabledBorderColor ?? Theme.of(context).disabledColor;

  Color get border =>
      widget.borderColor ?? Theme.of(context).colorScheme.outline;

  Color get filledBorderColor =>
      widget.filledBorderColor ?? Theme.of(context).colorScheme.primary;

  Widget _buildTextField({
    required BuildContext context,
    required int index,
    TextStyle? style,
  }) {
    return widget.loading
        ? Container(
            width: widget.fieldWidth,
            height: widget.fieldHeight,
            decoration: BoxDecoration(
              borderRadius: widget.borderRadius,
              border: Border.all(
                width: widget.borderWidth,
                color:
                    widget.enabledBorderColor != null ? enabledBorder : border,
              ),
            ),
            child: LinearProgressIndicator(
              borderRadius: widget.borderRadius
                  .subtract(const BorderRadius.all(Radius.circular(1))),
              color:
                  widget.loadingColor ?? Theme.of(context).colorScheme.primary,
            ),
          )
        : SizedBox(
            width: widget.fieldWidth,
            height: widget.fieldHeight,
            child: TextField(
              maxLines: null,
              expands: true,
              showCursor: widget.showCursor,
              keyboardType: widget.keyboardType,
              textAlign: TextAlign.center,
              maxLength: 2,
              readOnly: widget.readOnly,
              style: style ?? widget.textStyle,
              autofocus: widget.autoFocus,
              cursorColor: widget.cursorColor,
              controller: _textControllers[index],
              focusNode: _focusNodes[index],
              enabled: widget.enabled,
              inputFormatters: widget.inputFormatters,
              decoration: widget.decoration ??
                  InputDecoration(
                    counterText: "",
                    filled: widget.filled,
                    fillColor: widget.fillColor,
                    errorBorder: checkBorder(errorBorder),
                    focusedBorder: checkBorder(focusedBorder),
                    enabledBorder: checkBorder(
                        (_textControllers[index]?.text.isNotEmpty ?? false)
                            ? filledBorderColor
                            : enabledBorder),
                    disabledBorder: checkBorder(disabledBorder),
                    border: checkBorder(border),
                  ),
              obscureText: widget.obscureText,
              onTap: () => moveCursorToEnd(index),
              onChanged: (String val) {
                //save entered value in a list
                _verificationCode[index] = val;
                final value =
                    replaceSecondValue(value: val, indexOfTextField: index);

                onCodeChanged(verificationCode: value);

                changeFocusToNextNodeWhenValueIsEntered(
                    value: value, indexOfTextField: index);

                changeFocusToPreviousNodeWhenValueIsRemoved(
                    value: value, indexOfTextField: index);

                onSubmit(verificationCode: _verificationCode);
              },
            ),
          );
  }
}
