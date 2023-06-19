import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/global_widgets/app_drawer.dart';
import 'package:flutter_detextre4/global_widgets/app_scaffold.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/helper_widgets/double_back_to_close_widget.dart';
import 'package:flutter_detextre4/utils/helper_widgets/will_pop_custom.dart';
import 'package:go_router/go_router.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation(this.state, this.child, {super.key});
  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final routes = routerConfig.configuration.routes
        .firstWhere((element) => element is ShellRoute)
        .routes;

    final indexTab = routes.indexWhere((element) =>
        (element as GoRoute).path == "/${state.location.split('/')[1]}");

    final subRoutes = routes
        .firstWhereOrNull(
            (element) => (element as GoRoute).path.startsWith(state.location))
        ?.routes;

    final currentSubRoute = subRoutes
        ?.any((element) => (element as GoRoute).path.contains(state.location));

    return AppScaffold(
      paddless: true,
      drawer: currentSubRoute != null ? const AppDrawer() : null,
      appBar: AppBar(
        leading: currentSubRoute == null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: context.pop,
              )
            : null,
        title: Text((routes[indexTab] as GoRoute).name ?? ""),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context),
        child: BottomNavigationBar(
          currentIndex: indexTab,
          onTap: (index) => context.go((routes[index] as GoRoute).path),
          selectedItemColor: ThemeApp.colors(context).focusColor,
          items: routes.map((element) {
            Icon getIcon(String? value) {
              switch (value) {
                case "user":
                  return const Icon(Icons.person);
                case "home":
                  return const Icon(Icons.home);
                case "search":
                default:
                  return const Icon(Icons.search);
              }
            }

            return BottomNavigationBarItem(
              label: "",
              tooltip: (element as GoRoute).name?.toCapitalize(),
              icon: Container(
                margin: const EdgeInsets.only(top: 20),
                child: getIcon(element.name),
              ),
            );
          }).toList(),
        ),
      ),
      child: state.location == "/"
          ? DoubleBackToCloseWidget(
              snackBarMessage: "Press again to leave",
              child: child,
            )
          : WillPopCustom(
              onWillPop: () async {
                context.go("/");
                return false;
              },
              child: child,
            ),
    );
  }
}
