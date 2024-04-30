import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
part 'voucher.g.dart';

@JsonSerializable()
@Collection()
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
  Id? id;
  int? value;
  int? interval;
  bool? used;
  int? createdAt;
  int? usedAt;
  String? descriptor;
}
