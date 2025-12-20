import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'challenge_service.dart';
import 'package:flipper_models/models/challenge_code.dart';
import 'package:flipper_models/models/claim.dart';

part 'providers.g.dart';

// Provider for DittoService from flipper_web
@riverpod
DittoService dittoService(Ref ref) {
  return DittoService.instance;
}

// Provider for ChallengeService
@riverpod
ChallengeService challengeService(Ref ref) {
  final dittoService = ref.watch(dittoServiceProvider);
  return ChallengeService(dittoService);
}

// Provider for available challenge codes stream
@riverpod
Stream<List<ChallengeCode>> availableChallengeCodes(Ref ref) {
  final challengeService = ref.watch(challengeServiceProvider);
  return challengeService.availableChallengeCodes;
}

// Provider for user's claims
@riverpod
Future<List<Claim>> userClaims(Ref ref, String userId) {
  final challengeService = ref.watch(challengeServiceProvider);
  return challengeService.getClaimsForUser(userId);
}

// Provider for challenge codes of a business
@riverpod
Future<List<ChallengeCode>> businessChallengeCodes(Ref ref, String businessId) {
  final challengeService = ref.watch(challengeServiceProvider);
  return challengeService.getChallengeCodesForBusiness(businessId);
}

// State notifier for managing challenge claiming
@riverpod
class ChallengeClaim extends _$ChallengeClaim {
  ChallengeService get _challengeService => ref.watch(challengeServiceProvider);

  @override
  AsyncValue<bool> build() {
    return const AsyncValue.data(false);
  }

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

// Provider to check if Ditto is ready
@riverpod
bool dittoReady(Ref ref) {
  final dittoService = ref.watch(dittoServiceProvider);
  return dittoService.isReady();
}

// Typedef/Aliases for compatibility if needed
typedef ChallengeClaimNotifier = ChallengeClaim;
// challengeClaimProvider is generated.
