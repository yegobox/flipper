import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'challenge_service.dart';
import '../models/models.dart';

// Provider for DittoService from flipper_web
final dittoServiceProvider = Provider<DittoService>((ref) {
  return DittoService.instance;
});

// Provider for ChallengeService
final challengeServiceProvider = Provider<ChallengeService>((ref) {
  final dittoService = ref.watch(dittoServiceProvider);
  return ChallengeService(dittoService);
});

// Provider for available challenge codes stream
final availableChallengeCodesProvider = StreamProvider<List<ChallengeCode>>((
  ref,
) {
  final challengeService = ref.watch(challengeServiceProvider);
  return challengeService.availableChallengeCodes;
});

// Provider for user's claims
final userClaimsProvider = FutureProvider.family<List<Claim>, String>((
  ref,
  userId,
) {
  final challengeService = ref.watch(challengeServiceProvider);
  return challengeService.getClaimsForUser(userId);
});

// Provider for challenge codes of a business
final businessChallengeCodesProvider =
    FutureProvider.family<List<ChallengeCode>, String>((ref, businessId) {
      final challengeService = ref.watch(challengeServiceProvider);
      return challengeService.getChallengeCodesForBusiness(businessId);
    });

// State notifier for managing challenge claiming
class ChallengeClaimNotifier extends StateNotifier<AsyncValue<bool>> {
  final ChallengeService _challengeService;

  ChallengeClaimNotifier(this._challengeService)
    : super(const AsyncValue.data(false));

  Future<void> claimChallenge(String userId, String challengeCodeId) async {
    state = const AsyncValue.loading();
    try {
      final success = await _challengeService.claimChallengeCode(
        userId,
        challengeCodeId,
      );
      state = AsyncValue.data(success);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}

final challengeClaimProvider =
    StateNotifierProvider<ChallengeClaimNotifier, AsyncValue<bool>>((ref) {
      final challengeService = ref.watch(challengeServiceProvider);
      return ChallengeClaimNotifier(challengeService);
    });

// Provider to check if Ditto is ready
final dittoReadyProvider = Provider<bool>((ref) {
  final dittoService = ref.watch(dittoServiceProvider);
  return dittoService.isReady();
});
