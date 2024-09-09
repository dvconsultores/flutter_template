import 'package:flutter/material.dart';
import 'package:flutter_detextre4/routes/shell_routes/home_route/home_route.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/widget_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeDesktop extends StatelessWidget {
  const HomeDesktop(this.constraints, {super.key});
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final inherited = context.getInheritedWidgetOfExactType<HomeInherited>()!;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Button(
            text:
                "Change language: ${AppLocalizations.of(context)!.helloWorld}",
            onPressed: () {
              AppLocale.locale.languageCode ==
                      LanguageList.en.locale.languageCode
                  ? AppLocale.changeLanguage(LanguageList.es)
                  : AppLocale.changeLanguage(LanguageList.en);
            },
          ),
          const Gap(Vars.gapMax).column,
          const Text('You have pushed the button this many times:'),
          Text(
            '${inherited.counter}',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(Vars.gapMax).column,
          Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: FloatingActionButton(
                onPressed: inherited.incrementCounter,
                tooltip: 'Increment',
                heroTag: UniqueKey(),
                child: const Icon(Icons.add).invertedColor(),
              )),
          Text(
            ThemeApp.theme.name,
            style: Theme.of(context).textTheme.displaySmall,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Button.icon(
              onPressed: () => ThemeApp.switchTheme(context, ThemeType.light),
              icon: Icon(
                Icons.light_mode,
                color: ThemeApp.colors(context).tertiary,
              ),
            ),
            const Gap(Vars.gapMax).row,
            Button.icon(
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
