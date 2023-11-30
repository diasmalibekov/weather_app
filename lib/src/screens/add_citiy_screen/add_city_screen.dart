import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/src/screens/add_citiy_screen/add_city_view.dart';
import 'package:weather_app/src/screens/add_citiy_screen/bloc/add_city_bloc_cubit.dart';

class AddCityScreen extends StatelessWidget {
  const AddCityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddCityCubit>(
      create: (context) => AddCityCubit(),
      child: const AddCityView(),
    );
  }
}
