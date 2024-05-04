import 'package:json_annotation/json_annotation.dart';
part 'voucher.g.dart';

@JsonSerializable()
class Voucher {
  Voucher({
    required this.id,
    this.value,
    this.interval,
    this.used,
    this.createdAt,
    this.usedAt,
    this.descriptor,
  });
  int? id;
  int? value;
  int? interval;
  bool? used;
  int? createdAt;
  int? usedAt;
  String? descriptor;
}
