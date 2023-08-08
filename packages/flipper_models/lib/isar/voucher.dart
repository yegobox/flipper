import 'package:isar/isar.dart';
part 'voucher.g.dart';

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
  late String id;
  int? value;
  int? interval;
  bool? used;
  int? createdAt;
  int? usedAt;
  String? descriptor;
}
