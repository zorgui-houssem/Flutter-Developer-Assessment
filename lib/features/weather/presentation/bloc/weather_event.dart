import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object?> get props => [];
}

class FetchWeatherEvent extends WeatherEvent {
  final String cityName;

  const FetchWeatherEvent({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

class RefreshWeatherEvent extends WeatherEvent {
  const RefreshWeatherEvent();
}
