import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../providers/providers.dart';
import 'challenge_discovery_popup.dart';

/// Widget that displays available challenge codes and handles discovery
class ChallengeDiscoveryWidget extends ConsumerWidget {
  final String userId;

  const ChallengeDiscoveryWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengeCodesAsync = ref.watch(availableChallengeCodesProvider);
    final dittoReady = ref.watch(dittoReadyProvider);

    if (!dittoReady) {
      return const SizedBox.shrink(); // Don't show anything if Ditto isn't ready
    }

    return challengeCodesAsync.when(
      data: (challengeCodes) {
        if (challengeCodes.isEmpty) {
          return const SizedBox.shrink(); // No challenges available
        }

        // Show popup for the first available challenge
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            _showChallengePopup(context, ref, challengeCodes.first);
          }
        });

        return const SizedBox.shrink(); // The popup handles the UI
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) {
        debugPrint('Error loading challenge codes: $error');
        return const SizedBox.shrink();
      },
    );
  }

  void _showChallengePopup(
    BuildContext context,
    WidgetRef ref,
    ChallengeCode challengeCode,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) =>
          ChallengeDiscoveryPopup(challengeCode: challengeCode, userId: userId),
    );
  }
}

/// Widget to display user's claimed rewards
class UserRewardsWidget extends ConsumerWidget {
  final String userId;

  const UserRewardsWidget({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final claimsAsync = ref.watch(userClaimsProvider(userId));

    return claimsAsync.when(
      data: (claims) {
        if (claims.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.card_giftcard, color: Colors.green.shade600),
                    const SizedBox(width: 8),
                    Text(
                      'Your Rewards',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...claims.map((claim) => _buildClaimItem(context, claim)),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Error loading rewards: $error')),
    );
  }

  Widget _buildClaimItem(BuildContext context, Claim claim) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          Icon(
            claim.status == ClaimStatus.claimed
                ? Icons.check_circle
                : Icons.redeem,
            color: Colors.green.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Challenge Claimed',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade800,
                  ),
                ),
                Text(
                  'Claimed on ${_formatDate(claim.claimedAt)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: claim.status == ClaimStatus.claimed
                  ? Colors.blue.shade100
                  : Colors.orange.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              claim.status.name.toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: claim.status == ClaimStatus.claimed
                    ? Colors.blue.shade800
                    : Colors.orange.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
