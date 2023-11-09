import 'package:dio/dio.dart';
import 'weather_model.dart';

final Dio dio = Dio();

class WeatherApiEnvironmentException implements Exception {
  String cause;
  WeatherApiEnvironmentException(this.cause);
}

class WeatherRepository {
  final String? _owmApiKey;
  WeatherRepository(this._owmApiKey);

  Future<Weather> fetchWeather(String cityName) async {
    final result = await _getWeather<Map<String, dynamic>>(
      query: <String, dynamic>{
        'q': cityName,
      },
    );
    try {
      final weather = Weather(
        result.data!['weather'][0]['main'] as String,
        Temperature(
          (result.data!['main']['temp'] as double).round(),
          (result.data!['main']['feels_like'] as double).round(),
        ),
      );
      return weather;
    } catch (_) {
      return Weather('', null);
    }
  }

  Future<Response<T>> _getWeather<T>({
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) {
    if (_owmApiKey == null) {
      throw WeatherApiEnvironmentException(
        'Env var OWM_API_KEY is required\nPlease check your .env file',
      );
    }
    return dio.get<T>(
      'https://api.openweathermap.org/data/2.5/weather',
      options: Options(
        headers: <String, dynamic>{
          'content-type': 'application/json',
          ...(headers ?? <String, dynamic>{}),
        },
      ),
      queryParameters: <String, dynamic>{
        'appid': _owmApiKey,
        'units': 'metric',
        ...(query ?? <String, dynamic>{})
      },
    );
  }
}
