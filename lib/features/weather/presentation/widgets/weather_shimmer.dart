import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/shimmer_box.dart';

class WeatherShimmer extends StatelessWidget {
  const WeatherShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.shimmerBaseDark : AppColors.shimmerBaseLight;
    final highlightColor = isDark
        ? AppColors.shimmerHighlightDark
        : AppColors.shimmerHighlightLight;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color:
              isDark ? AppColors.darkGlassBorder : AppColors.lightGlassBorder,
        ),
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(
                      width: 180,
                      height: 26,
                      baseColor: baseColor,
                      highlightColor: highlightColor),
                  const SizedBox(height: 8),
                  ShimmerBox(
                      width: 80,
                      height: 14,
                      baseColor: baseColor,
                      highlightColor: highlightColor),
                ],
              ),
              ShimmerBox(
                width: 64,
                height: 64,
                baseColor: baseColor,
                highlightColor: highlightColor,
                borderRadius: BorderRadius.circular(32),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ShimmerBox(
              width: 120,
              height: 72,
              baseColor: baseColor,
              highlightColor: highlightColor),
          const SizedBox(height: 12),
          ShimmerBox(
              width: 160,
              height: 18,
              baseColor: baseColor,
              highlightColor: highlightColor),
          const SizedBox(height: 32),
          ShimmerBox(
            width: double.infinity,
            height: 1,
            baseColor: baseColor,
            highlightColor: highlightColor,
            borderRadius: BorderRadius.zero,
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              3,
              (_) => Column(
                children: [
                  ShimmerBox(
                    width: 20,
                    height: 20,
                    baseColor: baseColor,
                    highlightColor: highlightColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  const SizedBox(height: 8),
                  ShimmerBox(
                      width: 56,
                      height: 16,
                      baseColor: baseColor,
                      highlightColor: highlightColor),
                  const SizedBox(height: 6),
                  ShimmerBox(
                      width: 48,
                      height: 12,
                      baseColor: baseColor,
                      highlightColor: highlightColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
