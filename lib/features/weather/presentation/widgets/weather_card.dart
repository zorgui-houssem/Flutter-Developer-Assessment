import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/weather_icon_mapper.dart';
import '../../domain/entities/weather_entity.dart';

class WeatherCard extends StatefulWidget {
  final WeatherEntity weather;

  final bool isFromCache;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.isFromCache,
  });

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void didUpdateWidget(WeatherCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.weather != widget.weather) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: _buildGlassCard(context, isDark),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            isDark
                ? AppColors.darkAccent.withValues(alpha: 0.3)
                : AppColors.lightAccent.withValues(alpha: 0.2),
            Colors.transparent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkCardSurface
                  : AppColors.lightCardSurface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? AppColors.darkGlassBorder
                    : AppColors.lightGlassBorder,
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isDark),
                  const SizedBox(height: 24),
                  _buildTemperatureRow(context, isDark),
                  const SizedBox(height: 8),
                  _buildCondition(context, isDark),
                  const SizedBox(height: 28),
                  _buildDivider(isDark),
                  const SizedBox(height: 24),
                  _buildStatsRow(context, isDark),
                  if (widget.isFromCache) ...[
                    const SizedBox(height: 20),
                    _buildCacheIndicator(context, isDark),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.weather.cityName,
                style: AppTextStyles.cityName(textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    size: 14,
                    color:
                        isDark ? AppColors.darkAccent : AppColors.lightAccent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.weather.country,
                    style: AppTextStyles.countryName(textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                    .withValues(alpha: 0.25),
                Colors.transparent,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: Icon(
            WeatherIconMapper.getIcon(widget.weather.iconCode),
            size: 44,
            color: isDark ? AppColors.darkAccent : AppColors.lightAccent,
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureRow(BuildContext context, bool isDark) {
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.weather.temperature.round()}',
          style: AppTextStyles.temperatureHuge(textPrimary),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            '°C',
            style: AppTextStyles.temperatureMedium(
              (isDark ? AppColors.darkAccent : AppColors.lightAccent)
                  .withValues(alpha: 0.8),
            ).copyWith(fontSize: 28),
          ),
        ),
      ],
    );
  }

  Widget _buildCondition(BuildContext context, bool isDark) {
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final condition = widget.weather.condition;
    final capitalized = condition.isEmpty
        ? ''
        : condition[0].toUpperCase() + condition.substring(1);

    return Text(
      capitalized,
      style: AppTextStyles.condition(textSecondary),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder)
                .withValues(alpha: 0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStat(
          context,
          icon: Icons.water_drop_rounded,
          value: '${widget.weather.humidity}%',
          label: 'Humidity',
          isDark: isDark,
        ),
        _buildVerticalDivider(isDark),
        _buildStat(
          context,
          icon: Icons.air_rounded,
          value: '${widget.weather.windSpeed.round()} km/h',
          label: 'Wind',
          isDark: isDark,
        ),
        _buildVerticalDivider(isDark),
        _buildStat(
          context,
          icon: Icons.thermostat_rounded,
          value: '${widget.weather.feelsLike.round()}°C',
          label: 'Feels Like',
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildStat(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
    required bool isDark,
  }) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;
    final textPrimary =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Column(
      children: [
        Icon(icon, color: accent, size: 20),
        const SizedBox(height: 8),
        Text(value, style: AppTextStyles.statValue(textPrimary)),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.statLabel(textSecondary)),
      ],
    );
  }

  Widget _buildVerticalDivider(bool isDark) {
    return Container(
      width: 1,
      height: 48,
      color: (isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder)
          .withValues(alpha: 0.4),
    );
  }

  Widget _buildCacheIndicator(BuildContext context, bool isDark) {
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Row(
      children: [
        Icon(Icons.history_rounded, size: 14, color: textSecondary),
        const SizedBox(width: 6),
        Text(
          'Cached ${DateFormatter.timeAgo(widget.weather.cachedAt)}',
          style: AppTextStyles.cacheTimestamp(textSecondary),
        ),
      ],
    );
  }
}
