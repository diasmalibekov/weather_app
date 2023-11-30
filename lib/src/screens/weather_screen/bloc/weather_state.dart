class WeatherState {
  final List<WeatherData> weatherData;
  final bool loading;
  final bool error;

  WeatherState(
      {this.weatherData = const [], this.loading = false, this.error = false});

  WeatherState copyWith(
      {List<WeatherData>? weatherData,
      bool loading = false,
      bool error = false}) {
    return WeatherState(
        weatherData: weatherData ?? this.weatherData,
        loading: loading,
        error: error);
  }
}

class WeatherData {
  final String? main;
  final TemperatureState? temp;
  final bool? error;
  final String cityName;

  WeatherData({required this.cityName, this.temp, this.main, this.error});
}

class TemperatureState {
  final int current;
  final int feelsLike;

  TemperatureState({required this.current, required this.feelsLike});
}
