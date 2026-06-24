/// Pure helpers for cash book line item codes (no Flutter / DB imports).

String segmentForCashMovementItemCode(String transactionType) {
  final normalized = transactionType.toLowerCase().replaceAll(' ', '');
  if (normalized == 'cashin') {
    return 'CASH-IN';
  }
  if (normalized == 'cashout') {
    return 'CASH-OUT';
  }
  return transactionType.toUpperCase();
}

String buildCashMovementItemCode(
  String transactionType,
  DateTime day,
) {
  final dateStr =
      '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
  return '${segmentForCashMovementItemCode(transactionType)}-$dateStr';
}
