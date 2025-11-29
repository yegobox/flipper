import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class VariantShimmerPlaceholder extends StatelessWidget {
  const VariantShimmerPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        // Reduce the duration to make shimmering less resource intensive
        period: const Duration(milliseconds: 1500),
        child: Container(
          width: double.infinity,
          height: 120.0, // Fixed height to prevent layout shifts
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}