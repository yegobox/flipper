import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(),
)
class Plan extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  final int id;
  final int? businessId;
  final String? selectedPlan;
  final int? additionalDevices;
  final bool? isYearlyPlan;
  final int? totalPrice;
  final DateTime? createdAt;
  bool? paymentCompletedByUser = false;
  @Supabase(name: "paystack_customer_id")
  final int? payStackCustomerId;
  final String? rule;
  final String? paymentMethod;
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
  });
}
