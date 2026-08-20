import 'package:supabase_models/brick/models/transaction.model.dart';

/// Builds a unique, human-readable filename for a receipt PDF:
/// `<customer>-<yyyyMMdd_HHmmss>.pdf`, e.g. `John_Doe-20260808_143012.pdf`.
///
/// Without this every printed/saved receipt lands on the same `receipt.pdf`,
/// so a second sale silently overwrites the first one in the temp/downloads
/// folder. Falls back to `receipt` when the sale has no customer, and to the
/// current time when the transaction carries no creation timestamp.
String receiptPdfFilename(
  ITransaction? transaction, {
  String prefix = 'receipt',
  DateTime? now,
}) =>
    buildReceiptPdfFilename(
      customerName: transaction?.customerName,
      createdAt: transaction?.createdAt ?? transaction?.lastTouched,
      prefix: prefix,
      now: now,
    );

/// Model-free core of [receiptPdfFilename].
String buildReceiptPdfFilename({
  String? customerName,
  DateTime? createdAt,
  String prefix = 'receipt',
  DateTime? now,
}) {
  final customer = _slug(customerName);
  final stampedAt = (createdAt ?? now ?? DateTime.now()).toLocal();
  final stamp = '${stampedAt.year}${_pad(stampedAt.month)}${_pad(stampedAt.day)}'
      '_${_pad(stampedAt.hour)}${_pad(stampedAt.minute)}${_pad(stampedAt.second)}';

  return '${customer ?? prefix}-$stamp.pdf';
}

/// Filename-safe form of [name]: spaces become underscores, anything that is
/// not a letter/digit/underscore/hyphen is dropped, and the result is capped so
/// long business customer names don't blow past filesystem limits.
String? _slug(String? name) {
  final trimmed = name?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;

  final slug = trimmed
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '')
      .replaceAll(RegExp(r'_{2,}'), '_')
      .replaceAll(RegExp(r'^[_-]+|[_-]+$'), '');
  if (slug.isEmpty) return null;

  return slug.length > 40 ? slug.substring(0, 40) : slug;
}

String _pad(int value) => value.toString().padLeft(2, '0');
