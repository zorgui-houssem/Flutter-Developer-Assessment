import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../domain/entities/city_suggestion.dart';

abstract class CitySearchDatasource {
  Future<List<CitySuggestion>> searchCities(String query, {int limit = 5});
}

@LazySingleton(as: CitySearchDatasource)
class CitySearchDatasourceImpl implements CitySearchDatasource {
  final Dio _dio;

  CitySearchDatasourceImpl() : _dio = Dio();

  @override
  Future<List<CitySuggestion>> searchCities(String query,
      {int limit = 5}) async {
    if (query.trim().isEmpty) return [];

    try {
      const apiUrl = 'https://api.openweathermap.org/geo/1.0/direct';
      final fullUrl = kIsWeb
          ? 'https://corsproxy.io/?${Uri.encodeFull('$apiUrl?q=${query.trim()}&limit=$limit&appid=${ApiConstants.apiKey}')}'
          : apiUrl;

      final response = await _dio.get(
        fullUrl,
        queryParameters: kIsWeb
            ? null
            : {
                'q': query.trim(),
                'limit': limit,
                'appid': ApiConstants.apiKey,
              },
      );

      if (response.data is List) {
        return (response.data as List)
            .map((json) => _fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint('[CitySearch] Error: $e');
      return [];
    }
  }

  CitySuggestion _fromJson(Map<String, dynamic> json) {
    return CitySuggestion(
      name: (json['name'] ?? '') as String,
      country: (json['country'] ?? '') as String,
      state: json['state'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
    );
  }
}
