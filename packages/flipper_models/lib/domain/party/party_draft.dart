import 'package:flipper_models/domain/party/party_validation.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:uuid/uuid.dart';

/// Which canonical store a party row belongs to.
///
/// Customers live in the `customers` Supabase table / Ditto collection,
/// suppliers in `suppliers`. They are deliberately separate stores: POS
/// customer queries have no kind filter, so mixing kinds in one table would
/// leak suppliers into POS sale attachment and EBM submission.
enum PartyKind { customer, supplier }

extension PartyKindStore on PartyKind {
  /// Supabase table name == Ditto collection name.
  String get storeName =>
      this == PartyKind.customer ? 'customers' : 'suppliers';
}

/// Pure value class capturing how Flipper constructs a customer/supplier
/// record, including the RRA/EBM defaults.
///
/// This is the single source of truth for party row shapes. The POS app
/// converts a draft to a Brick `Customer` via `customerFromDraft` (see
/// customer_factory.dart); the web app writes [toDittoRow]/[toSupabaseRow]
/// directly. Keep this file pure Dart (no ProxyService/Brick/Flutter) so the
/// wasm-compiled web app can import it.
///
/// Field semantics mirror the legacy CoreViewModel.addCustomer behavior
/// byte-for-byte:
///   - custTin = tin ?? phone
///   - custNo  = phone without leading zero (derived from telNo, NOT from tin)
///   - regrNm/regrId/modrNm/modrId = independent random 5-digit strings
///   - ebmSynced=false, useYn='N', bhfId default '00'
class PartyDraft {
  PartyDraft({
    String? id,
    required this.name,
    required this.phone,
    required this.customerType,
    required this.branchId,
    this.email = '',
    this.tin,
    String? bhfId,
    this.address,
    this.kind = PartyKind.customer,
    DateTime? updatedAt,
    String Function()? randomFiveDigits,
  })  : id = id ?? const Uuid().v4(),
        bhfId = bhfId ?? '00',
        updatedAt = updatedAt ?? DateTime.now().toUtc(),
        regrNm = (randomFiveDigits ?? _defaultRandomFiveDigits)(),
        regrId = (randomFiveDigits ?? _defaultRandomFiveDigits)(),
        modrNm = (randomFiveDigits ?? _defaultRandomFiveDigits)(),
        modrId = (randomFiveDigits ?? _defaultRandomFiveDigits)();

  static String _defaultRandomFiveDigits() =>
      randomNumber().toString().substring(0, 5);

  final String id;
  final String name;
  final String phone;
  final String email;
  final String? tin;
  final String customerType;
  final String branchId;
  final String bhfId;
  final String? address;
  final PartyKind kind;
  final DateTime updatedAt;

  // RRA registrant/modifier fields (random 5-digit strings, legacy behavior).
  final String regrNm;
  final String regrId;
  final String modrNm;
  final String modrId;

  /// TIN falls back to the phone number ONLY when null (legacy CoreViewModel
  /// `tinNumber ?? phone` behavior — an empty string passes through as-is,
  /// which is what the POS form submits when the TIN field is blank).
  String get custTin => tin ?? phone;

  /// Phone without leading zero (mirrors the `Customer` model constructor).
  String? get custNo => normalizeCustNo(phone);

  /// Row shape for the Ditto `customers`/`suppliers` collection. Keys match
  /// the generated DittoAdapter `toDittoDocument` for the Customer model.
  Map<String, dynamic> toDittoRow() => {
        '_id': id,
        'id': id,
        'custNm': name,
        'email': email,
        'telNo': phone,
        'adrs': address,
        'branchId': branchId,
        'updatedAt': updatedAt.toIso8601String(),
        'custNo': custNo,
        'custTin': custTin,
        'regrNm': regrNm,
        'regrId': regrId,
        'modrNm': modrNm,
        'modrId': modrId,
        'ebmSynced': false,
        'bhfId': bhfId,
        'useYn': 'N',
        'customerType': customerType,
      };

  /// Row shape for the Supabase `customers`/`suppliers` table. Keys match
  /// the generated Brick adapter column names.
  Map<String, dynamic> toSupabaseRow() => {
        'id': id,
        'cust_nm': name,
        'email': email,
        'tel_no': phone,
        'adrs': address,
        'branch_id': branchId,
        'updated_at': updatedAt.toIso8601String(),
        'cust_no': custNo,
        'cust_tin': custTin,
        'regr_nm': regrNm,
        'regr_id': regrId,
        'modr_nm': modrNm,
        'modr_id': modrId,
        'ebm_synced': false,
        'bhf_id': bhfId,
        'use_yn': 'N',
        'customer_type': customerType,
      };
}
