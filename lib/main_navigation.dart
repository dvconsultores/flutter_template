import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/home/home_screen.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/widgets/app_drawer.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
import 'package:flutter_detextre4/widgets/app_scaffold.dart';
import 'package:flutter_detextre4/utils/helper_widgets/double_back_to_close_widget.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  void routeWhenInit() {
    // (Home)
    final mainProvider = context.read<MainProvider>();
    mainProvider.indexTab = 1;
    mainProvider.indexRoute = 0;
  }

  @override
  void initState() {
    routeWhenInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();
    final indexTab = mainProvider.indexTab;
    final indexRoute = mainProvider.indexRoute;

    return AppScaffold(
      drawer: indexRoute == 0 ? const AppDrawer() : null,
      appBar: AppBar(
        leading: indexRoute > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => RouterNavigator.pop(),
              )
            : null,
        title: Text(RouterNavigator.routes[indexTab].name),
      ),

      // * Routes rendering
      tablet: RouterNavigator.currentName ==
              RouterNavigatorNames.home.name // ? if home or not
          ? const DoubleBackToCloseWidget(
              snackBarMessage: "Presione de nuevo para salir",
              child: HomeScreen(),
            )
          : WillPopCustom(
              onWillPop: () async {
                RouterNavigator.pushNamed(RouterNavigatorNames.home);
                return false;
              },
              child:
                  RouterNavigator.routes[indexTab].pages[indexRoute].routePage),

      // * Navigation bar
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          onTap: (index) =>
              setState(() => mainProvider.setNavigationTab = index),
          currentIndex: indexTab,
          selectedItemColor: ThemeApp.colors(context).focusColor,
          items: RouterNavigator.routes
              .map((element) => BottomNavigationBarItem(
                    label: "",
                    tooltip: element.name,
                    icon: Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: element.icon,
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
