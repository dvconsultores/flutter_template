import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/features/search/bloc/search_bloc.dart';
import 'package:flutter_detextre4/features/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/splash_screen.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  /*
  ? -- config to firebase 🖊️ --
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

    // * Feature blocs
    return BlocProvider<UserBloc>(
      bloc: UserBloc(),
      child: BlocProvider<SearchBloc>(
          bloc: SearchBloc(),
          // * Main provider
          child: ChangeNotifierProvider(
              create: (context) => MainProvider(),
              child: Consumer<MainProvider>(builder: (context, value, child) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: AppThemes.getTheme(context), // * Theme switcher
                  home: const SplashScreen(),
                );
              }))),
    );
  }
}
