// FIXME under testing
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/extensions/widget_extensions.dart';

class BottomSheetListItem {
  const BottomSheetListItem({
    required this.title,
    this.subtitle,
    this.image,
  });

  final String title;
  final String? subtitle;
  final String? image;
}

class BottomSheetList extends StatelessWidget {
  const BottomSheetList({
    super.key,
    this.padding,
    required this.items,
    required this.onTap,
    this.expand = false,
    this.initialChildSize = .33,
    this.minChildSize = .1,
    this.maxChildSize = .45,
  });
  final EdgeInsetsGeometry? padding;
  final List<BottomSheetListItem> items;
  final void Function(BottomSheetListItem item) onTap;
  final bool expand;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: expand,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      builder: (context, scrollController) {
        return Column(children: [
          Expanded(
            child: ListView.builder(
              padding: padding ??
                  EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return ListTile(
                  shape: const ContinuousRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      item.image ?? "",
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ).prebuilder(),
                  ),
                  title: Text(
                    item.title,
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  subtitle: Text(
                    item.subtitle ?? "",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  onTap: () => onTap(item),
                );
              },
            ),
          ),
        ]);
      },
    );
  }
}
