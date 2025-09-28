import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'location_service.dart';
import '../models/models.dart';

/// Service for managing challenge codes and claims with Ditto
class ChallengeService {
  final DittoService _dittoService;
  final LocationService _locationService;
  Timer? _syncTimer;
  StreamSubscription? _locationSubscription;

  ChallengeService(this._dittoService) : _locationService = LocationService() {
    _initializeCollections();
    _startPeriodicSync();
    _startLocationMonitoring();
  }

  /// Initialize Ditto collections for challenge codes and claims
  void _initializeCollections() {
    // Collections are automatically created when we insert documents
    // This method ensures we're ready to work with them
    debugPrint('ChallengeService: Collections initialized');
  }

  /// Start periodic sync to ensure data is up to date
  void _startPeriodicSync() {
    // Sync every 30 seconds to check for nearby challenges
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (_dittoService.isReady()) {
        _dittoService.startSync();
        debugPrint('ChallengeService: Periodic sync triggered');
      }
    });
  }

  /// Stream of available challenge codes (nearby and valid)
  Stream<List<ChallengeCode>> get availableChallengeCodes {
    if (!_dittoService.isReady()) {
      return Stream.value([]);
    }

    return _dittoService.observeChallengeCodes().asyncMap((
      challengeMaps,
    ) async {
      final codes = challengeMaps
          .map((doc) {
            try {
              final code = ChallengeCode.fromJson(doc);
              return code;
            } catch (e) {
              debugPrint('Error parsing challenge code: $e');
              return null;
            }
          })
          .whereType<ChallengeCode>()
          .toList();

      // Filter by proximity
      final nearbyCodes = <ChallengeCode>[];
      for (final code in codes) {
        if (await _isChallengeCodeAvailable(code)) {
          nearbyCodes.add(code);
        }
      }

      return nearbyCodes;
    });
  }

  /// Check if a challenge code is available (valid and meets proximity requirements)
  Future<bool> _isChallengeCodeAvailable(ChallengeCode code) async {
    // Check time validity
    if (!code.isValid) return false;

    // Check location proximity if location constraint exists
    if (code.location != null) {
      return await _locationService.isWithinRange(code);
    }

    return true;
  }

  /// Get all claims for a specific user
  Future<List<Claim>> getClaimsForUser(String userId) async {
    try {
      if (!_dittoService.isReady()) {
        debugPrint('Ditto not initialized, cannot get claims');
        return [];
      }

      final claimMaps = await _dittoService.getClaimsForUser(userId);

      return claimMaps
          .map((doc) {
            try {
              return Claim.fromJson(doc);
            } catch (e) {
              debugPrint('Error parsing claim: $e');
              return null;
            }
          })
          .whereType<Claim>()
          .toList();
    } catch (e) {
      debugPrint('Error getting claims for user $userId: $e');
      return [];
    }
  }

  /// Save a challenge code to Ditto (typically done by businesses)
  Future<void> saveChallengeCode(ChallengeCode challengeCode) async {
    try {
      if (!_dittoService.isReady()) {
        debugPrint('Ditto not initialized, cannot save challenge code');
        return;
      }

      await _dittoService.saveChallengeCode(challengeCode.toJson());
    } catch (e) {
      debugPrint('Error saving challenge code to Ditto: $e');
    }
  }

  /// Claim a challenge code for a user
  Future<bool> claimChallengeCode(String userId, String challengeCodeId) async {
    try {
      if (!_dittoService.isReady()) {
        debugPrint('Ditto not initialized, cannot claim challenge code');
        return false;
      }

      // Check if already claimed
      final alreadyClaimed = await _dittoService.isChallengeCodeClaimed(
        userId,
        challengeCodeId,
      );
      if (alreadyClaimed) {
        debugPrint('Challenge code already claimed by user');
        return false;
      }

      // Create new claim
      final claim = Claim(
        userId: userId,
        challengeCodeId: challengeCodeId,
        claimedAt: DateTime.now(),
        status: ClaimStatus.claimed,
      );

      await _dittoService.saveClaim(claim.toJson());

      debugPrint('Successfully claimed challenge code: $challengeCodeId');
      return true;
    } catch (e) {
      debugPrint('Error claiming challenge code: $e');
      return false;
    }
  }

  /// Get challenge codes for a specific business
  Future<List<ChallengeCode>> getChallengeCodesForBusiness(
    String businessId,
  ) async {
    try {
      if (!_dittoService.isReady()) {
        debugPrint('Ditto not initialized, cannot get challenge codes');
        return [];
      }

      final challengeMaps = await _dittoService.getChallengeCodes(
        businessId: businessId,
      );

      return challengeMaps
          .map((doc) {
            try {
              return ChallengeCode.fromJson(doc);
            } catch (e) {
              debugPrint('Error parsing challenge code: $e');
              return null;
            }
          })
          .whereType<ChallengeCode>()
          .toList();
    } catch (e) {
      debugPrint('Error getting challenge codes for business $businessId: $e');
      return [];
    }
  }

  /// Force a sync operation
  void forceSync() {
    if (_dittoService.isReady()) {
      _dittoService.startSync();
      debugPrint('ChallengeService: Forced sync triggered');
    }
  }

  /// Start location monitoring for proximity detection
  void _startLocationMonitoring() {
    _locationSubscription = _locationService.startLocationMonitoring().listen(
      (position) {
        debugPrint(
          'Location updated: ${position.latitude}, ${position.longitude}',
        );
        // Force a sync when location changes significantly
        forceSync();
      },
      onError: (error) {
        debugPrint('Location monitoring error: $error');
      },
    );
  }

  /// Dispose of resources
  void dispose() {
    _syncTimer?.cancel();
    _locationSubscription?.cancel();
    debugPrint('ChallengeService: Disposed');
  }
}
