import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/document_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_documents_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';

class DittoAccountingDocumentsRepository implements AccountingDocumentsRepository {
  DittoAccountingDocumentsRepository(this._ditto);

  final DittoService _ditto;

  @override
  Stream<List<AccountingDocument>> watchDocuments({
    required String businessId,
    required DocKind kind,
  }) {
    final kindDb = DocumentRowMapper.kindToDb(kind);
    return _ditto
        .watchCollection(
          'accounting_documents',
          'SELECT * FROM accounting_documents WHERE businessId = :businessId AND docKind = :kind',
          {'businessId': businessId, 'kind': kindDb},
        )
        .map((rows) => rows.map(DocumentRowMapper.documentFromRow).toList()
          ..sort((a, b) => b.id.compareTo(a.id)));
  }

  @override
  Future<void> upsertDocument({
    required String businessId,
    required DocKind kind,
    required AccountingDocument doc,
  }) async {
    final docId = doc.uuid ??
        '${businessId}_${DocumentRowMapper.kindToDb(kind)}_${doc.id}';
    final row = DocumentRowMapper.documentToRow(
      businessId: businessId,
      kind: kind,
      doc: doc,
      id: docId,
    );
    await _ditto.upsertAccountingDocument(businessId, row, docId);
  }

  @override
  Future<void> deleteDocument({
    required String businessId,
    required DocKind kind,
    required String docNumber,
  }) async {
    final docId = '${businessId}_${DocumentRowMapper.kindToDb(kind)}_$docNumber';
    await _ditto.deleteAccountingDocument(docId);
  }

  @override
  Stream<List<AccountingContact>> watchContacts({
    required String businessId,
    required bool isCustomer,
  }) {
    final kindDb = isCustomer ? 'customer' : 'supplier';
    return _ditto
        .watchCollection(
          'accounting_contacts',
          'SELECT * FROM accounting_contacts WHERE businessId = :businessId AND contactKind = :kind',
          {'businessId': businessId, 'kind': kindDb},
        )
        .map((rows) => rows.map(DocumentRowMapper.contactFromRow).toList()
          ..sort((a, b) => a.name.compareTo(b.name)));
  }

  @override
  Future<void> upsertContact({
    required String businessId,
    required bool isCustomer,
    required AccountingContact contact,
  }) async {
    final docId = contact.uuid ??
        '${businessId}_${isCustomer ? 'customer' : 'supplier'}_${contact.id}';
    final row = DocumentRowMapper.contactToRow(
      businessId: businessId,
      isCustomer: isCustomer,
      contact: contact,
      id: docId,
    );
    await _ditto.upsertAccountingContact(businessId, row, docId);
  }

  @override
  Future<void> deleteContact({
    required String businessId,
    required String contactId,
  }) async {
    await _ditto.deleteAccountingContact(contactId);
  }
}
