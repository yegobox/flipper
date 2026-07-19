import 'package:flipper_models/db_model_export.dart';

/// Shared Pay-gate customer completeness check for [QuickSellingView] and
/// [CheckOut].
///
/// Resolves name, phone, and TIN from typed fields, the transaction row, and an
/// attached/searched customer. Does **not** accept [ITransaction.customerId]
/// alone. Name is always required; phone is required only when no TIN is
/// present. Persisted box keys are intentionally excluded (they can carry a
/// previous sale's customer).
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
    transaction?.customerName,
    attachedCustomer?.custNm,
  ]);
  if (name.isEmpty) return pleaseEnterCustomerName;

  final tin = firstNonEmpty([
    typedTin,
    transaction?.customerTin,
    attachedCustomer?.custTin,
  ]);
  if (tin.isNotEmpty) return null;

  final phone = firstNonEmpty([
    typedPhone,
    transaction?.customerPhone,
    transaction?.currentSaleCustomerPhoneNumber,
    attachedCustomer?.telNo,
  ]);
  if (phone.isEmpty) return phoneRequiredWhenTinMissing;

  return null;
}
