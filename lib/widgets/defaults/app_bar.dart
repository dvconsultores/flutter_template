import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_gap/flutter_gap.dart';

class CustomAppBar extends AppBar {
  CustomAppBar({
    super.key,
    this.titleText,
    this.subTitleText,
    super.centerTitle = true,
  }) : super(
          systemOverlayStyle: ThemeApp.systemUiOverlayStyle,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            iconSize: 28,
            onPressed: () => router.goNamed("home"),
          ),
          bottom: PreferredSize(
              preferredSize: const Size(0, 0),
              child: Transform.translate(
                offset: const Offset(0, -5),
                child: Container(
                    margin: Vars.paddingScaffold.copyWith(top: 0, bottom: 0),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: ThemeApp.colors(null).label)),
                    )),
              )),
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(
              left: Vars.gapLow,
              right: Vars.paddingScaffold.right,
              bottom: subTitleText.hasValue ? Vars.gapMedium : 0,
            ),
            child: Column(children: [
              if (titleText.hasValue) Text(titleText!),
              if (subTitleText.hasValue) ...[
                const Gap(Vars.gapXLow).column,
                Text(subTitleText!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ))
              ],
            ]),
          ),
        );

  final String? titleText;
  final String? subTitleText;
}
