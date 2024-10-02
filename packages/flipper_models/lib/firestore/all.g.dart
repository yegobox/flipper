// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all.dart';

// **************************************************************************
// CollectionGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, require_trailing_commas, prefer_single_quotes, prefer_double_quotes, use_super_parameters, duplicate_ignore
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_internal_member

class _Sentinel {
  const _Sentinel();
}

const _sentinel = _Sentinel();

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class StockRequestCollectionReference
    implements
        StockRequestQuery,
        FirestoreCollectionReference<StockRequest, StockRequestQuerySnapshot> {
  factory StockRequestCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$StockRequestCollectionReference;

  static StockRequest fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return StockRequest.fromJson({'id': snapshot.id, ...?snapshot.data()});
  }

  static Map<String, Object?> toFirestore(
    StockRequest value,
    SetOptions? options,
  ) {
    return {...value.toJson()}..remove('id');
  }

  @override
  CollectionReference<StockRequest> get reference;

  @override
  StockRequestDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<StockRequestDocumentReference> add(StockRequest value);
}

class _$StockRequestCollectionReference extends _$StockRequestQuery
    implements StockRequestCollectionReference {
  factory _$StockRequestCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$StockRequestCollectionReference._(
      firestore.collection('stockRequests').withConverter(
            fromFirestore: StockRequestCollectionReference.fromFirestore,
            toFirestore: StockRequestCollectionReference.toFirestore,
          ),
    );
  }

  _$StockRequestCollectionReference._(
    CollectionReference<StockRequest> reference,
  ) : super(reference, $referenceWithoutCursor: reference);

  String get path => reference.path;

  @override
  CollectionReference<StockRequest> get reference =>
      super.reference as CollectionReference<StockRequest>;

  @override
  StockRequestDocumentReference doc([String? id]) {
    assert(
      id == null || id.split('/').length == 1,
      'The document ID cannot be from a different collection',
    );
    return StockRequestDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<StockRequestDocumentReference> add(StockRequest value) {
    return reference
        .add(value)
        .then((ref) => StockRequestDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$StockRequestCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class StockRequestDocumentReference extends FirestoreDocumentReference<
    StockRequest, StockRequestDocumentSnapshot> {
  factory StockRequestDocumentReference(
          DocumentReference<StockRequest> reference) =
      _$StockRequestDocumentReference;

  DocumentReference<StockRequest> get reference;

  /// A reference to the [StockRequestCollectionReference] containing this document.
  StockRequestCollectionReference get parent {
    return _$StockRequestCollectionReference(reference.firestore);
  }

  @override
  Stream<StockRequestDocumentSnapshot> snapshots();

  @override
  Future<StockRequestDocumentSnapshot> get([GetOptions? options]);

  @override
  Future<void> delete();

  /// Sets data on the document, overwriting any existing data. If the document
  /// does not yet exist, it will be created.
  ///
  /// If [SetOptions] are provided, the data can be merged into an existing
  /// document instead of overwriting.
  ///
  /// Any [FieldValue]s provided will replace the corresponding fields in the
  /// [model] during serialization.
  Future<void> set(
    StockRequest model, {
    SetOptions? options,
    FieldValue mainBranchIdFieldValue,
    FieldValue subBranchIdFieldValue,
    FieldValue createdAtFieldValue,
    FieldValue statusFieldValue,
    FieldValue deliveryDateFieldValue,
    FieldValue deliveryNoteFieldValue,
    FieldValue orderNoteFieldValue,
    FieldValue customerReceivedOrderFieldValue,
    FieldValue driverRequestDeliveryConfirmationFieldValue,
    FieldValue driverIdFieldValue,
    FieldValue itemsFieldValue,
    FieldValue updatedAtFieldValue,
  });

  /// Writes to the document using the transaction API.
  ///
  /// If the document does not exist yet, it will be created. If you pass
  /// [SetOptions], the provided data can be merged into the existing document.
  ///
  /// Any [FieldValue]s provided will replace the corresponding fields in the
  /// [model] during serialization.
  void transactionSet(
    Transaction transaction,
    StockRequest model, {
    SetOptions? options,
    FieldValue mainBranchIdFieldValue,
    FieldValue subBranchIdFieldValue,
    FieldValue createdAtFieldValue,
    FieldValue statusFieldValue,
    FieldValue deliveryDateFieldValue,
    FieldValue deliveryNoteFieldValue,
    FieldValue orderNoteFieldValue,
    FieldValue customerReceivedOrderFieldValue,
    FieldValue driverRequestDeliveryConfirmationFieldValue,
    FieldValue driverIdFieldValue,
    FieldValue itemsFieldValue,
    FieldValue updatedAtFieldValue,
  });

  /// Writes to the document using the batch API.
  ///
  /// If the document does not exist yet, it will be created. If you pass
  /// [SetOptions], the provided data can be merged into the existing document.
  ///
  /// Any [FieldValue]s provided will replace the corresponding fields in the
  /// [model] during serialization.
  void batchSet(
    WriteBatch batch,
    StockRequest model, {
    SetOptions? options,
    FieldValue mainBranchIdFieldValue,
    FieldValue subBranchIdFieldValue,
    FieldValue createdAtFieldValue,
    FieldValue statusFieldValue,
    FieldValue deliveryDateFieldValue,
    FieldValue deliveryNoteFieldValue,
    FieldValue orderNoteFieldValue,
    FieldValue customerReceivedOrderFieldValue,
    FieldValue driverRequestDeliveryConfirmationFieldValue,
    FieldValue driverIdFieldValue,
    FieldValue itemsFieldValue,
    FieldValue updatedAtFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int mainBranchId,
    FieldValue mainBranchIdFieldValue,
    int subBranchId,
    FieldValue subBranchIdFieldValue,
    DateTime createdAt,
    FieldValue createdAtFieldValue,
    String status,
    FieldValue statusFieldValue,
    DateTime? deliveryDate,
    FieldValue deliveryDateFieldValue,
    String? deliveryNote,
    FieldValue deliveryNoteFieldValue,
    String? orderNote,
    FieldValue orderNoteFieldValue,
    bool customerReceivedOrder,
    FieldValue customerReceivedOrderFieldValue,
    bool driverRequestDeliveryConfirmation,
    FieldValue driverRequestDeliveryConfirmationFieldValue,
    int? driverId,
    FieldValue driverIdFieldValue,
    List<TransactionItem> items,
    FieldValue itemsFieldValue,
    DateTime? updatedAt,
    FieldValue updatedAtFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int mainBranchId,
    FieldValue mainBranchIdFieldValue,
    int subBranchId,
    FieldValue subBranchIdFieldValue,
    DateTime createdAt,
    FieldValue createdAtFieldValue,
    String status,
    FieldValue statusFieldValue,
    DateTime? deliveryDate,
    FieldValue deliveryDateFieldValue,
    String? deliveryNote,
    FieldValue deliveryNoteFieldValue,
    String? orderNote,
    FieldValue orderNoteFieldValue,
    bool customerReceivedOrder,
    FieldValue customerReceivedOrderFieldValue,
    bool driverRequestDeliveryConfirmation,
    FieldValue driverRequestDeliveryConfirmationFieldValue,
    int? driverId,
    FieldValue driverIdFieldValue,
    List<TransactionItem> items,
    FieldValue itemsFieldValue,
    DateTime? updatedAt,
    FieldValue updatedAtFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int mainBranchId,
    FieldValue mainBranchIdFieldValue,
    int subBranchId,
    FieldValue subBranchIdFieldValue,
    DateTime createdAt,
    FieldValue createdAtFieldValue,
    String status,
    FieldValue statusFieldValue,
    DateTime? deliveryDate,
    FieldValue deliveryDateFieldValue,
    String? deliveryNote,
    FieldValue deliveryNoteFieldValue,
    String? orderNote,
    FieldValue orderNoteFieldValue,
    bool customerReceivedOrder,
    FieldValue customerReceivedOrderFieldValue,
    bool driverRequestDeliveryConfirmation,
    FieldValue driverRequestDeliveryConfirmationFieldValue,
    int? driverId,
    FieldValue driverIdFieldValue,
    List<TransactionItem> items,
    FieldValue itemsFieldValue,
    DateTime? updatedAt,
    FieldValue updatedAtFieldValue,
  });
}

class _$StockRequestDocumentReference extends FirestoreDocumentReference<
    StockRequest,
    StockRequestDocumentSnapshot> implements StockRequestDocumentReference {
  _$StockRequestDocumentReference(this.reference);

  @override
  final DocumentReference<StockRequest> reference;

  /// A reference to the [StockRequestCollectionReference] containing this document.
  StockRequestCollectionReference get parent {
    return _$StockRequestCollectionReference(reference.firestore);
  }

  @override
  Stream<StockRequestDocumentSnapshot> snapshots() {
    return reference.snapshots().map(StockRequestDocumentSnapshot._);
  }

  @override
  Future<StockRequestDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then(StockRequestDocumentSnapshot._);
  }

  @override
  Future<StockRequestDocumentSnapshot> transactionGet(Transaction transaction) {
    return transaction.get(reference).then(StockRequestDocumentSnapshot._);
  }

  Future<void> set(
    StockRequest model, {
    SetOptions? options,
    FieldValue? mainBranchIdFieldValue,
    FieldValue? subBranchIdFieldValue,
    FieldValue? createdAtFieldValue,
    FieldValue? statusFieldValue,
    FieldValue? deliveryDateFieldValue,
    FieldValue? deliveryNoteFieldValue,
    FieldValue? orderNoteFieldValue,
    FieldValue? customerReceivedOrderFieldValue,
    FieldValue? driverRequestDeliveryConfirmationFieldValue,
    FieldValue? driverIdFieldValue,
    FieldValue? itemsFieldValue,
    FieldValue? updatedAtFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (mainBranchIdFieldValue != null)
        _$StockRequestFieldMap['mainBranchId']!: mainBranchIdFieldValue,
      if (subBranchIdFieldValue != null)
        _$StockRequestFieldMap['subBranchId']!: subBranchIdFieldValue,
      if (createdAtFieldValue != null)
        _$StockRequestFieldMap['createdAt']!: createdAtFieldValue,
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (deliveryDateFieldValue != null)
        _$StockRequestFieldMap['deliveryDate']!: deliveryDateFieldValue,
      if (deliveryNoteFieldValue != null)
        _$StockRequestFieldMap['deliveryNote']!: deliveryNoteFieldValue,
      if (orderNoteFieldValue != null)
        _$StockRequestFieldMap['orderNote']!: orderNoteFieldValue,
      if (customerReceivedOrderFieldValue != null)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            customerReceivedOrderFieldValue,
      if (driverRequestDeliveryConfirmationFieldValue != null)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            driverRequestDeliveryConfirmationFieldValue,
      if (driverIdFieldValue != null)
        _$StockRequestFieldMap['driverId']!: driverIdFieldValue,
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updatedAtFieldValue != null)
        _$StockRequestFieldMap['updatedAt']!: updatedAtFieldValue,
    };

    final castedReference = reference.withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, options) => throw UnimplementedError(),
      toFirestore: (value, options) => value,
    );
    return castedReference.set(json, options);
  }

  void transactionSet(
    Transaction transaction,
    StockRequest model, {
    SetOptions? options,
    FieldValue? mainBranchIdFieldValue,
    FieldValue? subBranchIdFieldValue,
    FieldValue? createdAtFieldValue,
    FieldValue? statusFieldValue,
    FieldValue? deliveryDateFieldValue,
    FieldValue? deliveryNoteFieldValue,
    FieldValue? orderNoteFieldValue,
    FieldValue? customerReceivedOrderFieldValue,
    FieldValue? driverRequestDeliveryConfirmationFieldValue,
    FieldValue? driverIdFieldValue,
    FieldValue? itemsFieldValue,
    FieldValue? updatedAtFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (mainBranchIdFieldValue != null)
        _$StockRequestFieldMap['mainBranchId']!: mainBranchIdFieldValue,
      if (subBranchIdFieldValue != null)
        _$StockRequestFieldMap['subBranchId']!: subBranchIdFieldValue,
      if (createdAtFieldValue != null)
        _$StockRequestFieldMap['createdAt']!: createdAtFieldValue,
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (deliveryDateFieldValue != null)
        _$StockRequestFieldMap['deliveryDate']!: deliveryDateFieldValue,
      if (deliveryNoteFieldValue != null)
        _$StockRequestFieldMap['deliveryNote']!: deliveryNoteFieldValue,
      if (orderNoteFieldValue != null)
        _$StockRequestFieldMap['orderNote']!: orderNoteFieldValue,
      if (customerReceivedOrderFieldValue != null)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            customerReceivedOrderFieldValue,
      if (driverRequestDeliveryConfirmationFieldValue != null)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            driverRequestDeliveryConfirmationFieldValue,
      if (driverIdFieldValue != null)
        _$StockRequestFieldMap['driverId']!: driverIdFieldValue,
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updatedAtFieldValue != null)
        _$StockRequestFieldMap['updatedAt']!: updatedAtFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    StockRequest model, {
    SetOptions? options,
    FieldValue? mainBranchIdFieldValue,
    FieldValue? subBranchIdFieldValue,
    FieldValue? createdAtFieldValue,
    FieldValue? statusFieldValue,
    FieldValue? deliveryDateFieldValue,
    FieldValue? deliveryNoteFieldValue,
    FieldValue? orderNoteFieldValue,
    FieldValue? customerReceivedOrderFieldValue,
    FieldValue? driverRequestDeliveryConfirmationFieldValue,
    FieldValue? driverIdFieldValue,
    FieldValue? itemsFieldValue,
    FieldValue? updatedAtFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (mainBranchIdFieldValue != null)
        _$StockRequestFieldMap['mainBranchId']!: mainBranchIdFieldValue,
      if (subBranchIdFieldValue != null)
        _$StockRequestFieldMap['subBranchId']!: subBranchIdFieldValue,
      if (createdAtFieldValue != null)
        _$StockRequestFieldMap['createdAt']!: createdAtFieldValue,
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (deliveryDateFieldValue != null)
        _$StockRequestFieldMap['deliveryDate']!: deliveryDateFieldValue,
      if (deliveryNoteFieldValue != null)
        _$StockRequestFieldMap['deliveryNote']!: deliveryNoteFieldValue,
      if (orderNoteFieldValue != null)
        _$StockRequestFieldMap['orderNote']!: orderNoteFieldValue,
      if (customerReceivedOrderFieldValue != null)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            customerReceivedOrderFieldValue,
      if (driverRequestDeliveryConfirmationFieldValue != null)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            driverRequestDeliveryConfirmationFieldValue,
      if (driverIdFieldValue != null)
        _$StockRequestFieldMap['driverId']!: driverIdFieldValue,
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updatedAtFieldValue != null)
        _$StockRequestFieldMap['updatedAt']!: updatedAtFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? mainBranchId = _sentinel,
    FieldValue? mainBranchIdFieldValue,
    Object? subBranchId = _sentinel,
    FieldValue? subBranchIdFieldValue,
    Object? createdAt = _sentinel,
    FieldValue? createdAtFieldValue,
    Object? status = _sentinel,
    FieldValue? statusFieldValue,
    Object? deliveryDate = _sentinel,
    FieldValue? deliveryDateFieldValue,
    Object? deliveryNote = _sentinel,
    FieldValue? deliveryNoteFieldValue,
    Object? orderNote = _sentinel,
    FieldValue? orderNoteFieldValue,
    Object? customerReceivedOrder = _sentinel,
    FieldValue? customerReceivedOrderFieldValue,
    Object? driverRequestDeliveryConfirmation = _sentinel,
    FieldValue? driverRequestDeliveryConfirmationFieldValue,
    Object? driverId = _sentinel,
    FieldValue? driverIdFieldValue,
    Object? items = _sentinel,
    FieldValue? itemsFieldValue,
    Object? updatedAt = _sentinel,
    FieldValue? updatedAtFieldValue,
  }) async {
    assert(
      mainBranchId == _sentinel || mainBranchIdFieldValue == null,
      "Cannot specify both mainBranchId and mainBranchIdFieldValue",
    );
    assert(
      subBranchId == _sentinel || subBranchIdFieldValue == null,
      "Cannot specify both subBranchId and subBranchIdFieldValue",
    );
    assert(
      createdAt == _sentinel || createdAtFieldValue == null,
      "Cannot specify both createdAt and createdAtFieldValue",
    );
    assert(
      status == _sentinel || statusFieldValue == null,
      "Cannot specify both status and statusFieldValue",
    );
    assert(
      deliveryDate == _sentinel || deliveryDateFieldValue == null,
      "Cannot specify both deliveryDate and deliveryDateFieldValue",
    );
    assert(
      deliveryNote == _sentinel || deliveryNoteFieldValue == null,
      "Cannot specify both deliveryNote and deliveryNoteFieldValue",
    );
    assert(
      orderNote == _sentinel || orderNoteFieldValue == null,
      "Cannot specify both orderNote and orderNoteFieldValue",
    );
    assert(
      customerReceivedOrder == _sentinel ||
          customerReceivedOrderFieldValue == null,
      "Cannot specify both customerReceivedOrder and customerReceivedOrderFieldValue",
    );
    assert(
      driverRequestDeliveryConfirmation == _sentinel ||
          driverRequestDeliveryConfirmationFieldValue == null,
      "Cannot specify both driverRequestDeliveryConfirmation and driverRequestDeliveryConfirmationFieldValue",
    );
    assert(
      driverId == _sentinel || driverIdFieldValue == null,
      "Cannot specify both driverId and driverIdFieldValue",
    );
    assert(
      items == _sentinel || itemsFieldValue == null,
      "Cannot specify both items and itemsFieldValue",
    );
    assert(
      updatedAt == _sentinel || updatedAtFieldValue == null,
      "Cannot specify both updatedAt and updatedAtFieldValue",
    );
    final json = {
      if (mainBranchId != _sentinel)
        _$StockRequestFieldMap['mainBranchId']!:
            _$StockRequestPerFieldToJson.mainBranchId(mainBranchId as int),
      if (mainBranchIdFieldValue != null)
        _$StockRequestFieldMap['mainBranchId']!: mainBranchIdFieldValue,
      if (subBranchId != _sentinel)
        _$StockRequestFieldMap['subBranchId']!:
            _$StockRequestPerFieldToJson.subBranchId(subBranchId as int),
      if (subBranchIdFieldValue != null)
        _$StockRequestFieldMap['subBranchId']!: subBranchIdFieldValue,
      if (createdAt != _sentinel)
        _$StockRequestFieldMap['createdAt']!:
            _$StockRequestPerFieldToJson.createdAt(createdAt as DateTime),
      if (createdAtFieldValue != null)
        _$StockRequestFieldMap['createdAt']!: createdAtFieldValue,
      if (status != _sentinel)
        _$StockRequestFieldMap['status']!:
            _$StockRequestPerFieldToJson.status(status as String),
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (deliveryDate != _sentinel)
        _$StockRequestFieldMap['deliveryDate']!: _$StockRequestPerFieldToJson
            .deliveryDate(deliveryDate as DateTime?),
      if (deliveryDateFieldValue != null)
        _$StockRequestFieldMap['deliveryDate']!: deliveryDateFieldValue,
      if (deliveryNote != _sentinel)
        _$StockRequestFieldMap['deliveryNote']!:
            _$StockRequestPerFieldToJson.deliveryNote(deliveryNote as String?),
      if (deliveryNoteFieldValue != null)
        _$StockRequestFieldMap['deliveryNote']!: deliveryNoteFieldValue,
      if (orderNote != _sentinel)
        _$StockRequestFieldMap['orderNote']!:
            _$StockRequestPerFieldToJson.orderNote(orderNote as String?),
      if (orderNoteFieldValue != null)
        _$StockRequestFieldMap['orderNote']!: orderNoteFieldValue,
      if (customerReceivedOrder != _sentinel)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            _$StockRequestPerFieldToJson
                .customerReceivedOrder(customerReceivedOrder as bool),
      if (customerReceivedOrderFieldValue != null)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            customerReceivedOrderFieldValue,
      if (driverRequestDeliveryConfirmation != _sentinel)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            _$StockRequestPerFieldToJson.driverRequestDeliveryConfirmation(
                driverRequestDeliveryConfirmation as bool),
      if (driverRequestDeliveryConfirmationFieldValue != null)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            driverRequestDeliveryConfirmationFieldValue,
      if (driverId != _sentinel)
        _$StockRequestFieldMap['driverId']!:
            _$StockRequestPerFieldToJson.driverId(driverId as int?),
      if (driverIdFieldValue != null)
        _$StockRequestFieldMap['driverId']!: driverIdFieldValue,
      if (items != _sentinel)
        _$StockRequestFieldMap['items']!:
            _$StockRequestPerFieldToJson.items(items as List<TransactionItem>),
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updatedAt != _sentinel)
        _$StockRequestFieldMap['updatedAt']!:
            _$StockRequestPerFieldToJson.updatedAt(updatedAt as DateTime?),
      if (updatedAtFieldValue != null)
        _$StockRequestFieldMap['updatedAt']!: updatedAtFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? mainBranchId = _sentinel,
    FieldValue? mainBranchIdFieldValue,
    Object? subBranchId = _sentinel,
    FieldValue? subBranchIdFieldValue,
    Object? createdAt = _sentinel,
    FieldValue? createdAtFieldValue,
    Object? status = _sentinel,
    FieldValue? statusFieldValue,
    Object? deliveryDate = _sentinel,
    FieldValue? deliveryDateFieldValue,
    Object? deliveryNote = _sentinel,
    FieldValue? deliveryNoteFieldValue,
    Object? orderNote = _sentinel,
    FieldValue? orderNoteFieldValue,
    Object? customerReceivedOrder = _sentinel,
    FieldValue? customerReceivedOrderFieldValue,
    Object? driverRequestDeliveryConfirmation = _sentinel,
    FieldValue? driverRequestDeliveryConfirmationFieldValue,
    Object? driverId = _sentinel,
    FieldValue? driverIdFieldValue,
    Object? items = _sentinel,
    FieldValue? itemsFieldValue,
    Object? updatedAt = _sentinel,
    FieldValue? updatedAtFieldValue,
  }) {
    assert(
      mainBranchId == _sentinel || mainBranchIdFieldValue == null,
      "Cannot specify both mainBranchId and mainBranchIdFieldValue",
    );
    assert(
      subBranchId == _sentinel || subBranchIdFieldValue == null,
      "Cannot specify both subBranchId and subBranchIdFieldValue",
    );
    assert(
      createdAt == _sentinel || createdAtFieldValue == null,
      "Cannot specify both createdAt and createdAtFieldValue",
    );
    assert(
      status == _sentinel || statusFieldValue == null,
      "Cannot specify both status and statusFieldValue",
    );
    assert(
      deliveryDate == _sentinel || deliveryDateFieldValue == null,
      "Cannot specify both deliveryDate and deliveryDateFieldValue",
    );
    assert(
      deliveryNote == _sentinel || deliveryNoteFieldValue == null,
      "Cannot specify both deliveryNote and deliveryNoteFieldValue",
    );
    assert(
      orderNote == _sentinel || orderNoteFieldValue == null,
      "Cannot specify both orderNote and orderNoteFieldValue",
    );
    assert(
      customerReceivedOrder == _sentinel ||
          customerReceivedOrderFieldValue == null,
      "Cannot specify both customerReceivedOrder and customerReceivedOrderFieldValue",
    );
    assert(
      driverRequestDeliveryConfirmation == _sentinel ||
          driverRequestDeliveryConfirmationFieldValue == null,
      "Cannot specify both driverRequestDeliveryConfirmation and driverRequestDeliveryConfirmationFieldValue",
    );
    assert(
      driverId == _sentinel || driverIdFieldValue == null,
      "Cannot specify both driverId and driverIdFieldValue",
    );
    assert(
      items == _sentinel || itemsFieldValue == null,
      "Cannot specify both items and itemsFieldValue",
    );
    assert(
      updatedAt == _sentinel || updatedAtFieldValue == null,
      "Cannot specify both updatedAt and updatedAtFieldValue",
    );
    final json = {
      if (mainBranchId != _sentinel)
        _$StockRequestFieldMap['mainBranchId']!:
            _$StockRequestPerFieldToJson.mainBranchId(mainBranchId as int),
      if (mainBranchIdFieldValue != null)
        _$StockRequestFieldMap['mainBranchId']!: mainBranchIdFieldValue,
      if (subBranchId != _sentinel)
        _$StockRequestFieldMap['subBranchId']!:
            _$StockRequestPerFieldToJson.subBranchId(subBranchId as int),
      if (subBranchIdFieldValue != null)
        _$StockRequestFieldMap['subBranchId']!: subBranchIdFieldValue,
      if (createdAt != _sentinel)
        _$StockRequestFieldMap['createdAt']!:
            _$StockRequestPerFieldToJson.createdAt(createdAt as DateTime),
      if (createdAtFieldValue != null)
        _$StockRequestFieldMap['createdAt']!: createdAtFieldValue,
      if (status != _sentinel)
        _$StockRequestFieldMap['status']!:
            _$StockRequestPerFieldToJson.status(status as String),
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (deliveryDate != _sentinel)
        _$StockRequestFieldMap['deliveryDate']!: _$StockRequestPerFieldToJson
            .deliveryDate(deliveryDate as DateTime?),
      if (deliveryDateFieldValue != null)
        _$StockRequestFieldMap['deliveryDate']!: deliveryDateFieldValue,
      if (deliveryNote != _sentinel)
        _$StockRequestFieldMap['deliveryNote']!:
            _$StockRequestPerFieldToJson.deliveryNote(deliveryNote as String?),
      if (deliveryNoteFieldValue != null)
        _$StockRequestFieldMap['deliveryNote']!: deliveryNoteFieldValue,
      if (orderNote != _sentinel)
        _$StockRequestFieldMap['orderNote']!:
            _$StockRequestPerFieldToJson.orderNote(orderNote as String?),
      if (orderNoteFieldValue != null)
        _$StockRequestFieldMap['orderNote']!: orderNoteFieldValue,
      if (customerReceivedOrder != _sentinel)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            _$StockRequestPerFieldToJson
                .customerReceivedOrder(customerReceivedOrder as bool),
      if (customerReceivedOrderFieldValue != null)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            customerReceivedOrderFieldValue,
      if (driverRequestDeliveryConfirmation != _sentinel)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            _$StockRequestPerFieldToJson.driverRequestDeliveryConfirmation(
                driverRequestDeliveryConfirmation as bool),
      if (driverRequestDeliveryConfirmationFieldValue != null)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            driverRequestDeliveryConfirmationFieldValue,
      if (driverId != _sentinel)
        _$StockRequestFieldMap['driverId']!:
            _$StockRequestPerFieldToJson.driverId(driverId as int?),
      if (driverIdFieldValue != null)
        _$StockRequestFieldMap['driverId']!: driverIdFieldValue,
      if (items != _sentinel)
        _$StockRequestFieldMap['items']!:
            _$StockRequestPerFieldToJson.items(items as List<TransactionItem>),
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updatedAt != _sentinel)
        _$StockRequestFieldMap['updatedAt']!:
            _$StockRequestPerFieldToJson.updatedAt(updatedAt as DateTime?),
      if (updatedAtFieldValue != null)
        _$StockRequestFieldMap['updatedAt']!: updatedAtFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? mainBranchId = _sentinel,
    FieldValue? mainBranchIdFieldValue,
    Object? subBranchId = _sentinel,
    FieldValue? subBranchIdFieldValue,
    Object? createdAt = _sentinel,
    FieldValue? createdAtFieldValue,
    Object? status = _sentinel,
    FieldValue? statusFieldValue,
    Object? deliveryDate = _sentinel,
    FieldValue? deliveryDateFieldValue,
    Object? deliveryNote = _sentinel,
    FieldValue? deliveryNoteFieldValue,
    Object? orderNote = _sentinel,
    FieldValue? orderNoteFieldValue,
    Object? customerReceivedOrder = _sentinel,
    FieldValue? customerReceivedOrderFieldValue,
    Object? driverRequestDeliveryConfirmation = _sentinel,
    FieldValue? driverRequestDeliveryConfirmationFieldValue,
    Object? driverId = _sentinel,
    FieldValue? driverIdFieldValue,
    Object? items = _sentinel,
    FieldValue? itemsFieldValue,
    Object? updatedAt = _sentinel,
    FieldValue? updatedAtFieldValue,
  }) {
    assert(
      mainBranchId == _sentinel || mainBranchIdFieldValue == null,
      "Cannot specify both mainBranchId and mainBranchIdFieldValue",
    );
    assert(
      subBranchId == _sentinel || subBranchIdFieldValue == null,
      "Cannot specify both subBranchId and subBranchIdFieldValue",
    );
    assert(
      createdAt == _sentinel || createdAtFieldValue == null,
      "Cannot specify both createdAt and createdAtFieldValue",
    );
    assert(
      status == _sentinel || statusFieldValue == null,
      "Cannot specify both status and statusFieldValue",
    );
    assert(
      deliveryDate == _sentinel || deliveryDateFieldValue == null,
      "Cannot specify both deliveryDate and deliveryDateFieldValue",
    );
    assert(
      deliveryNote == _sentinel || deliveryNoteFieldValue == null,
      "Cannot specify both deliveryNote and deliveryNoteFieldValue",
    );
    assert(
      orderNote == _sentinel || orderNoteFieldValue == null,
      "Cannot specify both orderNote and orderNoteFieldValue",
    );
    assert(
      customerReceivedOrder == _sentinel ||
          customerReceivedOrderFieldValue == null,
      "Cannot specify both customerReceivedOrder and customerReceivedOrderFieldValue",
    );
    assert(
      driverRequestDeliveryConfirmation == _sentinel ||
          driverRequestDeliveryConfirmationFieldValue == null,
      "Cannot specify both driverRequestDeliveryConfirmation and driverRequestDeliveryConfirmationFieldValue",
    );
    assert(
      driverId == _sentinel || driverIdFieldValue == null,
      "Cannot specify both driverId and driverIdFieldValue",
    );
    assert(
      items == _sentinel || itemsFieldValue == null,
      "Cannot specify both items and itemsFieldValue",
    );
    assert(
      updatedAt == _sentinel || updatedAtFieldValue == null,
      "Cannot specify both updatedAt and updatedAtFieldValue",
    );
    final json = {
      if (mainBranchId != _sentinel)
        _$StockRequestFieldMap['mainBranchId']!:
            _$StockRequestPerFieldToJson.mainBranchId(mainBranchId as int),
      if (mainBranchIdFieldValue != null)
        _$StockRequestFieldMap['mainBranchId']!: mainBranchIdFieldValue,
      if (subBranchId != _sentinel)
        _$StockRequestFieldMap['subBranchId']!:
            _$StockRequestPerFieldToJson.subBranchId(subBranchId as int),
      if (subBranchIdFieldValue != null)
        _$StockRequestFieldMap['subBranchId']!: subBranchIdFieldValue,
      if (createdAt != _sentinel)
        _$StockRequestFieldMap['createdAt']!:
            _$StockRequestPerFieldToJson.createdAt(createdAt as DateTime),
      if (createdAtFieldValue != null)
        _$StockRequestFieldMap['createdAt']!: createdAtFieldValue,
      if (status != _sentinel)
        _$StockRequestFieldMap['status']!:
            _$StockRequestPerFieldToJson.status(status as String),
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (deliveryDate != _sentinel)
        _$StockRequestFieldMap['deliveryDate']!: _$StockRequestPerFieldToJson
            .deliveryDate(deliveryDate as DateTime?),
      if (deliveryDateFieldValue != null)
        _$StockRequestFieldMap['deliveryDate']!: deliveryDateFieldValue,
      if (deliveryNote != _sentinel)
        _$StockRequestFieldMap['deliveryNote']!:
            _$StockRequestPerFieldToJson.deliveryNote(deliveryNote as String?),
      if (deliveryNoteFieldValue != null)
        _$StockRequestFieldMap['deliveryNote']!: deliveryNoteFieldValue,
      if (orderNote != _sentinel)
        _$StockRequestFieldMap['orderNote']!:
            _$StockRequestPerFieldToJson.orderNote(orderNote as String?),
      if (orderNoteFieldValue != null)
        _$StockRequestFieldMap['orderNote']!: orderNoteFieldValue,
      if (customerReceivedOrder != _sentinel)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            _$StockRequestPerFieldToJson
                .customerReceivedOrder(customerReceivedOrder as bool),
      if (customerReceivedOrderFieldValue != null)
        _$StockRequestFieldMap['customerReceivedOrder']!:
            customerReceivedOrderFieldValue,
      if (driverRequestDeliveryConfirmation != _sentinel)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            _$StockRequestPerFieldToJson.driverRequestDeliveryConfirmation(
                driverRequestDeliveryConfirmation as bool),
      if (driverRequestDeliveryConfirmationFieldValue != null)
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!:
            driverRequestDeliveryConfirmationFieldValue,
      if (driverId != _sentinel)
        _$StockRequestFieldMap['driverId']!:
            _$StockRequestPerFieldToJson.driverId(driverId as int?),
      if (driverIdFieldValue != null)
        _$StockRequestFieldMap['driverId']!: driverIdFieldValue,
      if (items != _sentinel)
        _$StockRequestFieldMap['items']!:
            _$StockRequestPerFieldToJson.items(items as List<TransactionItem>),
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updatedAt != _sentinel)
        _$StockRequestFieldMap['updatedAt']!:
            _$StockRequestPerFieldToJson.updatedAt(updatedAt as DateTime?),
      if (updatedAtFieldValue != null)
        _$StockRequestFieldMap['updatedAt']!: updatedAtFieldValue,
    };

    batch.update(reference, json);
  }

  @override
  bool operator ==(Object other) {
    return other is StockRequestDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

abstract class StockRequestQuery
    implements QueryReference<StockRequest, StockRequestQuerySnapshot> {
  @override
  StockRequestQuery limit(int limit);

  @override
  StockRequestQuery limitToLast(int limit);

  /// Perform a where query based on a [FieldPath].
  ///
  /// This method is considered unsafe as it does check that the field path
  /// maps to a valid property or that parameters such as [isEqualTo] receive
  /// a value of the correct type.
  ///
  /// If possible, instead use the more explicit variant of where queries:
  ///
  /// **AVOID**:
  /// ```dart
  /// collection.whereFieldPath(FieldPath.fromString('title'), isEqualTo: 'title');
  /// ```
  ///
  /// **PREFER**:
  /// ```dart
  /// collection.whereTitle(isEqualTo: 'title');
  /// ```
  StockRequestQuery whereFieldPath(
    Object fieldPath, {
    Object? isEqualTo,
    Object? isNotEqualTo,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereDocumentId({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    List<String>? whereIn,
    List<String>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereMainBranchId({
    int? isEqualTo,
    int? isNotEqualTo,
    int? isLessThan,
    int? isLessThanOrEqualTo,
    int? isGreaterThan,
    int? isGreaterThanOrEqualTo,
    List<int>? whereIn,
    List<int>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereSubBranchId({
    int? isEqualTo,
    int? isNotEqualTo,
    int? isLessThan,
    int? isLessThanOrEqualTo,
    int? isGreaterThan,
    int? isGreaterThanOrEqualTo,
    List<int>? whereIn,
    List<int>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereCreatedAt({
    DateTime? isEqualTo,
    DateTime? isNotEqualTo,
    DateTime? isLessThan,
    DateTime? isLessThanOrEqualTo,
    DateTime? isGreaterThan,
    DateTime? isGreaterThanOrEqualTo,
    List<DateTime>? whereIn,
    List<DateTime>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereStatus({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    List<String>? whereIn,
    List<String>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereDeliveryDate({
    DateTime? isEqualTo,
    DateTime? isNotEqualTo,
    DateTime? isLessThan,
    DateTime? isLessThanOrEqualTo,
    DateTime? isGreaterThan,
    DateTime? isGreaterThanOrEqualTo,
    List<DateTime?>? whereIn,
    List<DateTime?>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereDeliveryNote({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    List<String?>? whereIn,
    List<String?>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereOrderNote({
    String? isEqualTo,
    String? isNotEqualTo,
    String? isLessThan,
    String? isLessThanOrEqualTo,
    String? isGreaterThan,
    String? isGreaterThanOrEqualTo,
    List<String?>? whereIn,
    List<String?>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereCustomerReceivedOrder({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereDriverRequestDeliveryConfirmation({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereDriverId({
    int? isEqualTo,
    int? isNotEqualTo,
    int? isLessThan,
    int? isLessThanOrEqualTo,
    int? isGreaterThan,
    int? isGreaterThanOrEqualTo,
    List<int?>? whereIn,
    List<int?>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereItems({
    List<TransactionItem>? isEqualTo,
    List<TransactionItem>? isNotEqualTo,
    List<TransactionItem>? isLessThan,
    List<TransactionItem>? isLessThanOrEqualTo,
    List<TransactionItem>? isGreaterThan,
    List<TransactionItem>? isGreaterThanOrEqualTo,
    TransactionItem? arrayContains,
    List<TransactionItem>? arrayContainsAny,
    bool? isNull,
  });

  StockRequestQuery whereUpdatedAt({
    DateTime? isEqualTo,
    DateTime? isNotEqualTo,
    DateTime? isLessThan,
    DateTime? isLessThanOrEqualTo,
    DateTime? isGreaterThan,
    DateTime? isGreaterThanOrEqualTo,
    List<DateTime?>? whereIn,
    List<DateTime?>? whereNotIn,
    bool? isNull,
  });

  /// Perform an order query based on a [FieldPath].
  ///
  /// This method is considered unsafe as it does check that the field path
  /// maps to a valid property or that parameters such as [isEqualTo] receive
  /// a value of the correct type.
  ///
  /// If possible, instead use the more explicit variant of order queries:
  ///
  /// **AVOID**:
  /// ```dart
  /// collection.orderByFieldPath(
  ///   FieldPath.fromString('title'),
  ///   startAt: 'title',
  /// );
  /// ```
  ///
  /// **PREFER**:
  /// ```dart
  /// collection.orderByTitle(startAt: 'title');
  /// ```
  StockRequestQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object startAt,
    Object startAfter,
    Object endAt,
    Object endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByDocumentId({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByMainBranchId({
    bool descending = false,
    int startAt,
    int startAfter,
    int endAt,
    int endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderBySubBranchId({
    bool descending = false,
    int startAt,
    int startAfter,
    int endAt,
    int endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByCreatedAt({
    bool descending = false,
    DateTime startAt,
    DateTime startAfter,
    DateTime endAt,
    DateTime endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByStatus({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByDeliveryDate({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByDeliveryNote({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByOrderNote({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByCustomerReceivedOrder({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByDriverRequestDeliveryConfirmation({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByDriverId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByItems({
    bool descending = false,
    List<TransactionItem> startAt,
    List<TransactionItem> startAfter,
    List<TransactionItem> endAt,
    List<TransactionItem> endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByUpdatedAt({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });
}

class _$StockRequestQuery
    extends QueryReference<StockRequest, StockRequestQuerySnapshot>
    implements StockRequestQuery {
  _$StockRequestQuery(
    this._collection, {
    required Query<StockRequest> $referenceWithoutCursor,
    $QueryCursor $queryCursor = const $QueryCursor(),
  }) : super(
          $referenceWithoutCursor: $referenceWithoutCursor,
          $queryCursor: $queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<StockRequestQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference
        .snapshots()
        .map(StockRequestQuerySnapshot._fromQuerySnapshot);
  }

  @override
  Future<StockRequestQuerySnapshot> get([GetOptions? options]) {
    return reference
        .get(options)
        .then(StockRequestQuerySnapshot._fromQuerySnapshot);
  }

  @override
  StockRequestQuery limit(int limit) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limit(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery limitToLast(int limit) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limitToLast(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereFieldPath(
    Object fieldPath, {
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Object?>? arrayContainsAny,
    List<Object?>? whereIn,
    List<Object?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        fieldPath,
        isEqualTo: isEqualTo != _sentinel ? isEqualTo : null,
        isNotEqualTo: isNotEqualTo != _sentinel ? isNotEqualTo : null,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        arrayContains: arrayContains,
        arrayContainsAny: arrayContainsAny,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDocumentId({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<String>? whereIn,
    List<String>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        FieldPath.documentId,
        isEqualTo: isEqualTo != _sentinel ? isEqualTo : null,
        isNotEqualTo: isNotEqualTo != _sentinel ? isNotEqualTo : null,
        isLessThan: isLessThan,
        isLessThanOrEqualTo: isLessThanOrEqualTo,
        isGreaterThan: isGreaterThan,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
        whereIn: whereIn,
        whereNotIn: whereNotIn,
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereMainBranchId({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<int>? whereIn,
    List<int>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['mainBranchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.mainBranchId(isEqualTo as int)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.mainBranchId(isNotEqualTo as int)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.mainBranchId(isLessThan as int)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .mainBranchId(isLessThanOrEqualTo as int)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.mainBranchId(isGreaterThan as int)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .mainBranchId(isGreaterThanOrEqualTo as int)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.mainBranchId(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.mainBranchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereSubBranchId({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<int>? whereIn,
    List<int>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['subBranchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.subBranchId(isEqualTo as int)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.subBranchId(isNotEqualTo as int)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.subBranchId(isLessThan as int)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .subBranchId(isLessThanOrEqualTo as int)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.subBranchId(isGreaterThan as int)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .subBranchId(isGreaterThanOrEqualTo as int)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.subBranchId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.subBranchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereCreatedAt({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<DateTime>? whereIn,
    List<DateTime>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['createdAt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.createdAt(isEqualTo as DateTime)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.createdAt(isNotEqualTo as DateTime)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.createdAt(isLessThan as DateTime)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .createdAt(isLessThanOrEqualTo as DateTime)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.createdAt(isGreaterThan as DateTime)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .createdAt(isGreaterThanOrEqualTo as DateTime)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson.createdAt(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.createdAt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereStatus({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<String>? whereIn,
    List<String>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['status']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.status(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.status(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.status(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson.status(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.status(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .status(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson.status(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.status(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDeliveryDate({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<DateTime?>? whereIn,
    List<DateTime?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['deliveryDate']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.deliveryDate(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .deliveryDate(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.deliveryDate(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .deliveryDate(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .deliveryDate(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .deliveryDate(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.deliveryDate(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.deliveryDate(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDeliveryNote({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<String?>? whereIn,
    List<String?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['deliveryNote']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.deliveryNote(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.deliveryNote(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.deliveryNote(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .deliveryNote(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .deliveryNote(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .deliveryNote(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.deliveryNote(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.deliveryNote(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereOrderNote({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<String?>? whereIn,
    List<String?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['orderNote']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.orderNote(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.orderNote(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.orderNote(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .orderNote(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.orderNote(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .orderNote(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson.orderNote(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.orderNote(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereCustomerReceivedOrder({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['customerReceivedOrder']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .customerReceivedOrder(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .customerReceivedOrder(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson
                .customerReceivedOrder(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .customerReceivedOrder(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .customerReceivedOrder(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .customerReceivedOrder(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn
            ?.map((e) => _$StockRequestPerFieldToJson.customerReceivedOrder(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.customerReceivedOrder(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDriverRequestDeliveryConfirmation({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<bool>? whereIn,
    List<bool>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .driverRequestDeliveryConfirmation(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .driverRequestDeliveryConfirmation(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson
                .driverRequestDeliveryConfirmation(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .driverRequestDeliveryConfirmation(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .driverRequestDeliveryConfirmation(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson.driverRequestDeliveryConfirmation(
                isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) =>
            _$StockRequestPerFieldToJson.driverRequestDeliveryConfirmation(e)),
        whereNotIn: whereNotIn?.map((e) =>
            _$StockRequestPerFieldToJson.driverRequestDeliveryConfirmation(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDriverId({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<int?>? whereIn,
    List<int?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['driverId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.driverId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.driverId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.driverId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson.driverId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.driverId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .driverId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson.driverId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.driverId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereItems({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<TransactionItem>? arrayContainsAny,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['items']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .items(isEqualTo as List<TransactionItem>)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .items(isNotEqualTo as List<TransactionItem>)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson
                .items(isLessThan as List<TransactionItem>)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .items(isLessThanOrEqualTo as List<TransactionItem>)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .items(isGreaterThan as List<TransactionItem>)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .items(isGreaterThanOrEqualTo as List<TransactionItem>)
            : null,
        arrayContains: arrayContains != null
            ? (_$StockRequestPerFieldToJson
                    .items([arrayContains as TransactionItem]) as List?)!
                .single
            : null,
        arrayContainsAny: arrayContainsAny != null
            ? _$StockRequestPerFieldToJson.items(arrayContainsAny)
                as Iterable<Object>?
            : null,
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereUpdatedAt({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<DateTime?>? whereIn,
    List<DateTime?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['updatedAt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.updatedAt(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.updatedAt(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.updatedAt(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .updatedAt(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.updatedAt(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .updatedAt(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson.updatedAt(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.updatedAt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query =
        $referenceWithoutCursor.orderBy(fieldPath, descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByDocumentId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(FieldPath.documentId,
        descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByMainBranchId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockRequestFieldMap['mainBranchId']!,
        descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderBySubBranchId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockRequestFieldMap['subBranchId']!,
        descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByCreatedAt({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockRequestFieldMap['createdAt']!, descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByStatus({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockRequestFieldMap['status']!, descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByDeliveryDate({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockRequestFieldMap['deliveryDate']!,
        descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByDeliveryNote({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockRequestFieldMap['deliveryNote']!,
        descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByOrderNote({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockRequestFieldMap['orderNote']!, descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByCustomerReceivedOrder({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockRequestFieldMap['customerReceivedOrder']!,
        descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByDriverRequestDeliveryConfirmation({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockRequestFieldMap['driverRequestDeliveryConfirmation']!,
        descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByDriverId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockRequestFieldMap['driverId']!, descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByItems({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockRequestFieldMap['items']!, descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockRequestQuery orderByUpdatedAt({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockRequestFieldMap['updatedAt']!, descending: descending);
    var queryCursor = $queryCursor;

    if (startAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAt: const [],
        startAtDocumentSnapshot: startAtDocument.snapshot,
      );
    }
    if (startAfterDocument != null) {
      queryCursor = queryCursor.copyWith(
        startAfter: const [],
        startAfterDocumentSnapshot: startAfterDocument.snapshot,
      );
    }
    if (endAtDocument != null) {
      queryCursor = queryCursor.copyWith(
        endAt: const [],
        endAtDocumentSnapshot: endAtDocument.snapshot,
      );
    }
    if (endBeforeDocument != null) {
      queryCursor = queryCursor.copyWith(
        endBefore: const [],
        endBeforeDocumentSnapshot: endBeforeDocument.snapshot,
      );
    }

    if (startAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAt: [...queryCursor.startAt, startAt],
        startAtDocumentSnapshot: null,
      );
    }
    if (startAfter != _sentinel) {
      queryCursor = queryCursor.copyWith(
        startAfter: [...queryCursor.startAfter, startAfter],
        startAfterDocumentSnapshot: null,
      );
    }
    if (endAt != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endAt: [...queryCursor.endAt, endAt],
        endAtDocumentSnapshot: null,
      );
    }
    if (endBefore != _sentinel) {
      queryCursor = queryCursor.copyWith(
        endBefore: [...queryCursor.endBefore, endBefore],
        endBeforeDocumentSnapshot: null,
      );
    }

    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$StockRequestQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class StockRequestDocumentSnapshot
    extends FirestoreDocumentSnapshot<StockRequest> {
  StockRequestDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final DocumentSnapshot<StockRequest> snapshot;

  @override
  StockRequestDocumentReference get reference {
    return StockRequestDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final StockRequest? data;
}

class StockRequestQuerySnapshot extends FirestoreQuerySnapshot<StockRequest,
    StockRequestQueryDocumentSnapshot> {
  StockRequestQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  factory StockRequestQuerySnapshot._fromQuerySnapshot(
    QuerySnapshot<StockRequest> snapshot,
  ) {
    final docs =
        snapshot.docs.map(StockRequestQueryDocumentSnapshot._).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return _decodeDocumentChange(
        change,
        StockRequestDocumentSnapshot._,
      );
    }).toList();

    return StockRequestQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  static FirestoreDocumentChange<StockRequestDocumentSnapshot>
      _decodeDocumentChange<T>(
    DocumentChange<T> docChange,
    StockRequestDocumentSnapshot Function(DocumentSnapshot<T> doc) decodeDoc,
  ) {
    return FirestoreDocumentChange<StockRequestDocumentSnapshot>(
      type: docChange.type,
      oldIndex: docChange.oldIndex,
      newIndex: docChange.newIndex,
      doc: decodeDoc(docChange.doc),
    );
  }

  final QuerySnapshot<StockRequest> snapshot;

  @override
  final List<StockRequestQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<StockRequestDocumentSnapshot>> docChanges;
}

class StockRequestQueryDocumentSnapshot
    extends FirestoreQueryDocumentSnapshot<StockRequest>
    implements StockRequestDocumentSnapshot {
  StockRequestQueryDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final QueryDocumentSnapshot<StockRequest> snapshot;

  @override
  final StockRequest data;

  @override
  StockRequestDocumentReference get reference {
    return StockRequestDocumentReference(snapshot.reference);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockRequest _$StockRequestFromJson(Map<String, dynamic> json) => StockRequest(
      id: json['id'] as String?,
      mainBranchId: (json['mainBranchId'] as num).toInt(),
      subBranchId: (json['subBranchId'] as num).toInt(),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      status: json['status'] as String,
      deliveryDate: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['deliveryDate'], const TimestampConverter().fromJson),
      deliveryNote: json['deliveryNote'] as String?,
      orderNote: json['orderNote'] as String?,
      customerReceivedOrder: json['customerReceivedOrder'] as bool? ?? false,
      driverRequestDeliveryConfirmation:
          json['driverRequestDeliveryConfirmation'] as bool? ?? false,
      driverId: (json['driverId'] as num?)?.toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      updatedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
          json['updatedAt'], const TimestampConverter().fromJson),
    );

Map<String, dynamic> _$StockRequestToJson(StockRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mainBranchId': instance.mainBranchId,
      'subBranchId': instance.subBranchId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'status': instance.status,
      'deliveryDate': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.deliveryDate, const TimestampConverter().toJson),
      'deliveryNote': instance.deliveryNote,
      'orderNote': instance.orderNote,
      'customerReceivedOrder': instance.customerReceivedOrder,
      'driverRequestDeliveryConfirmation':
          instance.driverRequestDeliveryConfirmation,
      'driverId': instance.driverId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'updatedAt': _$JsonConverterToJson<Timestamp, DateTime>(
          instance.updatedAt, const TimestampConverter().toJson),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) =>
    value == null ? null : toJson(value);

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      itemId: json['itemId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'quantity': instance.quantity,
    };
