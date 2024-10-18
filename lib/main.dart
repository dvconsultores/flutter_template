import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/blocs/main_bloc.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/session_timeout_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/helper_widgets/restart_widget.dart';
import 'package:flutter_detextre4/utils/services/dio_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:responsive_mixin_layout/responsive_mixin_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ? -- config to dotenv 🖊️ --
  await dotenv.load(fileName: '.env');

  await Hive.initFlutter();
  await Hive.openBox(HiveData.boxName);

  runApp(const RestartWidget(child: AppState()));
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      SystemChrome.setSystemUIOverlayStyle(
        ThemeApp.of(context)
            .systemUiOverlayStyle
            .copyWith(systemNavigationBarColor: Colors.amber),
      );
    }

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

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final sessionTimeoutConfig = SessionTimeoutConfig(context);

  @override
  void initState() {
    DioService.init();
    sessionTimeoutConfig.listen();
    super.initState();
  }

  @override
  void dispose() {
    sessionTimeoutConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<MainProvider>(builder: (context, value, child) {
        return SessionTimeoutManager(
          sessionConfig: sessionTimeoutConfig.instance,
          child: ScreenSizes(
            child: ScreenUtilInit(
                designSize: Vars.mSize,
                builder: (context, child) {
                  return MaterialApp.router(
                    scaffoldMessengerKey: ContextUtility.scaffoldMessengerKey,
                    locale: value.locale,
                    debugShowCheckedModeBanner: true,
                    title: AppName.capitalize.value,
                    theme: ThemeApp.lightTheme,
                    darkTheme: ThemeApp.darkTheme,
                    themeMode: value.appTheme, // * Theme switcher
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    routerConfig: router,
                    // // * global text scale factorized
                    // builder: (context, child) {
                    //   return MediaQuery(
                    //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                    //     child: child!,
                    //   );
                    // },
                  );
                }),
          ),
        );
      });
}
