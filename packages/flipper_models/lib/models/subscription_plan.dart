import 'package:uuid/uuid.dart';

/// Supabase addons row mapped in Dart (non-Brick; server table `addons`).
class PlanAddon {
  final String id;
  final String? planId;
  final String? addonName;
  final DateTime? createdAt;

  PlanAddon({
    String? id,
    this.planId,
    this.addonName,
    this.createdAt,
  }) : id = id ?? const Uuid().v4();

  factory PlanAddon.fromDittoDocument(Map<String, dynamic> doc) {
    DateTime? parse(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString());

    final rawId = doc['_id'] ?? doc['id'];
    return PlanAddon(
      id: rawId?.toString() ?? const Uuid().v4(),
      planId: doc['planId']?.toString(),
      addonName: doc['addonName']?.toString(),
      createdAt: parse(doc['createdAt']),
    );
  }
}

/// Subscription plan: Supabase is the source of truth for writes (`Supabase.instance.client`,
/// see [CoreSync]). Offline reads use Ditto (`PlanDittoScheduler` / [PlanDittoSyncService]
/// push from backend).
class Plan {
  final String? id;
  String? businessId;
  String? branchId;
  String? selectedPlan;
  int? additionalDevices;
  bool? isYearlyPlan;
  int? totalPrice;
  DateTime? createdAt;
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

  /// Set when payment succeeds (mirrors `last_payment_date` in Supabase / Ditto).
  DateTime? lastPaymentDate;

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
    this.lastPaymentDate,
  }) : id = id ?? const Uuid().v4();

  /// Build from a Supabase PostgREST row (`snake_case` keys).
  factory Plan.fromSupabaseJson(Map<String, dynamic> row) {
    DateTime? parse(dynamic v) =>
        v == null ? null : DateTime.tryParse(v.toString());

    return Plan(
      id: row['id']?.toString(),
      businessId: row['business_id']?.toString(),
      branchId: row['branch_id']?.toString(),
      selectedPlan: row['selected_plan']?.toString(),
      additionalDevices: (row['additional_devices'] as num?)?.toInt(),
      isYearlyPlan: row['is_yearly_plan'] as bool?,
      totalPrice: (row['total_price'] as num?)?.toInt(),
      createdAt: parse(row['created_at']),
      paymentCompletedByUser:
          row['payment_completed_by_user'] as bool? ?? false,
      rule: row['rule']?.toString(),
      paymentMethod: row['payment_method']?.toString(),
      nextBillingDate: parse(row['next_billing_date']),
      numberOfPayments: (row['number_of_payments'] as num?)?.toInt(),
      phoneNumber: row['phone_number']?.toString(),
      externalId: row['external_id']?.toString(),
      paymentStatus: row['payment_status']?.toString(),
      lastProcessedAt: parse(row['last_processed_at']),
      lastError: row['last_error']?.toString(),
      updatedAt: parse(row['updated_at']),
      lastUpdated: parse(row['last_updated']),
      processingStatus: row['processing_status']?.toString(),
      lastPaymentDate: parse(row['last_payment_date']),
    );
  }
}
