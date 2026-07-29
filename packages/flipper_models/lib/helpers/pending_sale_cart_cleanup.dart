/// Pure helpers for [clearPendingSaleCartsExcept] classification.
///
/// Resume must never hard-delete a non-empty pending sale (e.g. a ticket that
/// was already resumed on this device). Only wipe empty operator carts.
bool isEmptyPendingSaleCart({
  required double subTotal,
  String? ticketName,
  required bool hasItems,
}) {
  final name = ticketName?.trim() ?? '';
  return !hasItems && subTotal <= 0.01 && name.isEmpty;
}
