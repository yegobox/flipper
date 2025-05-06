import 'package:flutter/material.dart';
import 'credit_icon_widget.dart';

class CreditDisplay extends StatelessWidget {
  final int credits;
  final int maxCredits;
  final ColorScheme colorScheme;

  const CreditDisplay({
    Key? key,
    required this.credits,
    required this.maxCredits,
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLightMode = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            isLightMode
                ? const Color(0xFF0078D4) // Microsoft blue
                : const Color(0xFF104E8B), // Dark blue
            isLightMode
                ? const Color(0xFF2B88D8) // Lighter blue
                : const Color(0xFF1A6BB2), // Medium blue
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isLightMode
                ? Colors.black.withOpacity(0.1)
                : Colors.black.withOpacity(0.3),
            offset: const Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Available Credits',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              CreditIconWidget(
                credits: credits,
                maxCredits: maxCredits,
                size: 60,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text(
                '$credits',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Credits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: credits / maxCredits,
              backgroundColor: Colors.white.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                credits / maxCredits > 0.5
                    ? Colors.greenAccent
                    : credits / maxCredits > 0.2
                        ? Colors.amberAccent
                        : Colors.redAccent,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Maximum: $maxCredits',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
