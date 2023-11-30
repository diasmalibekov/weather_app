import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_app/src/app_state/cities_state.dart';

class CitiesCubit extends HydratedCubit<CitiesState> with ChangeNotifier {
  CitiesCubit() : super(const CitiesState(cities: []));

  void addCity(AddedCity city) {
    final List<AddedCity> updatedCities = [...state.cities ?? []];
    updatedCities.add(city);

    emit(CitiesState(cities: updatedCities));
    notifyListeners();
  }

  void removeCity(String cityName) {
    final List<AddedCity> updatedCities = [...state.cities ?? []];
    updatedCities.removeWhere((city) => city.cityName == cityName);

    emit(CitiesState(cities: updatedCities));
  }

  bool isCityNameInList(String cityNameToCheck) {
    for (var city in state.cities ?? []) {
      if (city.cityName == cityNameToCheck) {
        return true;
      }
    }

    return false;
  }

  @override
  CitiesState? fromJson(Map<String, dynamic> json) {
    final List<AddedCity> cities = json['cities'];

    return CitiesState(cities: cities);
  }

  @override
  Map<String, dynamic>? toJson(CitiesState state) {
    return {
      'cities': state.cities,
    };
  }
}
