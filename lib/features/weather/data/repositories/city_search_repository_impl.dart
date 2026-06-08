import 'package:injectable/injectable.dart';
import '../../domain/entities/city_suggestion.dart';
import '../../domain/repositories/city_search_repository.dart';
import '../datasources/city_search_datasource.dart';

@LazySingleton(as: CitySearchRepository)
class CitySearchRepositoryImpl implements CitySearchRepository {
  final CitySearchDatasource _datasource;

  const CitySearchRepositoryImpl(this._datasource);

  @override
  Future<List<CitySuggestion>> searchCities(String query, {int limit = 5}) {
    return _datasource.searchCities(query, limit: limit);
  }
}
