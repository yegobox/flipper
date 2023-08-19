import 'package:flipper_models/member.dart';

class MembershipApi implements Members {
  String apihub = "https://apihub.yegobox.com";
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
