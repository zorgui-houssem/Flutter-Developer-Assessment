import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'features/weather/presentation/bloc/recent_searches/recent_searches_bloc.dart';
import 'features/weather/presentation/bloc/theme/theme_bloc.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';
import 'features/weather/presentation/pages/weather_page.dart';
import 'injection/injection.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(create: (_) => getIt<ThemeBloc>()),
        BlocProvider<WeatherBloc>(create: (_) => getIt<WeatherBloc>()),
        BlocProvider<RecentSearchesBloc>(
          create: (_) => getIt<RecentSearchesBloc>(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'WeatherNow',
            debugShowCheckedModeBanner: false,
            themeMode: themeState.mode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const WeatherPage(),
          );
        },
      ),
    );
  }
}
