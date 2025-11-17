// features/info_centre/view/info_centre_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class InfoCentreShimmer extends StatelessWidget {
  const InfoCentreShimmer({super.key});

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
          children: List.generate(6, (_) => const _TopicShimmerCard()),
        ),
      ),
    );
  }
}

class _TopicShimmerCard extends StatelessWidget {
  const _TopicShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              Container(width: 80, height: 16, color: Colors.grey),
              const SizedBox(height: 8),
              Container(width: double.infinity, height: 10, color: Colors.grey),
              const SizedBox(height: 4),
              Container(width: double.infinity, height: 10, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
