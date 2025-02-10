import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/extensions/widget_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/expands_wrapper.dart';
import 'package:flutter_detextre4/utils/packages/skeletons/skeleton_widgets.dart';

class ListTileWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? title;
  final Widget? subTitle;
  final Widget? leading;
  final String? leadingImage;
  final double leadingSize;
  final double leadingRadius;
  final Widget? trailing;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;
  final ShapeBorder? shape;
  final double? horizontalTitleGap;
  const ListTileWidget({
    super.key,
    this.onTap,
    this.title,
    this.subTitle,
    this.leading,
    this.leadingImage,
    this.leadingSize = 80,
    this.leadingRadius = Vars.radius50,
    this.trailing,
    this.contentPadding,
    this.dense = true,
    this.shape,
    this.horizontalTitleGap,
  });

  @override
  Widget build(BuildContext context) {
    final border = shape ??
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Vars.radius15));

    return Material(
      shadowColor: Colors.black54,
      elevation: 5,
      shape: border,
      child: ListTile(
        dense: dense,
        contentPadding: contentPadding,
        shape: border,
        onTap: onTap,
        horizontalTitleGap: horizontalTitleGap,
        leading: leading ??
            (leadingImage != null
                ? ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(leadingRadius),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: leadingImage ?? '',
                      width: leadingSize / 2,
                      height: leadingSize / 2,
                      fit: BoxFit.cover,
                    ).prebuilder(),
                  )
                : null),
        title: title,
        subtitle: subTitle,
        trailing: trailing,
      ),
    );
  }
}

class ListTileExpandedWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final Widget? title;
  final Widget? subTitle;
  final Widget? leading;
  final String? leadingImage;
  final double leadingSize;
  final double leadingRadius;
  final Widget? trailing;
  final Widget Function(BuildContext context)? desplegableBuilder;
  final double desplegableGap;
  final EdgeInsetsGeometry? contentPadding;
  final bool dense;
  final ShapeBorder? shape;
  final Color bgColor;
  final Color? menuIconColor;
  final double? horizontalTitleGap;
  final AnimationController? expandsController;
  final double elevation;
  final bool disabled;
  const ListTileExpandedWidget({
    super.key,
    this.onTap,
    this.title,
    this.subTitle,
    this.leading,
    this.leadingImage,
    this.leadingSize = 80,
    this.leadingRadius = Vars.radius50,
    this.trailing,
    this.desplegableBuilder,
    this.desplegableGap = 0,
    this.contentPadding,
    this.dense = true,
    this.shape,
    this.bgColor = Colors.white,
    this.menuIconColor,
    this.horizontalTitleGap,
    this.expandsController,
    this.elevation = 5,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Vars.radius15),
          side: const BorderSide(color: Color(0xffE3E3E3)),
        );

    return ExpandsWrapper(
      key: key,
      desplegableBuilder: desplegableBuilder,
      desplegableGap: desplegableGap,
      onTap: onTap,
      child: (context, animationController, handlerExpands) {
        return Material(
          shadowColor: Colors.black54,
          elevation: elevation,
          color: bgColor,
          shape: border,
          child: ListTile(
            onTap: disabled
                ? null
                : () {
                    handlerExpands();
                    if (onTap != null) onTap!();
                  },
            dense: dense,
            contentPadding: contentPadding,
            shape: border,
            horizontalTitleGap: horizontalTitleGap,
            leading: leading ??
                ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(leadingRadius),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: leadingImage ?? '',
                    width: leadingSize / 2,
                    height: leadingSize / 2,
                    fit: BoxFit.cover,
                  ).prebuilder(),
                ),
            title: title,
            subtitle: subTitle,
            trailing: trailing ??
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) => Icon(
                    animationController.isCompleted
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    color: menuIconColor,
                  ),
                ),
          ),
        );
      },
    );
  }
}

class ListTileSkeleton extends StatelessWidget {
  const ListTileSkeleton({
    super.key,
    this.shape,
    this.padding,
    this.customTrailling,
    this.hideTrailling = false,
    this.minHeight = 70,
  });
  final ShapeBorder? shape;
  final EdgeInsetsGeometry? padding;
  final Widget? customTrailling;
  final bool hideTrailling;
  final double minHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      shadowColor: Colors.black54,
      elevation: 5,
      shape: shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Vars.radius15)),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Skeleton(
          isLoading: true,
          duration: Vars.skeletonDuration,
          shimmerGradient: Vars.getGradient(context),
          skeleton: SkeletonListTile(
            contentSpacing: 20,
            padding: padding ??
                const EdgeInsets.only(
                    left: 5, right: 5, top: 3, bottom: Vars.gapXLow),
            leadingStyle: const SkeletonAvatarStyle(
              width: 40,
              height: 40,
              padding: EdgeInsets.only(left: Vars.gapMedium),
              shape: BoxShape.circle,
            ),
            hasSubtitle: true,
            titleStyle: const SkeletonLineStyle(height: 15, randomLength: true),
            subtitleStyle:
                const SkeletonLineStyle(height: 15, randomLength: true),
            trailing: hideTrailling
                ? null
                : customTrailling ??
                    Padding(
                      padding: const EdgeInsets.only(left: Vars.gapMedium),
                      child: SizedBox(
                        width: 60,
                        child: SkeletonListTile(
                          leadingStyle: const SkeletonAvatarStyle(
                              width: 20, height: 20, shape: BoxShape.circle),
                          titleStyle: const SkeletonLineStyle(height: 10),
                        ),
                      ),
                    ),
          ),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
