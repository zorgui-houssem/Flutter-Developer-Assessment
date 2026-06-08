import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/weather_entity.dart';
import '../repositories/weather_repository.dart';

class WeatherParams extends Equatable {
  final String cityName;

  const WeatherParams({required this.cityName});

  @override
  List<Object?> get props => [cityName];
}

@lazySingleton
class GetWeatherUseCase implements UseCase<WeatherEntity, WeatherParams> {
  final WeatherRepository _repository;

  const GetWeatherUseCase(this._repository);

  @override
  Future<Either<Failure, WeatherEntity>> call(WeatherParams params) {
    return _repository.getWeather(params.cityName);
  }
}
