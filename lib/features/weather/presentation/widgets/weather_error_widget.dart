import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class WeatherErrorWidget extends StatefulWidget {
  final String message;

  final VoidCallback? onRetry;

  const WeatherErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  State<WeatherErrorWidget> createState() => _WeatherErrorWidgetState();
}

class _WeatherErrorWidgetState extends State<WeatherErrorWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _iconForMessage(String message) {
    if (message.contains('not found')) return Icons.location_off_rounded;
    if (message.contains('internet') || message.contains('cached')) {
      return Icons.wifi_off_rounded;
    }
    if (message.contains('limit')) return Icons.timer_off_rounded;
    if (message.contains('Server')) return Icons.cloud_off_rounded;
    return Icons.error_outline_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final errorColor = AppColors.errorColor;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: errorColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: errorColor.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    _iconForMessage(widget.message),
                    color: errorColor,
                    size: 36,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  widget.message,
                  style: AppTextStyles.errorMessage(
                    isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the search bar to try again',
                  style: AppTextStyles.statLabel(textSecondary)
                      .copyWith(fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                if (widget.onRetry != null) ...[
                  const SizedBox(height: 28),
                  _RetryButton(
                    onTap: widget.onRetry!,
                    isDark: isDark,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _RetryButton({required this.onTap, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final accent = isDark ? AppColors.darkAccent : AppColors.lightAccent;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [accent, accent.withOpacity(0.7)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              'Try Again',
              style:
                  AppTextStyles.chipLabel(Colors.white).copyWith(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
