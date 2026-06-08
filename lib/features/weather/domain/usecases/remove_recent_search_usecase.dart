import 'package:injectable/injectable.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class RemoveRecentSearchUseCase {
  final WeatherRepository _repository;

  const RemoveRecentSearchUseCase(this._repository);

  Future<void> call(String city) async {
    final current = await _repository.getRecentSearches();
    final updated = current.where((c) => c != city).toList();
    await _repository.saveRecentSearches(updated);
  }
}
