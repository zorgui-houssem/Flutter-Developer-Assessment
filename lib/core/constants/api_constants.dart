import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  ApiConstants._();

  static String get baseUrl => kIsWeb
      ? 'https://corsproxy.io/?https://api.openweathermap.org/data/2.5/'
      : 'https://api.openweathermap.org/data/2.5/';

  static const String weatherEndpoint = 'weather';

  static String get apiKey => dotenv.env['OPENWEATHER_API_KEY'] ?? '';

  static const String units = 'metric';
}
