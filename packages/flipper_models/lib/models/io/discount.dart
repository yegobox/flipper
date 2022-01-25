import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class DiscountSync {
  DiscountSync(
      {this.id = 0, required this.name, this.amount, required this.branchId});
  @Id(assignable: true)
  int id;
  String name;

  /// this is to get ready when there will be option for percentage instead of amount!
  int? amount;
  int branchId;

  factory DiscountSync.fromJson(Map<String, dynamic> json) => DiscountSync(
      id: json['id'],
      name: json['name'],
      amount: json['amount'],
      branchId: json['branchId']);

  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "amount": amount, "branchId": branchId};
}
