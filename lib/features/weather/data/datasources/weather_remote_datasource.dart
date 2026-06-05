import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/weather_model.dart';

abstract class WeatherRemoteDatasource {
  Future<WeatherModel> getWeather(String cityName);
}

@LazySingleton(as: WeatherRemoteDatasource)
class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  final DioClient _dioClient;

  const WeatherRemoteDatasourceImpl(this._dioClient);

  @override
  Future<WeatherModel> getWeather(String cityName) async {
    try {
      final requestUrl = kIsWeb
          ? 'https://corsproxy.io/?' +
              Uri.encodeFull(
                  'https://api.openweathermap.org/data/2.5/weather?q=${cityName.trim()}&appid=${ApiConstants.apiKey}&units=${ApiConstants.units}')
          : '${ApiConstants.baseUrl}${ApiConstants.weatherEndpoint}';
      final response = await _dioClient.dio.get(
        requestUrl,
        queryParameters: kIsWeb
            ? null
            : {
                'q': cityName.trim(),
                'appid': ApiConstants.apiKey,
                'units': ApiConstants.units,
              },
      );
      return WeatherModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NotFoundException) throw const NotFoundException();
      if (e.error is RateLimitException) throw const RateLimitException();
      if (e.error is ServerException) {
        throw ServerException(message: (e.error as ServerException).message);
      }
      if (e.error is NetworkException) throw const NetworkException();
      throw ServerException(message: e.message ?? 'Unknown network error');
    }
  }
}
