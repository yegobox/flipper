class VoucherException implements Exception {
  String term;

  String errMsg() => 'VoucherException: $term';

  VoucherException({required this.term});
}

class LoginChoicesException implements Exception {
  String term;

  String errMsg() => 'You need to choose: $term';

  LoginChoicesException({required this.term});
}

class InternalServerException implements Exception {
  String term;

  String errMsg() => 'InternalServerException: $term';

  InternalServerException({required this.term});
}

class SessionException implements Exception {
  String term;

  String errMsg() => 'SessionException: $term';

  SessionException({required this.term});
}

/// The server could not check the PIN or log the user in.
///
/// Thrown only for server-side faults, never for what the user typed:
/// `GET /v2/api/pin/<pin>` answering anything but 200 or 404 (turbo returns
/// 500 when its Supabase lookup fails; nginx 502/503/504 when turbo is down)
/// and a 500 from the login request. A PIN with no account is a 404, thrown as
/// [NeedSignUpException]. [term] is the HTTP status (`HTTP 503`) or a short
/// reason, never the PIN.
class PinError implements Exception {
  String term;

  String errMsg() => 'Pin: $term';

  PinError({required this.term});

  /// Error tracking shows this text, so it must name the failure; the default
  /// was the unreadable "Instance of 'PinError'".
  @override
  String toString() => 'PinError: $term';
}

class NeedSignUpException implements Exception {
  String term;

  String errMsg() => 'NeedSignUpException: $term';

  NeedSignUpException({required this.term});
}

class BranchLoadingException implements Exception {
  String term;

  String errMsg() => 'Branch error: $term';

  BranchLoadingException({required this.term});
}

class NoDrawerOpenException implements Exception {
  String term;

  String errMsg() => 'NoDrawerOpen: $term';

  NoDrawerOpenException({required this.term});
}

class InternalServerError implements Exception {
  String term;

  String errMsg() => 'SessionException: $term';

  InternalServerError({required this.term});
}

/// The signup email or phone already belongs to another Flipper account
/// (`/v2/api/user` answered 409 `login_linked_to_other_account`). Signing up
/// with it can never finish, so the signup screen stops before sending an OTP.
class LoginLinkedToOtherAccountException implements Exception {
  const LoginLinkedToOtherAccountException();

  static const code = 'login_linked_to_other_account';

  /// True for the server's 409 with [code] in the body.
  static bool matches(int statusCode, String body) =>
      statusCode == 409 && body.contains(code);

  @override
  String toString() => 'LoginLinkedToOtherAccountException: $code';
}

class BusinessNotFoundException implements Exception {
  String term;

  String errMsg() => 'SessionException: $term';

  BusinessNotFoundException({required this.term});
}

class TenantNotFoundException implements Exception {
  String term;

  String errMsg() => 'SessionException: $term';

  TenantNotFoundException({required this.term});
}

class UnknownError implements Exception {
  String term;

  String errMsg() => 'Unknown error: $term';

  UnknownError({required this.term});
}

class SubscriptionError implements Exception {
  String term;

  String errMsg() => 'Subscription Error: $term';

  SubscriptionError({required this.term});
}

class CustomerNotFoundException implements Exception {
  final String message;
  CustomerNotFoundException(this.message);
}

class ProductNotFoundException implements Exception {
  final String message;
  ProductNotFoundException(this.message);

  @override
  String toString() => 'ProductNotFoundException: $message';
}

class FailedPaymentException implements Exception {
  final String message;
  FailedPaymentException(this.message);
}

class PaymentIncompleteException implements Exception {
  final String message;
  PaymentIncompleteException(this.message);
}

class NoPaymentPlanFound implements Exception {
  final String message;
  NoPaymentPlanFound(this.message);
}

class NoOpenDrawer implements Exception {
  final String message;
  NoOpenDrawer(this.message);
}

class FlipperException implements Exception {
  final String message;

  FlipperException(this.message);

  @override
  String toString() => 'FlipperException: $message';
}

class DuplicateTenantException implements Exception {
  final String message;

  DuplicateTenantException(this.message);

  String errMsg() => 'Duplicate Tenant: $message';

  @override
  String toString() => 'DuplicateTenantException: $message';
}
