import 'package:shared_preferences/shared_preferences.dart';

/// Persists last-selected business/branch across app restarts (per user).
abstract final class BusinessSelectionPersistence {
  static const _userKey = 'flipper_web_selection_user_id';
  static const _businessKey = 'flipper_web_selected_business_id';
  static const _branchKey = 'flipper_web_selected_branch_id';

  static Future<void> save({
    required String userId,
    required String businessId,
    required String branchId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userId.trim());
    await prefs.setString(_businessKey, businessId.trim());
    await prefs.setString(_branchKey, branchId.trim());
  }

  static Future<({String businessId, String branchId})?> read({
    required String userId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final storedUser = prefs.getString(_userKey)?.trim();
    if (storedUser == null || storedUser != userId.trim()) return null;

    final businessId = prefs.getString(_businessKey)?.trim();
    final branchId = prefs.getString(_branchKey)?.trim();
    if (businessId == null ||
        businessId.isEmpty ||
        branchId == null ||
        branchId.isEmpty) {
      return null;
    }
    return (businessId: businessId, branchId: branchId);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.remove(_businessKey);
    await prefs.remove(_branchKey);
  }
}
