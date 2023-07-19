// update existing model to support EBM API?
// -> if we update existing model then this means we are tied to one EBM or RW.
// -> then we need different way to adopt to every EBM of every country.
// -> It is important to know that the EBM data will be posted to respective EBM. of the country.
// -> so we need to know which EBM we are using.
// -> it is okey to use existing model but mapp key when posting to respective EBM.
// ->

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/isar/receipt_signature.dart';

abstract class TaxApi {
  Future<bool> saveItem({required Variant variation});
  Future<bool> saveStock({required Stock stock});
  Future<bool> initApi({
    required String tinNumber,
    required String bhfId,
    required String dvcSrlNo,
  });
  Future<bool> selectItems({
    required String tinNumber,
    required String bhfId,
    String lastReqDt,
  });
  // Right now saving purchase is not supported.
  // will do later. (umuntu avuye kurangura.)
  // Future<bool> savePurchases({
  //   required Transaction transaction,
  //   required List<TransactionItem> items,
  // });
  Future<ReceiptSignature?> createReceipt(
      {Customer? customer,
      required Transaction transaction,
      required List<TransactionItem> items,
      required String receiptType,
      required Counter counter});
}
