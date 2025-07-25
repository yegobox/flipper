import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/finance_provider.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'purchase_financings'),
)
class Financing extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;
  final bool requested;
  final String status;
  FinanceProvider? provider;
  String? financeProviderId;
  num? amount;
  final DateTime approvalDate;

  Financing({
    String? id,
    required this.requested,
    required this.provider,
    required this.status,
    required this.financeProviderId,
    this.amount,
    required this.approvalDate,
  }) : id = id ?? const Uuid().v4();
  //copyWith
  Financing copyWith({
    String? id,
    bool? requested,
    String? status,
    FinanceProvider? provider,
    String? financeProviderId,
    num? amount,
    DateTime? approvalDate,
  }) {
    return Financing(
      id: id ?? this.id,
      requested: requested ?? this.requested,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      financeProviderId: financeProviderId ?? this.financeProviderId,
      amount: amount ?? this.amount,
      approvalDate: approvalDate ?? this.approvalDate,
    );
  }
}
