import 'package:flipper_models/sync/interfaces/receipt_interface.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaReceiptMixin implements ReceiptInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Receipt?> createReceipt({
    required RwApiResponse signature,
    required DateTime whenCreated,
    required ITransaction transaction,
    required String qrCode,
    required String receiptType,
    required Counter counter,
    required int invoiceNumber,
  }) async {
    throw UnimplementedError(
        'createReceipt needs to be implemented for Capella');
  }
}
