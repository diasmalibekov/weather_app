import 'package:dio/dio.dart';

final Dio dio = Dio();

class GeoApiEnvironmentException implements Exception {
  String cause;
  GeoApiEnvironmentException(this.cause);
}

class GeoDataRepository {
  final String? _rapidApiKey;

  GeoDataRepository(this._rapidApiKey);

  Future<Map<String, dynamic>> fetchCities({
    int limit = 10,
    int offset = 0,
    required String countryCode,
    String? search,
  }) async {
    final result = await _geoGetList<Map<String, dynamic>>(
      'cities',
      query: <String, dynamic>{
        'namePrefix': search,
        'limit': limit,
        'offset': offset,
        'countryIds': countryCode
      },
    );
    return result.data!;
  }

  Future<Map<String, dynamic>> fetchCountries({
    int limit = 10,
    int offset = 0,
    String? search,
  }) async {
    final result = await _geoGetList<Map<String, dynamic>>(
      'countries',
      query: <String, dynamic>{
        'namePrefix': search,
        'limit': limit,
        'offset': offset,
      },
    );
    return result.data!;
  }

  Future<Response<T>> _geoGetList<T>(
    String endpoint, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? query,
  }) async {
    if (_rapidApiKey == null) {
      throw GeoApiEnvironmentException(
        'Env var RAPID_API_KEY is required\nPlease check your .env file',
      );
    }
    final res = await dio.get<T>(
      'https://wft-geo-db.p.rapidapi.com/v1/geo/$endpoint',
      options: Options(
        headers: <String, dynamic>{
          'x-rapidapi-key': _rapidApiKey,
          'x-rapidapi-host': 'wft-geo-db.p.rapidapi.com',
          'content-type': 'application/json',
          ...(headers ?? <String, dynamic>{}),
        },
      ),
      queryParameters: query,
    );
    return res;
  }
}
