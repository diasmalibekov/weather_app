import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weather_app/packages/repositories/geo_data/geo_data_repository.dart';
import 'package:weather_app/packages/repositories/weather/weather_repository.dart';
import 'package:weather_app/src/app_state/cities_cubit.dart';

class DI {
  static final GetIt _locator = GetIt.instance;

  static void init() {
    DI.registerLazySingleton(
      () => GeoDataRepository(dotenv.env['RAPID_API_KEY']),
      instanceName: 'geodata',
    );
    DI.registerLazySingleton<WeatherRepository>(
      () => WeatherRepository(dotenv.env['OWM_API_KEY']),
      instanceName: 'weather',
    );
    DI.registerSingleton<CitiesCubit>(
      CitiesCubit(),
      instanceName: 'cities_state',
    );
  }

  static void registerFactory<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    DI._locator.registerFactory(factoryFunc, instanceName: instanceName);
  }

  static T registerSingleton<T extends Object>(
    T instance, {
    String? instanceName,
  }) {
    DI._locator.registerSingleton<T>(
      instance,
      instanceName: instanceName,
    );
    return instance;
  }

  static void registerLazySingleton<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    DI._locator.registerLazySingleton<T>(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  static T get<T extends Object>({String? instanceName}) {
    return DI._locator<T>(instanceName: instanceName);
  }
}
