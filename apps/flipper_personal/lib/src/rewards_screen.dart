import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flipper_personal/src/personal_home_screen.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.flipperL10n.personalYourRewards),
        backgroundColor: FlipperPalette.primaryGreen,
        elevation: 0,
      ),
      backgroundColor: FlipperPalette.backgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildRewardCard(
            context,
            context.flipperL10n.personalRewardFreeCoffee,
            context.flipperL10n.personalRewardFreeCoffeeBody,
            Icons.coffee,
            FlipperPalette.accentBlue,
          ),
          const SizedBox(height: 16),
          _buildRewardCard(
            context,
            context.flipperL10n.personalRewardDiscount,
            context.flipperL10n.personalRewardDiscountBody,
            Icons.local_offer,
            FlipperPalette.warningOrange,
          ),
          const SizedBox(height: 16),
          _buildRewardCard(
            context,
            context.flipperL10n.personalRewardEarlyAccess,
            context.flipperL10n.personalRewardEarlyAccessBody,
            Icons.star,
            FlipperPalette.gemPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: FlipperPalette.cardWhite,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: FlipperPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: FlipperPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
