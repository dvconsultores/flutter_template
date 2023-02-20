import 'package:flutter/material.dart';
import 'package:flutter_detextre4/features/search/ui/screens/search_screen.dart';
import 'package:flutter_detextre4/features/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/features/user/ui/screens/user_screen.dart';
import 'package:flutter_detextre4/home_screen.dart';
import 'package:flutter_detextre4/main_drawer.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/widgets/double_back_to_close_widget.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:provider/provider.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = context.watch<MainProvider>();

    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        title: Text(<String>["User", "Home", "Search"][mainProvider.indexTab]),
      ),
      // * Routes rendering
      body: DoubleBackToCloseWidget(
        onDoubleBack: () =>
            BlocProvider.of<UserBloc>(context).dataUserController.close(),
        snackBarMessage: "Press again to close",
        child: IndexedStack(
          index: mainProvider.indexTab,
          children: const [
            UserScreen(),
            HomeScreen(),
            SearchScreen(),
          ],
        ),
      ),
      // * Navigation bar
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.white),
        child: BottomNavigationBar(
          onTap: (index) => setState(() {
            mainProvider.setNavigationIndex = index;
          }),
          currentIndex: mainProvider.indexTab,
          selectedItemColor: Colors.blue,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Icon(Icons.person)),
                label: "",
                tooltip: "user"), // * User feature
            BottomNavigationBarItem(
                icon: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Icon(Icons.home)),
                label: "",
                tooltip: "home"), // * Home page
            BottomNavigationBarItem(
                icon: Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Icon(Icons.search)),
                label: "",
                tooltip: "search"), // * Search feature
          ],
        ),
      ),
    );
  }
}
