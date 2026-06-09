import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weathernow/core/errors/failures.dart';
import 'package:weathernow/features/weather/domain/entities/weather_entity.dart';
import 'package:weathernow/features/weather/domain/repositories/weather_repository.dart';
import 'package:weathernow/features/weather/domain/usecases/get_weather_usecase.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetWeatherUseCase usecase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    usecase = GetWeatherUseCase(mockRepository);
  });

  const tCityName = 'Paris';
  final tWeather = WeatherEntity(
    cityName: 'Paris',
    country: 'FR',
    temperature: 20.0,
    condition: 'Clear sky',
    humidity: 50,
    windSpeed: 10.0,
    feelsLike: 19.5,
    iconCode: '01d',
    cachedAt: DateTime(2026, 6, 7),
  );

  test(
    'should get weather for the city from the repository',
    () async {
      // arrange
      when(() => mockRepository.getWeather(any()))
          .thenAnswer((_) async => Right(tWeather));

      // act
      final result = await usecase(const WeatherParams(cityName: tCityName));

      // assert
      expect(result, Right(tWeather));
      verify(() => mockRepository.getWeather(tCityName));
      verifyNoMoreInteractions(mockRepository);
    },
  );

  test(
    'should return Failure when repository call fails',
    () async {
      // arrange
      const tFailure = ServerFailure(message: 'Server Error');
      when(() => mockRepository.getWeather(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // act
      final result = await usecase(const WeatherParams(cityName: tCityName));

      // assert
      expect(result, const Left(tFailure));
      verify(() => mockRepository.getWeather(tCityName));
      verifyNoMoreInteractions(mockRepository);
    },
  );
}
