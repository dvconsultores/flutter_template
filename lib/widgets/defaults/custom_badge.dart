import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';

class CustomBadge extends badges.Badge {
  CustomBadge({
    super.key,
    super.child,
    super.showBadge,
    required String text,
    List<Color>? colors,
  }) : super(
          position: badges.BadgePosition.topEnd(top: 10, end: -8),
          badgeStyle: const badges.BadgeStyle(
            padding: EdgeInsets.all(0),
            badgeColor: Colors.transparent,
          ),
          badgeContent: Transform(
            transform: Matrix4.skewY(0.15),
            child: Transform.rotate(
              angle: 69.7,
              origin: const Offset(5, 5),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: Vars.gapXLow,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: colors ??
                          [
                            ThemeApp.colors(null).tertiary,
                          ]),
                  boxShadow: const [Vars.boxShadow2],
                  borderRadius: const BorderRadius.all(Radius.circular(2)),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
}
