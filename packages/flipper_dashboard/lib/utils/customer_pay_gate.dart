import 'package:flipper_models/db_model_export.dart';

/// Shared Pay-gate customer completeness check for [QuickSellingView] and
/// [CheckOut].
///
/// Resolves name, phone, and TIN from typed fields, an attached/searched
/// customer, then the transaction row. Does **not** accept
/// [ITransaction.customerId] alone. Name is always required; phone is required
/// only when no TIN is present. When [attachedCustomer] is present, its TIN is
/// authoritative over denormalized [ITransaction.customerTin] (so clearing TIN
/// on the customer is respected). Persisted box keys are intentionally
/// excluded (they can carry a previous sale's customer).
///
/// Returns a localized error message when a required detail is missing, else
/// null. Callers supply the localized strings.
String? missingCustomerDetailsForPay({
  required ITransaction? transaction,
  Customer? attachedCustomer,
  required String typedName,
  required String typedPhone,
  String? typedTin,
  required String pleaseEnterCustomerName,
  required String phoneRequiredWhenTinMissing,
}) {
  String firstNonEmpty(List<String?> values) {
    for (final v in values) {
      final t = v?.trim() ?? '';
      if (t.isNotEmpty) return t;
    }
    return '';
  }

  final name = firstNonEmpty([
    typedName,
    attachedCustomer?.custNm,
    transaction?.customerName,
  ]);
  if (name.isEmpty) return pleaseEnterCustomerName;

  // Typed TIN wins. When a live/attached customer is present, their TIN is
  // authoritative (including empty) so a cleared TIN is not overridden by a
  // stale denormalized transaction.customerTin.
  final typedTinValue = typedTin?.trim() ?? '';
  final tin = typedTinValue.isNotEmpty
      ? typedTinValue
      : attachedCustomer != null
          ? (attachedCustomer.custTin?.trim() ?? '')
          : (transaction?.customerTin?.trim() ?? '');
  if (tin.isNotEmpty) return null;

  final phone = firstNonEmpty([
    typedPhone,
    attachedCustomer?.telNo,
    transaction?.customerPhone,
    transaction?.currentSaleCustomerPhoneNumber,
  ]);
  if (phone.isEmpty) return phoneRequiredWhenTinMissing;

  return null;
}
