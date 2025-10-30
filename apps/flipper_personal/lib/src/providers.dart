import 'package:flipper_personal/src/providers/location_service.dart';
import 'package:flipper_personal/src/services/ditto_service.dart';
import 'package:flipper_models/models/challenge_code.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

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

final challengeFinderProvider =
    StateNotifierProvider<
      ChallengeFinderNotifier,
      AsyncValue<List<ChallengeCode>>
    >((ref) {
      return ChallengeFinderNotifier(ref);
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

class ChallengeFinderNotifier
    extends StateNotifier<AsyncValue<List<ChallengeCode>>> {
  final Ref ref;

  ChallengeFinderNotifier(this.ref) : super(const AsyncValue.data([]));

  Future<void> findNearbyChallenges() async {
    state = const AsyncValue.loading();

    try {
      // Get current location
      final locationService = ref.read(locationServiceProvider);
      final position = await locationService.getCurrentPosition();

      if (position == null) {
        state = AsyncValue.error(
          'Could not determine your location.',
          StackTrace.current,
        );
        return;
      }

      // Get business ID from local storage
      final businessId = ProxyService.box.getBusinessId();
      if (businessId == null) {
        state = AsyncValue.error(
          'Business ID not found. Please login again.',
          StackTrace.current,
        );
        return;
      }

      // Make API call to fetch nearby challenges
      final url =
          'https://apihub.yegobox.com/v2/api/challenge-codes/business/$businessId/nearby?latitude=${position.latitude}&longitude=${position.longitude}&maxDistance=10';

      final response = await ProxyService.http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['success'] == true) {
          final challengeCodesJson =
              jsonResponse['challengeCodes'] as List<dynamic>;
          final challenges = challengeCodesJson
              .map((json) => ChallengeCode.fromJson(json))
              .toList();

          state = AsyncValue.data(challenges);
        } else {
          state = AsyncValue.error(
            jsonResponse['message'] ?? 'Failed to fetch challenges',
            StackTrace.current,
          );
        }
      } else {
        state = AsyncValue.error(
          'Failed to fetch challenges. Please try again.',
          StackTrace.current,
        );
      }
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }

  void reset() {
    state = const AsyncValue.data([]);
  }
}
