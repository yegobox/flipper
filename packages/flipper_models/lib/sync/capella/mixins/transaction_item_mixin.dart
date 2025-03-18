import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaTransactionItemMixin implements TransactionItemInterface {
  Repository get repository;
  Talker get talker;
  @override
  Future<void> addTransactionItem(
      {ITransaction? transaction,
      required bool partOfComposite,
      required DateTime lastTouched,
      required double discount,
      double? compositePrice,
      required double quantity,
      required double currentStock,
      Variant? variation,
      required double amountTotal,
      required String name,
      TransactionItem? item}) {
    // TODO: implement addTransactionItem
    throw UnimplementedError();
  }
}
