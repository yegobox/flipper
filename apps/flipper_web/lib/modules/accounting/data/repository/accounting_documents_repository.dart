import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';

abstract class AccountingDocumentsRepository {
  Stream<List<AccountingDocument>> watchDocuments({
    required String businessId,
    required DocKind kind,
  });

  Future<void> upsertDocument({
    required String businessId,
    required DocKind kind,
    required AccountingDocument doc,
  });

  /// Deletes by [docId] (the loaded document's id) when given: numbers are
  /// not unique once two suppliers' bills share one.
  Future<void> deleteDocument({
    required String businessId,
    required DocKind kind,
    required String docNumber,
    String? docId,
  });

  Stream<List<AccountingContact>> watchContacts({
    required String businessId,
    required bool isCustomer,
  });

  Future<void> upsertContact({
    required String businessId,
    required bool isCustomer,
    required AccountingContact contact,
  });

  Future<void> deleteContact({
    required String businessId,
    required String contactId,
  });
}
