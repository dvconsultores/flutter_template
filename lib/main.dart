import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platzi_trips/features/search/bloc/search_bloc.dart';
import 'package:flutter_platzi_trips/features/user/bloc/user_bloc.dart';
import 'package:flutter_platzi_trips/features/user/ui/screens/sign_in_screen.dart';
import 'package:flutter_platzi_trips/main_provider.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() async {
  // -- config to firebase 🖊️ --
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);

    return ChangeNotifierProvider(
      create: (context) => MainProvider(), // Main provider
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: GoogleFonts.latoTextTheme(),
            primarySwatch: Colors.blue,
          ),
          // Feature blocs
          home: BlocProvider<UserBloc>(
            bloc: UserBloc(),
            child: BlocProvider<SearchBloc>(
              bloc: SearchBloc(),
              child: const SignInScreen(),
            ),
          )),
    );
  }
}
