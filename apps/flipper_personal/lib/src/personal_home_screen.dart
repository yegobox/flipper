import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/challenge_widgets.dart';

/// Duolingo-inspired color palette
class DuoPalette {
  static const Color primaryGreen = Color(0xFF58CC02);
  static const Color darkGreen = Color(0xFF46A302);
  static const Color lightGreen = Color(0xFFE8F5E8);
  static const Color accentBlue = Color(0xFF1CB0F6);
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color textPrimary = Color(0xFF3C3C41);
  static const Color textSecondary = Color(0xFF777777);
  static const Color errorRed = Color(0xFFFF4B4B);
  static const Color warningOrange = Color(0xFFFF9600);
}

/// The main screen for the Flipper Personal app.
/// Re-imagined with Duolingo-inspired playful style, bright colors, rounded shapes, and friendly UX.
class PersonalHomeScreen extends ConsumerStatefulWidget {
  const PersonalHomeScreen({super.key});

  @override
  ConsumerState<PersonalHomeScreen> createState() => _PersonalHomeScreenState();
}

class _PersonalHomeScreenState extends ConsumerState<PersonalHomeScreen> {
  // TODO: Get actual user ID from authentication
  final String currentUserId = 'user-123'; // Placeholder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DuoPalette.backgroundColor,
      appBar: AppBar(
        title: const Text('Flipper Personal'),
        backgroundColor: DuoPalette.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            splashRadius: 24,
            onPressed: () {
              // TODO: Implement manual sync
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: DuoPalette.darkGreen,
                  content: Text('Syncing with nearby businesses...'),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
                  decoration: const BoxDecoration(
                    color: DuoPalette.primaryGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: DuoPalette.lightGreen,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(18),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: DuoPalette.darkGreen,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Welcome to Flipper Personal!',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Discover playful challenges, earn rewards, and have fun while supporting local businesses!',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // User's rewards section (with playful card style)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  child: Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(18),
                    color: DuoPalette.lightGreen,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 10,
                      ),
                      child: UserRewardsWidget(userId: currentUserId),
                    ),
                  ),
                ),

                // Features section
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: DuoPalette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildFeatureCard(
                        icon: Icons.location_on,
                        iconBg: DuoPalette.accentBlue,
                        title: 'Visit Nearby Businesses',
                        description:
                            'Walk in and automatically discover hidden challenges. It’s more fun together!',
                      ),
                      const SizedBox(height: 10),
                      _buildFeatureCard(
                        icon: Icons.celebration,
                        iconBg: DuoPalette.warningOrange,
                        title: 'Claim Instant Rewards',
                        description:
                            'Earn discounts, points, or special badges — all while exploring!',
                      ),
                      const SizedBox(height: 10),
                      _buildFeatureCard(
                        icon: Icons.sync,
                        iconBg: DuoPalette.primaryGreen,
                        title: 'Offline First',
                        description:
                            'No internet? No problem! Sync your rewards when you’re back online.',
                      ),
                    ],
                  ),
                ),

                // Get started button
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 28,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to business discovery or settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: DuoPalette.primaryGreen,
                          content: Text('Start exploring nearby businesses!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DuoPalette.primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 5,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    child: const Text(
                      'Start Exploring',
                      style: TextStyle(color: Colors.white, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Challenge discovery overlay (shows popups when challenges are found)
          ChallengeDiscoveryWidget(userId: currentUserId),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String description,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(14),
              child: Icon(icon, color: iconBg, size: 32),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: DuoPalette.textPrimary,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: TextStyle(
                      color: DuoPalette.textSecondary,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
