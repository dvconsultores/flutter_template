import 'package:flutter/material.dart';
import 'package:flutter_detextre4/global_widgets/app_scaffold.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/extensions/widget_extensions.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/helper_widgets/gap.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomePageState();
}

class _HomePageState extends State<HomeScreen>
    with ResponsiveLayoutMixinStateful {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
    showSnackbar("El contador ha incrementado");
  }

  @override
  Widget tabletLayout(BuildContext context, BoxConstraints constraints) {
    return ScaffoldBody(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              child: Text(
                "Change language: ${AppLocalizations.of(context)!.helloWorld}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: ThemeApp.colors(context).primary),
              ),
              onPressed: () {
                AppLocale.locale == LanguageList.en.locale
                    ? AppLocale.changeLanguage(LanguageList.es)
                    : AppLocale.changeLanguage(LanguageList.en);
              },
            ),
            const Gap(20).column,
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Gap(20).column,
            Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: FloatingActionButton(
                  onPressed: _incrementCounter,
                  tooltip: 'Increment',
                  child: const Icon(Icons.add).invertedColor(),
                )),
            Text(
              ThemeApp.theme.name,
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              IconButton(
                onPressed: () => ThemeApp.switchTheme(context, ThemeType.light),
                icon: Icon(
                  Icons.light_mode,
                  color: ThemeApp.colors(context).primary,
                ),
              ),
              const Gap(20).row,
              IconButton(
                onPressed: () => ThemeApp.switchTheme(context, ThemeType.dark),
                icon: Icon(
                  Icons.dark_mode,
                  color: ThemeApp.colors(context).secondary,
                ),
              ),
            ]),
          ]),
    );
  }
}
