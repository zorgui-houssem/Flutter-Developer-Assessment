import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/usecases/get_weather_usecase.dart';
import 'weather_event.dart';
import 'weather_state.dart';

@injectable
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeatherUseCase _getWeatherUseCase;

  String? _lastSearchedCity;

  WeatherBloc({required GetWeatherUseCase getWeatherUseCase})
      : _getWeatherUseCase = getWeatherUseCase,
        super(const WeatherInitial()) {
    on<FetchWeatherEvent>(_onFetchWeather);
    on<RefreshWeatherEvent>(_onRefreshWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    if (state is WeatherLoading) return;

    final city = event.cityName.trim();
    if (city.isEmpty) return;

    emit(const WeatherLoading());
    _lastSearchedCity = city;

    final result = await _getWeatherUseCase(WeatherParams(cityName: city));

    result.fold(
      (failure) => emit(WeatherError(message: _mapFailureToMessage(failure))),
      (weather) {
        final isFromCache =
            DateTime.now().difference(weather.cachedAt).inSeconds > 5;
        emit(WeatherLoaded(weather: weather, isFromCache: isFromCache));
      },
    );
  }

  Future<void> _onRefreshWeather(
    RefreshWeatherEvent event,
    Emitter<WeatherState> emit,
  ) async {
    final city = _lastSearchedCity;
    if (city == null || city.isEmpty) return;

    emit(const WeatherLoading());

    final result = await _getWeatherUseCase(WeatherParams(cityName: city));

    result.fold(
      (failure) => emit(WeatherError(message: _mapFailureToMessage(failure))),
      (weather) => emit(WeatherLoaded(weather: weather, isFromCache: false)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    return switch (failure) {
      NotFoundFailure() => 'City not found. Please check the spelling.',
      CacheFailure() => 'No internet connection. No cached data available.',
      NetworkFailure() => 'No internet connection. No cached data available.',
      RateLimitFailure() => 'API limit reached. Please try again later.',
      ServerFailure(message: final msg) when msg.isNotEmpty =>
        'Server error. Please try again.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  String? get lastSearchedCity => _lastSearchedCity;
}
