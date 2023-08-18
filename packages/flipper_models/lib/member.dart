abstract class Members {
  Future<bool> deduct({required String phoneNumberOrId, int? defaultDeductor});
  Future<bool> topUp({required String phoneNumberOrId, required int points});
  Future<bool> addMembership(
      {required String phoneNumberOrId, String welcomePoints});
}
