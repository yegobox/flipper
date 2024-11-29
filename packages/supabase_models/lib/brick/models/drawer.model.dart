import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'drawers'),
)
class Drawers extends OfflineFirstWithSupabaseModel {
  @Sqlite(unique: true)
  final int id;

  double? openingBalance;
  double? closingBalance;
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
  int? cashierId; // the userId owning this drawer
  bool? open;
  DateTime? deletedAt;
  int? businessId;
  int? branchId;
  Drawers({
    required this.id,
    this.openingBalance,
    this.closingBalance,
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
    this.cashierId,
    this.open,
    this.deletedAt,
    this.businessId,
    this.branchId,
  });
}
