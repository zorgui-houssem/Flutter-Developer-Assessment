// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../core/network/dio_client.dart' as _i393;
import '../core/network/network_info.dart' as _i6;
import '../features/weather/data/datasources/city_search_datasource.dart'
    as _i471;
import '../features/weather/data/datasources/weather_local_datasource.dart'
    as _i408;
import '../features/weather/data/datasources/weather_remote_datasource.dart'
    as _i402;
import '../features/weather/data/repositories/city_search_repository_impl.dart'
    as _i544;
import '../features/weather/data/repositories/weather_repository_impl.dart'
    as _i22;
import '../features/weather/domain/repositories/city_search_repository.dart'
    as _i908;
import '../features/weather/domain/repositories/weather_repository.dart'
    as _i954;
import '../features/weather/domain/usecases/clear_recent_searches_usecase.dart'
    as _i226;
import '../features/weather/domain/usecases/get_recent_searches_usecase.dart'
    as _i196;
import '../features/weather/domain/usecases/get_weather_usecase.dart' as _i722;
import '../features/weather/domain/usecases/remove_recent_search_usecase.dart'
    as _i366;
import '../features/weather/domain/usecases/save_recent_search_usecase.dart'
    as _i442;
import '../features/weather/domain/usecases/search_cities_usecase.dart' as _i73;
import '../features/weather/presentation/bloc/city_search/city_search_bloc.dart'
    as _i109;
import '../features/weather/presentation/bloc/recent_searches/recent_searches_bloc.dart'
    as _i526;
import '../features/weather/presentation/bloc/theme/theme_bloc.dart' as _i330;
import '../features/weather/presentation/bloc/weather_bloc.dart' as _i983;
import 'injection.dart' as _i464;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i393.DioClient>(() => _i393.DioClient());
    gh.lazySingleton<_i330.ThemeBloc>(() => _i330.ThemeBloc());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i471.CitySearchDatasource>(
        () => _i471.CitySearchDatasourceImpl());
    gh.lazySingleton<_i402.WeatherRemoteDatasource>(
        () => _i402.WeatherRemoteDatasourceImpl(gh<_i393.DioClient>()));
    gh.lazySingleton<_i408.WeatherLocalDatasource>(
        () => _i408.WeatherLocalDatasourceImpl());
    gh.lazySingleton<_i6.NetworkInfo>(
        () => _i6.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i908.CitySearchRepository>(
        () => _i544.CitySearchRepositoryImpl(gh<_i471.CitySearchDatasource>()));
    gh.lazySingleton<_i954.WeatherRepository>(() => _i22.WeatherRepositoryImpl(
          gh<_i402.WeatherRemoteDatasource>(),
          gh<_i408.WeatherLocalDatasource>(),
          gh<_i6.NetworkInfo>(),
        ));
    gh.lazySingleton<_i73.SearchCitiesUseCase>(
        () => _i73.SearchCitiesUseCase(gh<_i908.CitySearchRepository>()));
    gh.factory<_i109.CitySearchBloc>(() =>
        _i109.CitySearchBloc(searchCities: gh<_i73.SearchCitiesUseCase>()));
    gh.lazySingleton<_i226.ClearRecentSearchesUseCase>(
        () => _i226.ClearRecentSearchesUseCase(gh<_i954.WeatherRepository>()));
    gh.lazySingleton<_i196.GetRecentSearchesUseCase>(
        () => _i196.GetRecentSearchesUseCase(gh<_i954.WeatherRepository>()));
    gh.lazySingleton<_i722.GetWeatherUseCase>(
        () => _i722.GetWeatherUseCase(gh<_i954.WeatherRepository>()));
    gh.lazySingleton<_i366.RemoveRecentSearchUseCase>(
        () => _i366.RemoveRecentSearchUseCase(gh<_i954.WeatherRepository>()));
    gh.lazySingleton<_i442.SaveRecentSearchUseCase>(
        () => _i442.SaveRecentSearchUseCase(gh<_i954.WeatherRepository>()));
    gh.factory<_i983.WeatherBloc>(() =>
        _i983.WeatherBloc(getWeatherUseCase: gh<_i722.GetWeatherUseCase>()));
    gh.factory<_i526.RecentSearchesBloc>(() => _i526.RecentSearchesBloc(
          getRecentSearches: gh<_i196.GetRecentSearchesUseCase>(),
          saveRecentSearch: gh<_i442.SaveRecentSearchUseCase>(),
          removeRecentSearch: gh<_i366.RemoveRecentSearchUseCase>(),
          clearRecentSearches: gh<_i226.ClearRecentSearchesUseCase>(),
        ));
    return this;
  }
}

class _$RegisterModule extends _i464.RegisterModule {}
