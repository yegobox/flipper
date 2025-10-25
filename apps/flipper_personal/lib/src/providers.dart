import 'package:flipper_personal/src/providers/location_service.dart';
import 'package:flipper_personal/src/services/ditto_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

final challengeServiceProvider = Provider<DittoService>((ref) {
  return DittoService();
});

final challengeClaimProvider =
    StateNotifierProvider<ChallengeClaimNotifier, AsyncValue<bool>>((ref) {
      return ChallengeClaimNotifier();
    });

class ChallengeClaimNotifier extends StateNotifier<AsyncValue<bool>> {
  ChallengeClaimNotifier() : super(const AsyncValue.data(false));

  Future<void> claimChallenge(String userId, String challengeId) async {
    state = const AsyncValue.loading();
    try {
      // Simulate network request
      await Future.delayed(const Duration(seconds: 2));
      state = const AsyncValue.data(true);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
