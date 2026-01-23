// ignore_for_file: invalid_use_of_visible_for_testing_member
import 'dart:async';

import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ditto_mixins/ditto_core_mixin.dart';
import 'ditto_mixins/user_profile_mixin.dart';
import 'ditto_mixins/business_mixin.dart';
import 'ditto_mixins/branch_mixin.dart';
import 'ditto_mixins/tenant_mixin.dart';
import 'ditto_mixins/event_mixin.dart';
import 'ditto_mixins/challenge_code_mixin.dart';
import 'ditto_mixins/claim_mixin.dart';
import 'ditto_mixins/sync_mixin.dart';
import 'ditto_mixins/observation_mixin.dart';
import 'ditto_mixins/user_access_mixin.dart';

// Global singleton instance of DittoService
final DittoService _dittoServiceInstance = DittoService._internal();

/// Provider for the DittoService singleton
final dittoServiceProvider = Provider<DittoService>((ref) {
  return _dittoServiceInstance;
});

/// Provider for Ditto sync control
final dittoSyncProvider = Provider<DittoSyncController>((ref) {
  return DittoSyncController();
});

class DittoSyncController {
  /// Starts Ditto sync
  void startSync() {
    DittoService.instance.startSync();
  }

  /// Stops Ditto sync
  void stopSync() {
    DittoService.instance.stopSync();
  }

  /// Checks if Ditto is ready for sync operations
  bool isReady() {
    return DittoService.instance.isReady();
  }
}

/// Simplified DittoService that manages a single Ditto instance
/// initialized once at app startup
class DittoService extends DittoCore
    with
        UserProfileMixin,
        BusinessMixin,
        BranchMixin,
        TenantMixin,
        EventMixin,
        ChallengeCodeMixin,
        ClaimMixin,
        SyncMixin,
        ObservationMixin,
        UserAccessMixin {
  // Private constructor for singleton implementation
  DittoService._internal();

  // Factory constructor that returns the singleton instance
  factory DittoService() {
    return _dittoServiceInstance;
  }

  /// Static accessor for the singleton instance
  static DittoService get instance {
    return _dittoServiceInstance;
  }

  /// Sets the Ditto instance and configures sync functionality
  @override
  void setDitto(Ditto ditto) {
    super.setDitto(ditto); // This calls DittoCore's setDitto
    setupDittoWithSync(ditto); // This calls SyncMixin's functionality
  }

  /// Reset the service state (useful for hot restart scenarios)
  static Future<void> resetInstance() async {
    debugPrint('🔄 Resetting DittoService instance...');
    await _dittoServiceInstance.dispose();
    debugPrint('✅ DittoService instance reset completed');
  }
}
