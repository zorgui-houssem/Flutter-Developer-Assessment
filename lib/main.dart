import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'features/weather/data/models/weather_model.dart';
import 'injection/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(WeatherModelAdapter());

  await Hive.openBox<WeatherModel>('weather_cache');
  await Hive.openBox<List>('recent_searches');
  await Hive.openBox<String>('settings');

  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Warning: Could not load .env file.');
  }

  await configureDependencies();
  runApp(const WeatherApp());
}
