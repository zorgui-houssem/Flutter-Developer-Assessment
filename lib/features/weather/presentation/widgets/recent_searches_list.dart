import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../bloc/recent_searches/recent_searches_bloc.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';

class RecentSearchesList extends StatelessWidget {
  const RecentSearchesList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecentSearchesBloc, RecentSearchesState>(
      builder: (context, state) {
        if (state.searches.isEmpty) return const SizedBox.shrink();

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'Recent Searches',
                style: AppTextStyles.statLabel(
                  isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ).copyWith(
                  fontSize: 13,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.searches.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final city = state.searches[index];
                  return _RecentChip(
                    key: ValueKey(city),
                    city: city,
                    isDark: isDark,
                    index: index,
                    onTap: () {
                      context.read<WeatherBloc>().add(
                            FetchWeatherEvent(cityName: city),
                          );
                    },
                    onRemove: () {
                      context.read<RecentSearchesBloc>().add(
                            RecentSearchRemoved(city),
                          );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecentChip extends StatefulWidget {
  final String city;
  final bool isDark;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentChip({
    super.key,
    required this.city,
    required this.isDark,
    required this.index,
    required this.onTap,
    required this.onRemove,
  });

  @override
  State<_RecentChip> createState() => _RecentChipState();
}

class _RecentChipState extends State<_RecentChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    Future.delayed(Duration(milliseconds: widget.index * 60), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return SlideTransition(
      position: _slideAnim,
      child: FadeTransition(
        opacity: _fadeAnim,
        child: GestureDetector(
          onTap: widget.onTap,
          onLongPress: widget.onRemove,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.18),
                  accent.withValues(alpha: 0.06),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: accent.withValues(alpha: 0.35)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history_rounded, size: 14, color: accent),
                const SizedBox(width: 6),
                Text(
                  widget.city,
                  style: AppTextStyles.chipLabel(
                    widget.isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
