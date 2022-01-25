class VoucherException implements Exception {
  String term;

  String errMsg() => 'VoucherException: $term';

  VoucherException({required this.term});
}

class SessionException implements Exception {
  String term;

  String errMsg() => 'SessionException: $term';

  SessionException({required this.term});
}
