import 'package:flutter/material.dart';
import 'package:flutter_detextre4/widgets/restart_widget.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.exceptionError});
  final Exception? exceptionError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  exceptionError.toString(),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                TextButton(
                  child: const Text(
                    "Refresh",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () => restartApp(context),
                )
              ]),
        ),
      ),
    );
  }
}
