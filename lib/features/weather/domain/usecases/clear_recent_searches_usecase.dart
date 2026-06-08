import 'package:injectable/injectable.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class ClearRecentSearchesUseCase {
  final WeatherRepository _repository;

  const ClearRecentSearchesUseCase(this._repository);

  Future<void> call() => _repository.saveRecentSearches([]);
}
