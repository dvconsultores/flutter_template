import 'package:flutter/material.dart';
import 'package:flutter_detextre4/home_screen.dart';
import 'package:flutter_detextre4/main_drawer.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
import 'package:flutter_detextre4/widgets/app_scaffold.dart';
import 'package:flutter_detextre4/widgets/double_back_to_close_widget.dart';
import 'package:flutter_detextre4/widgets/will_pop_custom.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  List<BottomNavigationBarItem> renderBottomNavigationBarItem() {
    final itemList = <BottomNavigationBarItem>[];

    for (var element in NavigationRoutes.values) {
      itemList.add(
        BottomNavigationBarItem(
            icon: Container(
              margin: const EdgeInsets.only(top: 20),
              child: element.icon,
            ),
            label: "",
            tooltip: element.name),
      );
    }

    return itemList;
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();
    final indexTab = mainProvider.indexTab;
    final indexRoute = mainProvider.indexRoute;

    return AppScaffold(
      drawer: indexRoute == 0 ? const MainDrawer() : null,
      appBar: AppBar(
        leading: indexRoute > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => const Navigator().routerBack(),
              )
            : null,
        title: Text(NavigationRoutes.values[indexTab].name),
      ),
      // * Routes rendering
      body: indexTab == 1 && indexRoute == 0 // ? if home or not
          ? const DoubleBackToCloseWidget(
              snackBarMessage: "Presione de nuevo para salir",
              child: HomeScreen(),
            )
          : WillPopCustom(
              onWillPop: () async {
                const Navigator().routerPushByName(NavigationRoutesName.home);
                return false;
              },
              child: NavigationRoutes.values[indexTab].routes[indexRoute].page),
      // * Navigation bar
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          onTap: (index) =>
              setState(() => mainProvider.setNavigationTab = index),
          currentIndex: indexTab,
          selectedItemColor: AppColors.getColor(context, ColorType.active),
          items: [
            ...renderBottomNavigationBarItem(), // * Icons rendering
          ],
        ),
      ),
    );
  }
}
