import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:supabase_models/brick/models/plan_addon.model.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'plans'),
  sqliteConfig: SqliteSerializable(),
)
class Plan extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  @Supabase(unique: true)
  final int? id;
  @Supabase(name: "business_id")
  final int? businessId;
  @Supabase(name: "selected_plan")
  final String? selectedPlan;
  @Supabase(name: "additional_devices")
  final int? additionalDevices;
  @Supabase(name: "is_yearly_plan")
  final bool? isYearlyPlan;
  @Supabase(name: "total_price")
  final int? totalPrice;
  @Supabase(name: "created_at")
  final DateTime? createdAt;
  @Supabase(name: "payment_completed_by_user")
  bool? paymentCompletedByUser = false;
  @Supabase(name: "paystack_customer_id")
  final int? payStackCustomerId;
  final String? rule;
  @Supabase(name: "payment_method")
  final String? paymentMethod;

  @Supabase(name: "addons")
  final List<PlanAddon> addons;

  @Supabase(name: "next_billing_date")
  final DateTime? nextBillingDate;

  Plan({
    required this.id,
    this.businessId,
    this.selectedPlan,
    this.additionalDevices,
    this.isYearlyPlan,
    this.totalPrice,
    this.createdAt,
    this.paymentCompletedByUser = false,
    this.payStackCustomerId,
    this.rule,
    this.paymentMethod,
    this.nextBillingDate,
    this.addons = const [],
  });
}
