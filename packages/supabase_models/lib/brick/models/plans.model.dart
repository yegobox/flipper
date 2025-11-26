import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/plan_addon.model.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';

part 'plans.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'plans'),
  sqliteConfig: SqliteSerializable(),
)
@DittoAdapter('plans', syncDirection: SyncDirection.bidirectional)
class Plan extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String? id;
  String? businessId;
  String? branchId;
  String? selectedPlan;
  int? additionalDevices;
  bool? isYearlyPlan;
  int? totalPrice;
  DateTime? createdAt;
  @Sqlite(defaultValue: "false")
  @Supabase(defaultValue: "false")
  bool? paymentCompletedByUser;

  String? rule;
  String? paymentMethod;

  final List<PlanAddon>? addons;

  DateTime? nextBillingDate;

  int? numberOfPayments;

  String? phoneNumber;
  String? externalId;

  String? paymentStatus;
  DateTime? lastProcessedAt;
  String? lastError;
  DateTime? updatedAt;
  DateTime? lastUpdated;
  String? processingStatus;

  Plan({
    String? id,
    this.businessId,
    this.branchId,
    this.selectedPlan,
    this.additionalDevices,
    this.isYearlyPlan,
    this.totalPrice,
    this.createdAt,
    this.paymentCompletedByUser = false,
    this.rule,
    this.paymentMethod,
    this.nextBillingDate,
    this.numberOfPayments,
    this.addons = const [],
    this.phoneNumber,
    this.externalId,
    this.paymentStatus,
    this.lastProcessedAt,
    this.lastError,
    this.updatedAt,
    this.lastUpdated,
    this.processingStatus,
  }) : id = id ?? const Uuid().v4();
}
