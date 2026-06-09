import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weathernow/core/errors/exceptions.dart';
import 'package:weathernow/core/errors/failures.dart';
import 'package:weathernow/core/network/network_info.dart';
import 'package:weathernow/features/weather/data/datasources/weather_local_datasource.dart';
import 'package:weathernow/features/weather/data/datasources/weather_remote_datasource.dart';
import 'package:weathernow/features/weather/data/models/weather_model.dart';
import 'package:weathernow/features/weather/data/repositories/weather_repository_impl.dart';

class MockRemoteDataSource extends Mock implements WeatherRemoteDatasource {}
class MockLocalDataSource extends Mock implements WeatherLocalDatasource {}
class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockRemoteDataSource mockRemoteDataSource;
  late MockLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(WeatherModel(
      cityName: 'Paris',
      country: 'FR',
      temperature: 20.0,
      condition: 'Clear sky',
      humidity: 50,
      windSpeed: 10.0,
      feelsLike: 19.5,
      iconCode: '01d',
      cachedAt: DateTime(2026, 6, 7),
    ));
  });

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = WeatherRepositoryImpl(
      mockRemoteDataSource,
      mockLocalDataSource,
      mockNetworkInfo,
    );
  });

  const tCityName = 'Paris';
  final tWeatherModel = WeatherModel(
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

  group('getWeather', () {
    test('should check if the device is online', () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDataSource.getWeather(any()))
          .thenAnswer((_) async => tWeatherModel);
      when(() => mockLocalDataSource.cacheWeather(any()))
          .thenAnswer((_) async => {});

      // act
      await repository.getWeather(tCityName);

      // assert
      verify(() => mockNetworkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      test('should return remote data and cache it when successful', () async {
        // arrange
        when(() => mockRemoteDataSource.getWeather(any()))
            .thenAnswer((_) async => tWeatherModel);
        when(() => mockLocalDataSource.cacheWeather(any()))
            .thenAnswer((_) async => {});

        // act
        final result = await repository.getWeather(tCityName);

        // assert
        verify(() => mockRemoteDataSource.getWeather(tCityName));
        verify(() => mockLocalDataSource.cacheWeather(tWeatherModel));
        expect(result, Right(tWeatherModel));
      });

      test('should return ServerFailure when remote call is unsuccessful', () async {
        // arrange
        when(() => mockRemoteDataSource.getWeather(any()))
            .thenThrow(const ServerException(message: 'Server Error'));

        // act
        final result = await repository.getWeather(tCityName);

        // assert
        verify(() => mockRemoteDataSource.getWeather(tCityName));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, const Left(ServerFailure(message: 'Server Error')));
      });

      test('should return NotFoundFailure when remote city is not found', () async {
        // arrange
        when(() => mockRemoteDataSource.getWeather(any()))
            .thenThrow(const NotFoundException());

        // act
        final result = await repository.getWeather(tCityName);

        // assert
        verify(() => mockRemoteDataSource.getWeather(tCityName));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, const Left(NotFoundFailure()));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      test('should return last cached weather data when cached is present', () async {
        // arrange
        when(() => mockLocalDataSource.getWeather(any()))
            .thenAnswer((_) async => tWeatherModel);

        // act
        final result = await repository.getWeather(tCityName);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getWeather(tCityName));
        expect(result, Right(tWeatherModel));
      });

      test('should return CacheFailure when there is no cached data', () async {
        // arrange
        when(() => mockLocalDataSource.getWeather(any()))
            .thenThrow(const CacheException());

        // act
        final result = await repository.getWeather(tCityName);

        // assert
        verifyZeroInteractions(mockRemoteDataSource);
        verify(() => mockLocalDataSource.getWeather(tCityName));
        expect(result, const Left(CacheFailure()));
      });
    });
  });
}
