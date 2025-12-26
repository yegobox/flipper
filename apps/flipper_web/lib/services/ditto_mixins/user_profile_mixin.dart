import 'dart:async';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flutter/foundation.dart';
import 'ditto_core_mixin.dart';

mixin UserProfileMixin on DittoCore {
  StreamController<List<UserProfile>>? _userProfilesController;

  Stream<List<UserProfile>> get userProfiles {
    _userProfilesController ??= StreamController<List<UserProfile>>.broadcast();
    return _userProfilesController!.stream;
  }

  /// Save user profile to Ditto
  Future<void> saveUserProfile(UserProfile userProfile) async {
    if (dittoInstance == null) return handleNotInitialized('saveUserProfile');
    final docId = userProfile.id.toString();
    await executeUpsert('users', docId, userProfile.toJson());
    debugPrint('Saved user profile with ID: ${userProfile.id}');
  }

  /// Update an existing user profile in Ditto
  Future<void> updateUserProfile(UserProfile userProfile) async {
    if (dittoInstance == null) return handleNotInitialized('updateUserProfile');
    final docId = userProfile.id.toString();
    await executeUpdate('users', docId, userProfile.toJson());
    debugPrint('Successfully updated user profile with ID: ${userProfile.id}');
  }

  /// Get user profile by ID from Ditto
  Future<UserProfile?> getUserProfile(String id) async {
    if (dittoInstance == null) return handleNotInitializedAndReturn('getUserProfile', null);
    final result = await dittoInstance!.store.execute(
      "SELECT * FROM users WHERE _id = :id",
      arguments: {"id": id},
    );
    if (result.items.isEmpty) return null;
    return UserProfile.fromJson(
      Map<String, dynamic>.from(result.items.first.value),
      id: id,
    );
  }

  /// Get all user profiles from Ditto
  Future<List<UserProfile>> getAllUserProfiles() async {
    if (dittoInstance == null) return handleNotInitializedAndReturn('getAllUserProfiles', []);
    final result = await dittoInstance!.store.execute("SELECT * FROM users");
    return result.items
        .map((doc) => _parseUserProfile(doc.value))
        .whereType<UserProfile>()
        .toList();
  }

  /// Delete user profile by ID from Ditto
  Future<void> deleteUserProfile(String id) async {
    if (dittoInstance == null) return handleNotInitialized('deleteUserProfile');
    await dittoInstance!.store.execute(
      "EVICT FROM users WHERE _id = :id",
      arguments: {"id": id},
    );
    debugPrint('Deleted user profile with ID: $id');
  }

  /// Helper method to parse user profile from document
  UserProfile? _parseUserProfile(dynamic value) {
    try {
      return UserProfile.fromJson(Map<String, dynamic>.from(value));
    } catch (e) {
      debugPrint('Error parsing user profile document: $e');
      return null;
    }
  }
}