import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/general/global_functions.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
    appSnackbar("El contador ha incrementado");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: Text(
                  "Change language: ${AppLocalizations.of(context)!.helloWorld}",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                ),
                onPressed: () {
                  AppLocale.locale == Locale(LanguageList.en.name)
                      ? AppLocale.changeLanguage(LanguageList.es)
                      : AppLocale.changeLanguage(LanguageList.en);
                },
              ),
              const Text('You have pushed the button this many times:'),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: FloatingActionButton(
                    onPressed: _incrementCounter,
                    tooltip: 'Increment',
                    child: const Icon(Icons.add).invertedColor(),
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
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<MainProvider>().switchTheme = ThemeType.dark;
                    },
                    icon: Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
