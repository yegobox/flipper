// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'realmITransaction.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class RealmITransaction extends _RealmITransaction
    with RealmEntity, RealmObjectBase, RealmObject {
  RealmITransaction(
    String id,
    String reference,
    String transactionNumber,
    int branchId,
    String status,
    String transactionType,
    double subTotal,
    String paymentType,
    double cashReceived,
    double customerChangeDue,
    String createdAt,
    String action, {
    String? categoryId,
    String? receiptType,
    String? updatedAt,
    String? customerId,
    String? note,
    DateTime? lastTouched,
    String? ticketName,
    DateTime? deletedAt,
    int? retailerId,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'reference', reference);
    RealmObjectBase.set(this, 'categoryId', categoryId);
    RealmObjectBase.set(this, 'transactionNumber', transactionNumber);
    RealmObjectBase.set(this, 'branchId', branchId);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'transactionType', transactionType);
    RealmObjectBase.set(this, 'subTotal', subTotal);
    RealmObjectBase.set(this, 'paymentType', paymentType);
    RealmObjectBase.set(this, 'cashReceived', cashReceived);
    RealmObjectBase.set(this, 'customerChangeDue', customerChangeDue);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'receiptType', receiptType);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'customerId', customerId);
    RealmObjectBase.set(this, 'note', note);
    RealmObjectBase.set(this, 'lastTouched', lastTouched);
    RealmObjectBase.set(this, 'action', action);
    RealmObjectBase.set(this, 'ticketName', ticketName);
    RealmObjectBase.set(this, 'deletedAt', deletedAt);
    RealmObjectBase.set(this, 'retailerId', retailerId);
  }

  RealmITransaction._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;
  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get reference =>
      RealmObjectBase.get<String>(this, 'reference') as String;
  @override
  set reference(String value) => RealmObjectBase.set(this, 'reference', value);

  @override
  String? get categoryId =>
      RealmObjectBase.get<String>(this, 'categoryId') as String?;
  @override
  set categoryId(String? value) =>
      RealmObjectBase.set(this, 'categoryId', value);

  @override
  String get transactionNumber =>
      RealmObjectBase.get<String>(this, 'transactionNumber') as String;
  @override
  set transactionNumber(String value) =>
      RealmObjectBase.set(this, 'transactionNumber', value);

  @override
  int get branchId => RealmObjectBase.get<int>(this, 'branchId') as int;
  @override
  set branchId(int value) => RealmObjectBase.set(this, 'branchId', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;
  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  String get transactionType =>
      RealmObjectBase.get<String>(this, 'transactionType') as String;
  @override
  set transactionType(String value) =>
      RealmObjectBase.set(this, 'transactionType', value);

  @override
  double get subTotal =>
      RealmObjectBase.get<double>(this, 'subTotal') as double;
  @override
  set subTotal(double value) => RealmObjectBase.set(this, 'subTotal', value);

  @override
  String get paymentType =>
      RealmObjectBase.get<String>(this, 'paymentType') as String;
  @override
  set paymentType(String value) =>
      RealmObjectBase.set(this, 'paymentType', value);

  @override
  double get cashReceived =>
      RealmObjectBase.get<double>(this, 'cashReceived') as double;
  @override
  set cashReceived(double value) =>
      RealmObjectBase.set(this, 'cashReceived', value);

  @override
  double get customerChangeDue =>
      RealmObjectBase.get<double>(this, 'customerChangeDue') as double;
  @override
  set customerChangeDue(double value) =>
      RealmObjectBase.set(this, 'customerChangeDue', value);

  @override
  String get createdAt =>
      RealmObjectBase.get<String>(this, 'createdAt') as String;
  @override
  set createdAt(String value) => RealmObjectBase.set(this, 'createdAt', value);

  @override
  String? get receiptType =>
      RealmObjectBase.get<String>(this, 'receiptType') as String?;
  @override
  set receiptType(String? value) =>
      RealmObjectBase.set(this, 'receiptType', value);

  @override
  String? get updatedAt =>
      RealmObjectBase.get<String>(this, 'updatedAt') as String?;
  @override
  set updatedAt(String? value) => RealmObjectBase.set(this, 'updatedAt', value);

  @override
  String? get customerId =>
      RealmObjectBase.get<String>(this, 'customerId') as String?;
  @override
  set customerId(String? value) =>
      RealmObjectBase.set(this, 'customerId', value);

  @override
  String? get note => RealmObjectBase.get<String>(this, 'note') as String?;
  @override
  set note(String? value) => RealmObjectBase.set(this, 'note', value);

  @override
  DateTime? get lastTouched =>
      RealmObjectBase.get<DateTime>(this, 'lastTouched') as DateTime?;
  @override
  set lastTouched(DateTime? value) =>
      RealmObjectBase.set(this, 'lastTouched', value);

  @override
  String get action => RealmObjectBase.get<String>(this, 'action') as String;
  @override
  set action(String value) => RealmObjectBase.set(this, 'action', value);

  @override
  String? get ticketName =>
      RealmObjectBase.get<String>(this, 'ticketName') as String?;
  @override
  set ticketName(String? value) =>
      RealmObjectBase.set(this, 'ticketName', value);

  @override
  DateTime? get deletedAt =>
      RealmObjectBase.get<DateTime>(this, 'deletedAt') as DateTime?;
  @override
  set deletedAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deletedAt', value);

  @override
  int? get retailerId => RealmObjectBase.get<int>(this, 'retailerId') as int?;
  @override
  set retailerId(int? value) => RealmObjectBase.set(this, 'retailerId', value);

  @override
  Stream<RealmObjectChanges<RealmITransaction>> get changes =>
      RealmObjectBase.getChanges<RealmITransaction>(this);

  @override
  RealmITransaction freeze() =>
      RealmObjectBase.freezeObject<RealmITransaction>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RealmITransaction._);
    return const SchemaObject(
        ObjectType.realmObject, RealmITransaction, 'RealmITransaction', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('reference', RealmPropertyType.string),
      SchemaProperty('categoryId', RealmPropertyType.string, optional: true),
      SchemaProperty('transactionNumber', RealmPropertyType.string),
      SchemaProperty('branchId', RealmPropertyType.int),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('transactionType', RealmPropertyType.string),
      SchemaProperty('subTotal', RealmPropertyType.double),
      SchemaProperty('paymentType', RealmPropertyType.string),
      SchemaProperty('cashReceived', RealmPropertyType.double),
      SchemaProperty('customerChangeDue', RealmPropertyType.double),
      SchemaProperty('createdAt', RealmPropertyType.string),
      SchemaProperty('receiptType', RealmPropertyType.string, optional: true),
      SchemaProperty('updatedAt', RealmPropertyType.string, optional: true),
      SchemaProperty('customerId', RealmPropertyType.string, optional: true),
      SchemaProperty('note', RealmPropertyType.string, optional: true),
      SchemaProperty('lastTouched', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('action', RealmPropertyType.string),
      SchemaProperty('ticketName', RealmPropertyType.string, optional: true),
      SchemaProperty('deletedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('retailerId', RealmPropertyType.int, optional: true),
    ]);
  }
}
