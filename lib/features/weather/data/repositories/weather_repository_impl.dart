import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/weather_entity.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_local_datasource.dart';
import '../datasources/weather_remote_datasource.dart';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource _remoteDatasource;
  final WeatherLocalDatasource _localDatasource;
  final NetworkInfo _networkInfo;

  const WeatherRepositoryImpl(
    this._remoteDatasource,
    this._localDatasource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, WeatherEntity>> getWeather(String cityName) async {
    if (await _networkInfo.isConnected) {
      return _fetchFromRemote(cityName);
    } else {
      return _fetchFromCache(cityName);
    }
  }

  Future<Either<Failure, WeatherEntity>> _fetchFromRemote(
      String cityName) async {
    try {
      final weatherModel = await _remoteDatasource.getWeather(cityName);
      await _localDatasource.cacheWeather(weatherModel);
      return Right(weatherModel);
    } on NotFoundException {
      return const Left(NotFoundFailure());
    } on RateLimitException {
      return const Left(RateLimitFailure());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  Future<Either<Failure, WeatherEntity>> _fetchFromCache(
      String cityName) async {
    try {
      final cached = await _localDatasource.getWeather(cityName);
      return Right(cached);
    } on CacheException {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<List<String>> getRecentSearches() {
    return _localDatasource.getRecentSearches();
  }

  @override
  Future<void> saveRecentSearches(List<String> searches) {
    return _localDatasource.saveRecentSearches(searches);
  }
}
