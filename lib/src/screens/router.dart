import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/src/app_state/cities_cubit.dart';
import 'package:weather_app/src/screens/add_citiy_screen/add_city_screen.dart';
import 'package:weather_app/src/screens/weather_screen/weather_screen.dart';

GoRouter goRouter(CitiesCubit citiesCubit) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const CupertinoPage(
            child: WeatherScreen(),
          ),
          routes: [
            GoRoute(
              path: 'add_city',
              pageBuilder: (context, state) => const CupertinoPage(
                child: AddCityScreen(),
              ),
            )
          ],
        ),
      ],
      refreshListenable: citiesCubit,
    );
