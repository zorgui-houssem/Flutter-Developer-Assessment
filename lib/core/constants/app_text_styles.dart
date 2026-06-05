import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle temperatureHuge(Color color) => TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: -2,
        height: 1,
      );

  static TextStyle temperatureMedium(Color color) => TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: -1,
      );

  static TextStyle cityName(Color color) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle countryName(Color color) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
        letterSpacing: 1.5,
      );

  static TextStyle condition(Color color) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: color,
        letterSpacing: 0.3,
      );

  static TextStyle statValue(Color color) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle statLabel(Color color) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle searchInput(Color color) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle searchHint(Color color) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
        fontStyle: FontStyle.italic,
      );

  static TextStyle errorMessage(Color color) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle offlineBanner(Color color) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.3,
      );

  static TextStyle cacheTimestamp(Color color) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color,
      );

  static TextStyle chipLabel(Color color) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle appBarTitle(Color color) => TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
        letterSpacing: 0.5,
      );
}
