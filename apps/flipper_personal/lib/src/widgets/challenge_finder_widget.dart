import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';

/// Enhanced Duolingo-inspired color palette
class FlipperPalette {
  static const Color primaryGreen = Color(0xFF58CC02);
  static const Color darkGreen = Color(0xFF46A302);
  static const Color accentBlue = Color(0xFF1CB0F6);
  static const Color backgroundColor = Color(0xFFF7F7F7);
  static const Color textPrimary = Color(0xFF3C3C41);
  static const Color textSecondary = Color(0xFF777777);
  static const Color errorRed = Color(0xFFFF4B4B);
  static const Color searchingBlue = Color(0xFF4A90E2);
  static const Color successGreen = Color(0xFF50C878);
}

/// Shazam-like animated search button
class ShazamSearchButton extends StatefulWidget {
  final VoidCallback onTap;
  final bool isSearching;

  const ShazamSearchButton({
    super.key,
    required this.onTap,
    this.isSearching = false,
  });

  @override
  State<ShazamSearchButton> createState() => _ShazamSearchButtonState();
}

class _ShazamSearchButtonState extends State<ShazamSearchButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rippleController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(ShazamSearchButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSearching && !oldWidget.isSearching) {
      _rippleController.repeat();
    } else if (!widget.isSearching && oldWidget.isSearching) {
      _rippleController.stop();
      _rippleController.reset();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseAnimation, _rippleAnimation]),
        builder: (context, child) {
          return Container(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer ripple effect when searching
                if (widget.isSearching) ...[
                  Container(
                    width: 120 + (_rippleAnimation.value * 60),
                    height: 120 + (_rippleAnimation.value * 60),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: FlipperPalette.searchingBlue.withValues(
                          alpha: 0.3 * (1 - _rippleAnimation.value),
                        ),
                        width: 2,
                      ),
                    ),
                  ),
                ],
                // Main button
                Transform.scale(
                  scale: widget.isSearching ? 1.0 : _pulseAnimation.value,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: widget.isSearching
                            ? [
                                FlipperPalette.searchingBlue,
                                FlipperPalette.searchingBlue.withValues(
                                  alpha: 0.8,
                                ),
                              ]
                            : [
                                FlipperPalette.accentBlue,
                                FlipperPalette.primaryGreen,
                              ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.isSearching
                              ? FlipperPalette.searchingBlue.withValues(
                                  alpha: 0.3,
                                )
                              : FlipperPalette.accentBlue.withValues(
                                  alpha: 0.3,
                                ),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.isSearching ? Icons.search : Icons.radar,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                // Inner pulse dot when searching
                if (widget.isSearching)
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Enhanced Challenge Card with animations
class AnimatedChallengeCard extends StatefulWidget {
  final ChallengeCode challenge;
  final VoidCallback onClaim;
  final int index;

  const AnimatedChallengeCard({
    super.key,
    required this.challenge,
    required this.onClaim,
    required this.index,
  });

  @override
  State<AnimatedChallengeCard> createState() => _AnimatedChallengeCardState();
}

class _AnimatedChallengeCardState extends State<AnimatedChallengeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300 + (widget.index * 100)),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
        );

    // Start animation after a delay
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _slideController.forward();
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, FlipperPalette.backgroundColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: FlipperPalette.accentBlue.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: FlipperPalette.accentBlue.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.location_on_outlined,
                color: FlipperPalette.accentBlue,
                size: 24,
              ),
            ),
            title: Text(
              'Business: ${widget.challenge.businessId}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      size: 16,
                      color: FlipperPalette.primaryGreen,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Reward: ${widget.challenge.reward?.value ?? 'Special reward'}',
                      style: TextStyle(
                        color: FlipperPalette.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: widget.onClaim,
              style: ElevatedButton.styleFrom(
                backgroundColor: FlipperPalette.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 16),
                  SizedBox(width: 4),
                  Text('Claim'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget responsible for finding and displaying nearby challenges with Shazam-like UI
class ChallengeFinderWidget extends ConsumerStatefulWidget {
  final String userId;

  const ChallengeFinderWidget({super.key, required this.userId});

  @override
  ConsumerState<ChallengeFinderWidget> createState() =>
      ChallengeFinderWidgetState();
}

class ChallengeFinderWidgetState extends ConsumerState<ChallengeFinderWidget>
    with TickerProviderStateMixin {
  bool _isSearching = false;
  late AnimationController _searchController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Shazam-like search button
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(_isSearching ? 40 : 20),
          child: Column(
            children: [
              ShazamSearchButton(
                onTap: () {
                  findNearbyChallenges();
                },
                isSearching: _isSearching,
              ),
              const SizedBox(height: 16),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isSearching
                    ? Column(
                        key: const ValueKey('searching'),
                        children: [
                          Text(
                            'Searching for nearby challenges...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: FlipperPalette.searchingBlue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            backgroundColor: FlipperPalette.searchingBlue
                                .withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              FlipperPalette.searchingBlue,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        key: const ValueKey('idle'),
                        'Tap to discover challenges nearby',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: FlipperPalette.textSecondary,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Finds nearby challenges with Shazam-like experience
  Future<void> findNearbyChallenges() async {
    if (_isSearching) return;

    setState(() {
      _isSearching = true;
    });

    // Haptic feedback
    HapticFeedback.mediumImpact();

    try {
      // Simulate realistic search time
      await Future.delayed(const Duration(milliseconds: 800));

      // Force a sync to find nearby challenges
      final challengeService = ref.read(challengeServiceProvider);
      challengeService.forceSync();

      // Wait for sync to complete
      await Future.delayed(const Duration(milliseconds: 1200));

      // Get available challenges
      final availableChallenges = await ref.read(
        availableChallengeCodesProvider.future,
      );

      setState(() {
        _isSearching = false;
      });

      if (availableChallenges.isEmpty) {
        if (context.mounted) {
          HapticFeedback.lightImpact();
          _showActionFeedback(
            'No challenges found nearby. Try moving around!',
            isError: true,
          );
        }
        return;
      }

      // Success haptic
      HapticFeedback.heavyImpact();

      // Show challenge selection dialog with animation
      if (context.mounted) {
        _showEnhancedChallengeDialog(availableChallenges);
      }
    } catch (e) {
      setState(() {
        _isSearching = false;
      });

      if (context.mounted) {
        HapticFeedback.heavyImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FlipperPalette.errorRed,
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Error finding challenges: $e')),
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

  void _showEnhancedChallengeDialog(List<ChallengeCode> challenges) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 600),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, FlipperPalette.backgroundColor],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      FlipperPalette.accentBlue,
                      FlipperPalette.primaryGreen,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.celebration, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Challenges Found!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${challenges.length} nearby rewards',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Challenges list
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  itemCount: challenges.length,
                  itemBuilder: (context, index) {
                    final challenge = challenges[index];
                    return AnimatedChallengeCard(
                      challenge: challenge,
                      onClaim: () => _claimChallenge(challenge),
                      index: index,
                    );
                  },
                ),
              ),
              // Bottom action
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: FlipperPalette.textPrimary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _claimChallenge(ChallengeCode challenge) async {
    // Haptic feedback
    HapticFeedback.mediumImpact();

    try {
      final claimNotifier = ref.read(challengeClaimProvider.notifier);
      await claimNotifier.claimChallenge(widget.userId, challenge.id);

      if (context.mounted) {
        Navigator.of(context).pop(); // Close the dialog
        HapticFeedback.heavyImpact(); // Success haptic
        _showActionFeedback('Challenge claimed successfully! 🎉');
      }
    } catch (e) {
      if (context.mounted) {
        HapticFeedback.heavyImpact(); // Error haptic
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: FlipperPalette.errorRed,
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text('Failed to claim challenge: $e')),
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

  void _showActionFeedback(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError
            ? FlipperPalette.errorRed
            : FlipperPalette.successGreen,
        content: Row(
          children: [
            Icon(
              isError ? Icons.warning_amber : Icons.celebration,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white70,
          onPressed: () {},
        ),
      ),
    );
  }
}
