import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/weather_model.dart';

abstract class WeatherLocalDatasource {
  Future<void> cacheWeather(WeatherModel weatherModel);

  Future<WeatherModel> getWeather(String cityName);

  Future<void> saveRecentSearches(List<String> searches);

  Future<List<String>> getRecentSearches();
}

class _HiveKeys {
  static const String lastWeather = 'last_weather';
  static const String searches = 'searches';
}

class _HiveBoxes {
  static const String weatherCache = 'weather_cache';
  static const String recentSearches = 'recent_searches';
}

@LazySingleton(as: WeatherLocalDatasource)
class WeatherLocalDatasourceImpl implements WeatherLocalDatasource {
  @override
  Future<void> cacheWeather(WeatherModel weatherModel) async {
    final box = Hive.box<WeatherModel>(_HiveBoxes.weatherCache);
    await box.put(weatherModel.cityName.toLowerCase(), weatherModel);
    await box.put(_HiveKeys.lastWeather, weatherModel);
  }

  @override
  Future<WeatherModel> getWeather(String cityName) async {
    final box = Hive.box<WeatherModel>(_HiveBoxes.weatherCache);
    final cached = box.get(cityName.toLowerCase());
    if (cached == null) throw const CacheException();
    return cached;
  }

  @override
  Future<void> saveRecentSearches(List<String> searches) async {
    final box = Hive.box<List>(_HiveBoxes.recentSearches);
    await box.put(_HiveKeys.searches, searches);
  }

  @override
  Future<List<String>> getRecentSearches() async {
    final box = Hive.box<List>(_HiveBoxes.recentSearches);
    final raw = box.get(_HiveKeys.searches);
    if (raw == null) return [];
    return raw.cast<String>();
  }
}
