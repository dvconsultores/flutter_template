import 'package:flutter/material.dart';
import 'package:flutter_detextre4/blocs/main_bloc.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/scroll_behavior.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ? -- config to dotenv 🖊️ --
  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  await Hive.openBox(HiveData.boxName);

  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    // * Route blocs
    return BlocProvider<MainBloc>(
      bloc: MainBloc(),
      // * Main Provider
      child: ChangeNotifierProvider<MainProvider>(
        create: (context) => MainProvider(),
        child: const App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => ScreenSizes(
        child: Consumer<MainProvider>(builder: (context, provider, child) {
          provider.setupInitializationService = context;

          return ScreenUtilInit(
              designSize: Vars.getDesignSize(context),
              builder: (context, child) {
                return MaterialApp.router(
                  scrollBehavior: CustomScrollBehavior.of(context),
                  scaffoldMessengerKey: ContextUtility.scaffoldMessengerKey,
                  locale: provider.locale,
                  debugShowCheckedModeBanner: true,
                  title: AppName.capitalize.value,
                  theme: ThemeApp.lightTheme,
                  darkTheme: ThemeApp.darkTheme,
                  themeMode: provider.appTheme, // * Theme switcher
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  routerConfig: routerConfig.router,
                );
              });
        }),
      );
}
