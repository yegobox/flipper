import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'drawers'),
)
class Drawers extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  double? openingBalance;
  double? closingBalance;
  DateTime? openingDateTime;
  DateTime? closingDateTime;
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
    String? id,
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
  }) : id = id ?? const Uuid().v4();
}
