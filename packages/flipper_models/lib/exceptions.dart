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

class PinError implements Exception {
  String term;

  String errMsg() => 'Pin: $term';

  PinError({required this.term});
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

class FailedPaymentException implements Exception {
  final String message;
  FailedPaymentException(this.message);
}
