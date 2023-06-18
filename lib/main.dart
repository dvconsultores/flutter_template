import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/routes/search/bloc/search_bloc.dart';
import 'package:flutter_detextre4/routes/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/utils/helper_widgets/restart_widget.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();
final globalScaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ? -- config to dotenv 🖊️ --
  await dotenv
      .load(fileName: '.env')
      .catchError((error) => debugPrint('Error loading .env file: $error ㊗️'));

  /*
  ? -- config to firebase 🖊️ --
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */

  Hive.initFlutter().then((_) => Hive.openBox(HiveData.boxName).then((value) {
        runApp(const RestartWidget(child: AppState()));
      }));
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

    // * Feature blocs
    return BlocProvider<UserBloc>(
      bloc: UserBloc(),
      child: BlocProvider<SearchBloc>(
        bloc: SearchBloc(),
        // * Main Bloc
        child: ChangeNotifierProvider<MainProvider>(
          create: (context) => MainProvider(),
          child: const App(),
        ),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer<MainProvider>(builder: (context, value, child) {
        return MaterialApp(
            scaffoldMessengerKey: globalScaffoldMessengerKey,
            locale: value.locale,
            debugShowCheckedModeBanner: true,
            title: 'Flutter Demo',
            theme: ThemeApp.of(context), // * Theme switcher
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            initialRoute: value.navigatorRoutes.keys.first,
            routes: value.navigatorRoutes,
            navigatorKey: globalNavigatorKey,
            // * global text scale factorized
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            });
      });
}
