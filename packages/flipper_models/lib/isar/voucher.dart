import 'package:isar/isar.dart';
part 'voucher.g.dart';

@Collection()
class Voucher {
  Id id = Isar.autoIncrement;
  late int value;
  late int interval;
  late bool used;
  late int createdAt;
  late int usedAt;
  late String descriptor;
}
