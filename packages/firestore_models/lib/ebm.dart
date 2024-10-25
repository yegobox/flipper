import 'package:freezed_annotation/freezed_annotation.dart';

part 'ebm.freezed.dart';
part 'ebm.g.dart';

@freezed
class EBM with _$EBM {
  const factory EBM({
    int? id,
    required String bhfId,
    required int tinNumber,
    required String dvcSrlNo,
    required int userId,
    String? taxServerUrl,
    required int businessId,
    required int branchId,
    DateTime? lastTouched,
    required String action,
  }) = _EBM;

  factory EBM.fromJson(Map<String, dynamic> json) => _$EBMFromJson(json);
}
