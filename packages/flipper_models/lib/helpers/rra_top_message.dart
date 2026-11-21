import 'package:flipper_models/models/branch_document_settings.dart';

/// The `topMsg` sent to RRA with a sale: the header RRA prints on its copy of
/// the receipt.
///
/// Phone, email and the welcome line come from the branch's receipt header
/// (Tax Settings → Receipt header), falling back to the business. The
/// placeholder phone, email and TIN are what this message has always sent
/// when nothing is set; RRA has accepted them for years, so a missing value
/// keeps that behaviour rather than sending an empty `TEL:`.
String rraReceiptTopMessage({
  required BranchDocumentSettings header,
  String? businessName,
  String? address,
  String? businessPhone,
  String? businessEmail,
  String? tin,
}) {
  final phone = header.receiptPhoneOr(businessPhone).replaceAll('+', '');
  final email = header.receiptEmailOr(businessEmail);
  return [
    businessName ?? 'Our Business',
    (address?.isNotEmpty ?? false) ? address! : '',
    'TEL: ${phone.isEmpty ? '0780000000' : phone}',
    'Email: ${email.isEmpty ? 'info@yegobox.com' : email}',
    'TIN: ${tin ?? '999909695'}',
    header.receiptWelcomeLine,
  ].join('\n');
}
