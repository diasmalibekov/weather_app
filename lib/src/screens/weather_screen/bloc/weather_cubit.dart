import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_app/packages/repositories/weather/weather_model.dart';
import 'package:weather_app/packages/repositories/weather/weather_repository.dart';
import 'package:weather_app/src/app_state/cities_cubit.dart';
import 'package:weather_app/src/app_state/cities_state.dart';
import 'package:weather_app/src/di/di_init.dart';
import 'package:weather_app/src/screens/weather_screen/bloc/weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit() : super(WeatherState());

  Future updateWeather() async {
    emit(state.copyWith(loading: true));

    final citiesRepository = DI.get<CitiesCubit>(instanceName: 'cities_state');

    final List<AddedCity> cities = citiesRepository.state.cities ?? [];
    final List<WeatherData> weatherList = [];

    for (final city in cities) {
      Weather? weather;
      try {
        weather = await DI
            .get<WeatherRepository>(instanceName: 'weather')
            .fetchWeather(city.cityName);
      } catch (e) {
        weatherList.add(WeatherData(cityName: city.cityName, error: true));

        continue;
      }

      final weatherData = WeatherData(
        cityName: city.cityName,
        main: weather.main,
        temp: TemperatureState(
          current: weather.temp?.current ?? 0,
          feelsLike: weather.temp?.feelsLike ?? 0,
        ),
      );

      weatherList.add(weatherData);
    }

    emit(state.copyWith(weatherData: weatherList));
  }
}
