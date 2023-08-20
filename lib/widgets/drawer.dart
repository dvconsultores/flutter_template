import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/routes/test_web_sockets_page.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    // * Go to router page or normal push
    void goToRouterPage(dynamic page) {
      Navigator.pop(context);

      if (page is Widget) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => page),
        );
        return;
      }

      context.go(page);
    }

    final items = <String, dynamic>{
      "Test web socket": const TestWebSocketsPage(),
      "Search Two": "/search/search-two",
      "List Screen": "/search/list",
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
                  color: ThemeApp.colors(context).focusColor,
                )),
          ),
        ],
      ],
    ));
  }
}
