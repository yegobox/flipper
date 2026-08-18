import 'package:flipper_hr/features/invite/data/hr_invite.dart';

/// Request bodies and response parsing for the invite's three hops.
///
/// Split out from the repository so every payload and every "what shape did the
/// backend answer in" decision is unit-testable without a socket. apihub is
/// loose about response shapes — `POST /v2/api/pin` has been seen returning the
/// pin object bare, wrapped in `data`, and as a one-element list — so parsing
/// belongs somewhere it can be pinned down by tests.
class HrInviteWire {
  HrInviteWire._();

  /// `POST $apihub/v2/api/user`. The field is `phone_number` and it accepts an
  /// email just as well, which is why HR sends whatever contact the person was
  /// added with.
  static Map<String, dynamic> accountBody({required String contact}) => {
    'phone_number': contact.trim(),
  };

  /// `create_agent` RPC params.
  ///
  /// `p_allow_business_login` is always true: an HR invitee must be able to sign
  /// in. The flag only means anything for `Agent`-type tenants (commission-only
  /// logins), and HR never creates those.
  static Map<String, dynamic> membershipParams({
    required String userId,
    required String name,
    required String contact,
    required String businessId,
    required String branchId,
    required HrRole role,
  }) => {
    'p_user_id': userId,
    'p_name': name,
    'p_email': contact.trim(),
    'p_business_id': businessId,
    'p_branch_id': branchId,
    'p_accesses': [
      {
        'feature_name': HrRole.featureName,
        'access_level': role.accessLevel,
        'status': 'active',
      },
    ],
    // Not 'Agent': that type turns the login commission-only unless the flag
    // below overrides it. 'Cashier' / 'Admin' are the two non-agent types the
    // POS app uses (UserType in flipper_services/constants.dart).
    'p_user_type': role == HrRole.manager ? 'Admin' : 'Cashier',
    'p_allow_business_login': true,
  };

  /// `POST $apihub/v2/api/pin`. Field names are apihub's, not this schema's —
  /// camelCase here, snake_case coming back.
  static Map<String, dynamic> pinBody({
    required String userId,
    required String phoneNumber,
    required String businessId,
    required String branchId,
    required String ownerName,
  }) => {
    'phoneNumber': phoneNumber,
    'userId': userId,
    'branchId': branchId,
    'businessId': businessId,
    'defaultApp': hrInviteDefaultApp,
    'ownerName': ownerName,
  };

  /// The account id from `POST /v2/api/user`.
  ///
  /// Returns null rather than throwing so the caller can attach the HTTP body
  /// to the error message — a null here almost always means the response was an
  /// error page, and the body is the useful part.
  static String? accountIdOf(Object? decoded) {
    final row = _firstObject(decoded);
    if (row == null) return null;
    return _nonEmpty(row['id']) ?? _nonEmpty(row['user_id']);
  }

  /// The phone apihub has on file, which is the number the login OTP goes to.
  /// Falls back to null when the account carries no phone (an email-only login).
  static String? accountPhoneOf(Object? decoded) {
    final row = _firstObject(decoded);
    if (row == null) return null;
    return _nonEmpty(row['phone_number']) ?? _nonEmpty(row['phone']);
  }

  /// The PIN from `POST /v2/api/pin`.
  ///
  /// Kept as a string: `pin` arrives as an int, and formatting an int would drop
  /// a leading zero that the invitee has to type.
  static String? pinOf(Object? decoded) {
    final unwrapped = _unwrap(decoded);
    if (unwrapped is Map<String, dynamic>) return _nonEmpty(unwrapped['pin']);
    // Some deployments answer with the bare number, or a list holding it.
    return _nonEmpty(unwrapped);
  }

  /// The tenant id `create_agent` returns. PostgREST hands back a bare string,
  /// a one-row list, or (with some headers) a JSON object — all three seen in
  /// flipper_dashboard's `addUserStatic`.
  static String? tenantIdOf(Object? decoded) {
    final unwrapped = _unwrap(decoded);
    if (unwrapped is Map<String, dynamic>) {
      return _nonEmpty(unwrapped['id']) ?? _nonEmpty(unwrapped['tenant_id']);
    }
    return _nonEmpty(unwrapped);
  }

  /// Like [_unwrap] but only yields an object, so callers that need named fields
  /// do not have to re-test the type.
  static Map<String, dynamic>? _firstObject(Object? value) {
    final unwrapped = _unwrap(value);
    return unwrapped is Map<String, dynamic> ? unwrapped : null;
  }

  /// Peels the envelopes apihub and PostgREST use interchangeably — `[x]`,
  /// `{data: x}`, `{data: [x]}` — down to the value inside.
  ///
  /// Returns a `Map<String, dynamic>` for an object, the scalar for a bare value
  /// (PostgREST returns `create_agent`'s uuid as a naked JSON string), and null
  /// when there is nothing in there.
  static Object? _unwrap(Object? value) {
    if (value is List) {
      return value.isEmpty ? null : _unwrap(value.first);
    }
    if (value is Map) {
      final map = value.cast<String, dynamic>();
      final data = map['data'];
      // Only follow `data` when the wrapper carries no id of its own, so a row
      // that happens to have a `data` column is not mistaken for an envelope.
      if ((data is Map || data is List) && !map.containsKey('id')) {
        return _unwrap(data);
      }
      return map;
    }
    return value;
  }

  static String? _nonEmpty(Object? value) {
    if (value == null) return null;
    final s = value.toString().trim();
    return s.isEmpty || s == 'null' ? null : s;
  }
}
