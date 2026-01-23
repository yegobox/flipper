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

part 'transaction_payment_record.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig:
      SupabaseSerializable(tableName: 'transaction_payment_records'),
)
@DittoAdapter(
  'transaction_payment_records',
  syncDirection: SyncDirection.bidirectional,
)
class TransactionPaymentRecord extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  String? transactionId;
  @Sqlite(defaultValue: "0.0")
  @Supabase(defaultValue: "0.0")
  double? amount;
  String? paymentMethod;
  DateTime? createdAt;
  TransactionPaymentRecord({
    String? id,
    required this.transactionId,
    required this.amount,
    required this.paymentMethod,
    required this.createdAt,
  }) : id = id ?? const Uuid().v4();
}
