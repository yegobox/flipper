import 'package:flipper_models/isar_models.dart';

part 'drawer.g.dart';

@Collection()
class Drawers {
  late int id = Isar.autoIncrement;
  late double openingBalance;
  late double closingBalance;
  String? openingDateTime;
  String? closingDateTime;
  int? csSaleCount;
  String? tradeName;
  double? totalNsSaleIncome;
  double? totalCsSaleIncome;
  int? nrSaleCount;
  int? nsSaleCount;
  int? trSaleCount;
  int? psSaleCount;
  int? incompleteSale;
  int? otherTransactions;
  String? paymentMode;
  @Index()
  late int cashierId;
  @Index(composite: [CompositeIndex('cashierId')])
  late bool open;
}
