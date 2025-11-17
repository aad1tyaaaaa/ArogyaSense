// features/health_data/view/health_data_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HealthDataShimmer extends StatelessWidget {
  const HealthDataShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 600,
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: List.generate(5, (_) => const _MetricShimmerCard()),
        ),
      ),
    );
  }
}

class _MetricShimmerCard extends StatelessWidget {
  const _MetricShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 12),
              Container(width: 60, height: 20, color: Colors.grey),
              const SizedBox(height: 6),
              Container(width: 40, height: 12, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
