/// The invite: what HR sends a new hire so they can sign into the HR app.
///
/// Deliberately plain Dart — no Supabase, http or Flutter imports — so the
/// payload builders and the result parsing are unit-testable without a backend.
/// The network calls live in `apihub_hr_invite_repository.dart`.
library;

/// What an invited person may do in HR.
///
/// These map onto Flipper's existing feature/access-level model (see
/// `AppFeature` and `AccessLevel` in flipper_services/constants.dart), so an HR
/// invite produces the same `accesses` rows any other Flipper user has rather
/// than a parallel permission system.
enum HrRole {
  /// A new hire: books their own leave and sees their own balance. Nothing else.
  staff('read', 'Staff — books own leave'),

  /// An HR manager: the roster plus approving other people's leave.
  manager('admin', 'Manager — roster and approvals');

  const HrRole(this.accessLevel, this.label);

  /// `accesses.access_level` granted for [featureName].
  final String accessLevel;
  final String label;

  /// The single feature name HR grants. `create_agent` accepts any string here;
  /// keeping it to one feature means an HR invite never widens someone's POS
  /// permissions as a side effect.
  static const featureName = 'HR';
}

/// The `defaultApp` recorded on the PIN.
///
/// `1` is the business app. HR never reads this — it signs in through
/// flipper_web's PIN screen, which ignores it — but `POST /v2/api/pin` requires
/// it, and `1` is what every other business-side invite sends
/// (flipper_dashboard's `TenantOperationsMixin.addUserStatic`). Sending `2`
/// would route this person to the social home on the POS app instead.
const hrInviteDefaultApp = 1;

/// A person who can now sign into HR.
///
/// [pin] is the credential: the invitee types it into the PIN screen at
/// hr.useflipper.com and confirms with the OTP sent to [phoneNumber]. It is
/// shown once, to the person doing the inviting, who passes it on.
class HrInvite {
  const HrInvite({
    required this.userId,
    required this.tenantId,
    required this.pin,
    required this.phoneNumber,
    required this.role,
  });

  /// `public.users.id` / `auth.users.id` for the invitee. This is what goes into
  /// `hr_employees.user_id`, so the person's own leave resolves back to them.
  final String userId;

  /// `public.tenants.id` — the membership row that ties them to the business.
  final String tenantId;

  /// The login PIN, as a string because leading zeros matter when it is read
  /// out or typed in.
  final String pin;

  /// Where the login OTP will be sent.
  final String phoneNumber;

  final HrRole role;

  /// What the invitee types into the PIN screen's identity field on a device
  /// that asks for one. Matches the synthetic keys elsewhere in Flipper
  /// (`api_login_key.dart`) — see `0003_hr_employees_rls_pin_identity.sql`.
  String get loginKey => '$pin@flipper.rw';

  @override
  String toString() => 'HrInvite(user $userId, tenant $tenantId, ${role.name})';
}

/// Thrown when any step of the invite fails, so the UI shows one message
/// instead of leaking a PostgrestException or a raw HTTP body.
///
/// [step] names which hop failed. The pipeline is three calls against two
/// backends, and "which one" is the first thing anyone debugging it asks.
class HrInviteException implements Exception {
  HrInviteException(this.message, {required this.step, this.cause});

  final String message;
  final HrInviteStep step;
  final Object? cause;

  @override
  String toString() => 'HrInviteException(${step.name}): $message';
}

/// The hops the invite makes, in order.
enum HrInviteStep {
  /// `POST $apihub/v2/api/user` — find or create the login account.
  resolveAccount,

  /// `create_agent` RPC — the tenant row and its `accesses`.
  grantMembership,

  /// `POST $apihub/v2/api/pin` — the credential the invitee types in.
  issuePin,

  /// Reading the `tenants` row back, so a half-finished invite is not reported
  /// as a success.
  verify,

  /// Writing `hr_employees.user_id`, which is what links the person to their
  /// own leave.
  linkEmployee,
}
