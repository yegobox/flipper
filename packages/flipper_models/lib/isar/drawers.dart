import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:pocketbase/pocketbase.dart';

part 'drawers.g.dart';

@JsonSerializable()
@Collection()
class Drawers extends IJsonSerializable {
  Id? id;
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
  // @Index(composite:  ['cashierId'])
  late bool open;

  Drawers({
    required this.id,
    required this.openingBalance,
    required this.closingBalance,
    this.openingDateTime,
    this.closingDateTime,
    this.csSaleCount,
    this.tradeName,
    this.totalNsSaleIncome,
    this.totalCsSaleIncome,
    this.nrSaleCount,
    this.nsSaleCount,
    this.trSaleCount,
    this.psSaleCount,
    this.incompleteSale,
    this.otherTransactions,
    this.paymentMode,
    required this.cashierId,
    required this.open,
  });
  factory Drawers.fromRecord(RecordModel record) =>
      Drawers.fromJson(record.toJson());

  factory Drawers.fromJson(Map<String, dynamic> json) =>
      _$DrawersFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$DrawersToJson(this);
}
