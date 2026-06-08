import 'package:injectable/injectable.dart';
import '../repositories/weather_repository.dart';

@lazySingleton
class SaveRecentSearchUseCase {
  final WeatherRepository _repository;

  const SaveRecentSearchUseCase(this._repository);

  Future<void> call(String city) async {
    final trimmed = city.trim();
    if (trimmed.isEmpty) return;

    final current = await _repository.getRecentSearches();
    final updated =
        [trimmed, ...current.where((c) => c != trimmed)].take(5).toList();
    await _repository.saveRecentSearches(updated);
  }
}
