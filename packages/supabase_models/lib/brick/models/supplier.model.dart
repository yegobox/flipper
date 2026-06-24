import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:flipper_services/proxy.dart';
import 'package:uuid/uuid.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flutter/foundation.dart' hide Category;

part 'supplier.model.ditto_sync_adapter.g.dart';

/// Supplier master record mirroring [Customer].
///
/// Suppliers live in their OWN `suppliers` table/collection (not a kind
/// column on `customers`): POS customer queries have no kind filter, so
/// mixing kinds would leak suppliers into POS sale attachment and EBM/RRA
/// submission. Managed primarily from flipper_web Books contacts.
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'suppliers'),
)
@DittoAdapter(
  'suppliers',
  syncDirection: SyncDirection.sendOnly,
)
class Supplier extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  // supplier business name
  String? custNm;
  String? email;
  // supplier phone number
  String? telNo;

  /// address
  String? adrs;
  String? branchId;
  DateTime? updatedAt;
  // Supplier Number (phone without leading zero, RRA convention)
  String? custNo;
  // supplier tin number
  @Sqlite(nullable: true)
  @Supabase(defaultValue: null)
  final String? custTin;
  // Registrant Name
  String? regrNm;
  // Registrant ID
  String? regrId;
  // Modifier Name
  String? modrNm;
  // Modifier ID
  String? modrId;

  /// Same retry semantics as [Customer.ebmSynced].
  bool? ebmSynced;

  String? bhfId;
  String? useYn;
  String? customerType;
  Supplier({
    String? id,
    this.custNm,
    this.email,
    this.telNo,
    this.adrs,
    this.branchId,
    this.updatedAt,
    String? custNo,
    this.custTin,
    this.modrNm,
    this.regrNm,
    this.regrId,
    this.modrId,
    this.ebmSynced,
    this.bhfId,
    this.useYn,
    this.customerType,
  })  : custNo =
            telNo != null && telNo.startsWith('0') ? telNo.substring(1) : telNo,
        id = id ?? const Uuid().v4();

  Map<String, dynamic> toFlipperJson() {
    return {
      'id': id,
      'custNm': custNm,
      'email': email,
      'telNo': telNo,
      'adrs': adrs,
      'branchId': branchId,
      'updatedAt': updatedAt,
      'custNo': telNo != null && telNo!.startsWith('0')
          ? telNo!.substring(1)
          : telNo,
      'custTin': custTin,
      'regrNm': regrNm,
      'regrId': regrId,
      'modrNm': modrNm,
      'modrId': modrId,
      'ebmSynced': ebmSynced,
      'bhfId': bhfId,
      'useYn': useYn,
      'customerType': customerType,
    };
  }

  Supplier copyWith({
    String? id,
    String? custNm,
    String? email,
    String? telNo,
    String? adrs,
    String? branchId,
    DateTime? updatedAt,
    String? custNo,
    String? custTin,
    String? modrNm,
    String? regrNm,
    String? regrId,
    String? modrId,
    bool? ebmSynced,
    String? bhfId,
    String? useYn,
    String? customerType,
  }) {
    return Supplier(
      id: id ?? this.id,
      custNm: custNm ?? this.custNm,
      email: email ?? this.email,
      telNo: telNo ?? this.telNo,
      adrs: adrs ?? this.adrs,
      branchId: branchId ?? this.branchId,
      updatedAt: updatedAt ?? this.updatedAt,
      custNo: custNo ?? this.custNo,
      custTin: custTin ?? this.custTin,
      modrNm: modrNm ?? this.modrNm,
      regrNm: regrNm ?? this.regrNm,
      regrId: regrId ?? this.regrId,
      modrId: modrId ?? this.modrId,
      ebmSynced: ebmSynced ?? this.ebmSynced,
      bhfId: bhfId ?? this.bhfId,
      useYn: useYn ?? this.useYn,
      customerType: customerType ?? this.customerType,
    );
  }
}
