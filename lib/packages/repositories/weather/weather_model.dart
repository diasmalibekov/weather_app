import 'package:flutter/material.dart';

enum WeatherIconData {
  error('__ERROR__', Icons.error_outline_rounded),
  clouds('Clouds', Icons.cloud),
  clear('Clear', Icons.sunny),
  thunderstorm('Thunderstorm', Icons.thunderstorm_rounded),
  snow('Snow', Icons.cloudy_snowing),
  rain('Rain', Icons.thunderstorm_rounded),
  drizzle('Drizzle', Icons.cloudy_snowing),
  fog('Fog', Icons.foggy);

  final IconData icon;
  final String weatherType;
  const WeatherIconData(this.weatherType, this.icon);

  @override
  String toString() => weatherType;
}

class Weather {
  final String main;
  final Temperature? temp;

  Weather(this.main, this.temp);
}

class Temperature {
  final int current;
  final int feelsLike;

  Temperature(this.current, this.feelsLike);
}
