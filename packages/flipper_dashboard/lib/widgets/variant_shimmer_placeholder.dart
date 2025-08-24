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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.white,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: double.infinity,
              height: 12.0,
              color: Colors.white,
            ),
            const SizedBox(height: 8.0),
            Container(
              width: 100.0,
              height: 12.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}