import 'package:flipper_models/member.dart';
import 'package:flipper_models/secrets.dart';

class MembershipApi implements Members {
  String get apihub => AppSecrets.coreApi;
  @override
  Future<bool> deduct({required String phoneNumberOrId, int? defaultDeductor}) {
    // TODO: implement deduct
    throw UnimplementedError();
  }

  @override
  Future<bool> topUp({required String phoneNumberOrId, required int points}) {
    // TODO: implement topUp
    throw UnimplementedError();
  }

  @override
  Future<bool> addMembership(
      {required String phoneNumberOrId, String? welcomePoints}) {
    // TODO: implement addMembership
    throw UnimplementedError();
  }
}
