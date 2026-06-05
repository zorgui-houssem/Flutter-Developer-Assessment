import '../entities/city_suggestion.dart';

abstract class CitySearchRepository {
  Future<List<CitySuggestion>> searchCities(String query, {int limit = 5});
}
