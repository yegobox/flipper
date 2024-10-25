import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_plan.freezed.dart';
part 'payment_plan.g.dart';

@freezed
class PaymentPlan with _$PaymentPlan {
  const factory PaymentPlan({
    int? id,
    int? businessId,
    String? selectedPlan,
    int? additionalDevices,
    bool? isYearlyPlan,
    double? totalPrice,
    DateTime? createdAt,
    @Default(false) bool? paymentCompletedByUser,
    int? payStackCustomerId,
    String? rule,
    String? paymentMethod,
    String? customerCode,
    String? payStackPlanId,
  }) = _PaymentPlan;

  factory PaymentPlan.fromJson(Map<String, dynamic> json) =>
      _$PaymentPlanFromJson(json);
}
