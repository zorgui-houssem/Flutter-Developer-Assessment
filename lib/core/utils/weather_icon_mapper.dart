import 'package:flutter/material.dart';

class WeatherIconMapper {
  WeatherIconMapper._();

  static IconData getIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return Icons.wb_sunny_rounded;
      case '01n':
        return Icons.nightlight_round;

      case '02d':
        return Icons.wb_cloudy_rounded;
      case '02n':
        return Icons.nights_stay_rounded;

      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return Icons.cloud_rounded;

      case '09d':
      case '09n':
        return Icons.grain_rounded;

      case '10d':
        return Icons.umbrella_rounded;
      case '10n':
        return Icons.umbrella_rounded;

      case '11d':
      case '11n':
        return Icons.bolt_rounded;

      case '13d':
      case '13n':
        return Icons.ac_unit_rounded;

      case '50d':
      case '50n':
        return Icons.blur_on_rounded;

      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  static String getEmoji(String iconCode) {
    switch (iconCode) {
      case '01d':
        return 'â˜€ï¸';
      case '01n':
        return 'ðŸŒ™';
      case '02d':
        return 'â›…';
      case '02n':
        return 'â˜ï¸';
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return 'â˜ï¸';
      case '09d':
      case '09n':
        return 'ðŸŒ§ï¸';
      case '10d':
      case '10n':
        return 'ðŸŒ¦ï¸';
      case '11d':
      case '11n':
        return 'â›ˆï¸';
      case '13d':
      case '13n':
        return 'â„ï¸';
      case '50d':
      case '50n':
        return 'ðŸŒ«ï¸';
      default:
        return 'ðŸŒ¤ï¸';
    }
  }

  static String getIconUrl(String iconCode) =>
      'https://openweathermap.org/img/wn/$iconCode@2x.png';
}
