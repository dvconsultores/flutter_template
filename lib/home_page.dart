import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/local_data/shared_preferenses.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    // prefs.setString(SharedPreferensesCollection.something.name, "algoalgoalgo");
    // prefs.setInt(SharedPreferensesCollection.somethingMore.name, 2);

    SharedPrefs.read(SharedPreferensesCollection.somethingMore);
    Flushbar(
      message: "El contador ha incrementado",
      backgroundColor: Colors.black54,
      duration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(6),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
    ).show(context);
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
                    context.read<MainProvider>().switchTheme = ThemeType.light;
                  },
                  icon: Icon(Icons.light_mode,
                      color: AppColors.getColor(context, ColorType.primary)),
                ),
                IconButton(
                  onPressed: () {
                    context.read<MainProvider>().switchTheme = ThemeType.dark;
                  },
                  icon: const Icon(
                    Icons.dark_mode,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
