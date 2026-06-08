import 'package:injectable/injectable.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class GetRecentSearchesUseCase {
  final WeatherRepository _repository;

  const GetRecentSearchesUseCase(this._repository);

  Future<List<String>> call() => _repository.getRecentSearches();
}
