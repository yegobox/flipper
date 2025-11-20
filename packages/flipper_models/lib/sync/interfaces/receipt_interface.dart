import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/db_model_export.dart';

abstract class ReceiptInterface {
  Future<Receipt?> createReceipt({
    required RwApiResponse signature,
    required DateTime whenCreated,
    required ITransaction transaction,
    required String qrCode,
    required String receiptType,
    required int highestInvcNo,
    required int invoiceNumber,
    required String timeReceivedFromserver,
  });
}
