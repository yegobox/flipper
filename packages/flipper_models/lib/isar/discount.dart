import 'package:isar/isar.dart';

part 'discount.g.dart';

@Collection()
class Discount {
  Discount(
      {this.id = 0, required this.name, this.amount, required this.branchId});

  Id id = Isar.autoIncrement;
  late String name;

  /// this is to get ready when there will be option for percentage instead of amount!
  late double? amount;
  @Index()
  late int branchId;

  factory Discount.fromJson(Map<String, dynamic> json) => Discount(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      branchId: json['branchId']);

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "amount": amount, "branchId": branchId};
}
