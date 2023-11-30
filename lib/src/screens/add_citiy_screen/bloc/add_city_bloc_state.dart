class CityState {
  final String name;

  CityState({required this.name});
}

class AddCityState {
  final List<CityState> cities;
  final bool isLoading;
  final bool error;
  final int totalCount;
  final int page;

  AddCityState({
    this.cities = const [],
    this.totalCount = 0,
    this.page = 0,
    this.isLoading = false,
    this.error = false,
  });

  AddCityState copyWith({
    List<CityState>? cities,
    int? totalCount,
    int? page,
    bool isLoading = false,
    bool error = false,
  }) {
    return AddCityState(
        cities: cities ?? this.cities,
        totalCount: totalCount ?? this.totalCount,
        page: page ?? this.page,
        isLoading: isLoading,
        error: error);
  }
}
