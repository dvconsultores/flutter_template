import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/features/search/bloc/search_bloc.dart';
import 'package:flutter_detextre4/features/user/bloc/user_bloc.dart';
import 'package:flutter_detextre4/features/user/model/user_model.dart';
import 'package:flutter_detextre4/features/user/ui/screens/sign_in_screen.dart';
import 'package:flutter_detextre4/main_navigation.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/splash_screen.dart';
import 'package:flutter_detextre4/utils/config/app_config.dart';
import 'package:flutter_detextre4/utils/local_data/hive_data.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

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
      runApp(const App());
    });
  });
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
            })),
      ),
    );
  }
}

// * sesion manager - after splash screen
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
            return const SignInScreen();
          } else {
            return const MainNavigation();
          }
        });
  }
}
