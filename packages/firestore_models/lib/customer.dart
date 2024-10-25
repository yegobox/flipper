import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.freezed.dart';
part 'customer.g.dart';

@freezed
class Customer with _$Customer {
  const factory Customer({
    int? id,
    String? custNm,
    String? email,
    String? telNo,
    String? adrs,
    int? branchId,
    DateTime? updatedAt,
    String? custNo,
    String? custTin,
    String? regrNm,
    String? regrId,
    @Default("284746303937") String modrNm,
    String? modrId,
    @Default(false) bool ebmSynced,
    DateTime? lastTouched,
    DateTime? deletedAt,
    int? tin,
    String? bhfId,
    String? useYn,
    String? customerType,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}
