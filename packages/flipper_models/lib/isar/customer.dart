import 'package:isar/isar.dart';

part 'customer.g.dart';

@Collection()
class Customer {
  Id id = Isar.autoIncrement;
  late String name;
  late String email;
  late String phone;
  String? address;
  late int transactionId;
  late int branchId;
  String? updatedAt;
  String? tinNumber;
}
