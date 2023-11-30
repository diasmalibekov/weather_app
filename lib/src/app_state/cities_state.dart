import 'package:equatable/equatable.dart';

class AddedCity {
  final String? countryCode;
  final String cityName;

  AddedCity({this.countryCode, required this.cityName});

  copyWith({String? countryCode, String? cityName}) {
    return AddedCity(
      countryCode: countryCode ?? this.countryCode,
      cityName: cityName ?? this.cityName,
    );
  }

  factory AddedCity.fromJson(Map<String, dynamic> json) {
    return AddedCity(
      cityName: json['cityName'],
      countryCode: json['countryCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cityName': cityName,
      'countryCode': countryCode,
    };
  }
}

class CitiesState extends Equatable {
  final List<AddedCity>? cities;

  const CitiesState({this.cities});

  @override
  List<Object?> get props => [cities];
}
