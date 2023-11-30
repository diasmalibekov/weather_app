import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/packages/repositories/weather/weather_model.dart';
import 'package:weather_app/src/app_state/cities_cubit.dart';
import 'package:weather_app/src/screens/weather_screen/bloc/weather_cubit.dart';
import 'package:weather_app/src/screens/weather_screen/bloc/weather_state.dart';
import 'package:weather_app/src/widgets/metrics.dart';

class WeatherView extends StatelessWidget {
  const WeatherView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, weatherState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Your cities'),
            actions: [
              IconButton(
                  icon: const Icon(Icons.plus_one_outlined),
                  onPressed: () => context.go('/add_city')),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              context.read<WeatherCubit>().updateWeather();
            },
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (weatherState.loading ||
                    weatherState.error ||
                    weatherState.weatherData.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (weatherState.loading)
                          const CircularProgressIndicator(),
                        // if (weatherState.error) const Text('Произошла ошибка')
                        // сейчас ошибка  добавляется к инстансу каждого города
                        if (!weatherState.loading &&
                            weatherState.weatherData.isEmpty)
                          const Text('No added cities yet')
                      ],
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          final weatherData = weatherState.weatherData[index];

                          return BlocProvider<CitiesCubit>(
                            create: (context) => CitiesCubit(),
                            child: Dismissible(
                              key: Key(weatherData
                                  .cityName), // assuming cityName is unique for each item
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                context
                                    .read<CitiesCubit>()
                                    .removeCity(weatherData.cityName);
                              },
                              background: Container(
                                  color: Colors
                                      .red), // red background when swiping
                              child: Card(
                                child: ListTile(
                                  title: Padding(
                                    padding: const EdgeInsets.only(bottom: 1.0),
                                    child: Text(
                                      weatherData.cityName,
                                    ),
                                  ),
                                  subtitle: Text(
                                    weatherData.error == null
                                        ? 'Temperature: ${weatherData.temp?.current}°C ${weatherData.temp?.feelsLike != null ? '\nFeels like: ${weatherData.temp?.feelsLike}°' : ''}'
                                        : 'Couldn\'t get weather for this city',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 1.2,
                                      color: Colors.black.withOpacity(.7),
                                    ),
                                  ),
                                  trailing: Icon(
                                    WeatherIconData.values
                                        .firstWhere(
                                          (iconData) =>
                                              iconData.toString() ==
                                              weatherData.main,
                                          orElse: () =>
                                              WeatherIconData.values[0],
                                        )
                                        .icon,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        childCount: weatherState.weatherData.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
