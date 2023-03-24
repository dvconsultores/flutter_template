import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/features/search/bloc/search_bloc.dart';
import 'package:flutter_detextre4/features/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/features/user/model/user_model.dart';
import 'package:flutter_detextre4/features/user/ui/screens/log_in_screen.dart';
import 'package:flutter_detextre4/main_navigation.dart';
import 'package:flutter_detextre4/splash_screen.dart';
import 'package:flutter_detextre4/widgets/restart_widget.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/local_data/hive_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();
final globalScaffoldSKey = GlobalKey<ScaffoldState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  ? -- config to firebase 🖊️ --
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  */
  Hive.initFlutter().then((_) {
    Hive.openBox(HiveData.boxName).then((value) {
      runApp(const RestartWidget(child: App()));
    });
  });
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
        // * Main provider
        child: ChangeNotifierProvider(
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
  Widget build(BuildContext context) {
    return Consumer<MainProvider>(builder: (context, value, child) {
      // * Session timeout manager
      final sessionConfig = SessionConfig(
          // invalidateSessionForAppLostFocus: const Duration(seconds: 15),
          // invalidateSessionForUserInactivity: const Duration(seconds: 30),
          );

      sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
        if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
          // * handle user  inactive timeout
          // Navigator.of(globalNavigatorKey.currentContext!).pushNamed("/auth");
        } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
          // * handle user  app lost focus timeout
          // Navigator.of(globalNavigatorKey.currentContext!).pushNamed("/auth");
        }
      });

      return SessionTimeoutManager(
        sessionConfig: sessionConfig,
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: AppThemes.getTheme(context), // * Theme switcher
          home: const SplashScreen(),
          navigatorKey: globalNavigatorKey,
          builder: (context, child) {
            // * global text scale factorized
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child!,
            );
          },
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('es', 'ES'),
          ],
        ),
      );
    });
  }
}

// * Sesion manager - after splash screen
class SesionManagerScreen extends StatefulWidget {
  const SesionManagerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SesionManagerScreen();
  }
}

class _SesionManagerScreen extends State<SesionManagerScreen> {
  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);

    return StreamBuilder<UserModel?>(
        stream: userBloc.getDataUserStream,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData || snapshot.hasError) {
            return const LogInScreen();
          } else {
            return const MainNavigation();
          }
        });
  }
}
