import 'dart:async';

import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin ObservationMixin on DittoCore {
  StreamController<List<UserProfile>>? _userProfilesController;

  /// Load and update user profiles
  Future<void> loadAndUpdateUserProfiles() async {
    try {
      // This method will be available from the class that mixes in UserProfileMixin
      final profiles = await getAllUserProfiles();
      _userProfilesController ??= StreamController<List<UserProfile>>.broadcast();
      _userProfilesController!.add(profiles);
    } catch (e) {
      debugPrint('Error updating user profiles: $e');
    }
  }

  /// Method to be implemented by the class using this mixin
  Future<List<UserProfile>> getAllUserProfiles();
}