import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../injection/injection.dart';
import '../bloc/recent_searches/recent_searches_bloc.dart';
import '../bloc/theme/theme_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
import '../widgets/offline_banner.dart';
import '../widgets/recent_searches_list.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/weather_card.dart';
import '../widgets/weather_error_widget.dart';
import '../widgets/weather_shimmer.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherLoaded) {
          context.read<RecentSearchesBloc>().add(
                RecentSearchAdded(state.weather.cityName),
              );
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _buildAppBar(context),
        body: const _WeatherPageBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [accent, accent.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child:
                const Icon(Icons.cloud_rounded, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            'WeatherNow',
            style: AppTextStyles.appBarTitle(
              isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
      actions: [
        BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, themeState) {
            return IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Icon(
                  themeState.isDark
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey(themeState.mode),
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  size: 22,
                ),
              ),
              onPressed: () =>
                  context.read<ThemeBloc>().add(const ThemeToggled()),
              tooltip: themeState.isDark ? 'Light mode' : 'Dark mode',
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}

class _WeatherPageBody extends StatelessWidget {
  const _WeatherPageBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isDark
                  ? [
                      AppColors.darkBackground,
                      AppColors.darkBackgroundSecondary,
                      const Color(0xFF0F1B3D),
                    ]
                  : [
                      AppColors.lightBackground,
                      AppColors.lightBackgroundSecondary,
                      const Color(0xFFE8F0FF),
                    ],
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accent.withValues(alpha: 0.18),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 120,
          left: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accent.withValues(alpha: 0.1),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        SafeArea(
          child: BlocBuilder<WeatherBloc, WeatherState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  if (state is! WeatherInitial) {
                    context
                        .read<WeatherBloc>()
                        .add(const RefreshWeatherEvent());
                    await Future.delayed(const Duration(milliseconds: 1200));
                  }
                },
                color: accent,
                backgroundColor:
                    isDark ? AppColors.darkBackgroundSecondary : Colors.white,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          SearchBarWidget(
                            enabled: state is! WeatherLoading,
                            onSearch: (city) {
                              context.read<WeatherBloc>().add(
                                    FetchWeatherEvent(cityName: city),
                                  );
                            },
                          ),
                          const SizedBox(height: 20),
                          const RecentSearchesList(),
                          const SizedBox(height: 24),
                          StreamBuilder<List<ConnectivityResult>>(
                            stream: getIt<Connectivity>().onConnectivityChanged,
                            builder: (context, snapshot) {
                              final isOffline = snapshot.hasData &&
                                  !snapshot.data!
                                      .any((r) => r != ConnectivityResult.none);
                              final isCached =
                                  state is WeatherLoaded && state.isFromCache;

                              if (isOffline || isCached) {
                                return const Padding(
                                  padding: EdgeInsets.only(bottom: 16),
                                  child: OfflineBanner(),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 400),
                            switchInCurve: Curves.easeOutCubic,
                            switchOutCurve: Curves.easeInCubic,
                            child: _buildBody(context, state),
                          ),
                          const SizedBox(height: 40),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context, WeatherState state) {
    if (state is WeatherInitial) {
      return _WelcomeState(key: const ValueKey('welcome'));
    }
    if (state is WeatherLoading) {
      return const WeatherShimmer(key: ValueKey('loading'));
    }
    if (state is WeatherLoaded) {
      return WeatherCard(
        key: ValueKey(state.weather.cityName),
        weather: state.weather,
        isFromCache: state.isFromCache,
      );
    }
    if (state is WeatherError) {
      return WeatherErrorWidget(
        key: ValueKey(state.message),
        message: state.message,
        onRetry: () {
          context.read<WeatherBloc>().add(const RefreshWeatherEvent());
        },
      );
    }
    return const SizedBox.shrink();
  }
}

class _WelcomeState extends StatelessWidget {
  const _WelcomeState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    accent.withValues(alpha: 0.25),
                    accent.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
                border: Border.all(color: accent.withValues(alpha: 0.2)),
              ),
              child: Icon(
                Icons.wb_sunny_rounded,
                size: 72,
                color: accent.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Search for a city',
              style: AppTextStyles.cityName(
                isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ).copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Real-time weather\nfor any city',
              style: AppTextStyles.condition(textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: ['Paris', 'London', 'Tokyo', 'New York'].map((city) {
                return ActionChip(
                  label: Text(city),
                  backgroundColor: accent.withValues(alpha: 0.12),
                  side: BorderSide(color: accent.withValues(alpha: 0.3)),
                  labelStyle: AppTextStyles.chipLabel(accent),
                  onPressed: () {
                    context.read<WeatherBloc>().add(
                          FetchWeatherEvent(cityName: city),
                        );
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
