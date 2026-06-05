import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/weather_entity.dart';

abstract class WeatherRepository {
  Future<Either<Failure, WeatherEntity>> getWeather(String cityName);

  Future<List<String>> getRecentSearches();

  Future<void> saveRecentSearches(List<String> searches);
}
