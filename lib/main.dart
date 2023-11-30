import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/packages/widgets/dismiss_keyboard.dart';
import 'package:weather_app/src/app_state/cities_cubit.dart';
import 'package:weather_app/src/di/di_init.dart';
import 'package:weather_app/src/screens/router.dart';

Future initApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set translucent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
}

Future main() async {
  await initApp();
  await dotenv.load(fileName: '.env');

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );

  DI.init();

  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    final citiesCubit = DI.get<CitiesCubit>(instanceName: 'cities_state');
    final router = goRouter(citiesCubit);

    return BlocProvider<CitiesCubit>(
      create: (_) => citiesCubit,
      child: DismissKeyboard(
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationProvider: router.routeInformationProvider,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
        ),
      ),
    );
  }
}
