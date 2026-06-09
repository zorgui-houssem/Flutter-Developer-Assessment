import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:weathernow/core/errors/failures.dart';
import 'package:weathernow/features/weather/domain/entities/weather_entity.dart';
import 'package:weathernow/features/weather/domain/usecases/get_weather_usecase.dart';
import 'package:weathernow/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:weathernow/features/weather/presentation/bloc/weather_event.dart';
import 'package:weathernow/features/weather/presentation/bloc/weather_state.dart';

class MockGetWeatherUseCase extends Mock implements GetWeatherUseCase {}

void main() {
  late WeatherBloc bloc;
  late MockGetWeatherUseCase mockGetWeatherUseCase;

  setUp(() {
    mockGetWeatherUseCase = MockGetWeatherUseCase();
    bloc = WeatherBloc(getWeatherUseCase: mockGetWeatherUseCase);
  });

  tearDown(() {
    bloc.close();
  });

  const tCityName = 'Paris';
  
  // Create a model/entity that is cached just now (cachedAt = now)
  final tWeatherNow = WeatherEntity(
    cityName: 'Paris',
    country: 'FR',
    temperature: 20.0,
    condition: 'Clear sky',
    humidity: 50,
    windSpeed: 10.0,
    feelsLike: 19.5,
    iconCode: '01d',
    cachedAt: DateTime.now(),
  );

  // Create a model/entity that was cached long ago (cachedAt = 1 hour ago)
  final tWeatherCached = WeatherEntity(
    cityName: 'Paris',
    country: 'FR',
    temperature: 20.0,
    condition: 'Clear sky',
    humidity: 50,
    windSpeed: 10.0,
    feelsLike: 19.5,
    iconCode: '01d',
    cachedAt: DateTime.now().subtract(const Duration(hours: 1)),
  );

  test('initial state should be WeatherInitial', () {
    expect(bloc.state, const WeatherInitial());
  });

  group('FetchWeatherEvent', () {
    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] when data is gotten successfully',
      build: () {
        registerFallbackValue(const WeatherParams(cityName: tCityName));
        when(() => mockGetWeatherUseCase(any()))
            .thenAnswer((_) async => Right(tWeatherNow));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchWeatherEvent(cityName: tCityName)),
      expect: () => [
        const WeatherLoading(),
        WeatherLoaded(weather: tWeatherNow, isFromCache: false),
      ],
      verify: (_) {
        verify(() => mockGetWeatherUseCase(const WeatherParams(cityName: tCityName)));
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded(isFromCache: true)] when cached data is older than 5 seconds',
      build: () {
        when(() => mockGetWeatherUseCase(any()))
            .thenAnswer((_) async => Right(tWeatherCached));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchWeatherEvent(cityName: tCityName)),
      expect: () => [
        const WeatherLoading(),
        WeatherLoaded(weather: tWeatherCached, isFromCache: true),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherError] when getting data fails',
      build: () {
        when(() => mockGetWeatherUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure(message: '')));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchWeatherEvent(cityName: tCityName)),
      expect: () => [
        const WeatherLoading(),
        const WeatherError(message: 'Something went wrong. Please try again.'),
      ],
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherError] with correct message on NotFoundFailure',
      build: () {
        when(() => mockGetWeatherUseCase(any()))
            .thenAnswer((_) async => const Left(NotFoundFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchWeatherEvent(cityName: tCityName)),
      expect: () => [
        const WeatherLoading(),
        const WeatherError(message: 'City not found. Please check the spelling.'),
      ],
    );
  });

  group('RefreshWeatherEvent', () {
    blocTest<WeatherBloc, WeatherState>(
      'should do nothing if no city was previously searched',
      build: () => bloc,
      act: (bloc) => bloc.add(const RefreshWeatherEvent()),
      expect: () => <WeatherState>[],
      verify: (_) {
        verifyZeroInteractions(mockGetWeatherUseCase);
      },
    );

    blocTest<WeatherBloc, WeatherState>(
      'should emit [WeatherLoading, WeatherLoaded] using the last searched city when pull-to-refresh is triggered',
      build: () {
        when(() => mockGetWeatherUseCase(any()))
            .thenAnswer((_) async => Right(tWeatherNow));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const FetchWeatherEvent(cityName: tCityName));
        // Wait for first call to resolve and update lastSearchedCity
        await Future.delayed(Duration.zero);
        bloc.add(const RefreshWeatherEvent());
      },
      expect: () => [
        const WeatherLoading(),
        WeatherLoaded(weather: tWeatherNow, isFromCache: false),
        const WeatherLoading(),
        WeatherLoaded(weather: tWeatherNow, isFromCache: false),
      ],
    );
  });
}
