import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/widgets/test_web_sockets.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // * Go to page
    void goToPage(Widget page) {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (builder) => page));
    }

    return Drawer(
        child: Column(
      children: [
        TextButton(
          child: Text(
            "Button one",
            style:
                TextStyle(color: AppColors.getColor(context, ColorType.active)),
          ),
          onPressed: () => goToPage(TestWebSockets()),
        )
      ],
    ));
  }
}
