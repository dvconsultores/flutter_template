import 'package:app_loader/app_loader.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_detextre4/blocs/main_bloc.dart';
import 'package:flutter_detextre4/main_provider.dart';
import 'package:flutter_detextre4/utils/config/config.dart';
import 'package:flutter_detextre4/utils/config/router_config.dart';
import 'package:flutter_detextre4/utils/config/session_timeout_config.dart';
import 'package:flutter_detextre4/utils/config/theme.dart';
import 'package:flutter_detextre4/utils/extensions/type_extensions.dart';
import 'package:flutter_detextre4/utils/general/context_utility.dart';
import 'package:flutter_detextre4/utils/general/scroll_behavior.dart';
import 'package:flutter_detextre4/utils/general/variables.dart';
import 'package:flutter_detextre4/utils/services/dio_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/hive_data_service.dart';
import 'package:flutter_detextre4/utils/services/local_data/secure_storage_service.dart';
import 'package:flutter_detextre4/widgets/defaults/snackbar.dart';
import 'package:flutter_detextre4/widgets/dialogs/modal_widget.dart';
import 'package:flutter_detextre4/widgets/loaders/splash_page.dart';
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

  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      ThemeApp.of(context)
          .systemUiOverlayStyle
          .copyWith(systemNavigationBarColor: Colors.amber),
    );

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
  late final SessionTimeoutConfig sessionTimeoutConfig;

  bool isLogged = false;

  Future<void> onFetchData({
    BuildContext? context,
    required AppLoader loader,
    required ValueNotifier<MaterialLoaderStatus> fetchStatus,
  }) async {
    if (context == null) return;

    // initialize DioService
    DioService.init(context);

    final provider = MainProvider.read(context);
    provider.setReturnDioAuthError = true;

    loader.open();

    try {
      final [
        tokenAuth,
        // _,
      ] = await Future.wait([
        SecureStorage.read<String?>(SecureCollection.tokenAuth),

        // initialize deep links
        // UniLinksService.init(context),
      ]);
      isLogged = tokenAuth != null;

      if (isLogged) {
        provider.setPreventModal = true;
        // get user data
        await Future.delayed(Durations.short1);
      }

      loader.close();
      fetchStatus.value = MaterialLoaderStatus.done;
    } catch (error) {
      final errorMessage =
          handleError(error, loader: loader, fetchStatus: fetchStatus);

      if (context.mounted) {
        if (error is DioException &&
            error.type == DioExceptionType.connectionError) {
          await Modal.showSystemAlert(
            context,
            contentText: errorMessage,
            textConfirmBtn: "Okay",
          );
        } else {
          showSnackbar(
            context: context,
            errorMessage,
            type: SnackbarType.error,
          );
        }
      }
    } finally {
      provider.setPreventModal = false;
    }
  }

  Future<void> onNextMaterial(VoidCallback handleNextMaterial) async {
    handleNextMaterial();
    if (kIsWeb) return;

    routerConfig.router.goNamed(isLogged ? "home" : "login");
  }

  String handleError(
    Object error, {
    required AppLoader loader,
    required ValueNotifier<MaterialLoaderStatus> fetchStatus,
  }) {
    loader.close();
    fetchStatus.value = MaterialLoaderStatus.error;

    if (error.catchErrorStatusCode() == "401") {
      SecureStorage.delete(SecureCollection.tokenAuth);
    }

    final errorMessage = error.catchErrorMessage(
      fallback:
          "An error has occurred while running the app 😞, please contact our support team for more information",
    );
    debugPrint("MaterialhandlerError: $errorMessage ⭕");

    return errorMessage;
  }

  @override
  void initState() {
    sessionTimeoutConfig = SessionTimeoutConfig(context)..listen();
    super.initState();
  }

  @override
  void dispose() {
    sessionTimeoutConfig.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScreenSizes(
        child: Consumer<MainProvider>(builder: (context, provider, child) {
          return SessionTimeoutManager(
            sessionConfig: sessionTimeoutConfig.instance,
            child: ScreenUtilInit(
                designSize: Vars.getDesignSize(context),
                builder: (context, child) {
                  return MaterialLoader(
                    onFetchData: onFetchData,
                    onNextMaterial: onNextMaterial,
                    splashPage: (animationController, getData, haveError) =>
                        SplashPage(
                            animationController: animationController,
                            getData: getData,
                            shouldShowRestartButton: haveError),
                    materialApp: MaterialApp.router(
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
                    ),
                  );
                }),
          );
        }),
      );
}
