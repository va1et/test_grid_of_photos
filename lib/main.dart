import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_text/presentation/bloc/photos/photos_bloc.dart';
import 'package:flutter_text/service_locator.dart' as dependency_injection;
import 'package:flutter_text/service_locator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl_standalone.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dependency_injection.setup();

  findSystemLocale().then((_) => runApp(const App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    final router = getIt<GoRouter>();
    return MultiBlocProvider(
        providers: [
          BlocProvider<PhotosBloc>(
              create: (context) =>
                  getIt<PhotosBloc>()..add(const PhotosEvent.getPhotos())),
        ],
        child: MaterialApp.router(
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ru'),
            ],
            // theme: lightTheme,
            locale: const Locale('ru'),
            debugShowCheckedModeBanner: false,
            routerConfig: router));
  }
}
