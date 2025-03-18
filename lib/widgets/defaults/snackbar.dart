import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter/material.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

BuildContext _getContext(BuildContext? context) =>
    context ?? ContextUtility.context!;

// * App snackbar types
enum SnackbarType {
  neutral,
  info,
  success,
  warning,
  error;
}

/// A global snackbar that can be invoked onto whatever widget.
/// To make it indefinite, set messageDuration to null
/// TODO do implementation to send snackbar with same id and replace old snackbar by id
void showSnackbar(
  String message, {
  BuildContext? context,
  String? title,
  SnackbarType? type,
  Duration? duration = const Duration(seconds: 15),
  bool closable = true,
  FlushbarDismissDirection dismissDirection = FlushbarDismissDirection.VERTICAL,
  FlushbarPosition? flushbarPosition,
  FlushbarStyle flushbarStyle = FlushbarStyle.FLOATING,
  double? maxWidth,
}) {
  if (message.hasNotValue) return;

  final isMobile = _getContext(context).width.isMobile;

  (Color, Icon?, FlushbarPosition) getValueByType() {
    Color? color;

    switch (type) {
      case SnackbarType.success:
        return (
          color ??= ThemeApp.of(_getContext(context)).colors.success,
          Icon(Icons.check_circle_outline_rounded, color: color),
          isMobile ? FlushbarPosition.BOTTOM : FlushbarPosition.TOP
        );
      case SnackbarType.warning:
        return (
          color ??= ThemeApp.of(_getContext(context)).colors.warning,
          Icon(Icons.warning_amber_rounded, color: color),
          isMobile ? FlushbarPosition.BOTTOM : FlushbarPosition.TOP
        );
      case SnackbarType.error:
        return (
          color ??= ThemeApp.of(_getContext(context)).colors.error,
          Icon(Icons.error_rounded, color: color),
          isMobile ? FlushbarPosition.BOTTOM : FlushbarPosition.TOP
        );
      case SnackbarType.info:
        return (
          color ??= ThemeApp.of(_getContext(context)).colors.secondary,
          Icon(Icons.info_outline_rounded, color: color),
          isMobile ? FlushbarPosition.BOTTOM : FlushbarPosition.TOP
        );
      case SnackbarType.neutral:
      default:
        return (
          color ??= ThemeApp.of(_getContext(context)).colors.text,
          null,
          isMobile ? FlushbarPosition.BOTTOM : FlushbarPosition.TOP
        );
    }
  }

  Flushbar? flushbar;
  flushbar = Flushbar(
    maxWidth: maxWidth ?? Vars.mobileSize.width,
    titleText: title.hasValue
        ? Text(title!,
            style: Theme.of(_getContext(context)).textTheme.bodyLarge)
        : null,
    messageText: Text(
      message,
      style: Theme.of(_getContext(context))
          .textTheme
          .bodyMedium
          ?.copyWith(fontSize: 14),
    ),
    icon: getValueByType().$2,
    titleColor: ThemeApp.of(_getContext(context)).colors.text,
    messageColor: ThemeApp.of(_getContext(context)).colors.text,
    backgroundColor: ThemeApp.of(_getContext(context)).colors.surface,
    borderRadius: const BorderRadius.all(Radius.circular(Vars.radius20)),
    borderColor: getValueByType().$1,
    borderWidth: 2.5,
    dismissDirection: dismissDirection,
    mainButton: closable
        ? IconButton(
            onPressed: () => flushbar?.dismiss(),
            icon: const Icon(Icons.close),
            splashRadius: 20,
          )
        : null,
    positionOffset: 20,
    flushbarPosition: flushbarPosition ?? getValueByType().$3,
    margin: EdgeInsets.only(
      top: isMobile ? 0 : Vars.gapMedium,
      left: Vars.gapMedium,
      right: Vars.gapMedium,
    ),
    duration: duration,
    flushbarStyle: flushbarStyle,
  );

  MainProvider.read(context).addSnackbar = flushbar;

  flushbar.show(_getContext(context));
}

void clearSnackbars([BuildContext? context]) =>
    MainProvider.read(context).clearSnackbars;
