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
    if (dittoInstance == null) return _handleNotInitialized('saveUserProfile');
    final docId = userProfile.id.toString();
    await _executeUpsert('users', docId, userProfile.toJson());
    debugPrint('Saved user profile with ID: ${userProfile.id}');
  }

  /// Update an existing user profile in Ditto
  Future<void> updateUserProfile(UserProfile userProfile) async {
    if (dittoInstance == null) return _handleNotInitialized('updateUserProfile');
    final docId = userProfile.id.toString();
    await _executeUpdate('users', docId, userProfile.toJson());
    debugPrint('Successfully updated user profile with ID: ${userProfile.id}');
  }

  /// Get user profile by ID from Ditto
  Future<UserProfile?> getUserProfile(String id) async {
    if (dittoInstance == null) return _handleNotInitializedAndReturn('getUserProfile', null);
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
    if (dittoInstance == null) return _handleNotInitializedAndReturn('getAllUserProfiles', []);
    final result = await dittoInstance!.store.execute("SELECT * FROM users");
    return result.items
        .map((doc) => _parseUserProfile(doc.value))
        .whereType<UserProfile>()
        .toList();
  }

  /// Delete user profile by ID from Ditto
  Future<void> deleteUserProfile(String id) async {
    if (dittoInstance == null) return _handleNotInitialized('deleteUserProfile');
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

  /// Helper method to handle not initialized case
  void _handleNotInitialized(String methodName) {
    debugPrint('Ditto not initialized, cannot $methodName');
    if (kDebugMode) debugPrint('❌ Ditto instance is null');
  }

  /// Helper method to handle not initialized case and return a value
  T _handleNotInitializedAndReturn<T>(String methodName, T defaultValue) {
    debugPrint('Ditto not initialized, cannot $methodName');
    return defaultValue;
  }

  /// Helper method to execute upsert operation
  Future<void> _executeUpsert(String collection, String docId, Map<String, dynamic> data) async {
    await dittoInstance!.store.execute(
      "INSERT INTO $collection DOCUMENTS (:data) ON ID CONFLICT DO UPDATE",
      arguments: {
        "data": {"_id": docId, ...data},
      },
    );
  }

  /// Helper method to execute update operation
  Future<void> _executeUpdate(String collection, String docId, Map<String, dynamic> data) async {
    final fields = data.keys.map((key) => '$key = :$key').join(', ');
    await dittoInstance!.store.execute(
      "UPDATE $collection SET $fields WHERE _id = :id",
      arguments: {"id": docId, ...data},
    );
  }
}