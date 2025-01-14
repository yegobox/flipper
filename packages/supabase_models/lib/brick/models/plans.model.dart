import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/plan_addon.model.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'plans'),
  sqliteConfig: SqliteSerializable(),
)
class Plan extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String? id;
  final int? businessId;
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

  final List<PlanAddon> addons;

  DateTime? nextBillingDate;

  int? numberOfPayments;

  Plan({
    String? id,
    this.businessId,
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
  }) : id = id ?? const Uuid().v4();
}
