import 'package:flipper_web/modules/accounting/data/party_models.dart';

/// Maps canonical `customers` / `suppliers` rows (Ditto camelCase or Supabase
/// snake_case) to/from the [Party] DTO. Row shapes mirror the generated Brick
/// and Ditto adapters for the Customer model — keep in sync with
/// flipper_models `PartyDraft.toDittoRow`/`toSupabaseRow`.
class PartyRowMapper {
  PartyRowMapper._();

  static String _str(Map<String, dynamic> row, String snake, String camel) =>
      (row[snake] ?? row[camel] ?? '').toString();

  static String? _strOrNull(
      Map<String, dynamic> row, String snake, String camel) {
    final v = row[snake] ?? row[camel];
    return v?.toString();
  }

  static Party partyFromRow(
    Map<String, dynamic> row, {
    PartyKind kind = PartyKind.customer,
  }) {
    return Party(
      id: (row['id'] ?? row['_id'] ?? '').toString(),
      name: _str(row, 'cust_nm', 'custNm'),
      phone: _str(row, 'tel_no', 'telNo'),
      email: _str(row, 'email', 'email'),
      tin: _str(row, 'cust_tin', 'custTin'),
      branchId: _str(row, 'branch_id', 'branchId'),
      customerType: _str(row, 'customer_type', 'customerType'),
      address: _strOrNull(row, 'adrs', 'adrs'),
      custNo: _strOrNull(row, 'cust_no', 'custNo'),
      regrNm: _strOrNull(row, 'regr_nm', 'regrNm'),
      regrId: _strOrNull(row, 'regr_id', 'regrId'),
      modrNm: _strOrNull(row, 'modr_nm', 'modrNm'),
      modrId: _strOrNull(row, 'modr_id', 'modrId'),
      ebmSynced: (row['ebm_synced'] ?? row['ebmSynced']) == true,
      bhfId: _strOrNull(row, 'bhf_id', 'bhfId') ?? '00',
      useYn: _strOrNull(row, 'use_yn', 'useYn') ?? 'N',
      updatedAtIso: _strOrNull(row, 'updated_at', 'updatedAt'),
      kind: kind,
    );
  }

  /// Ditto document shape (camelCase, matches the generated DittoAdapter).
  static Map<String, dynamic> toDittoRow(Party p) => {
        '_id': p.id,
        'id': p.id,
        'custNm': p.name,
        'email': p.email,
        'telNo': p.phone,
        'adrs': p.address,
        'branchId': p.branchId,
        'updatedAt': p.updatedAtIso,
        'custNo': p.custNo,
        'custTin': p.tin,
        'regrNm': p.regrNm,
        'regrId': p.regrId,
        'modrNm': p.modrNm,
        'modrId': p.modrId,
        'ebmSynced': p.ebmSynced,
        'bhfId': p.bhfId,
        'useYn': p.useYn,
        'customerType': p.customerType,
      };

  /// Supabase row shape (snake_case, matches the Brick adapter columns).
  static Map<String, dynamic> toSupabaseRow(Party p) => {
        'id': p.id,
        'cust_nm': p.name,
        'email': p.email,
        'tel_no': p.phone,
        'adrs': p.address,
        'branch_id': p.branchId,
        'updated_at': p.updatedAtIso,
        'cust_no': p.custNo,
        'cust_tin': p.tin,
        'regr_nm': p.regrNm,
        'regr_id': p.regrId,
        'modr_nm': p.modrNm,
        'modr_id': p.modrId,
        'ebm_synced': p.ebmSynced,
        'bhf_id': p.bhfId,
        'use_yn': p.useYn,
        'customer_type': p.customerType,
      };
}
