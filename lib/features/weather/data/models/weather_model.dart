import 'package:hive/hive.dart';
import '../../domain/entities/weather_entity.dart';

part 'weather_model.g.dart';

@HiveType(typeId: 0)
class WeatherModel extends WeatherEntity {
  @HiveField(0)
  @override
  final String cityName;

  @HiveField(1)
  @override
  final String country;

  @HiveField(2)
  @override
  final double temperature;

  @HiveField(3)
  @override
  final String condition;

  @HiveField(4)
  @override
  final int humidity;

  @HiveField(5)
  @override
  final double windSpeed;

  @HiveField(6)
  @override
  final double feelsLike;

  @HiveField(7)
  @override
  final String iconCode;

  @HiveField(8)
  @override
  final DateTime cachedAt;

  const WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.iconCode,
    required this.cachedAt,
  }) : super(
          cityName: cityName,
          country: country,
          temperature: temperature,
          condition: condition,
          humidity: humidity,
          windSpeed: windSpeed,
          feelsLike: feelsLike,
          iconCode: iconCode,
          cachedAt: cachedAt,
        );

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: (json['name'] as String?) ?? 'Unknown',
      country: (json['sys']?['country'] as String?) ?? '--',
      temperature: ((json['main']?['temp'] as num?) ?? 0).toDouble(),
      condition: (json['weather'] as List?)?.isNotEmpty == true
          ? (json['weather'][0]['description'] as String?) ?? 'Unknown'
          : 'Unknown',
      humidity: (json['main']?['humidity'] as int?) ?? 0,
      windSpeed: ((json['wind']?['speed'] as num?) ?? 0).toDouble() * 3.6,
      feelsLike: ((json['main']?['feels_like'] as num?) ?? 0).toDouble(),
      iconCode: (json['weather'] as List?)?.isNotEmpty == true
          ? (json['weather'][0]['icon'] as String?) ?? '01d'
          : '01d',
      cachedAt: DateTime.now(),
    );
  }

  WeatherEntity toEntity() => this;
}
