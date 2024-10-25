import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher.freezed.dart';
part 'voucher.g.dart';

@freezed
class Voucher with _$Voucher {
  const factory Voucher({
    int? id,
    int? value,
    int? interval,
    bool? used,
    int? createdAt,
    int? usedAt,
    String? descriptor,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, dynamic> json) =>
      _$VoucherFromJson(json);
}
