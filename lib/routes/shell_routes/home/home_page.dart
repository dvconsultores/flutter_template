import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/scaffold.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/extensions/widget_extensions.dart';
import 'package:flutter_detextre4/utils/general/functions.dart';
import 'package:flutter_detextre4/utils/helper_widgets/gap.dart';
import 'package:flutter_detextre4/utils/helper_widgets/responsive_layout.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomePage extends StatelessWidget with ResponsiveLayoutMixin {
  const HomePage({super.key});

  @override
  Widget? desktopLayout(BuildContext context, BoxConstraints constraints) {
    return const ScaffoldBody(
      body: _Page1(),
    );
  }

  @override
  Widget tabletLayout(BuildContext context, BoxConstraints constraints) {
    return ScaffoldBody(
      body: PageView(
        children: const [
          _Page1(),
        ],
      ),
    );
  }
}

class _Page1 extends StatefulWidget {
  const _Page1();
  @override
  State<_Page1> createState() => _Page1State();
}

class _Page1State extends State<_Page1> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() => _counter++);
    showSnackbar("El contador ha incrementado");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            child: Text(
              "Change language: ${AppLocalizations.of(context)!.helloWorld}",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: ThemeApp.colors(context).primary,
                    fontSize: 14,
                  ),
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
                heroTag: UniqueKey(),
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
        ]);
  }
}
