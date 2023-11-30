import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:weather_app/packages/repositories/geo_data/geo_data_repository.dart';
import 'package:weather_app/src/di/di_init.dart';
import 'package:weather_app/src/screens/add_citiy_screen/bloc/add_city_bloc_state.dart';

class AddCityCubit extends Cubit<AddCityState> {
  AddCityCubit() : super(AddCityState());

  void safetyEmit(AddCityState nextState) {
    if (!isClosed) emit(nextState);
  }

  Future getCities({
    required int page,
    String? search,
  }) async {
    if (page == 1) {
      safetyEmit(state.copyWith(
        isLoading: true,
        totalCount: 0,
        page: 1,
        cities: [],
      ));
    }

    final geodataRepository = DI.get<GeoDataRepository>(
      instanceName: 'geodata',
    );

    Map<String, dynamic>? geoData;

    try {
      if (state.totalCount > 0 && state.totalCount < page * 10) {
        return state.copyWith(
          isLoading: false,
          error: false,
        );
      }

      geoData = await geodataRepository.fetchCities(
        limit: 10,
        offset: page == 1 ? 0 : page * 10,
        search: search,
      );
    } catch (e) {
      return safetyEmit(
        state.copyWith(
          isLoading: false,
          error: true,
        ),
      );
    }

    final total = geoData['metadata']['totalCount']! as int;

    return safetyEmit(
      state.copyWith(
        isLoading: false,
        error: false,
        cities: [
          if (state.page != 1) ...state.cities,
          ...(geoData['data'] as List<dynamic>)
              .map<CityState>(
                (dynamic cityItem) => CityState(
                  name: cityItem['name']! as String,
                ),
              )
              .toList()
        ],
        totalCount: total,
        page: page,
      ),
    );
  }
}
