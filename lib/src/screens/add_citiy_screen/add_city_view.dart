import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/packages/widgets/centered_loader.dart';
import 'package:weather_app/packages/widgets/tapable_widget.dart';
import 'package:weather_app/src/app_state/cities_cubit.dart';
import 'package:weather_app/src/app_state/cities_state.dart';
import 'package:weather_app/src/screens/add_citiy_screen/bloc/add_city_bloc_cubit.dart';
import 'package:weather_app/src/screens/add_citiy_screen/bloc/add_city_bloc_state.dart';
import 'package:weather_app/src/widgets/metrics.dart';

class AddCityView extends StatefulWidget {
  const AddCityView({super.key});

  @override
  State<AddCityView> createState() => _AddCityViewState();
}

class _AddCityViewState extends State<AddCityView> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String? searchCity;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void onUpdateCities(BuildContext context, int page) {
    final citiesCubit = context.read<AddCityCubit>();
    citiesCubit.getCities(page: page, search: searchCity);
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final citiesCubit = context.read<AddCityCubit>();

      if (!citiesCubit.state.isLoading) {
        onUpdateCities(context, citiesCubit.state.page + 1);
      }
    }
  }

  void onSearch(BuildContext context, String value) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(const Duration(milliseconds: 1000), () {
      if (searchCity != value) setState(() => searchCity = value);

      onUpdateCities(context, 1);
    });
  }

  void onAddCity(BuildContext context, String cityName) {
    final cityIsInList = context.read<CitiesCubit>().isCityNameInList(cityName);

    if (cityIsInList) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);

      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('City is already in the list'),
        ),
      );
      return;
    }

    context.read<CitiesCubit>().addCity(AddedCity(cityName: cityName));

    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddCityCubit, AddCityState>(
      builder: (context, addCityState) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Add city'),
          ),
          body: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => onSearch(context, value),
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'City search',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppMetrics.DEFAULT_MARGIN,
                  ),
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 2,
                    minHeight: 2,
                  ),
                  suffixIcon: (addCityState.isLoading ||
                          _searchController.text.isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: addCityState.isLoading
                              ? const SizedBox(
                                  height: 14,
                                  width: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Tapable(
                                  properties: TapableProps(
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              AppMetrics.BORDER_RADIUS),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.close_rounded,
                                      ),
                                      onTap: () {
                                        _searchController.clear();
                                        setState(() {});
                                      }),
                                ),
                        )
                      : null,
                ),
              ),
              if (addCityState.cities.isNotEmpty &&
                  _searchController.text.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: addCityState.cities.length + 1,
                    itemBuilder: (context, id) {
                      if (id == addCityState.cities.length) {
                        return addCityState.isLoading
                            ? const CenteredLoader()
                            : null;
                      }

                      final weatherData = addCityState.cities[id];

                      return BlocProvider<AddCityCubit>(
                        create: (context) => AddCityCubit(),
                        child: Card(
                          child: ListTile(
                            onTap: () => onAddCity(context, weatherData.name),
                            title: Text(weatherData.name),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
