import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'customers'),
)
class Customer extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String id;

  //customer name
  String? custNm;
  String? email;
  // customer phone number
  String? telNo;

  /// address
  String? adrs;
  int? branchId;
  DateTime? updatedAt;
  // Customer Number
  String? custNo;
  //customer tin number
  @Sqlite(nullable: true)
  @Supabase(defaultValue: null)
  final String? custTin;
  //Registrant Name
  String? regrNm;
  // Registrant ID
  String? regrId;
  //Modifier Name
  // @Sqlite(defaultValue: "284746303937")
  String? modrNm;

  //Modifier ID
  String? modrId;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  bool? ebmSynced;

  String? bhfId;
  String? useYn;
  String? customerType;
  Customer({
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
  })  : custNo = telNo,
        id = id ?? const Uuid().v4();
  // toJson method
  Map<String, dynamic> toFlipperJson() {
    return {
      'id': id,
      'custNm': custNm,
      'email': email,
      'telNo': telNo,
      'adrs': adrs,
      'branchId': branchId,
      'updatedAt': updatedAt,
      'custNo': telNo, // Always set custNo to telNo for serialization
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

  // copyWith
  Customer copyWith({
    String? id,
    String? custNm,
    String? email,
    String? telNo,
    String? adrs,
    int? branchId,
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
    return Customer(
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
