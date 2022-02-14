import 'package:isar/isar.dart';

part 'discount.g.dart';

@Collection()
class DiscountSync {
  DiscountSync(
      {this.id = 0, required this.name, this.amount, required this.branchId});

  late int id = Isar.autoIncrement;
  late String name;

  /// this is to get ready when there will be option for percentage instead of amount!
  late int? amount;
  late int branchId;

  factory DiscountSync.fromJson(Map<String, dynamic> json) => DiscountSync(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      branchId: json['branchId']);

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "amount": amount, "branchId": branchId};
}
