class ServerException implements Exception {
  final String message;

  const ServerException({this.message = 'A server error occurred.'});
}

class NotFoundException implements Exception {
  const NotFoundException();
}

class RateLimitException implements Exception {
  const RateLimitException();
}

class CacheException implements Exception {
  const CacheException();
}

class NetworkException implements Exception {
  const NetworkException();
}
