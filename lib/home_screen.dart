import 'package:flutter/material.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/config/extensions_config.dart';
import 'package:flutter_detextre4/utils/general/global_functions.dart';
import 'package:flutter_detextre4/utils/general/input_formatters.dart';
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

    appSnackbar("El contador ha incrementado");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('You have pushed the button this many times:'),
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
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    DecimalTextInputFormatter(),
                  ],
                ),
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
