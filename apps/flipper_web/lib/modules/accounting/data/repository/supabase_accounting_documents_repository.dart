import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/document_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_documents_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAccountingDocumentsRepository
    implements AccountingDocumentsRepository {
  const SupabaseAccountingDocumentsRepository(this._client);

  final SupabaseClient _client;

  static const _docsTable = 'accounting_documents';
  static const _contactsTable = 'accounting_contacts';

  static const _dittoOnlyKeys = {
    'businessId',
    'docKind',
    'docNumber',
    'partyName',
    'issueDate',
    'dueDate',
    'contactKind',
    'localId',
    'contactName',
    'sinceLabel',
  };

  static Map<String, dynamic> _forPostgrest(Map<String, dynamic> row) {
    final out = Map<String, dynamic>.from(row);
    for (final key in _dittoOnlyKeys) {
      out.remove(key);
    }
    return out;
  }

  @override
  Stream<List<AccountingDocument>> watchDocuments({
    required String businessId,
    required DocKind kind,
  }) {
    final kindDb = DocumentRowMapper.kindToDb(kind);
    return _client
        .from(_docsTable)
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
        .map((rows) => rows
            .where((r) => r['doc_kind'] == kindDb)
            .map(DocumentRowMapper.documentFromRow)
            .toList()
          ..sort((a, b) => b.id.compareTo(a.id)));
  }

  @override
  Future<void> upsertDocument({
    required String businessId,
    required DocKind kind,
    required AccountingDocument doc,
  }) async {
    final row = _forPostgrest(
      DocumentRowMapper.documentToRow(
        businessId: businessId,
        kind: kind,
        doc: doc,
        id: doc.uuid,
      ),
    );
    await _client.from(_docsTable).upsert(
      row,
      onConflict: 'business_id,doc_kind,doc_number',
    );
  }

  @override
  Future<void> deleteDocument({
    required String businessId,
    required DocKind kind,
    required String docNumber,
  }) async {
    await _client
        .from(_docsTable)
        .delete()
        .eq('business_id', businessId)
        .eq('doc_kind', DocumentRowMapper.kindToDb(kind))
        .eq('doc_number', docNumber);
  }

  @override
  Stream<List<AccountingContact>> watchContacts({
    required String businessId,
    required bool isCustomer,
  }) {
    final kindDb = isCustomer ? 'customer' : 'supplier';
    return _client
        .from(_contactsTable)
        .stream(primaryKey: ['id'])
        .eq('business_id', businessId)
        .map((rows) => rows
            .where((r) => r['contact_kind'] == kindDb)
            .map(DocumentRowMapper.contactFromRow)
            .toList()
          ..sort((a, b) => a.name.compareTo(b.name)));
  }

  @override
  Future<void> upsertContact({
    required String businessId,
    required bool isCustomer,
    required AccountingContact contact,
  }) async {
    final row = _forPostgrest(
      DocumentRowMapper.contactToRow(
        businessId: businessId,
        isCustomer: isCustomer,
        contact: contact,
        id: contact.uuid,
      ),
    );
    await _client.from(_contactsTable).upsert(
      row,
      onConflict: 'business_id,contact_kind,local_id',
    );
  }

  @override
  Future<void> deleteContact({
    required String businessId,
    required String contactId,
  }) async {
    await _client.from(_contactsTable).delete().eq('id', contactId);
  }
}
