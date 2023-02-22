import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
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

    // * Go to router page
    void goToRouterPage(NavigationRoutesPath page) {
      Navigator.pop(context);
      const Navigator().routerPush(context, page);
    }

    return Drawer(
        child: Column(
      children: [
        TextButton(
          onPressed: () => goToPage(const TestWebSockets()),
          child: Text(
            "Test web socket",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.getColor(context, ColorType.active),
            ),
          ),
        ),
        TextButton(
          onPressed: () => goToRouterPage(NavigationRoutesPath.searchTwo),
          child: Text(
            "Search Two",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.getColor(context, ColorType.active),
            ),
          ),
        ),
      ],
    ));
  }
}
