// features/sharing/view/family_shimmer.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class FamilyShimmer extends StatelessWidget {
  const FamilyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) => const _FamilyMemberShimmerCard(),
      ),
    );
  }
}

class _FamilyMemberShimmerCard extends StatelessWidget {
  const _FamilyMemberShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 80, height: 16, color: Colors.grey),
                    const SizedBox(height: 8),
                    Container(width: 120, height: 12, color: Colors.grey),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(width: 60, height: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
