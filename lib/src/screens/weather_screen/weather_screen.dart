import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/app_state/cities_cubit.dart';
import 'package:weather_app/src/app_state/cities_state.dart';
import 'package:weather_app/src/screens/weather_screen/bloc/weather_cubit.dart';
import 'package:weather_app/src/screens/weather_screen/weather_view.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  WeatherScreenState createState() => WeatherScreenState();
}

class WeatherScreenState extends State<WeatherScreen> {
  CitiesState? previousState;

  void onCitiesUpdate(BuildContext context, CitiesState state) {
    if (previousState?.cities != state.cities) {
      if ((previousState?.cities?.length ?? 0) < state.cities!.length) {
        final weatherCubit = context.read<WeatherCubit>();
        weatherCubit.updateWeather();
      }

      setState(() => previousState = state);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WeatherCubit>(
      create: (context) => WeatherCubit()..updateWeather(),
      child: BlocListener<CitiesCubit, CitiesState>(
        listener: (context, state) => onCitiesUpdate(context, state),
        child: const WeatherView(),
      ),
    );
  }
}
