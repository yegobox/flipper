import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'widgets/challenge_widgets.dart';
import 'widgets/challenge_finder_widget.dart';

/// Enhanced Duolingo-inspired color palette
class FlipperPalette {
  static const Color primaryGreen = Color(0xFF58CC02);
  static const Color darkGreen = Color(0xFF46A302);
  static const Color lightGreen = Color(0xFFE8F5E8);
  static const Color accentBlue = Color(0xFF1CB0F6);
  static const Color darkBlue = Color(0xFF1899D6);
  static const Color lightBlue = Color(0xFFE6F7FF);
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color textPrimary = Color(0xFF3C3C41);
  static const Color textSecondary = Color(0xFF777777);
  static const Color errorRed = Color(0xFFFF4B4B);
  static const Color warningOrange = Color(0xFFFF9600);
  static const Color streakOrange = Color(0xFFFF9600);
  static const Color gemPurple = Color(0xFF8E44AD);
  static const Color xpGold = Color(0xFFFFC107);
  static const Color cardWhite = Color(0xFFFFFFFF);
}

/// The main screen for the Flipper Personal app.
/// Fully re-imagined with Duolingo-style gamification, streaks, XP, and achievements.
class PersonalHomeScreen extends ConsumerStatefulWidget {
  const PersonalHomeScreen({super.key});

  @override
  ConsumerState<PersonalHomeScreen> createState() => _PersonalHomeScreenState();
}

class _PersonalHomeScreenState extends ConsumerState<PersonalHomeScreen>
    with TickerProviderStateMixin, CoreMiscellaneous {
  final String currentUserId = 'user-123';

  // Mock user data (in real app, this would come from state management)
  int userXP = 1250;
  int currentStreak = 7;
  int totalGems = 45;
  int completedChallenges = 23;
  bool hasActiveStreak = true;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Opens the challenge finder experience inside a modal sheet
  Future<void> _openChallengeFinder() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) =>
          _ChallengeFinderBottomSheet(userId: currentUserId),
    );
  }

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlipperPalette.backgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Custom app bar with user stats
              SliverAppBar(
                expandedHeight: 280,
                floating: false,
                pinned: true,
                backgroundColor: FlipperPalette.primaryGreen,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          FlipperPalette.primaryGreen,
                          FlipperPalette.darkGreen,
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Top stats bar
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    Icons.local_fire_department,
                                    '$currentStreak',
                                    FlipperPalette.streakOrange,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildStatItem(
                                    Icons.diamond,
                                    '$totalGems',
                                    FlipperPalette.gemPurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _buildStatItem(
                                    Icons.stars,
                                    '${userXP}XP',
                                    FlipperPalette.xpGold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Character/Avatar with pulse animation
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _pulseAnimation.value,
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 20,
                                          offset: const Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: FlipperPalette.primaryGreen,
                                    ),
                                  ),
                                );
                              },
                            ),

                            const SizedBox(height: 12),
                            Text(
                              'Ready for adventure?',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            if (hasActiveStreak)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: FlipperPalette.streakOrange,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.local_fire_department,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '$currentStreak day streak!',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.sync, color: Colors.white),
                    onPressed: () => _showSyncFeedback(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _showLogoutDialog(),
                  ),
                ],
              ),

              // Main content
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 24),

                    // Progress section
                    _buildProgressSection(),

                    const SizedBox(height: 24),

                    // Quick actions
                    _buildQuickActions(),

                    const SizedBox(height: 24),

                    // Achievement badges
                    _buildAchievementSection(),

                    const SizedBox(height: 24),

                    // How it works (gamified)
                    _buildGameifiedFeatures(),

                    const SizedBox(height: 32),

                    // Call to action
                    _buildCTAButton(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
          // Challenge discovery overlay
          ChallengeDiscoveryWidget(userId: currentUserId),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: FlipperPalette.cardWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today\'s Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: FlipperPalette.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: FlipperPalette.lightGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '3/5 completed',
                    style: TextStyle(
                      color: FlipperPalette.darkGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // XP Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'XP Progress',
                      style: TextStyle(
                        color: FlipperPalette.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '+50 XP today',
                      style: TextStyle(
                        color: FlipperPalette.xpGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: FlipperPalette.lightGreen,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlipperPalette.primaryGreen,
                  ),
                  minHeight: 8,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FlipperPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildActionCard(
                'Find\nChallenges',
                Icons.search,
                FlipperPalette.accentBlue,
                () => _openChallengeFinder(),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'View\nRewards',
                  Icons.card_giftcard,
                  FlipperPalette.warningOrange,
                  () => _showActionFeedback('Opening your rewards!'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  'Leaderboard',
                  Icons.leaderboard,
                  FlipperPalette.gemPurple,
                  () => _showActionFeedback('Loading leaderboard!'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Achievements',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: FlipperPalette.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () =>
                    _showActionFeedback('Opening all achievements!'),
                child: Text(
                  'View all',
                  style: TextStyle(color: FlipperPalette.accentBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildAchievementBadge(
                  'First Steps',
                  Icons.directions_walk,
                  FlipperPalette.primaryGreen,
                  true,
                ),
                _buildAchievementBadge(
                  'Explorer',
                  Icons.explore,
                  FlipperPalette.accentBlue,
                  true,
                ),
                _buildAchievementBadge(
                  'Streak Master',
                  Icons.local_fire_department,
                  FlipperPalette.streakOrange,
                  true,
                ),
                _buildAchievementBadge(
                  'Social Star',
                  Icons.people,
                  FlipperPalette.gemPurple,
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementBadge(
    String title,
    IconData icon,
    Color color,
    bool isUnlocked,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: isUnlocked ? color : Colors.grey.withValues(alpha: 0.3),
              shape: BoxShape.circle,
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ]
                  : [],
            ),
            child: Icon(
              icon,
              color: isUnlocked ? Colors.white : Colors.grey,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isUnlocked ? FlipperPalette.textPrimary : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGameifiedFeatures() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How to Level Up',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: FlipperPalette.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildGameFeatureCard(
            icon: Icons.location_on,
            iconBg: FlipperPalette.accentBlue,
            title: 'Discover Hidden Quests',
            description:
                'Visit local businesses to unlock secret challenges and earn bonus XP!',
            xpReward: '+25 XP',
          ),
          const SizedBox(height: 12),
          _buildGameFeatureCard(
            icon: Icons.emoji_events,
            iconBg: FlipperPalette.xpGold,
            title: 'Complete Daily Challenges',
            description:
                'Maintain your streak and climb the leaderboard with friends!',
            xpReward: '+50 XP',
          ),
          const SizedBox(height: 12),
          _buildGameFeatureCard(
            icon: Icons.group,
            iconBg: FlipperPalette.gemPurple,
            title: 'Team Up with Friends',
            description:
                'Join forces for group challenges and earn multiplier bonuses!',
            xpReward: '+75 XP',
          ),
        ],
      ),
    );
  }

  Widget _buildGameFeatureCard({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String description,
    required String xpReward,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: FlipperPalette.cardWhite,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: iconBg.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: Icon(icon, color: iconBg, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: FlipperPalette.textPrimary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: FlipperPalette.xpGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        xpReward,
                        style: TextStyle(
                          color: FlipperPalette.xpGold,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    color: FlipperPalette.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [FlipperPalette.primaryGreen, FlipperPalette.darkGreen],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: FlipperPalette.primaryGreen.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: () => _showActionFeedback('Let the adventure begin! 🚀'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.rocket_launch, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              const Text(
                'Start Your Adventure!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSyncFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: FlipperPalette.accentBlue,
        content: const Row(
          children: [
            Icon(Icons.sync, color: Colors.white),
            SizedBox(width: 12),
            Text('Syncing with nearby adventures...'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: FlipperPalette.errorRed, size: 28),
              const SizedBox(width: 12),
              const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: FlipperPalette.textPrimary, fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: FlipperPalette.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                await _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: FlipperPalette.errorRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _performLogout() async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: FlipperPalette.accentBlue,
          content: const Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 12),
              Text('Logging out...'),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          duration: const Duration(seconds: 2),
        ),
      );

      // Use the shared logout from Miscellaneous mixin
      await logOut();

      // Navigate to login/landing by popping all routes to root
      if (mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FlipperPalette.primaryGreen,
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 12),
                Text('Successfully logged out!'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FlipperPalette.errorRed,
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Logout failed: ${e.toString()}')),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }

  void _showActionFeedback(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: FlipperPalette.primaryGreen,
        content: Row(
          children: [
            const Icon(Icons.celebration, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

class _ChallengeFinderBottomSheet extends StatelessWidget {
  final String userId;

  const _ChallengeFinderBottomSheet({required this.userId});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPadding),
        child: Container(
          decoration: BoxDecoration(
            color: FlipperPalette.cardWhite,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: FlipperPalette.textSecondary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Find nearby challenges',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: FlipperPalette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Tap the radar to scan and claim rewards around you.',
                            style: TextStyle(
                              fontSize: 14,
                              color: FlipperPalette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: ChallengeFinderWidget(userId: userId),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
