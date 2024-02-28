import 'package:flutter/material.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/widget_extensions.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/widgets/defaults/button.dart';
import 'package:flutter_detextre4/widgets/defaults/scaffold.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_gap/flutter_gap.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

class HomePage extends StatelessWidget with ResponsiveMixinLayout {
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

  Future<void> _incrementCounter() async {
    setState(() => _counter++);
    showSnackbar("El contador ha incrementado");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Button(
            text:
                "Change language: ${AppLocalizations.of(context)!.helloWorld}",
            onPressed: () {
              AppLocale.locale == LanguageList.en.locale
                  ? AppLocale.changeLanguage(LanguageList.es)
                  : AppLocale.changeLanguage(LanguageList.en);
            },
          ),
          const Gap(Variables.gapMax).column,
          const Text('You have pushed the button this many times:'),
          Text(
            '$_counter',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const Gap(Variables.gapMax).column,
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
            Button.icon(
              onPressed: () => ThemeApp.switchTheme(context, ThemeType.light),
              icon: Icon(
                Icons.light_mode,
                color: ThemeApp.colors(context).tertiary,
              ),
            ),
            const Gap(Variables.gapMax).row,
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
