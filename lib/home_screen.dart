import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/config/router_navigation_config.dart';
import 'package:flutter_detextre4/utils/const/global_functions.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    const Navigator().routerBack(context);

    appSnackbar(context, "El contador ha incrementado",
        type: ColorSnackbarState.neutral);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add),
                  )),
              Text(
                context.watch<MainProvider>().appTheme.name,
                style: Theme.of(context).textTheme.displaySmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.read<MainProvider>().switchTheme =
                          ThemeType.light;
                    },
                    icon: Icon(Icons.light_mode,
                        color: AppColors.getColor(context, ColorType.primary)),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<MainProvider>().switchTheme = ThemeType.dark;
                    },
                    icon: Icon(
                      Icons.dark_mode,
                      color: AppColors.getColor(context, ColorType.secondary),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
