import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../config/theme_config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryColor,
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.bgLightPink,
      highlightColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.bgLightPink,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.radiusMedium),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 14,
                      color: AppColors.bgLightPink,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 10,
                      width: double.infinity * 0.6,
                      color: AppColors.bgLightPink,
                    ),
                    const Spacer(),
                    Container(
                      height: 16,
                      width: 80,
                      color: AppColors.bgLightPink,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
