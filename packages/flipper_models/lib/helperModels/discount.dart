import 'package:json_annotation/json_annotation.dart';

part 'discount.g.dart';

@JsonSerializable()
class Discount {
  Discount(
      {required this.id,
      required this.name,
      this.amount,
      required this.branchId});

  int? id;
  late String name;

  /// this is to get ready when there will be option for percentage instead of amount!
  late double? amount;

  late int branchId;
}
