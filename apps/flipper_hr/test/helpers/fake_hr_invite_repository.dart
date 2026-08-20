import 'package:flipper_hr/features/invite/data/hr_invite.dart';
import 'package:flipper_hr/features/invite/data/hr_invite_repository.dart';

/// Records what it was asked for and hands back a canned invite.
class FakeHrInviteRepository implements HrInviteRepository {
  FakeHrInviteRepository({this.pin = '123456', this.failWith});

  final String pin;

  /// When set, [invite] throws this instead of succeeding.
  Object? failWith;

  /// Every call, in order — so a test can assert the contact and role that were
  /// actually sent, not just that something was.
  final calls = <({String contact, String name, String businessId,
      String branchId, HrRole role})>[];

  @override
  Future<HrInvite> invite({
    required String contact,
    required String name,
    required String businessId,
    required String branchId,
    required HrRole role,
  }) async {
    calls.add((
      contact: contact,
      name: name,
      businessId: businessId,
      branchId: branchId,
      role: role,
    ));
    final failure = failWith;
    if (failure != null) throw failure;
    return HrInvite(
      userId: 'user-new',
      tenantId: 'tenant-new',
      pin: pin,
      phoneNumber: contact,
      role: role,
    );
  }
}
