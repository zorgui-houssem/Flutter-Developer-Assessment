import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: false,
        responseHeader: false,
        logPrint: (obj) => _log(obj.toString()),
      ),
      _ErrorInterceptor(),
    ]);
  }

  Dio get dio => _dio;

  void _log(String message) {
    print('[DioClient] $message');
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: err.type,
        ),
      );
      return;
    }

    final statusCode = err.response?.statusCode;

    if (statusCode == 404) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: const NotFoundException(),
          type: err.type,
        ),
      );
    } else if (statusCode == 429) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: const RateLimitException(),
          type: err.type,
        ),
      );
    } else if (statusCode != null && statusCode >= 500) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          error: ServerException(message: 'Server error: $statusCode'),
          type: err.type,
        ),
      );
    } else {
      handler.next(err);
    }
  }
}
