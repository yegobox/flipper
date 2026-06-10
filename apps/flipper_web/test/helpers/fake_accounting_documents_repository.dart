import 'dart:async';

import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/repository/accounting_documents_repository.dart';

class FakeAccountingDocumentsRepository implements AccountingDocumentsRepository {
  FakeAccountingDocumentsRepository({
    List<AccountingDocument>? documents,
    List<AccountingContact>? customerContacts,
    List<AccountingContact>? supplierContacts,
  })  : _documents = documents ?? [],
        _customerContacts = customerContacts ?? [],
        _supplierContacts = supplierContacts ?? [];

  final List<AccountingDocument> _documents;
  final List<AccountingContact> _customerContacts;
  final List<AccountingContact> _supplierContacts;

  List<AccountingContact> contactsFor({required bool isCustomer}) =>
      List.unmodifiable(isCustomer ? _customerContacts : _supplierContacts);

  @override
  Stream<List<AccountingDocument>> watchDocuments({
    required String businessId,
    required DocKind kind,
  }) {
    return Stream.value(List<AccountingDocument>.from(_documents));
  }

  @override
  Future<void> upsertDocument({
    required String businessId,
    required DocKind kind,
    required AccountingDocument doc,
  }) async {
    _documents.removeWhere((d) => d.id == doc.id);
    _documents.add(doc);
  }

  @override
  Future<void> deleteDocument({
    required String businessId,
    required DocKind kind,
    required String docNumber,
  }) async {
    _documents.removeWhere((d) => d.id == docNumber);
  }

  @override
  Stream<List<AccountingContact>> watchContacts({
    required String businessId,
    required bool isCustomer,
  }) {
    return Stream.value(contactsFor(isCustomer: isCustomer));
  }

  @override
  Future<void> upsertContact({
    required String businessId,
    required bool isCustomer,
    required AccountingContact contact,
  }) async {
    final list = isCustomer ? _customerContacts : _supplierContacts;
    list.removeWhere((c) => c.id == contact.id);
    list.add(contact);
  }

  @override
  Future<void> deleteContact({
    required String businessId,
    required String contactId,
  }) async {
    _customerContacts.removeWhere((c) => c.uuid == contactId);
    _supplierContacts.removeWhere((c) => c.uuid == contactId);
  }
}
