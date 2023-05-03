import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/search/ui/screens/list_screen.dart';
import 'package:flutter_detextre4/routes/search/ui/screens/search_screen_two.dart';
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

    final items = <String, Widget>{
      "Test web socket": const TestWebSockets(),
      "Search Two": const SearchScreenTwo(),
      "List Screen": const ListScreen(),
    };

    return Drawer(
        child: Column(
      children: [
        for (final element in items.entries) ...[
          TextButton(
            onPressed: () => goToRouterPage(element.value),
            child: Text(element.key,
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.getColor(context, ColorType.active),
                )),
          ),
        ],
      ],
    ));
  }
}
