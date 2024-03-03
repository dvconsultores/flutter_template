import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/extensions/widget_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:skeletons/skeletons.dart';

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
      elevation: 10,
      shape: border,
      child: ListTile(
        dense: dense,
        contentPadding: contentPadding,
        shape: border,
        onTap: onTap,
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
        trailing: trailing,
      ),
    );
  }
}

class ListTileExpandedWidget extends StatefulWidget {
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
  final double? horizontalTitleGap;
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
    this.horizontalTitleGap,
  });

  @override
  State<ListTileExpandedWidget> createState() => _ListTileExpandedWidgetState();
}

class _ListTileExpandedWidgetState extends State<ListTileExpandedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animController;

  @override
  void initState() {
    animController =
        AnimationController(vsync: this, duration: Durations.short2)
          ..drive(CurveTween(curve: Curves.bounceIn));
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.shape ??
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Vars.radius15));

    return Column(children: [
      Material(
        shadowColor: Colors.black54,
        elevation: 10,
        shape: border,
        child: ListTile(
          onTap: () {
            animController.isCompleted
                ? animController.reverse()
                : animController.forward();

            if (widget.onTap != null) widget.onTap!();
          },
          dense: widget.dense,
          contentPadding: widget.contentPadding,
          shape: border,
          horizontalTitleGap: widget.horizontalTitleGap,
          leading: widget.leading ??
              ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.leadingRadius),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.leadingImage ?? '',
                  width: widget.leadingSize / 2,
                  height: widget.leadingSize / 2,
                  fit: BoxFit.cover,
                ).prebuilder(),
              ),
          title: widget.title,
          subtitle: widget.subTitle,
          trailing: widget.trailing ??
              AnimatedBuilder(
                animation: animController,
                builder: (context, child) => Icon(
                  animController.isCompleted
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down,
                ),
              ),
        ),
      ),
      if (widget.desplegableBuilder != null)
        AnimatedBuilder(
          animation: animController,
          builder: (context, child) {
            final translate =
                    Tween<double>(begin: -widget.desplegableGap, end: 0)
                        .animate(animController),
                opacity =
                    Tween<double>(begin: 0, end: 1).animate(animController);

            if (animController.isAnimating || animController.isCompleted) {
              return Opacity(
                opacity: opacity.value,
                child: Transform.translate(
                  offset: Offset(0, translate.value),
                  child: child!,
                ),
              );
            }

            return const SizedBox.shrink();
          },
          child: Column(children: [
            Gap(widget.desplegableGap).column,
            widget.desplegableBuilder!(context)
          ]),
        ),
    ]);
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
    const duration = Duration(milliseconds: 1500);

    return Material(
      shadowColor: Colors.black54,
      elevation: 10,
      shape: shape ??
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Vars.radius15)),
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        child: Skeleton(
          isLoading: true,
          duration: duration,
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
