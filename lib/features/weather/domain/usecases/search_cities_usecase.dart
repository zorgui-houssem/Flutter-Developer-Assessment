import 'package:injectable/injectable.dart';
import '../entities/city_suggestion.dart';
import '../repositories/city_search_repository.dart';

class SearchCitiesParams {
  final String query;
  final int limit;

  const SearchCitiesParams({required this.query, this.limit = 5});
}

@lazySingleton
class SearchCitiesUseCase {
  final CitySearchRepository _repository;

  const SearchCitiesUseCase(this._repository);

  Future<List<CitySuggestion>> call(SearchCitiesParams params) {
    return _repository.searchCities(params.query, limit: params.limit);
  }
}
