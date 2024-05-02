import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/isar/receipt_signature.dart';

abstract class TaxApi {
  Future<bool> saveStock({required Stock stock});
  Future saveCustomer({required Customer customer});
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

  Future<EBMApiResponse?> generateReceiptSignature({
    required ITransaction transaction,
    required List<TransactionItem> items,
    required String receiptType,
    required Counter counter,
    String? purchaseCode,
  });
  Future<bool> saveItem({required Variant variation});
}
