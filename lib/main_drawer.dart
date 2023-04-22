import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen_two.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
import 'package:flutter_detextre4/widgets/test_web_sockets.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // * Go to router page
    void goToRouterPage(Widget page) {
      Navigator.pop(context);
      RouterNavigator.push(page);
    }

    return Drawer(
        child: Column(
      children: [
        TextButton(
          onPressed: () => goToRouterPage(const TestWebSockets()),
          child: Text(
            "Test web socket",
            style: TextStyle(
              fontSize: 20,
              color: AppColors.getColor(context, ColorType.active),
            ),
          ),
        ),
        TextButton(
          onPressed: () => goToRouterPage(const SearchScreenTwo()),
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
