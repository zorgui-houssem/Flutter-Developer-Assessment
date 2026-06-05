import 'package:equatable/equatable.dart';

class WeatherEntity extends Equatable {
  final String cityName;

  final String country;

  final double temperature;

  final String condition;

  final int humidity;

  final double windSpeed;

  final double feelsLike;

  final String iconCode;

  final DateTime cachedAt;

  const WeatherEntity({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.iconCode,
    required this.cachedAt,
  });

  @override
  List<Object?> get props => [
        cityName,
        country,
        temperature,
        condition,
        humidity,
        windSpeed,
        feelsLike,
        iconCode,
        cachedAt,
      ];
}
