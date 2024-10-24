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
    return StockRequest.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    StockRequest value,
    SetOptions? options,
  ) {
    return value.toJson();
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
    FieldValue idFieldValue,
    FieldValue main_branch_idFieldValue,
    FieldValue sub_branch_idFieldValue,
    FieldValue created_atFieldValue,
    FieldValue statusFieldValue,
    FieldValue delivery_dateFieldValue,
    FieldValue delivery_noteFieldValue,
    FieldValue order_noteFieldValue,
    FieldValue customer_received_orderFieldValue,
    FieldValue driver_request_delivery_confirmationFieldValue,
    FieldValue driver_idFieldValue,
    FieldValue itemsFieldValue,
    FieldValue updated_atFieldValue,
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
    FieldValue idFieldValue,
    FieldValue main_branch_idFieldValue,
    FieldValue sub_branch_idFieldValue,
    FieldValue created_atFieldValue,
    FieldValue statusFieldValue,
    FieldValue delivery_dateFieldValue,
    FieldValue delivery_noteFieldValue,
    FieldValue order_noteFieldValue,
    FieldValue customer_received_orderFieldValue,
    FieldValue driver_request_delivery_confirmationFieldValue,
    FieldValue driver_idFieldValue,
    FieldValue itemsFieldValue,
    FieldValue updated_atFieldValue,
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
    FieldValue idFieldValue,
    FieldValue main_branch_idFieldValue,
    FieldValue sub_branch_idFieldValue,
    FieldValue created_atFieldValue,
    FieldValue statusFieldValue,
    FieldValue delivery_dateFieldValue,
    FieldValue delivery_noteFieldValue,
    FieldValue order_noteFieldValue,
    FieldValue customer_received_orderFieldValue,
    FieldValue driver_request_delivery_confirmationFieldValue,
    FieldValue driver_idFieldValue,
    FieldValue itemsFieldValue,
    FieldValue updated_atFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int? id,
    FieldValue idFieldValue,
    int? main_branch_id,
    FieldValue main_branch_idFieldValue,
    int? sub_branch_id,
    FieldValue sub_branch_idFieldValue,
    DateTime? created_at,
    FieldValue created_atFieldValue,
    String? status,
    FieldValue statusFieldValue,
    DateTime? delivery_date,
    FieldValue delivery_dateFieldValue,
    String? delivery_note,
    FieldValue delivery_noteFieldValue,
    String? order_note,
    FieldValue order_noteFieldValue,
    bool? customer_received_order,
    FieldValue customer_received_orderFieldValue,
    bool? driver_request_delivery_confirmation,
    FieldValue driver_request_delivery_confirmationFieldValue,
    int? driver_id,
    FieldValue driver_idFieldValue,
    List<TransactionItem>? items,
    FieldValue itemsFieldValue,
    DateTime? updated_at,
    FieldValue updated_atFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int? id,
    FieldValue idFieldValue,
    int? main_branch_id,
    FieldValue main_branch_idFieldValue,
    int? sub_branch_id,
    FieldValue sub_branch_idFieldValue,
    DateTime? created_at,
    FieldValue created_atFieldValue,
    String? status,
    FieldValue statusFieldValue,
    DateTime? delivery_date,
    FieldValue delivery_dateFieldValue,
    String? delivery_note,
    FieldValue delivery_noteFieldValue,
    String? order_note,
    FieldValue order_noteFieldValue,
    bool? customer_received_order,
    FieldValue customer_received_orderFieldValue,
    bool? driver_request_delivery_confirmation,
    FieldValue driver_request_delivery_confirmationFieldValue,
    int? driver_id,
    FieldValue driver_idFieldValue,
    List<TransactionItem>? items,
    FieldValue itemsFieldValue,
    DateTime? updated_at,
    FieldValue updated_atFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int? id,
    FieldValue idFieldValue,
    int? main_branch_id,
    FieldValue main_branch_idFieldValue,
    int? sub_branch_id,
    FieldValue sub_branch_idFieldValue,
    DateTime? created_at,
    FieldValue created_atFieldValue,
    String? status,
    FieldValue statusFieldValue,
    DateTime? delivery_date,
    FieldValue delivery_dateFieldValue,
    String? delivery_note,
    FieldValue delivery_noteFieldValue,
    String? order_note,
    FieldValue order_noteFieldValue,
    bool? customer_received_order,
    FieldValue customer_received_orderFieldValue,
    bool? driver_request_delivery_confirmation,
    FieldValue driver_request_delivery_confirmationFieldValue,
    int? driver_id,
    FieldValue driver_idFieldValue,
    List<TransactionItem>? items,
    FieldValue itemsFieldValue,
    DateTime? updated_at,
    FieldValue updated_atFieldValue,
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
    FieldValue? idFieldValue,
    FieldValue? main_branch_idFieldValue,
    FieldValue? sub_branch_idFieldValue,
    FieldValue? created_atFieldValue,
    FieldValue? statusFieldValue,
    FieldValue? delivery_dateFieldValue,
    FieldValue? delivery_noteFieldValue,
    FieldValue? order_noteFieldValue,
    FieldValue? customer_received_orderFieldValue,
    FieldValue? driver_request_delivery_confirmationFieldValue,
    FieldValue? driver_idFieldValue,
    FieldValue? itemsFieldValue,
    FieldValue? updated_atFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockRequestFieldMap['id']!: idFieldValue,
      if (main_branch_idFieldValue != null)
        _$StockRequestFieldMap['main_branch_id']!: main_branch_idFieldValue,
      if (sub_branch_idFieldValue != null)
        _$StockRequestFieldMap['sub_branch_id']!: sub_branch_idFieldValue,
      if (created_atFieldValue != null)
        _$StockRequestFieldMap['created_at']!: created_atFieldValue,
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (delivery_dateFieldValue != null)
        _$StockRequestFieldMap['delivery_date']!: delivery_dateFieldValue,
      if (delivery_noteFieldValue != null)
        _$StockRequestFieldMap['delivery_note']!: delivery_noteFieldValue,
      if (order_noteFieldValue != null)
        _$StockRequestFieldMap['order_note']!: order_noteFieldValue,
      if (customer_received_orderFieldValue != null)
        _$StockRequestFieldMap['customer_received_order']!:
            customer_received_orderFieldValue,
      if (driver_request_delivery_confirmationFieldValue != null)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            driver_request_delivery_confirmationFieldValue,
      if (driver_idFieldValue != null)
        _$StockRequestFieldMap['driver_id']!: driver_idFieldValue,
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updated_atFieldValue != null)
        _$StockRequestFieldMap['updated_at']!: updated_atFieldValue,
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
    FieldValue? idFieldValue,
    FieldValue? main_branch_idFieldValue,
    FieldValue? sub_branch_idFieldValue,
    FieldValue? created_atFieldValue,
    FieldValue? statusFieldValue,
    FieldValue? delivery_dateFieldValue,
    FieldValue? delivery_noteFieldValue,
    FieldValue? order_noteFieldValue,
    FieldValue? customer_received_orderFieldValue,
    FieldValue? driver_request_delivery_confirmationFieldValue,
    FieldValue? driver_idFieldValue,
    FieldValue? itemsFieldValue,
    FieldValue? updated_atFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockRequestFieldMap['id']!: idFieldValue,
      if (main_branch_idFieldValue != null)
        _$StockRequestFieldMap['main_branch_id']!: main_branch_idFieldValue,
      if (sub_branch_idFieldValue != null)
        _$StockRequestFieldMap['sub_branch_id']!: sub_branch_idFieldValue,
      if (created_atFieldValue != null)
        _$StockRequestFieldMap['created_at']!: created_atFieldValue,
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (delivery_dateFieldValue != null)
        _$StockRequestFieldMap['delivery_date']!: delivery_dateFieldValue,
      if (delivery_noteFieldValue != null)
        _$StockRequestFieldMap['delivery_note']!: delivery_noteFieldValue,
      if (order_noteFieldValue != null)
        _$StockRequestFieldMap['order_note']!: order_noteFieldValue,
      if (customer_received_orderFieldValue != null)
        _$StockRequestFieldMap['customer_received_order']!:
            customer_received_orderFieldValue,
      if (driver_request_delivery_confirmationFieldValue != null)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            driver_request_delivery_confirmationFieldValue,
      if (driver_idFieldValue != null)
        _$StockRequestFieldMap['driver_id']!: driver_idFieldValue,
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updated_atFieldValue != null)
        _$StockRequestFieldMap['updated_at']!: updated_atFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    StockRequest model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? main_branch_idFieldValue,
    FieldValue? sub_branch_idFieldValue,
    FieldValue? created_atFieldValue,
    FieldValue? statusFieldValue,
    FieldValue? delivery_dateFieldValue,
    FieldValue? delivery_noteFieldValue,
    FieldValue? order_noteFieldValue,
    FieldValue? customer_received_orderFieldValue,
    FieldValue? driver_request_delivery_confirmationFieldValue,
    FieldValue? driver_idFieldValue,
    FieldValue? itemsFieldValue,
    FieldValue? updated_atFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockRequestFieldMap['id']!: idFieldValue,
      if (main_branch_idFieldValue != null)
        _$StockRequestFieldMap['main_branch_id']!: main_branch_idFieldValue,
      if (sub_branch_idFieldValue != null)
        _$StockRequestFieldMap['sub_branch_id']!: sub_branch_idFieldValue,
      if (created_atFieldValue != null)
        _$StockRequestFieldMap['created_at']!: created_atFieldValue,
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (delivery_dateFieldValue != null)
        _$StockRequestFieldMap['delivery_date']!: delivery_dateFieldValue,
      if (delivery_noteFieldValue != null)
        _$StockRequestFieldMap['delivery_note']!: delivery_noteFieldValue,
      if (order_noteFieldValue != null)
        _$StockRequestFieldMap['order_note']!: order_noteFieldValue,
      if (customer_received_orderFieldValue != null)
        _$StockRequestFieldMap['customer_received_order']!:
            customer_received_orderFieldValue,
      if (driver_request_delivery_confirmationFieldValue != null)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            driver_request_delivery_confirmationFieldValue,
      if (driver_idFieldValue != null)
        _$StockRequestFieldMap['driver_id']!: driver_idFieldValue,
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updated_atFieldValue != null)
        _$StockRequestFieldMap['updated_at']!: updated_atFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? main_branch_id = _sentinel,
    FieldValue? main_branch_idFieldValue,
    Object? sub_branch_id = _sentinel,
    FieldValue? sub_branch_idFieldValue,
    Object? created_at = _sentinel,
    FieldValue? created_atFieldValue,
    Object? status = _sentinel,
    FieldValue? statusFieldValue,
    Object? delivery_date = _sentinel,
    FieldValue? delivery_dateFieldValue,
    Object? delivery_note = _sentinel,
    FieldValue? delivery_noteFieldValue,
    Object? order_note = _sentinel,
    FieldValue? order_noteFieldValue,
    Object? customer_received_order = _sentinel,
    FieldValue? customer_received_orderFieldValue,
    Object? driver_request_delivery_confirmation = _sentinel,
    FieldValue? driver_request_delivery_confirmationFieldValue,
    Object? driver_id = _sentinel,
    FieldValue? driver_idFieldValue,
    Object? items = _sentinel,
    FieldValue? itemsFieldValue,
    Object? updated_at = _sentinel,
    FieldValue? updated_atFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      main_branch_id == _sentinel || main_branch_idFieldValue == null,
      "Cannot specify both main_branch_id and main_branch_idFieldValue",
    );
    assert(
      sub_branch_id == _sentinel || sub_branch_idFieldValue == null,
      "Cannot specify both sub_branch_id and sub_branch_idFieldValue",
    );
    assert(
      created_at == _sentinel || created_atFieldValue == null,
      "Cannot specify both created_at and created_atFieldValue",
    );
    assert(
      status == _sentinel || statusFieldValue == null,
      "Cannot specify both status and statusFieldValue",
    );
    assert(
      delivery_date == _sentinel || delivery_dateFieldValue == null,
      "Cannot specify both delivery_date and delivery_dateFieldValue",
    );
    assert(
      delivery_note == _sentinel || delivery_noteFieldValue == null,
      "Cannot specify both delivery_note and delivery_noteFieldValue",
    );
    assert(
      order_note == _sentinel || order_noteFieldValue == null,
      "Cannot specify both order_note and order_noteFieldValue",
    );
    assert(
      customer_received_order == _sentinel ||
          customer_received_orderFieldValue == null,
      "Cannot specify both customer_received_order and customer_received_orderFieldValue",
    );
    assert(
      driver_request_delivery_confirmation == _sentinel ||
          driver_request_delivery_confirmationFieldValue == null,
      "Cannot specify both driver_request_delivery_confirmation and driver_request_delivery_confirmationFieldValue",
    );
    assert(
      driver_id == _sentinel || driver_idFieldValue == null,
      "Cannot specify both driver_id and driver_idFieldValue",
    );
    assert(
      items == _sentinel || itemsFieldValue == null,
      "Cannot specify both items and itemsFieldValue",
    );
    assert(
      updated_at == _sentinel || updated_atFieldValue == null,
      "Cannot specify both updated_at and updated_atFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockRequestFieldMap['id']!:
            _$StockRequestPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockRequestFieldMap['id']!: idFieldValue,
      if (main_branch_id != _sentinel)
        _$StockRequestFieldMap['main_branch_id']!:
            _$StockRequestPerFieldToJson.main_branch_id(main_branch_id as int?),
      if (main_branch_idFieldValue != null)
        _$StockRequestFieldMap['main_branch_id']!: main_branch_idFieldValue,
      if (sub_branch_id != _sentinel)
        _$StockRequestFieldMap['sub_branch_id']!:
            _$StockRequestPerFieldToJson.sub_branch_id(sub_branch_id as int?),
      if (sub_branch_idFieldValue != null)
        _$StockRequestFieldMap['sub_branch_id']!: sub_branch_idFieldValue,
      if (created_at != _sentinel)
        _$StockRequestFieldMap['created_at']!:
            _$StockRequestPerFieldToJson.created_at(created_at as DateTime?),
      if (created_atFieldValue != null)
        _$StockRequestFieldMap['created_at']!: created_atFieldValue,
      if (status != _sentinel)
        _$StockRequestFieldMap['status']!:
            _$StockRequestPerFieldToJson.status(status as String?),
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (delivery_date != _sentinel)
        _$StockRequestFieldMap['delivery_date']!: _$StockRequestPerFieldToJson
            .delivery_date(delivery_date as DateTime?),
      if (delivery_dateFieldValue != null)
        _$StockRequestFieldMap['delivery_date']!: delivery_dateFieldValue,
      if (delivery_note != _sentinel)
        _$StockRequestFieldMap['delivery_note']!: _$StockRequestPerFieldToJson
            .delivery_note(delivery_note as String?),
      if (delivery_noteFieldValue != null)
        _$StockRequestFieldMap['delivery_note']!: delivery_noteFieldValue,
      if (order_note != _sentinel)
        _$StockRequestFieldMap['order_note']!:
            _$StockRequestPerFieldToJson.order_note(order_note as String?),
      if (order_noteFieldValue != null)
        _$StockRequestFieldMap['order_note']!: order_noteFieldValue,
      if (customer_received_order != _sentinel)
        _$StockRequestFieldMap['customer_received_order']!:
            _$StockRequestPerFieldToJson
                .customer_received_order(customer_received_order as bool?),
      if (customer_received_orderFieldValue != null)
        _$StockRequestFieldMap['customer_received_order']!:
            customer_received_orderFieldValue,
      if (driver_request_delivery_confirmation != _sentinel)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            _$StockRequestPerFieldToJson.driver_request_delivery_confirmation(
                driver_request_delivery_confirmation as bool?),
      if (driver_request_delivery_confirmationFieldValue != null)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            driver_request_delivery_confirmationFieldValue,
      if (driver_id != _sentinel)
        _$StockRequestFieldMap['driver_id']!:
            _$StockRequestPerFieldToJson.driver_id(driver_id as int?),
      if (driver_idFieldValue != null)
        _$StockRequestFieldMap['driver_id']!: driver_idFieldValue,
      if (items != _sentinel)
        _$StockRequestFieldMap['items']!:
            _$StockRequestPerFieldToJson.items(items as List<TransactionItem>?),
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updated_at != _sentinel)
        _$StockRequestFieldMap['updated_at']!:
            _$StockRequestPerFieldToJson.updated_at(updated_at as DateTime?),
      if (updated_atFieldValue != null)
        _$StockRequestFieldMap['updated_at']!: updated_atFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? main_branch_id = _sentinel,
    FieldValue? main_branch_idFieldValue,
    Object? sub_branch_id = _sentinel,
    FieldValue? sub_branch_idFieldValue,
    Object? created_at = _sentinel,
    FieldValue? created_atFieldValue,
    Object? status = _sentinel,
    FieldValue? statusFieldValue,
    Object? delivery_date = _sentinel,
    FieldValue? delivery_dateFieldValue,
    Object? delivery_note = _sentinel,
    FieldValue? delivery_noteFieldValue,
    Object? order_note = _sentinel,
    FieldValue? order_noteFieldValue,
    Object? customer_received_order = _sentinel,
    FieldValue? customer_received_orderFieldValue,
    Object? driver_request_delivery_confirmation = _sentinel,
    FieldValue? driver_request_delivery_confirmationFieldValue,
    Object? driver_id = _sentinel,
    FieldValue? driver_idFieldValue,
    Object? items = _sentinel,
    FieldValue? itemsFieldValue,
    Object? updated_at = _sentinel,
    FieldValue? updated_atFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      main_branch_id == _sentinel || main_branch_idFieldValue == null,
      "Cannot specify both main_branch_id and main_branch_idFieldValue",
    );
    assert(
      sub_branch_id == _sentinel || sub_branch_idFieldValue == null,
      "Cannot specify both sub_branch_id and sub_branch_idFieldValue",
    );
    assert(
      created_at == _sentinel || created_atFieldValue == null,
      "Cannot specify both created_at and created_atFieldValue",
    );
    assert(
      status == _sentinel || statusFieldValue == null,
      "Cannot specify both status and statusFieldValue",
    );
    assert(
      delivery_date == _sentinel || delivery_dateFieldValue == null,
      "Cannot specify both delivery_date and delivery_dateFieldValue",
    );
    assert(
      delivery_note == _sentinel || delivery_noteFieldValue == null,
      "Cannot specify both delivery_note and delivery_noteFieldValue",
    );
    assert(
      order_note == _sentinel || order_noteFieldValue == null,
      "Cannot specify both order_note and order_noteFieldValue",
    );
    assert(
      customer_received_order == _sentinel ||
          customer_received_orderFieldValue == null,
      "Cannot specify both customer_received_order and customer_received_orderFieldValue",
    );
    assert(
      driver_request_delivery_confirmation == _sentinel ||
          driver_request_delivery_confirmationFieldValue == null,
      "Cannot specify both driver_request_delivery_confirmation and driver_request_delivery_confirmationFieldValue",
    );
    assert(
      driver_id == _sentinel || driver_idFieldValue == null,
      "Cannot specify both driver_id and driver_idFieldValue",
    );
    assert(
      items == _sentinel || itemsFieldValue == null,
      "Cannot specify both items and itemsFieldValue",
    );
    assert(
      updated_at == _sentinel || updated_atFieldValue == null,
      "Cannot specify both updated_at and updated_atFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockRequestFieldMap['id']!:
            _$StockRequestPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockRequestFieldMap['id']!: idFieldValue,
      if (main_branch_id != _sentinel)
        _$StockRequestFieldMap['main_branch_id']!:
            _$StockRequestPerFieldToJson.main_branch_id(main_branch_id as int?),
      if (main_branch_idFieldValue != null)
        _$StockRequestFieldMap['main_branch_id']!: main_branch_idFieldValue,
      if (sub_branch_id != _sentinel)
        _$StockRequestFieldMap['sub_branch_id']!:
            _$StockRequestPerFieldToJson.sub_branch_id(sub_branch_id as int?),
      if (sub_branch_idFieldValue != null)
        _$StockRequestFieldMap['sub_branch_id']!: sub_branch_idFieldValue,
      if (created_at != _sentinel)
        _$StockRequestFieldMap['created_at']!:
            _$StockRequestPerFieldToJson.created_at(created_at as DateTime?),
      if (created_atFieldValue != null)
        _$StockRequestFieldMap['created_at']!: created_atFieldValue,
      if (status != _sentinel)
        _$StockRequestFieldMap['status']!:
            _$StockRequestPerFieldToJson.status(status as String?),
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (delivery_date != _sentinel)
        _$StockRequestFieldMap['delivery_date']!: _$StockRequestPerFieldToJson
            .delivery_date(delivery_date as DateTime?),
      if (delivery_dateFieldValue != null)
        _$StockRequestFieldMap['delivery_date']!: delivery_dateFieldValue,
      if (delivery_note != _sentinel)
        _$StockRequestFieldMap['delivery_note']!: _$StockRequestPerFieldToJson
            .delivery_note(delivery_note as String?),
      if (delivery_noteFieldValue != null)
        _$StockRequestFieldMap['delivery_note']!: delivery_noteFieldValue,
      if (order_note != _sentinel)
        _$StockRequestFieldMap['order_note']!:
            _$StockRequestPerFieldToJson.order_note(order_note as String?),
      if (order_noteFieldValue != null)
        _$StockRequestFieldMap['order_note']!: order_noteFieldValue,
      if (customer_received_order != _sentinel)
        _$StockRequestFieldMap['customer_received_order']!:
            _$StockRequestPerFieldToJson
                .customer_received_order(customer_received_order as bool?),
      if (customer_received_orderFieldValue != null)
        _$StockRequestFieldMap['customer_received_order']!:
            customer_received_orderFieldValue,
      if (driver_request_delivery_confirmation != _sentinel)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            _$StockRequestPerFieldToJson.driver_request_delivery_confirmation(
                driver_request_delivery_confirmation as bool?),
      if (driver_request_delivery_confirmationFieldValue != null)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            driver_request_delivery_confirmationFieldValue,
      if (driver_id != _sentinel)
        _$StockRequestFieldMap['driver_id']!:
            _$StockRequestPerFieldToJson.driver_id(driver_id as int?),
      if (driver_idFieldValue != null)
        _$StockRequestFieldMap['driver_id']!: driver_idFieldValue,
      if (items != _sentinel)
        _$StockRequestFieldMap['items']!:
            _$StockRequestPerFieldToJson.items(items as List<TransactionItem>?),
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updated_at != _sentinel)
        _$StockRequestFieldMap['updated_at']!:
            _$StockRequestPerFieldToJson.updated_at(updated_at as DateTime?),
      if (updated_atFieldValue != null)
        _$StockRequestFieldMap['updated_at']!: updated_atFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? main_branch_id = _sentinel,
    FieldValue? main_branch_idFieldValue,
    Object? sub_branch_id = _sentinel,
    FieldValue? sub_branch_idFieldValue,
    Object? created_at = _sentinel,
    FieldValue? created_atFieldValue,
    Object? status = _sentinel,
    FieldValue? statusFieldValue,
    Object? delivery_date = _sentinel,
    FieldValue? delivery_dateFieldValue,
    Object? delivery_note = _sentinel,
    FieldValue? delivery_noteFieldValue,
    Object? order_note = _sentinel,
    FieldValue? order_noteFieldValue,
    Object? customer_received_order = _sentinel,
    FieldValue? customer_received_orderFieldValue,
    Object? driver_request_delivery_confirmation = _sentinel,
    FieldValue? driver_request_delivery_confirmationFieldValue,
    Object? driver_id = _sentinel,
    FieldValue? driver_idFieldValue,
    Object? items = _sentinel,
    FieldValue? itemsFieldValue,
    Object? updated_at = _sentinel,
    FieldValue? updated_atFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      main_branch_id == _sentinel || main_branch_idFieldValue == null,
      "Cannot specify both main_branch_id and main_branch_idFieldValue",
    );
    assert(
      sub_branch_id == _sentinel || sub_branch_idFieldValue == null,
      "Cannot specify both sub_branch_id and sub_branch_idFieldValue",
    );
    assert(
      created_at == _sentinel || created_atFieldValue == null,
      "Cannot specify both created_at and created_atFieldValue",
    );
    assert(
      status == _sentinel || statusFieldValue == null,
      "Cannot specify both status and statusFieldValue",
    );
    assert(
      delivery_date == _sentinel || delivery_dateFieldValue == null,
      "Cannot specify both delivery_date and delivery_dateFieldValue",
    );
    assert(
      delivery_note == _sentinel || delivery_noteFieldValue == null,
      "Cannot specify both delivery_note and delivery_noteFieldValue",
    );
    assert(
      order_note == _sentinel || order_noteFieldValue == null,
      "Cannot specify both order_note and order_noteFieldValue",
    );
    assert(
      customer_received_order == _sentinel ||
          customer_received_orderFieldValue == null,
      "Cannot specify both customer_received_order and customer_received_orderFieldValue",
    );
    assert(
      driver_request_delivery_confirmation == _sentinel ||
          driver_request_delivery_confirmationFieldValue == null,
      "Cannot specify both driver_request_delivery_confirmation and driver_request_delivery_confirmationFieldValue",
    );
    assert(
      driver_id == _sentinel || driver_idFieldValue == null,
      "Cannot specify both driver_id and driver_idFieldValue",
    );
    assert(
      items == _sentinel || itemsFieldValue == null,
      "Cannot specify both items and itemsFieldValue",
    );
    assert(
      updated_at == _sentinel || updated_atFieldValue == null,
      "Cannot specify both updated_at and updated_atFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockRequestFieldMap['id']!:
            _$StockRequestPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockRequestFieldMap['id']!: idFieldValue,
      if (main_branch_id != _sentinel)
        _$StockRequestFieldMap['main_branch_id']!:
            _$StockRequestPerFieldToJson.main_branch_id(main_branch_id as int?),
      if (main_branch_idFieldValue != null)
        _$StockRequestFieldMap['main_branch_id']!: main_branch_idFieldValue,
      if (sub_branch_id != _sentinel)
        _$StockRequestFieldMap['sub_branch_id']!:
            _$StockRequestPerFieldToJson.sub_branch_id(sub_branch_id as int?),
      if (sub_branch_idFieldValue != null)
        _$StockRequestFieldMap['sub_branch_id']!: sub_branch_idFieldValue,
      if (created_at != _sentinel)
        _$StockRequestFieldMap['created_at']!:
            _$StockRequestPerFieldToJson.created_at(created_at as DateTime?),
      if (created_atFieldValue != null)
        _$StockRequestFieldMap['created_at']!: created_atFieldValue,
      if (status != _sentinel)
        _$StockRequestFieldMap['status']!:
            _$StockRequestPerFieldToJson.status(status as String?),
      if (statusFieldValue != null)
        _$StockRequestFieldMap['status']!: statusFieldValue,
      if (delivery_date != _sentinel)
        _$StockRequestFieldMap['delivery_date']!: _$StockRequestPerFieldToJson
            .delivery_date(delivery_date as DateTime?),
      if (delivery_dateFieldValue != null)
        _$StockRequestFieldMap['delivery_date']!: delivery_dateFieldValue,
      if (delivery_note != _sentinel)
        _$StockRequestFieldMap['delivery_note']!: _$StockRequestPerFieldToJson
            .delivery_note(delivery_note as String?),
      if (delivery_noteFieldValue != null)
        _$StockRequestFieldMap['delivery_note']!: delivery_noteFieldValue,
      if (order_note != _sentinel)
        _$StockRequestFieldMap['order_note']!:
            _$StockRequestPerFieldToJson.order_note(order_note as String?),
      if (order_noteFieldValue != null)
        _$StockRequestFieldMap['order_note']!: order_noteFieldValue,
      if (customer_received_order != _sentinel)
        _$StockRequestFieldMap['customer_received_order']!:
            _$StockRequestPerFieldToJson
                .customer_received_order(customer_received_order as bool?),
      if (customer_received_orderFieldValue != null)
        _$StockRequestFieldMap['customer_received_order']!:
            customer_received_orderFieldValue,
      if (driver_request_delivery_confirmation != _sentinel)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            _$StockRequestPerFieldToJson.driver_request_delivery_confirmation(
                driver_request_delivery_confirmation as bool?),
      if (driver_request_delivery_confirmationFieldValue != null)
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!:
            driver_request_delivery_confirmationFieldValue,
      if (driver_id != _sentinel)
        _$StockRequestFieldMap['driver_id']!:
            _$StockRequestPerFieldToJson.driver_id(driver_id as int?),
      if (driver_idFieldValue != null)
        _$StockRequestFieldMap['driver_id']!: driver_idFieldValue,
      if (items != _sentinel)
        _$StockRequestFieldMap['items']!:
            _$StockRequestPerFieldToJson.items(items as List<TransactionItem>?),
      if (itemsFieldValue != null)
        _$StockRequestFieldMap['items']!: itemsFieldValue,
      if (updated_at != _sentinel)
        _$StockRequestFieldMap['updated_at']!:
            _$StockRequestPerFieldToJson.updated_at(updated_at as DateTime?),
      if (updated_atFieldValue != null)
        _$StockRequestFieldMap['updated_at']!: updated_atFieldValue,
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

  StockRequestQuery whereId({
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

  StockRequestQuery whereMain_branch_id({
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

  StockRequestQuery whereSub_branch_id({
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

  StockRequestQuery whereCreated_at({
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

  StockRequestQuery whereStatus({
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

  StockRequestQuery whereDelivery_date({
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

  StockRequestQuery whereDelivery_note({
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

  StockRequestQuery whereOrder_note({
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

  StockRequestQuery whereCustomer_received_order({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereDriver_request_delivery_confirmation({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  });

  StockRequestQuery whereDriver_id({
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

  StockRequestQuery whereUpdated_at({
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

  StockRequestQuery orderById({
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

  StockRequestQuery orderByMain_branch_id({
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

  StockRequestQuery orderBySub_branch_id({
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

  StockRequestQuery orderByCreated_at({
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

  StockRequestQuery orderByStatus({
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

  StockRequestQuery orderByDelivery_date({
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

  StockRequestQuery orderByDelivery_note({
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

  StockRequestQuery orderByOrder_note({
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

  StockRequestQuery orderByCustomer_received_order({
    bool descending = false,
    bool? startAt,
    bool? startAfter,
    bool? endAt,
    bool? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByDriver_request_delivery_confirmation({
    bool descending = false,
    bool? startAt,
    bool? startAfter,
    bool? endAt,
    bool? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByDriver_id({
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
    List<TransactionItem>? startAt,
    List<TransactionItem>? startAfter,
    List<TransactionItem>? endAt,
    List<TransactionItem>? endBefore,
    StockRequestDocumentSnapshot? startAtDocument,
    StockRequestDocumentSnapshot? endAtDocument,
    StockRequestDocumentSnapshot? endBeforeDocument,
    StockRequestDocumentSnapshot? startAfterDocument,
  });

  StockRequestQuery orderByUpdated_at({
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
  StockRequestQuery whereId({
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
        _$StockRequestFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson.id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson.id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson.id(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockRequestPerFieldToJson.id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereMain_branch_id({
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
        _$StockRequestFieldMap['main_branch_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.main_branch_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.main_branch_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.main_branch_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .main_branch_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.main_branch_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .main_branch_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.main_branch_id(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.main_branch_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereSub_branch_id({
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
        _$StockRequestFieldMap['sub_branch_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.sub_branch_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.sub_branch_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.sub_branch_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .sub_branch_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.sub_branch_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .sub_branch_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.sub_branch_id(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.sub_branch_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereCreated_at({
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
        _$StockRequestFieldMap['created_at']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.created_at(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.created_at(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.created_at(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .created_at(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .created_at(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .created_at(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.created_at(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.created_at(e)),
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
    List<String?>? whereIn,
    List<String?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['status']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.status(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.status(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.status(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .status(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.status(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .status(isGreaterThanOrEqualTo as String?)
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
  StockRequestQuery whereDelivery_date({
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
        _$StockRequestFieldMap['delivery_date']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.delivery_date(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .delivery_date(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson
                .delivery_date(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .delivery_date(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .delivery_date(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .delivery_date(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.delivery_date(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.delivery_date(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDelivery_note({
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
        _$StockRequestFieldMap['delivery_note']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.delivery_note(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .delivery_note(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.delivery_note(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .delivery_note(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .delivery_note(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .delivery_note(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.delivery_note(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockRequestPerFieldToJson.delivery_note(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereOrder_note({
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
        _$StockRequestFieldMap['order_note']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.order_note(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.order_note(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.order_note(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .order_note(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.order_note(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .order_note(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.order_note(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.order_note(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereCustomer_received_order({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['customer_received_order']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .customer_received_order(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .customer_received_order(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson
                .customer_received_order(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .customer_received_order(isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .customer_received_order(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .customer_received_order(isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn: whereIn?.map(
            (e) => _$StockRequestPerFieldToJson.customer_received_order(e)),
        whereNotIn: whereNotIn?.map(
            (e) => _$StockRequestPerFieldToJson.customer_received_order(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDriver_request_delivery_confirmation({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockRequestQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .driver_request_delivery_confirmation(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .driver_request_delivery_confirmation(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson
                .driver_request_delivery_confirmation(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson.driver_request_delivery_confirmation(
                isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .driver_request_delivery_confirmation(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson.driver_request_delivery_confirmation(
                isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson
            .driver_request_delivery_confirmation(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockRequestPerFieldToJson
            .driver_request_delivery_confirmation(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockRequestQuery whereDriver_id({
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
        _$StockRequestFieldMap['driver_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.driver_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.driver_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.driver_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .driver_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson.driver_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .driver_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockRequestPerFieldToJson.driver_id(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.driver_id(e)),
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
                .items(isEqualTo as List<TransactionItem>?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson
                .items(isNotEqualTo as List<TransactionItem>?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson
                .items(isLessThan as List<TransactionItem>?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .items(isLessThanOrEqualTo as List<TransactionItem>?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .items(isGreaterThan as List<TransactionItem>?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .items(isGreaterThanOrEqualTo as List<TransactionItem>?)
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
  StockRequestQuery whereUpdated_at({
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
        _$StockRequestFieldMap['updated_at']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.updated_at(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockRequestPerFieldToJson.updated_at(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockRequestPerFieldToJson.updated_at(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .updated_at(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockRequestPerFieldToJson
                .updated_at(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockRequestPerFieldToJson
                .updated_at(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockRequestPerFieldToJson.updated_at(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockRequestPerFieldToJson.updated_at(e)),
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
  StockRequestQuery orderById({
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
    final query = $referenceWithoutCursor.orderBy(_$StockRequestFieldMap['id']!,
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
  StockRequestQuery orderByMain_branch_id({
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
        _$StockRequestFieldMap['main_branch_id']!,
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
  StockRequestQuery orderBySub_branch_id({
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
        _$StockRequestFieldMap['sub_branch_id']!,
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
  StockRequestQuery orderByCreated_at({
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
        .orderBy(_$StockRequestFieldMap['created_at']!, descending: descending);
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
  StockRequestQuery orderByDelivery_date({
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
        _$StockRequestFieldMap['delivery_date']!,
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
  StockRequestQuery orderByDelivery_note({
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
        _$StockRequestFieldMap['delivery_note']!,
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
  StockRequestQuery orderByOrder_note({
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
        .orderBy(_$StockRequestFieldMap['order_note']!, descending: descending);
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
  StockRequestQuery orderByCustomer_received_order({
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
        _$StockRequestFieldMap['customer_received_order']!,
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
  StockRequestQuery orderByDriver_request_delivery_confirmation({
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
        _$StockRequestFieldMap['driver_request_delivery_confirmation']!,
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
  StockRequestQuery orderByDriver_id({
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
        .orderBy(_$StockRequestFieldMap['driver_id']!, descending: descending);
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
  StockRequestQuery orderByUpdated_at({
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
        .orderBy(_$StockRequestFieldMap['updated_at']!, descending: descending);
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

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class VariantCollectionReference
    implements
        VariantQuery,
        FirestoreCollectionReference<Variant, VariantQuerySnapshot> {
  factory VariantCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$VariantCollectionReference;

  static Variant fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return Variant.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    Variant value,
    SetOptions? options,
  ) {
    return value.toJson();
  }

  @override
  CollectionReference<Variant> get reference;

  @override
  VariantDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<VariantDocumentReference> add(Variant value);
}

class _$VariantCollectionReference extends _$VariantQuery
    implements VariantCollectionReference {
  factory _$VariantCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$VariantCollectionReference._(
      firestore.collection('variants').withConverter(
            fromFirestore: VariantCollectionReference.fromFirestore,
            toFirestore: VariantCollectionReference.toFirestore,
          ),
    );
  }

  _$VariantCollectionReference._(
    CollectionReference<Variant> reference,
  ) : super(reference, $referenceWithoutCursor: reference);

  String get path => reference.path;

  @override
  CollectionReference<Variant> get reference =>
      super.reference as CollectionReference<Variant>;

  @override
  VariantDocumentReference doc([String? id]) {
    assert(
      id == null || id.split('/').length == 1,
      'The document ID cannot be from a different collection',
    );
    return VariantDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<VariantDocumentReference> add(Variant value) {
    return reference.add(value).then((ref) => VariantDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$VariantCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class VariantDocumentReference
    extends FirestoreDocumentReference<Variant, VariantDocumentSnapshot> {
  factory VariantDocumentReference(DocumentReference<Variant> reference) =
      _$VariantDocumentReference;

  DocumentReference<Variant> get reference;

  /// A reference to the [VariantCollectionReference] containing this document.
  VariantCollectionReference get parent {
    return _$VariantCollectionReference(reference.firestore);
  }

  @override
  Stream<VariantDocumentSnapshot> snapshots();

  @override
  Future<VariantDocumentSnapshot> get([GetOptions? options]);

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
    Variant model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue variant_idFieldValue,
    FieldValue deleted_atFieldValue,
    FieldValue nameFieldValue,
    FieldValue colorFieldValue,
    FieldValue skuFieldValue,
    FieldValue product_idFieldValue,
    FieldValue unitFieldValue,
    FieldValue product_nameFieldValue,
    FieldValue branch_idFieldValue,
    FieldValue tax_nameFieldValue,
    FieldValue tax_percentageFieldValue,
    FieldValue is_tax_exemptedFieldValue,
    FieldValue item_seqFieldValue,
    FieldValue isrcc_cdFieldValue,
    FieldValue isrcc_nmFieldValue,
    FieldValue isrc_rtFieldValue,
    FieldValue isrc_amtFieldValue,
    FieldValue tax_ty_cdFieldValue,
    FieldValue bcdFieldValue,
    FieldValue item_cls_cdFieldValue,
    FieldValue item_ty_cdFieldValue,
    FieldValue item_std_nmFieldValue,
    FieldValue orgn_nat_cdFieldValue,
    FieldValue pkgFieldValue,
    FieldValue item_cdFieldValue,
    FieldValue pkg_unit_cdFieldValue,
    FieldValue qty_unit_cdFieldValue,
    FieldValue item_nmFieldValue,
    FieldValue qtyFieldValue,
    FieldValue prcFieldValue,
    FieldValue sply_amtFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhf_idFieldValue,
    FieldValue dft_prcFieldValue,
    FieldValue add_infoFieldValue,
    FieldValue isrc_aplcb_ynFieldValue,
    FieldValue use_ynFieldValue,
    FieldValue regr_idFieldValue,
    FieldValue regr_nmFieldValue,
    FieldValue modr_idFieldValue,
    FieldValue modr_nmFieldValue,
    FieldValue rsd_qtyFieldValue,
    FieldValue last_touchedFieldValue,
    FieldValue supply_priceFieldValue,
    FieldValue retail_priceFieldValue,
    FieldValue spplr_item_cls_cdFieldValue,
    FieldValue spplr_item_cdFieldValue,
    FieldValue spplr_item_nmFieldValue,
    FieldValue ebm_syncedFieldValue,
    FieldValue tax_typeFieldValue,
    FieldValue branch_idsFieldValue,
    FieldValue stockFieldValue,
    FieldValue updated_atFieldValue,
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
    Variant model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue variant_idFieldValue,
    FieldValue deleted_atFieldValue,
    FieldValue nameFieldValue,
    FieldValue colorFieldValue,
    FieldValue skuFieldValue,
    FieldValue product_idFieldValue,
    FieldValue unitFieldValue,
    FieldValue product_nameFieldValue,
    FieldValue branch_idFieldValue,
    FieldValue tax_nameFieldValue,
    FieldValue tax_percentageFieldValue,
    FieldValue is_tax_exemptedFieldValue,
    FieldValue item_seqFieldValue,
    FieldValue isrcc_cdFieldValue,
    FieldValue isrcc_nmFieldValue,
    FieldValue isrc_rtFieldValue,
    FieldValue isrc_amtFieldValue,
    FieldValue tax_ty_cdFieldValue,
    FieldValue bcdFieldValue,
    FieldValue item_cls_cdFieldValue,
    FieldValue item_ty_cdFieldValue,
    FieldValue item_std_nmFieldValue,
    FieldValue orgn_nat_cdFieldValue,
    FieldValue pkgFieldValue,
    FieldValue item_cdFieldValue,
    FieldValue pkg_unit_cdFieldValue,
    FieldValue qty_unit_cdFieldValue,
    FieldValue item_nmFieldValue,
    FieldValue qtyFieldValue,
    FieldValue prcFieldValue,
    FieldValue sply_amtFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhf_idFieldValue,
    FieldValue dft_prcFieldValue,
    FieldValue add_infoFieldValue,
    FieldValue isrc_aplcb_ynFieldValue,
    FieldValue use_ynFieldValue,
    FieldValue regr_idFieldValue,
    FieldValue regr_nmFieldValue,
    FieldValue modr_idFieldValue,
    FieldValue modr_nmFieldValue,
    FieldValue rsd_qtyFieldValue,
    FieldValue last_touchedFieldValue,
    FieldValue supply_priceFieldValue,
    FieldValue retail_priceFieldValue,
    FieldValue spplr_item_cls_cdFieldValue,
    FieldValue spplr_item_cdFieldValue,
    FieldValue spplr_item_nmFieldValue,
    FieldValue ebm_syncedFieldValue,
    FieldValue tax_typeFieldValue,
    FieldValue branch_idsFieldValue,
    FieldValue stockFieldValue,
    FieldValue updated_atFieldValue,
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
    Variant model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue variant_idFieldValue,
    FieldValue deleted_atFieldValue,
    FieldValue nameFieldValue,
    FieldValue colorFieldValue,
    FieldValue skuFieldValue,
    FieldValue product_idFieldValue,
    FieldValue unitFieldValue,
    FieldValue product_nameFieldValue,
    FieldValue branch_idFieldValue,
    FieldValue tax_nameFieldValue,
    FieldValue tax_percentageFieldValue,
    FieldValue is_tax_exemptedFieldValue,
    FieldValue item_seqFieldValue,
    FieldValue isrcc_cdFieldValue,
    FieldValue isrcc_nmFieldValue,
    FieldValue isrc_rtFieldValue,
    FieldValue isrc_amtFieldValue,
    FieldValue tax_ty_cdFieldValue,
    FieldValue bcdFieldValue,
    FieldValue item_cls_cdFieldValue,
    FieldValue item_ty_cdFieldValue,
    FieldValue item_std_nmFieldValue,
    FieldValue orgn_nat_cdFieldValue,
    FieldValue pkgFieldValue,
    FieldValue item_cdFieldValue,
    FieldValue pkg_unit_cdFieldValue,
    FieldValue qty_unit_cdFieldValue,
    FieldValue item_nmFieldValue,
    FieldValue qtyFieldValue,
    FieldValue prcFieldValue,
    FieldValue sply_amtFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhf_idFieldValue,
    FieldValue dft_prcFieldValue,
    FieldValue add_infoFieldValue,
    FieldValue isrc_aplcb_ynFieldValue,
    FieldValue use_ynFieldValue,
    FieldValue regr_idFieldValue,
    FieldValue regr_nmFieldValue,
    FieldValue modr_idFieldValue,
    FieldValue modr_nmFieldValue,
    FieldValue rsd_qtyFieldValue,
    FieldValue last_touchedFieldValue,
    FieldValue supply_priceFieldValue,
    FieldValue retail_priceFieldValue,
    FieldValue spplr_item_cls_cdFieldValue,
    FieldValue spplr_item_cdFieldValue,
    FieldValue spplr_item_nmFieldValue,
    FieldValue ebm_syncedFieldValue,
    FieldValue tax_typeFieldValue,
    FieldValue branch_idsFieldValue,
    FieldValue stockFieldValue,
    FieldValue updated_atFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    String? id,
    FieldValue idFieldValue,
    int? variant_id,
    FieldValue variant_idFieldValue,
    DateTime? deleted_at,
    FieldValue deleted_atFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? color,
    FieldValue colorFieldValue,
    String? sku,
    FieldValue skuFieldValue,
    int? product_id,
    FieldValue product_idFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? product_name,
    FieldValue product_nameFieldValue,
    int? branch_id,
    FieldValue branch_idFieldValue,
    String tax_name,
    FieldValue tax_nameFieldValue,
    double tax_percentage,
    FieldValue tax_percentageFieldValue,
    bool is_tax_exempted,
    FieldValue is_tax_exemptedFieldValue,
    int? item_seq,
    FieldValue item_seqFieldValue,
    String isrcc_cd,
    FieldValue isrcc_cdFieldValue,
    String isrcc_nm,
    FieldValue isrcc_nmFieldValue,
    int isrc_rt,
    FieldValue isrc_rtFieldValue,
    int isrc_amt,
    FieldValue isrc_amtFieldValue,
    String tax_ty_cd,
    FieldValue tax_ty_cdFieldValue,
    String bcd,
    FieldValue bcdFieldValue,
    String? item_cls_cd,
    FieldValue item_cls_cdFieldValue,
    String? item_ty_cd,
    FieldValue item_ty_cdFieldValue,
    String item_std_nm,
    FieldValue item_std_nmFieldValue,
    String orgn_nat_cd,
    FieldValue orgn_nat_cdFieldValue,
    String pkg,
    FieldValue pkgFieldValue,
    String item_cd,
    FieldValue item_cdFieldValue,
    String pkg_unit_cd,
    FieldValue pkg_unit_cdFieldValue,
    String qty_unit_cd,
    FieldValue qty_unit_cdFieldValue,
    String? item_nm,
    FieldValue item_nmFieldValue,
    double qty,
    FieldValue qtyFieldValue,
    double prc,
    FieldValue prcFieldValue,
    double sply_amt,
    FieldValue sply_amtFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhf_id,
    FieldValue bhf_idFieldValue,
    double dft_prc,
    FieldValue dft_prcFieldValue,
    String add_info,
    FieldValue add_infoFieldValue,
    String isrc_aplcb_yn,
    FieldValue isrc_aplcb_ynFieldValue,
    String use_yn,
    FieldValue use_ynFieldValue,
    String? regr_id,
    FieldValue regr_idFieldValue,
    String? regr_nm,
    FieldValue regr_nmFieldValue,
    String? modr_id,
    FieldValue modr_idFieldValue,
    String? modr_nm,
    FieldValue modr_nmFieldValue,
    double rsd_qty,
    FieldValue rsd_qtyFieldValue,
    DateTime? last_touched,
    FieldValue last_touchedFieldValue,
    double supply_price,
    FieldValue supply_priceFieldValue,
    double retail_price,
    FieldValue retail_priceFieldValue,
    String? spplr_item_cls_cd,
    FieldValue spplr_item_cls_cdFieldValue,
    String? spplr_item_cd,
    FieldValue spplr_item_cdFieldValue,
    String? spplr_item_nm,
    FieldValue spplr_item_nmFieldValue,
    bool ebm_synced,
    FieldValue ebm_syncedFieldValue,
    String tax_type,
    FieldValue tax_typeFieldValue,
    List<int> branch_ids,
    FieldValue branch_idsFieldValue,
    Stock stock,
    FieldValue stockFieldValue,
    DateTime? updated_at,
    FieldValue updated_atFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    String? id,
    FieldValue idFieldValue,
    int? variant_id,
    FieldValue variant_idFieldValue,
    DateTime? deleted_at,
    FieldValue deleted_atFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? color,
    FieldValue colorFieldValue,
    String? sku,
    FieldValue skuFieldValue,
    int? product_id,
    FieldValue product_idFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? product_name,
    FieldValue product_nameFieldValue,
    int? branch_id,
    FieldValue branch_idFieldValue,
    String tax_name,
    FieldValue tax_nameFieldValue,
    double tax_percentage,
    FieldValue tax_percentageFieldValue,
    bool is_tax_exempted,
    FieldValue is_tax_exemptedFieldValue,
    int? item_seq,
    FieldValue item_seqFieldValue,
    String isrcc_cd,
    FieldValue isrcc_cdFieldValue,
    String isrcc_nm,
    FieldValue isrcc_nmFieldValue,
    int isrc_rt,
    FieldValue isrc_rtFieldValue,
    int isrc_amt,
    FieldValue isrc_amtFieldValue,
    String tax_ty_cd,
    FieldValue tax_ty_cdFieldValue,
    String bcd,
    FieldValue bcdFieldValue,
    String? item_cls_cd,
    FieldValue item_cls_cdFieldValue,
    String? item_ty_cd,
    FieldValue item_ty_cdFieldValue,
    String item_std_nm,
    FieldValue item_std_nmFieldValue,
    String orgn_nat_cd,
    FieldValue orgn_nat_cdFieldValue,
    String pkg,
    FieldValue pkgFieldValue,
    String item_cd,
    FieldValue item_cdFieldValue,
    String pkg_unit_cd,
    FieldValue pkg_unit_cdFieldValue,
    String qty_unit_cd,
    FieldValue qty_unit_cdFieldValue,
    String? item_nm,
    FieldValue item_nmFieldValue,
    double qty,
    FieldValue qtyFieldValue,
    double prc,
    FieldValue prcFieldValue,
    double sply_amt,
    FieldValue sply_amtFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhf_id,
    FieldValue bhf_idFieldValue,
    double dft_prc,
    FieldValue dft_prcFieldValue,
    String add_info,
    FieldValue add_infoFieldValue,
    String isrc_aplcb_yn,
    FieldValue isrc_aplcb_ynFieldValue,
    String use_yn,
    FieldValue use_ynFieldValue,
    String? regr_id,
    FieldValue regr_idFieldValue,
    String? regr_nm,
    FieldValue regr_nmFieldValue,
    String? modr_id,
    FieldValue modr_idFieldValue,
    String? modr_nm,
    FieldValue modr_nmFieldValue,
    double rsd_qty,
    FieldValue rsd_qtyFieldValue,
    DateTime? last_touched,
    FieldValue last_touchedFieldValue,
    double supply_price,
    FieldValue supply_priceFieldValue,
    double retail_price,
    FieldValue retail_priceFieldValue,
    String? spplr_item_cls_cd,
    FieldValue spplr_item_cls_cdFieldValue,
    String? spplr_item_cd,
    FieldValue spplr_item_cdFieldValue,
    String? spplr_item_nm,
    FieldValue spplr_item_nmFieldValue,
    bool ebm_synced,
    FieldValue ebm_syncedFieldValue,
    String tax_type,
    FieldValue tax_typeFieldValue,
    List<int> branch_ids,
    FieldValue branch_idsFieldValue,
    Stock stock,
    FieldValue stockFieldValue,
    DateTime? updated_at,
    FieldValue updated_atFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    String? id,
    FieldValue idFieldValue,
    int? variant_id,
    FieldValue variant_idFieldValue,
    DateTime? deleted_at,
    FieldValue deleted_atFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? color,
    FieldValue colorFieldValue,
    String? sku,
    FieldValue skuFieldValue,
    int? product_id,
    FieldValue product_idFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? product_name,
    FieldValue product_nameFieldValue,
    int? branch_id,
    FieldValue branch_idFieldValue,
    String tax_name,
    FieldValue tax_nameFieldValue,
    double tax_percentage,
    FieldValue tax_percentageFieldValue,
    bool is_tax_exempted,
    FieldValue is_tax_exemptedFieldValue,
    int? item_seq,
    FieldValue item_seqFieldValue,
    String isrcc_cd,
    FieldValue isrcc_cdFieldValue,
    String isrcc_nm,
    FieldValue isrcc_nmFieldValue,
    int isrc_rt,
    FieldValue isrc_rtFieldValue,
    int isrc_amt,
    FieldValue isrc_amtFieldValue,
    String tax_ty_cd,
    FieldValue tax_ty_cdFieldValue,
    String bcd,
    FieldValue bcdFieldValue,
    String? item_cls_cd,
    FieldValue item_cls_cdFieldValue,
    String? item_ty_cd,
    FieldValue item_ty_cdFieldValue,
    String item_std_nm,
    FieldValue item_std_nmFieldValue,
    String orgn_nat_cd,
    FieldValue orgn_nat_cdFieldValue,
    String pkg,
    FieldValue pkgFieldValue,
    String item_cd,
    FieldValue item_cdFieldValue,
    String pkg_unit_cd,
    FieldValue pkg_unit_cdFieldValue,
    String qty_unit_cd,
    FieldValue qty_unit_cdFieldValue,
    String? item_nm,
    FieldValue item_nmFieldValue,
    double qty,
    FieldValue qtyFieldValue,
    double prc,
    FieldValue prcFieldValue,
    double sply_amt,
    FieldValue sply_amtFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhf_id,
    FieldValue bhf_idFieldValue,
    double dft_prc,
    FieldValue dft_prcFieldValue,
    String add_info,
    FieldValue add_infoFieldValue,
    String isrc_aplcb_yn,
    FieldValue isrc_aplcb_ynFieldValue,
    String use_yn,
    FieldValue use_ynFieldValue,
    String? regr_id,
    FieldValue regr_idFieldValue,
    String? regr_nm,
    FieldValue regr_nmFieldValue,
    String? modr_id,
    FieldValue modr_idFieldValue,
    String? modr_nm,
    FieldValue modr_nmFieldValue,
    double rsd_qty,
    FieldValue rsd_qtyFieldValue,
    DateTime? last_touched,
    FieldValue last_touchedFieldValue,
    double supply_price,
    FieldValue supply_priceFieldValue,
    double retail_price,
    FieldValue retail_priceFieldValue,
    String? spplr_item_cls_cd,
    FieldValue spplr_item_cls_cdFieldValue,
    String? spplr_item_cd,
    FieldValue spplr_item_cdFieldValue,
    String? spplr_item_nm,
    FieldValue spplr_item_nmFieldValue,
    bool ebm_synced,
    FieldValue ebm_syncedFieldValue,
    String tax_type,
    FieldValue tax_typeFieldValue,
    List<int> branch_ids,
    FieldValue branch_idsFieldValue,
    Stock stock,
    FieldValue stockFieldValue,
    DateTime? updated_at,
    FieldValue updated_atFieldValue,
  });
}

class _$VariantDocumentReference
    extends FirestoreDocumentReference<Variant, VariantDocumentSnapshot>
    implements VariantDocumentReference {
  _$VariantDocumentReference(this.reference);

  @override
  final DocumentReference<Variant> reference;

  /// A reference to the [VariantCollectionReference] containing this document.
  VariantCollectionReference get parent {
    return _$VariantCollectionReference(reference.firestore);
  }

  @override
  Stream<VariantDocumentSnapshot> snapshots() {
    return reference.snapshots().map(VariantDocumentSnapshot._);
  }

  @override
  Future<VariantDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then(VariantDocumentSnapshot._);
  }

  @override
  Future<VariantDocumentSnapshot> transactionGet(Transaction transaction) {
    return transaction.get(reference).then(VariantDocumentSnapshot._);
  }

  Future<void> set(
    Variant model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? variant_idFieldValue,
    FieldValue? deleted_atFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? skuFieldValue,
    FieldValue? product_idFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? product_nameFieldValue,
    FieldValue? branch_idFieldValue,
    FieldValue? tax_nameFieldValue,
    FieldValue? tax_percentageFieldValue,
    FieldValue? is_tax_exemptedFieldValue,
    FieldValue? item_seqFieldValue,
    FieldValue? isrcc_cdFieldValue,
    FieldValue? isrcc_nmFieldValue,
    FieldValue? isrc_rtFieldValue,
    FieldValue? isrc_amtFieldValue,
    FieldValue? tax_ty_cdFieldValue,
    FieldValue? bcdFieldValue,
    FieldValue? item_cls_cdFieldValue,
    FieldValue? item_ty_cdFieldValue,
    FieldValue? item_std_nmFieldValue,
    FieldValue? orgn_nat_cdFieldValue,
    FieldValue? pkgFieldValue,
    FieldValue? item_cdFieldValue,
    FieldValue? pkg_unit_cdFieldValue,
    FieldValue? qty_unit_cdFieldValue,
    FieldValue? item_nmFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? prcFieldValue,
    FieldValue? sply_amtFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhf_idFieldValue,
    FieldValue? dft_prcFieldValue,
    FieldValue? add_infoFieldValue,
    FieldValue? isrc_aplcb_ynFieldValue,
    FieldValue? use_ynFieldValue,
    FieldValue? regr_idFieldValue,
    FieldValue? regr_nmFieldValue,
    FieldValue? modr_idFieldValue,
    FieldValue? modr_nmFieldValue,
    FieldValue? rsd_qtyFieldValue,
    FieldValue? last_touchedFieldValue,
    FieldValue? supply_priceFieldValue,
    FieldValue? retail_priceFieldValue,
    FieldValue? spplr_item_cls_cdFieldValue,
    FieldValue? spplr_item_cdFieldValue,
    FieldValue? spplr_item_nmFieldValue,
    FieldValue? ebm_syncedFieldValue,
    FieldValue? tax_typeFieldValue,
    FieldValue? branch_idsFieldValue,
    FieldValue? stockFieldValue,
    FieldValue? updated_atFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (variant_idFieldValue != null)
        _$VariantFieldMap['variant_id']!: variant_idFieldValue,
      if (deleted_atFieldValue != null)
        _$VariantFieldMap['deleted_at']!: deleted_atFieldValue,
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (product_idFieldValue != null)
        _$VariantFieldMap['product_id']!: product_idFieldValue,
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (product_nameFieldValue != null)
        _$VariantFieldMap['product_name']!: product_nameFieldValue,
      if (branch_idFieldValue != null)
        _$VariantFieldMap['branch_id']!: branch_idFieldValue,
      if (tax_nameFieldValue != null)
        _$VariantFieldMap['tax_name']!: tax_nameFieldValue,
      if (tax_percentageFieldValue != null)
        _$VariantFieldMap['tax_percentage']!: tax_percentageFieldValue,
      if (is_tax_exemptedFieldValue != null)
        _$VariantFieldMap['is_tax_exempted']!: is_tax_exemptedFieldValue,
      if (item_seqFieldValue != null)
        _$VariantFieldMap['item_seq']!: item_seqFieldValue,
      if (isrcc_cdFieldValue != null)
        _$VariantFieldMap['isrcc_cd']!: isrcc_cdFieldValue,
      if (isrcc_nmFieldValue != null)
        _$VariantFieldMap['isrcc_nm']!: isrcc_nmFieldValue,
      if (isrc_rtFieldValue != null)
        _$VariantFieldMap['isrc_rt']!: isrc_rtFieldValue,
      if (isrc_amtFieldValue != null)
        _$VariantFieldMap['isrc_amt']!: isrc_amtFieldValue,
      if (tax_ty_cdFieldValue != null)
        _$VariantFieldMap['tax_ty_cd']!: tax_ty_cdFieldValue,
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (item_cls_cdFieldValue != null)
        _$VariantFieldMap['item_cls_cd']!: item_cls_cdFieldValue,
      if (item_ty_cdFieldValue != null)
        _$VariantFieldMap['item_ty_cd']!: item_ty_cdFieldValue,
      if (item_std_nmFieldValue != null)
        _$VariantFieldMap['item_std_nm']!: item_std_nmFieldValue,
      if (orgn_nat_cdFieldValue != null)
        _$VariantFieldMap['orgn_nat_cd']!: orgn_nat_cdFieldValue,
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (item_cdFieldValue != null)
        _$VariantFieldMap['item_cd']!: item_cdFieldValue,
      if (pkg_unit_cdFieldValue != null)
        _$VariantFieldMap['pkg_unit_cd']!: pkg_unit_cdFieldValue,
      if (qty_unit_cdFieldValue != null)
        _$VariantFieldMap['qty_unit_cd']!: qty_unit_cdFieldValue,
      if (item_nmFieldValue != null)
        _$VariantFieldMap['item_nm']!: item_nmFieldValue,
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (sply_amtFieldValue != null)
        _$VariantFieldMap['sply_amt']!: sply_amtFieldValue,
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhf_idFieldValue != null)
        _$VariantFieldMap['bhf_id']!: bhf_idFieldValue,
      if (dft_prcFieldValue != null)
        _$VariantFieldMap['dft_prc']!: dft_prcFieldValue,
      if (add_infoFieldValue != null)
        _$VariantFieldMap['add_info']!: add_infoFieldValue,
      if (isrc_aplcb_ynFieldValue != null)
        _$VariantFieldMap['isrc_aplcb_yn']!: isrc_aplcb_ynFieldValue,
      if (use_ynFieldValue != null)
        _$VariantFieldMap['use_yn']!: use_ynFieldValue,
      if (regr_idFieldValue != null)
        _$VariantFieldMap['regr_id']!: regr_idFieldValue,
      if (regr_nmFieldValue != null)
        _$VariantFieldMap['regr_nm']!: regr_nmFieldValue,
      if (modr_idFieldValue != null)
        _$VariantFieldMap['modr_id']!: modr_idFieldValue,
      if (modr_nmFieldValue != null)
        _$VariantFieldMap['modr_nm']!: modr_nmFieldValue,
      if (rsd_qtyFieldValue != null)
        _$VariantFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (last_touchedFieldValue != null)
        _$VariantFieldMap['last_touched']!: last_touchedFieldValue,
      if (supply_priceFieldValue != null)
        _$VariantFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_priceFieldValue != null)
        _$VariantFieldMap['retail_price']!: retail_priceFieldValue,
      if (spplr_item_cls_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cls_cd']!: spplr_item_cls_cdFieldValue,
      if (spplr_item_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cd']!: spplr_item_cdFieldValue,
      if (spplr_item_nmFieldValue != null)
        _$VariantFieldMap['spplr_item_nm']!: spplr_item_nmFieldValue,
      if (ebm_syncedFieldValue != null)
        _$VariantFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (tax_typeFieldValue != null)
        _$VariantFieldMap['tax_type']!: tax_typeFieldValue,
      if (branch_idsFieldValue != null)
        _$VariantFieldMap['branch_ids']!: branch_idsFieldValue,
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
      if (updated_atFieldValue != null)
        _$VariantFieldMap['updated_at']!: updated_atFieldValue,
    };

    final castedReference = reference.withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, options) => throw UnimplementedError(),
      toFirestore: (value, options) => value,
    );
    return castedReference.set(json, options);
  }

  void transactionSet(
    Transaction transaction,
    Variant model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? variant_idFieldValue,
    FieldValue? deleted_atFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? skuFieldValue,
    FieldValue? product_idFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? product_nameFieldValue,
    FieldValue? branch_idFieldValue,
    FieldValue? tax_nameFieldValue,
    FieldValue? tax_percentageFieldValue,
    FieldValue? is_tax_exemptedFieldValue,
    FieldValue? item_seqFieldValue,
    FieldValue? isrcc_cdFieldValue,
    FieldValue? isrcc_nmFieldValue,
    FieldValue? isrc_rtFieldValue,
    FieldValue? isrc_amtFieldValue,
    FieldValue? tax_ty_cdFieldValue,
    FieldValue? bcdFieldValue,
    FieldValue? item_cls_cdFieldValue,
    FieldValue? item_ty_cdFieldValue,
    FieldValue? item_std_nmFieldValue,
    FieldValue? orgn_nat_cdFieldValue,
    FieldValue? pkgFieldValue,
    FieldValue? item_cdFieldValue,
    FieldValue? pkg_unit_cdFieldValue,
    FieldValue? qty_unit_cdFieldValue,
    FieldValue? item_nmFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? prcFieldValue,
    FieldValue? sply_amtFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhf_idFieldValue,
    FieldValue? dft_prcFieldValue,
    FieldValue? add_infoFieldValue,
    FieldValue? isrc_aplcb_ynFieldValue,
    FieldValue? use_ynFieldValue,
    FieldValue? regr_idFieldValue,
    FieldValue? regr_nmFieldValue,
    FieldValue? modr_idFieldValue,
    FieldValue? modr_nmFieldValue,
    FieldValue? rsd_qtyFieldValue,
    FieldValue? last_touchedFieldValue,
    FieldValue? supply_priceFieldValue,
    FieldValue? retail_priceFieldValue,
    FieldValue? spplr_item_cls_cdFieldValue,
    FieldValue? spplr_item_cdFieldValue,
    FieldValue? spplr_item_nmFieldValue,
    FieldValue? ebm_syncedFieldValue,
    FieldValue? tax_typeFieldValue,
    FieldValue? branch_idsFieldValue,
    FieldValue? stockFieldValue,
    FieldValue? updated_atFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (variant_idFieldValue != null)
        _$VariantFieldMap['variant_id']!: variant_idFieldValue,
      if (deleted_atFieldValue != null)
        _$VariantFieldMap['deleted_at']!: deleted_atFieldValue,
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (product_idFieldValue != null)
        _$VariantFieldMap['product_id']!: product_idFieldValue,
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (product_nameFieldValue != null)
        _$VariantFieldMap['product_name']!: product_nameFieldValue,
      if (branch_idFieldValue != null)
        _$VariantFieldMap['branch_id']!: branch_idFieldValue,
      if (tax_nameFieldValue != null)
        _$VariantFieldMap['tax_name']!: tax_nameFieldValue,
      if (tax_percentageFieldValue != null)
        _$VariantFieldMap['tax_percentage']!: tax_percentageFieldValue,
      if (is_tax_exemptedFieldValue != null)
        _$VariantFieldMap['is_tax_exempted']!: is_tax_exemptedFieldValue,
      if (item_seqFieldValue != null)
        _$VariantFieldMap['item_seq']!: item_seqFieldValue,
      if (isrcc_cdFieldValue != null)
        _$VariantFieldMap['isrcc_cd']!: isrcc_cdFieldValue,
      if (isrcc_nmFieldValue != null)
        _$VariantFieldMap['isrcc_nm']!: isrcc_nmFieldValue,
      if (isrc_rtFieldValue != null)
        _$VariantFieldMap['isrc_rt']!: isrc_rtFieldValue,
      if (isrc_amtFieldValue != null)
        _$VariantFieldMap['isrc_amt']!: isrc_amtFieldValue,
      if (tax_ty_cdFieldValue != null)
        _$VariantFieldMap['tax_ty_cd']!: tax_ty_cdFieldValue,
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (item_cls_cdFieldValue != null)
        _$VariantFieldMap['item_cls_cd']!: item_cls_cdFieldValue,
      if (item_ty_cdFieldValue != null)
        _$VariantFieldMap['item_ty_cd']!: item_ty_cdFieldValue,
      if (item_std_nmFieldValue != null)
        _$VariantFieldMap['item_std_nm']!: item_std_nmFieldValue,
      if (orgn_nat_cdFieldValue != null)
        _$VariantFieldMap['orgn_nat_cd']!: orgn_nat_cdFieldValue,
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (item_cdFieldValue != null)
        _$VariantFieldMap['item_cd']!: item_cdFieldValue,
      if (pkg_unit_cdFieldValue != null)
        _$VariantFieldMap['pkg_unit_cd']!: pkg_unit_cdFieldValue,
      if (qty_unit_cdFieldValue != null)
        _$VariantFieldMap['qty_unit_cd']!: qty_unit_cdFieldValue,
      if (item_nmFieldValue != null)
        _$VariantFieldMap['item_nm']!: item_nmFieldValue,
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (sply_amtFieldValue != null)
        _$VariantFieldMap['sply_amt']!: sply_amtFieldValue,
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhf_idFieldValue != null)
        _$VariantFieldMap['bhf_id']!: bhf_idFieldValue,
      if (dft_prcFieldValue != null)
        _$VariantFieldMap['dft_prc']!: dft_prcFieldValue,
      if (add_infoFieldValue != null)
        _$VariantFieldMap['add_info']!: add_infoFieldValue,
      if (isrc_aplcb_ynFieldValue != null)
        _$VariantFieldMap['isrc_aplcb_yn']!: isrc_aplcb_ynFieldValue,
      if (use_ynFieldValue != null)
        _$VariantFieldMap['use_yn']!: use_ynFieldValue,
      if (regr_idFieldValue != null)
        _$VariantFieldMap['regr_id']!: regr_idFieldValue,
      if (regr_nmFieldValue != null)
        _$VariantFieldMap['regr_nm']!: regr_nmFieldValue,
      if (modr_idFieldValue != null)
        _$VariantFieldMap['modr_id']!: modr_idFieldValue,
      if (modr_nmFieldValue != null)
        _$VariantFieldMap['modr_nm']!: modr_nmFieldValue,
      if (rsd_qtyFieldValue != null)
        _$VariantFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (last_touchedFieldValue != null)
        _$VariantFieldMap['last_touched']!: last_touchedFieldValue,
      if (supply_priceFieldValue != null)
        _$VariantFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_priceFieldValue != null)
        _$VariantFieldMap['retail_price']!: retail_priceFieldValue,
      if (spplr_item_cls_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cls_cd']!: spplr_item_cls_cdFieldValue,
      if (spplr_item_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cd']!: spplr_item_cdFieldValue,
      if (spplr_item_nmFieldValue != null)
        _$VariantFieldMap['spplr_item_nm']!: spplr_item_nmFieldValue,
      if (ebm_syncedFieldValue != null)
        _$VariantFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (tax_typeFieldValue != null)
        _$VariantFieldMap['tax_type']!: tax_typeFieldValue,
      if (branch_idsFieldValue != null)
        _$VariantFieldMap['branch_ids']!: branch_idsFieldValue,
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
      if (updated_atFieldValue != null)
        _$VariantFieldMap['updated_at']!: updated_atFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Variant model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? variant_idFieldValue,
    FieldValue? deleted_atFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? skuFieldValue,
    FieldValue? product_idFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? product_nameFieldValue,
    FieldValue? branch_idFieldValue,
    FieldValue? tax_nameFieldValue,
    FieldValue? tax_percentageFieldValue,
    FieldValue? is_tax_exemptedFieldValue,
    FieldValue? item_seqFieldValue,
    FieldValue? isrcc_cdFieldValue,
    FieldValue? isrcc_nmFieldValue,
    FieldValue? isrc_rtFieldValue,
    FieldValue? isrc_amtFieldValue,
    FieldValue? tax_ty_cdFieldValue,
    FieldValue? bcdFieldValue,
    FieldValue? item_cls_cdFieldValue,
    FieldValue? item_ty_cdFieldValue,
    FieldValue? item_std_nmFieldValue,
    FieldValue? orgn_nat_cdFieldValue,
    FieldValue? pkgFieldValue,
    FieldValue? item_cdFieldValue,
    FieldValue? pkg_unit_cdFieldValue,
    FieldValue? qty_unit_cdFieldValue,
    FieldValue? item_nmFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? prcFieldValue,
    FieldValue? sply_amtFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhf_idFieldValue,
    FieldValue? dft_prcFieldValue,
    FieldValue? add_infoFieldValue,
    FieldValue? isrc_aplcb_ynFieldValue,
    FieldValue? use_ynFieldValue,
    FieldValue? regr_idFieldValue,
    FieldValue? regr_nmFieldValue,
    FieldValue? modr_idFieldValue,
    FieldValue? modr_nmFieldValue,
    FieldValue? rsd_qtyFieldValue,
    FieldValue? last_touchedFieldValue,
    FieldValue? supply_priceFieldValue,
    FieldValue? retail_priceFieldValue,
    FieldValue? spplr_item_cls_cdFieldValue,
    FieldValue? spplr_item_cdFieldValue,
    FieldValue? spplr_item_nmFieldValue,
    FieldValue? ebm_syncedFieldValue,
    FieldValue? tax_typeFieldValue,
    FieldValue? branch_idsFieldValue,
    FieldValue? stockFieldValue,
    FieldValue? updated_atFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (variant_idFieldValue != null)
        _$VariantFieldMap['variant_id']!: variant_idFieldValue,
      if (deleted_atFieldValue != null)
        _$VariantFieldMap['deleted_at']!: deleted_atFieldValue,
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (product_idFieldValue != null)
        _$VariantFieldMap['product_id']!: product_idFieldValue,
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (product_nameFieldValue != null)
        _$VariantFieldMap['product_name']!: product_nameFieldValue,
      if (branch_idFieldValue != null)
        _$VariantFieldMap['branch_id']!: branch_idFieldValue,
      if (tax_nameFieldValue != null)
        _$VariantFieldMap['tax_name']!: tax_nameFieldValue,
      if (tax_percentageFieldValue != null)
        _$VariantFieldMap['tax_percentage']!: tax_percentageFieldValue,
      if (is_tax_exemptedFieldValue != null)
        _$VariantFieldMap['is_tax_exempted']!: is_tax_exemptedFieldValue,
      if (item_seqFieldValue != null)
        _$VariantFieldMap['item_seq']!: item_seqFieldValue,
      if (isrcc_cdFieldValue != null)
        _$VariantFieldMap['isrcc_cd']!: isrcc_cdFieldValue,
      if (isrcc_nmFieldValue != null)
        _$VariantFieldMap['isrcc_nm']!: isrcc_nmFieldValue,
      if (isrc_rtFieldValue != null)
        _$VariantFieldMap['isrc_rt']!: isrc_rtFieldValue,
      if (isrc_amtFieldValue != null)
        _$VariantFieldMap['isrc_amt']!: isrc_amtFieldValue,
      if (tax_ty_cdFieldValue != null)
        _$VariantFieldMap['tax_ty_cd']!: tax_ty_cdFieldValue,
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (item_cls_cdFieldValue != null)
        _$VariantFieldMap['item_cls_cd']!: item_cls_cdFieldValue,
      if (item_ty_cdFieldValue != null)
        _$VariantFieldMap['item_ty_cd']!: item_ty_cdFieldValue,
      if (item_std_nmFieldValue != null)
        _$VariantFieldMap['item_std_nm']!: item_std_nmFieldValue,
      if (orgn_nat_cdFieldValue != null)
        _$VariantFieldMap['orgn_nat_cd']!: orgn_nat_cdFieldValue,
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (item_cdFieldValue != null)
        _$VariantFieldMap['item_cd']!: item_cdFieldValue,
      if (pkg_unit_cdFieldValue != null)
        _$VariantFieldMap['pkg_unit_cd']!: pkg_unit_cdFieldValue,
      if (qty_unit_cdFieldValue != null)
        _$VariantFieldMap['qty_unit_cd']!: qty_unit_cdFieldValue,
      if (item_nmFieldValue != null)
        _$VariantFieldMap['item_nm']!: item_nmFieldValue,
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (sply_amtFieldValue != null)
        _$VariantFieldMap['sply_amt']!: sply_amtFieldValue,
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhf_idFieldValue != null)
        _$VariantFieldMap['bhf_id']!: bhf_idFieldValue,
      if (dft_prcFieldValue != null)
        _$VariantFieldMap['dft_prc']!: dft_prcFieldValue,
      if (add_infoFieldValue != null)
        _$VariantFieldMap['add_info']!: add_infoFieldValue,
      if (isrc_aplcb_ynFieldValue != null)
        _$VariantFieldMap['isrc_aplcb_yn']!: isrc_aplcb_ynFieldValue,
      if (use_ynFieldValue != null)
        _$VariantFieldMap['use_yn']!: use_ynFieldValue,
      if (regr_idFieldValue != null)
        _$VariantFieldMap['regr_id']!: regr_idFieldValue,
      if (regr_nmFieldValue != null)
        _$VariantFieldMap['regr_nm']!: regr_nmFieldValue,
      if (modr_idFieldValue != null)
        _$VariantFieldMap['modr_id']!: modr_idFieldValue,
      if (modr_nmFieldValue != null)
        _$VariantFieldMap['modr_nm']!: modr_nmFieldValue,
      if (rsd_qtyFieldValue != null)
        _$VariantFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (last_touchedFieldValue != null)
        _$VariantFieldMap['last_touched']!: last_touchedFieldValue,
      if (supply_priceFieldValue != null)
        _$VariantFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_priceFieldValue != null)
        _$VariantFieldMap['retail_price']!: retail_priceFieldValue,
      if (spplr_item_cls_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cls_cd']!: spplr_item_cls_cdFieldValue,
      if (spplr_item_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cd']!: spplr_item_cdFieldValue,
      if (spplr_item_nmFieldValue != null)
        _$VariantFieldMap['spplr_item_nm']!: spplr_item_nmFieldValue,
      if (ebm_syncedFieldValue != null)
        _$VariantFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (tax_typeFieldValue != null)
        _$VariantFieldMap['tax_type']!: tax_typeFieldValue,
      if (branch_idsFieldValue != null)
        _$VariantFieldMap['branch_ids']!: branch_idsFieldValue,
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
      if (updated_atFieldValue != null)
        _$VariantFieldMap['updated_at']!: updated_atFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? variant_id = _sentinel,
    FieldValue? variant_idFieldValue,
    Object? deleted_at = _sentinel,
    FieldValue? deleted_atFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? sku = _sentinel,
    FieldValue? skuFieldValue,
    Object? product_id = _sentinel,
    FieldValue? product_idFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? product_name = _sentinel,
    FieldValue? product_nameFieldValue,
    Object? branch_id = _sentinel,
    FieldValue? branch_idFieldValue,
    Object? tax_name = _sentinel,
    FieldValue? tax_nameFieldValue,
    Object? tax_percentage = _sentinel,
    FieldValue? tax_percentageFieldValue,
    Object? is_tax_exempted = _sentinel,
    FieldValue? is_tax_exemptedFieldValue,
    Object? item_seq = _sentinel,
    FieldValue? item_seqFieldValue,
    Object? isrcc_cd = _sentinel,
    FieldValue? isrcc_cdFieldValue,
    Object? isrcc_nm = _sentinel,
    FieldValue? isrcc_nmFieldValue,
    Object? isrc_rt = _sentinel,
    FieldValue? isrc_rtFieldValue,
    Object? isrc_amt = _sentinel,
    FieldValue? isrc_amtFieldValue,
    Object? tax_ty_cd = _sentinel,
    FieldValue? tax_ty_cdFieldValue,
    Object? bcd = _sentinel,
    FieldValue? bcdFieldValue,
    Object? item_cls_cd = _sentinel,
    FieldValue? item_cls_cdFieldValue,
    Object? item_ty_cd = _sentinel,
    FieldValue? item_ty_cdFieldValue,
    Object? item_std_nm = _sentinel,
    FieldValue? item_std_nmFieldValue,
    Object? orgn_nat_cd = _sentinel,
    FieldValue? orgn_nat_cdFieldValue,
    Object? pkg = _sentinel,
    FieldValue? pkgFieldValue,
    Object? item_cd = _sentinel,
    FieldValue? item_cdFieldValue,
    Object? pkg_unit_cd = _sentinel,
    FieldValue? pkg_unit_cdFieldValue,
    Object? qty_unit_cd = _sentinel,
    FieldValue? qty_unit_cdFieldValue,
    Object? item_nm = _sentinel,
    FieldValue? item_nmFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? prc = _sentinel,
    FieldValue? prcFieldValue,
    Object? sply_amt = _sentinel,
    FieldValue? sply_amtFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhf_id = _sentinel,
    FieldValue? bhf_idFieldValue,
    Object? dft_prc = _sentinel,
    FieldValue? dft_prcFieldValue,
    Object? add_info = _sentinel,
    FieldValue? add_infoFieldValue,
    Object? isrc_aplcb_yn = _sentinel,
    FieldValue? isrc_aplcb_ynFieldValue,
    Object? use_yn = _sentinel,
    FieldValue? use_ynFieldValue,
    Object? regr_id = _sentinel,
    FieldValue? regr_idFieldValue,
    Object? regr_nm = _sentinel,
    FieldValue? regr_nmFieldValue,
    Object? modr_id = _sentinel,
    FieldValue? modr_idFieldValue,
    Object? modr_nm = _sentinel,
    FieldValue? modr_nmFieldValue,
    Object? rsd_qty = _sentinel,
    FieldValue? rsd_qtyFieldValue,
    Object? last_touched = _sentinel,
    FieldValue? last_touchedFieldValue,
    Object? supply_price = _sentinel,
    FieldValue? supply_priceFieldValue,
    Object? retail_price = _sentinel,
    FieldValue? retail_priceFieldValue,
    Object? spplr_item_cls_cd = _sentinel,
    FieldValue? spplr_item_cls_cdFieldValue,
    Object? spplr_item_cd = _sentinel,
    FieldValue? spplr_item_cdFieldValue,
    Object? spplr_item_nm = _sentinel,
    FieldValue? spplr_item_nmFieldValue,
    Object? ebm_synced = _sentinel,
    FieldValue? ebm_syncedFieldValue,
    Object? tax_type = _sentinel,
    FieldValue? tax_typeFieldValue,
    Object? branch_ids = _sentinel,
    FieldValue? branch_idsFieldValue,
    Object? stock = _sentinel,
    FieldValue? stockFieldValue,
    Object? updated_at = _sentinel,
    FieldValue? updated_atFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      variant_id == _sentinel || variant_idFieldValue == null,
      "Cannot specify both variant_id and variant_idFieldValue",
    );
    assert(
      deleted_at == _sentinel || deleted_atFieldValue == null,
      "Cannot specify both deleted_at and deleted_atFieldValue",
    );
    assert(
      name == _sentinel || nameFieldValue == null,
      "Cannot specify both name and nameFieldValue",
    );
    assert(
      color == _sentinel || colorFieldValue == null,
      "Cannot specify both color and colorFieldValue",
    );
    assert(
      sku == _sentinel || skuFieldValue == null,
      "Cannot specify both sku and skuFieldValue",
    );
    assert(
      product_id == _sentinel || product_idFieldValue == null,
      "Cannot specify both product_id and product_idFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      product_name == _sentinel || product_nameFieldValue == null,
      "Cannot specify both product_name and product_nameFieldValue",
    );
    assert(
      branch_id == _sentinel || branch_idFieldValue == null,
      "Cannot specify both branch_id and branch_idFieldValue",
    );
    assert(
      tax_name == _sentinel || tax_nameFieldValue == null,
      "Cannot specify both tax_name and tax_nameFieldValue",
    );
    assert(
      tax_percentage == _sentinel || tax_percentageFieldValue == null,
      "Cannot specify both tax_percentage and tax_percentageFieldValue",
    );
    assert(
      is_tax_exempted == _sentinel || is_tax_exemptedFieldValue == null,
      "Cannot specify both is_tax_exempted and is_tax_exemptedFieldValue",
    );
    assert(
      item_seq == _sentinel || item_seqFieldValue == null,
      "Cannot specify both item_seq and item_seqFieldValue",
    );
    assert(
      isrcc_cd == _sentinel || isrcc_cdFieldValue == null,
      "Cannot specify both isrcc_cd and isrcc_cdFieldValue",
    );
    assert(
      isrcc_nm == _sentinel || isrcc_nmFieldValue == null,
      "Cannot specify both isrcc_nm and isrcc_nmFieldValue",
    );
    assert(
      isrc_rt == _sentinel || isrc_rtFieldValue == null,
      "Cannot specify both isrc_rt and isrc_rtFieldValue",
    );
    assert(
      isrc_amt == _sentinel || isrc_amtFieldValue == null,
      "Cannot specify both isrc_amt and isrc_amtFieldValue",
    );
    assert(
      tax_ty_cd == _sentinel || tax_ty_cdFieldValue == null,
      "Cannot specify both tax_ty_cd and tax_ty_cdFieldValue",
    );
    assert(
      bcd == _sentinel || bcdFieldValue == null,
      "Cannot specify both bcd and bcdFieldValue",
    );
    assert(
      item_cls_cd == _sentinel || item_cls_cdFieldValue == null,
      "Cannot specify both item_cls_cd and item_cls_cdFieldValue",
    );
    assert(
      item_ty_cd == _sentinel || item_ty_cdFieldValue == null,
      "Cannot specify both item_ty_cd and item_ty_cdFieldValue",
    );
    assert(
      item_std_nm == _sentinel || item_std_nmFieldValue == null,
      "Cannot specify both item_std_nm and item_std_nmFieldValue",
    );
    assert(
      orgn_nat_cd == _sentinel || orgn_nat_cdFieldValue == null,
      "Cannot specify both orgn_nat_cd and orgn_nat_cdFieldValue",
    );
    assert(
      pkg == _sentinel || pkgFieldValue == null,
      "Cannot specify both pkg and pkgFieldValue",
    );
    assert(
      item_cd == _sentinel || item_cdFieldValue == null,
      "Cannot specify both item_cd and item_cdFieldValue",
    );
    assert(
      pkg_unit_cd == _sentinel || pkg_unit_cdFieldValue == null,
      "Cannot specify both pkg_unit_cd and pkg_unit_cdFieldValue",
    );
    assert(
      qty_unit_cd == _sentinel || qty_unit_cdFieldValue == null,
      "Cannot specify both qty_unit_cd and qty_unit_cdFieldValue",
    );
    assert(
      item_nm == _sentinel || item_nmFieldValue == null,
      "Cannot specify both item_nm and item_nmFieldValue",
    );
    assert(
      qty == _sentinel || qtyFieldValue == null,
      "Cannot specify both qty and qtyFieldValue",
    );
    assert(
      prc == _sentinel || prcFieldValue == null,
      "Cannot specify both prc and prcFieldValue",
    );
    assert(
      sply_amt == _sentinel || sply_amtFieldValue == null,
      "Cannot specify both sply_amt and sply_amtFieldValue",
    );
    assert(
      tin == _sentinel || tinFieldValue == null,
      "Cannot specify both tin and tinFieldValue",
    );
    assert(
      bhf_id == _sentinel || bhf_idFieldValue == null,
      "Cannot specify both bhf_id and bhf_idFieldValue",
    );
    assert(
      dft_prc == _sentinel || dft_prcFieldValue == null,
      "Cannot specify both dft_prc and dft_prcFieldValue",
    );
    assert(
      add_info == _sentinel || add_infoFieldValue == null,
      "Cannot specify both add_info and add_infoFieldValue",
    );
    assert(
      isrc_aplcb_yn == _sentinel || isrc_aplcb_ynFieldValue == null,
      "Cannot specify both isrc_aplcb_yn and isrc_aplcb_ynFieldValue",
    );
    assert(
      use_yn == _sentinel || use_ynFieldValue == null,
      "Cannot specify both use_yn and use_ynFieldValue",
    );
    assert(
      regr_id == _sentinel || regr_idFieldValue == null,
      "Cannot specify both regr_id and regr_idFieldValue",
    );
    assert(
      regr_nm == _sentinel || regr_nmFieldValue == null,
      "Cannot specify both regr_nm and regr_nmFieldValue",
    );
    assert(
      modr_id == _sentinel || modr_idFieldValue == null,
      "Cannot specify both modr_id and modr_idFieldValue",
    );
    assert(
      modr_nm == _sentinel || modr_nmFieldValue == null,
      "Cannot specify both modr_nm and modr_nmFieldValue",
    );
    assert(
      rsd_qty == _sentinel || rsd_qtyFieldValue == null,
      "Cannot specify both rsd_qty and rsd_qtyFieldValue",
    );
    assert(
      last_touched == _sentinel || last_touchedFieldValue == null,
      "Cannot specify both last_touched and last_touchedFieldValue",
    );
    assert(
      supply_price == _sentinel || supply_priceFieldValue == null,
      "Cannot specify both supply_price and supply_priceFieldValue",
    );
    assert(
      retail_price == _sentinel || retail_priceFieldValue == null,
      "Cannot specify both retail_price and retail_priceFieldValue",
    );
    assert(
      spplr_item_cls_cd == _sentinel || spplr_item_cls_cdFieldValue == null,
      "Cannot specify both spplr_item_cls_cd and spplr_item_cls_cdFieldValue",
    );
    assert(
      spplr_item_cd == _sentinel || spplr_item_cdFieldValue == null,
      "Cannot specify both spplr_item_cd and spplr_item_cdFieldValue",
    );
    assert(
      spplr_item_nm == _sentinel || spplr_item_nmFieldValue == null,
      "Cannot specify both spplr_item_nm and spplr_item_nmFieldValue",
    );
    assert(
      ebm_synced == _sentinel || ebm_syncedFieldValue == null,
      "Cannot specify both ebm_synced and ebm_syncedFieldValue",
    );
    assert(
      tax_type == _sentinel || tax_typeFieldValue == null,
      "Cannot specify both tax_type and tax_typeFieldValue",
    );
    assert(
      branch_ids == _sentinel || branch_idsFieldValue == null,
      "Cannot specify both branch_ids and branch_idsFieldValue",
    );
    assert(
      stock == _sentinel || stockFieldValue == null,
      "Cannot specify both stock and stockFieldValue",
    );
    assert(
      updated_at == _sentinel || updated_atFieldValue == null,
      "Cannot specify both updated_at and updated_atFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$VariantFieldMap['id']!: _$VariantPerFieldToJson.id(id as String?),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (variant_id != _sentinel)
        _$VariantFieldMap['variant_id']!:
            _$VariantPerFieldToJson.variant_id(variant_id as int?),
      if (variant_idFieldValue != null)
        _$VariantFieldMap['variant_id']!: variant_idFieldValue,
      if (deleted_at != _sentinel)
        _$VariantFieldMap['deleted_at']!:
            _$VariantPerFieldToJson.deleted_at(deleted_at as DateTime?),
      if (deleted_atFieldValue != null)
        _$VariantFieldMap['deleted_at']!: deleted_atFieldValue,
      if (name != _sentinel)
        _$VariantFieldMap['name']!:
            _$VariantPerFieldToJson.name(name as String?),
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (color != _sentinel)
        _$VariantFieldMap['color']!:
            _$VariantPerFieldToJson.color(color as String?),
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (sku != _sentinel)
        _$VariantFieldMap['sku']!: _$VariantPerFieldToJson.sku(sku as String?),
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (product_id != _sentinel)
        _$VariantFieldMap['product_id']!:
            _$VariantPerFieldToJson.product_id(product_id as int?),
      if (product_idFieldValue != null)
        _$VariantFieldMap['product_id']!: product_idFieldValue,
      if (unit != _sentinel)
        _$VariantFieldMap['unit']!:
            _$VariantPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (product_name != _sentinel)
        _$VariantFieldMap['product_name']!:
            _$VariantPerFieldToJson.product_name(product_name as String?),
      if (product_nameFieldValue != null)
        _$VariantFieldMap['product_name']!: product_nameFieldValue,
      if (branch_id != _sentinel)
        _$VariantFieldMap['branch_id']!:
            _$VariantPerFieldToJson.branch_id(branch_id as int?),
      if (branch_idFieldValue != null)
        _$VariantFieldMap['branch_id']!: branch_idFieldValue,
      if (tax_name != _sentinel)
        _$VariantFieldMap['tax_name']!:
            _$VariantPerFieldToJson.tax_name(tax_name as String),
      if (tax_nameFieldValue != null)
        _$VariantFieldMap['tax_name']!: tax_nameFieldValue,
      if (tax_percentage != _sentinel)
        _$VariantFieldMap['tax_percentage']!:
            _$VariantPerFieldToJson.tax_percentage(tax_percentage as double),
      if (tax_percentageFieldValue != null)
        _$VariantFieldMap['tax_percentage']!: tax_percentageFieldValue,
      if (is_tax_exempted != _sentinel)
        _$VariantFieldMap['is_tax_exempted']!:
            _$VariantPerFieldToJson.is_tax_exempted(is_tax_exempted as bool),
      if (is_tax_exemptedFieldValue != null)
        _$VariantFieldMap['is_tax_exempted']!: is_tax_exemptedFieldValue,
      if (item_seq != _sentinel)
        _$VariantFieldMap['item_seq']!:
            _$VariantPerFieldToJson.item_seq(item_seq as int?),
      if (item_seqFieldValue != null)
        _$VariantFieldMap['item_seq']!: item_seqFieldValue,
      if (isrcc_cd != _sentinel)
        _$VariantFieldMap['isrcc_cd']!:
            _$VariantPerFieldToJson.isrcc_cd(isrcc_cd as String),
      if (isrcc_cdFieldValue != null)
        _$VariantFieldMap['isrcc_cd']!: isrcc_cdFieldValue,
      if (isrcc_nm != _sentinel)
        _$VariantFieldMap['isrcc_nm']!:
            _$VariantPerFieldToJson.isrcc_nm(isrcc_nm as String),
      if (isrcc_nmFieldValue != null)
        _$VariantFieldMap['isrcc_nm']!: isrcc_nmFieldValue,
      if (isrc_rt != _sentinel)
        _$VariantFieldMap['isrc_rt']!:
            _$VariantPerFieldToJson.isrc_rt(isrc_rt as int),
      if (isrc_rtFieldValue != null)
        _$VariantFieldMap['isrc_rt']!: isrc_rtFieldValue,
      if (isrc_amt != _sentinel)
        _$VariantFieldMap['isrc_amt']!:
            _$VariantPerFieldToJson.isrc_amt(isrc_amt as int),
      if (isrc_amtFieldValue != null)
        _$VariantFieldMap['isrc_amt']!: isrc_amtFieldValue,
      if (tax_ty_cd != _sentinel)
        _$VariantFieldMap['tax_ty_cd']!:
            _$VariantPerFieldToJson.tax_ty_cd(tax_ty_cd as String),
      if (tax_ty_cdFieldValue != null)
        _$VariantFieldMap['tax_ty_cd']!: tax_ty_cdFieldValue,
      if (bcd != _sentinel)
        _$VariantFieldMap['bcd']!: _$VariantPerFieldToJson.bcd(bcd as String),
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (item_cls_cd != _sentinel)
        _$VariantFieldMap['item_cls_cd']!:
            _$VariantPerFieldToJson.item_cls_cd(item_cls_cd as String?),
      if (item_cls_cdFieldValue != null)
        _$VariantFieldMap['item_cls_cd']!: item_cls_cdFieldValue,
      if (item_ty_cd != _sentinel)
        _$VariantFieldMap['item_ty_cd']!:
            _$VariantPerFieldToJson.item_ty_cd(item_ty_cd as String?),
      if (item_ty_cdFieldValue != null)
        _$VariantFieldMap['item_ty_cd']!: item_ty_cdFieldValue,
      if (item_std_nm != _sentinel)
        _$VariantFieldMap['item_std_nm']!:
            _$VariantPerFieldToJson.item_std_nm(item_std_nm as String),
      if (item_std_nmFieldValue != null)
        _$VariantFieldMap['item_std_nm']!: item_std_nmFieldValue,
      if (orgn_nat_cd != _sentinel)
        _$VariantFieldMap['orgn_nat_cd']!:
            _$VariantPerFieldToJson.orgn_nat_cd(orgn_nat_cd as String),
      if (orgn_nat_cdFieldValue != null)
        _$VariantFieldMap['orgn_nat_cd']!: orgn_nat_cdFieldValue,
      if (pkg != _sentinel)
        _$VariantFieldMap['pkg']!: _$VariantPerFieldToJson.pkg(pkg as String),
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (item_cd != _sentinel)
        _$VariantFieldMap['item_cd']!:
            _$VariantPerFieldToJson.item_cd(item_cd as String),
      if (item_cdFieldValue != null)
        _$VariantFieldMap['item_cd']!: item_cdFieldValue,
      if (pkg_unit_cd != _sentinel)
        _$VariantFieldMap['pkg_unit_cd']!:
            _$VariantPerFieldToJson.pkg_unit_cd(pkg_unit_cd as String),
      if (pkg_unit_cdFieldValue != null)
        _$VariantFieldMap['pkg_unit_cd']!: pkg_unit_cdFieldValue,
      if (qty_unit_cd != _sentinel)
        _$VariantFieldMap['qty_unit_cd']!:
            _$VariantPerFieldToJson.qty_unit_cd(qty_unit_cd as String),
      if (qty_unit_cdFieldValue != null)
        _$VariantFieldMap['qty_unit_cd']!: qty_unit_cdFieldValue,
      if (item_nm != _sentinel)
        _$VariantFieldMap['item_nm']!:
            _$VariantPerFieldToJson.item_nm(item_nm as String?),
      if (item_nmFieldValue != null)
        _$VariantFieldMap['item_nm']!: item_nmFieldValue,
      if (qty != _sentinel)
        _$VariantFieldMap['qty']!: _$VariantPerFieldToJson.qty(qty as double),
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prc != _sentinel)
        _$VariantFieldMap['prc']!: _$VariantPerFieldToJson.prc(prc as double),
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (sply_amt != _sentinel)
        _$VariantFieldMap['sply_amt']!:
            _$VariantPerFieldToJson.sply_amt(sply_amt as double),
      if (sply_amtFieldValue != null)
        _$VariantFieldMap['sply_amt']!: sply_amtFieldValue,
      if (tin != _sentinel)
        _$VariantFieldMap['tin']!: _$VariantPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhf_id != _sentinel)
        _$VariantFieldMap['bhf_id']!:
            _$VariantPerFieldToJson.bhf_id(bhf_id as String?),
      if (bhf_idFieldValue != null)
        _$VariantFieldMap['bhf_id']!: bhf_idFieldValue,
      if (dft_prc != _sentinel)
        _$VariantFieldMap['dft_prc']!:
            _$VariantPerFieldToJson.dft_prc(dft_prc as double),
      if (dft_prcFieldValue != null)
        _$VariantFieldMap['dft_prc']!: dft_prcFieldValue,
      if (add_info != _sentinel)
        _$VariantFieldMap['add_info']!:
            _$VariantPerFieldToJson.add_info(add_info as String),
      if (add_infoFieldValue != null)
        _$VariantFieldMap['add_info']!: add_infoFieldValue,
      if (isrc_aplcb_yn != _sentinel)
        _$VariantFieldMap['isrc_aplcb_yn']!:
            _$VariantPerFieldToJson.isrc_aplcb_yn(isrc_aplcb_yn as String),
      if (isrc_aplcb_ynFieldValue != null)
        _$VariantFieldMap['isrc_aplcb_yn']!: isrc_aplcb_ynFieldValue,
      if (use_yn != _sentinel)
        _$VariantFieldMap['use_yn']!:
            _$VariantPerFieldToJson.use_yn(use_yn as String),
      if (use_ynFieldValue != null)
        _$VariantFieldMap['use_yn']!: use_ynFieldValue,
      if (regr_id != _sentinel)
        _$VariantFieldMap['regr_id']!:
            _$VariantPerFieldToJson.regr_id(regr_id as String?),
      if (regr_idFieldValue != null)
        _$VariantFieldMap['regr_id']!: regr_idFieldValue,
      if (regr_nm != _sentinel)
        _$VariantFieldMap['regr_nm']!:
            _$VariantPerFieldToJson.regr_nm(regr_nm as String?),
      if (regr_nmFieldValue != null)
        _$VariantFieldMap['regr_nm']!: regr_nmFieldValue,
      if (modr_id != _sentinel)
        _$VariantFieldMap['modr_id']!:
            _$VariantPerFieldToJson.modr_id(modr_id as String?),
      if (modr_idFieldValue != null)
        _$VariantFieldMap['modr_id']!: modr_idFieldValue,
      if (modr_nm != _sentinel)
        _$VariantFieldMap['modr_nm']!:
            _$VariantPerFieldToJson.modr_nm(modr_nm as String?),
      if (modr_nmFieldValue != null)
        _$VariantFieldMap['modr_nm']!: modr_nmFieldValue,
      if (rsd_qty != _sentinel)
        _$VariantFieldMap['rsd_qty']!:
            _$VariantPerFieldToJson.rsd_qty(rsd_qty as double),
      if (rsd_qtyFieldValue != null)
        _$VariantFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (last_touched != _sentinel)
        _$VariantFieldMap['last_touched']!:
            _$VariantPerFieldToJson.last_touched(last_touched as DateTime?),
      if (last_touchedFieldValue != null)
        _$VariantFieldMap['last_touched']!: last_touchedFieldValue,
      if (supply_price != _sentinel)
        _$VariantFieldMap['supply_price']!:
            _$VariantPerFieldToJson.supply_price(supply_price as double),
      if (supply_priceFieldValue != null)
        _$VariantFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_price != _sentinel)
        _$VariantFieldMap['retail_price']!:
            _$VariantPerFieldToJson.retail_price(retail_price as double),
      if (retail_priceFieldValue != null)
        _$VariantFieldMap['retail_price']!: retail_priceFieldValue,
      if (spplr_item_cls_cd != _sentinel)
        _$VariantFieldMap['spplr_item_cls_cd']!: _$VariantPerFieldToJson
            .spplr_item_cls_cd(spplr_item_cls_cd as String?),
      if (spplr_item_cls_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cls_cd']!: spplr_item_cls_cdFieldValue,
      if (spplr_item_cd != _sentinel)
        _$VariantFieldMap['spplr_item_cd']!:
            _$VariantPerFieldToJson.spplr_item_cd(spplr_item_cd as String?),
      if (spplr_item_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cd']!: spplr_item_cdFieldValue,
      if (spplr_item_nm != _sentinel)
        _$VariantFieldMap['spplr_item_nm']!:
            _$VariantPerFieldToJson.spplr_item_nm(spplr_item_nm as String?),
      if (spplr_item_nmFieldValue != null)
        _$VariantFieldMap['spplr_item_nm']!: spplr_item_nmFieldValue,
      if (ebm_synced != _sentinel)
        _$VariantFieldMap['ebm_synced']!:
            _$VariantPerFieldToJson.ebm_synced(ebm_synced as bool),
      if (ebm_syncedFieldValue != null)
        _$VariantFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (tax_type != _sentinel)
        _$VariantFieldMap['tax_type']!:
            _$VariantPerFieldToJson.tax_type(tax_type as String),
      if (tax_typeFieldValue != null)
        _$VariantFieldMap['tax_type']!: tax_typeFieldValue,
      if (branch_ids != _sentinel)
        _$VariantFieldMap['branch_ids']!:
            _$VariantPerFieldToJson.branch_ids(branch_ids as List<int>),
      if (branch_idsFieldValue != null)
        _$VariantFieldMap['branch_ids']!: branch_idsFieldValue,
      if (stock != _sentinel)
        _$VariantFieldMap['stock']!:
            _$VariantPerFieldToJson.stock(stock as Stock),
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
      if (updated_at != _sentinel)
        _$VariantFieldMap['updated_at']!:
            _$VariantPerFieldToJson.updated_at(updated_at as DateTime?),
      if (updated_atFieldValue != null)
        _$VariantFieldMap['updated_at']!: updated_atFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? variant_id = _sentinel,
    FieldValue? variant_idFieldValue,
    Object? deleted_at = _sentinel,
    FieldValue? deleted_atFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? sku = _sentinel,
    FieldValue? skuFieldValue,
    Object? product_id = _sentinel,
    FieldValue? product_idFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? product_name = _sentinel,
    FieldValue? product_nameFieldValue,
    Object? branch_id = _sentinel,
    FieldValue? branch_idFieldValue,
    Object? tax_name = _sentinel,
    FieldValue? tax_nameFieldValue,
    Object? tax_percentage = _sentinel,
    FieldValue? tax_percentageFieldValue,
    Object? is_tax_exempted = _sentinel,
    FieldValue? is_tax_exemptedFieldValue,
    Object? item_seq = _sentinel,
    FieldValue? item_seqFieldValue,
    Object? isrcc_cd = _sentinel,
    FieldValue? isrcc_cdFieldValue,
    Object? isrcc_nm = _sentinel,
    FieldValue? isrcc_nmFieldValue,
    Object? isrc_rt = _sentinel,
    FieldValue? isrc_rtFieldValue,
    Object? isrc_amt = _sentinel,
    FieldValue? isrc_amtFieldValue,
    Object? tax_ty_cd = _sentinel,
    FieldValue? tax_ty_cdFieldValue,
    Object? bcd = _sentinel,
    FieldValue? bcdFieldValue,
    Object? item_cls_cd = _sentinel,
    FieldValue? item_cls_cdFieldValue,
    Object? item_ty_cd = _sentinel,
    FieldValue? item_ty_cdFieldValue,
    Object? item_std_nm = _sentinel,
    FieldValue? item_std_nmFieldValue,
    Object? orgn_nat_cd = _sentinel,
    FieldValue? orgn_nat_cdFieldValue,
    Object? pkg = _sentinel,
    FieldValue? pkgFieldValue,
    Object? item_cd = _sentinel,
    FieldValue? item_cdFieldValue,
    Object? pkg_unit_cd = _sentinel,
    FieldValue? pkg_unit_cdFieldValue,
    Object? qty_unit_cd = _sentinel,
    FieldValue? qty_unit_cdFieldValue,
    Object? item_nm = _sentinel,
    FieldValue? item_nmFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? prc = _sentinel,
    FieldValue? prcFieldValue,
    Object? sply_amt = _sentinel,
    FieldValue? sply_amtFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhf_id = _sentinel,
    FieldValue? bhf_idFieldValue,
    Object? dft_prc = _sentinel,
    FieldValue? dft_prcFieldValue,
    Object? add_info = _sentinel,
    FieldValue? add_infoFieldValue,
    Object? isrc_aplcb_yn = _sentinel,
    FieldValue? isrc_aplcb_ynFieldValue,
    Object? use_yn = _sentinel,
    FieldValue? use_ynFieldValue,
    Object? regr_id = _sentinel,
    FieldValue? regr_idFieldValue,
    Object? regr_nm = _sentinel,
    FieldValue? regr_nmFieldValue,
    Object? modr_id = _sentinel,
    FieldValue? modr_idFieldValue,
    Object? modr_nm = _sentinel,
    FieldValue? modr_nmFieldValue,
    Object? rsd_qty = _sentinel,
    FieldValue? rsd_qtyFieldValue,
    Object? last_touched = _sentinel,
    FieldValue? last_touchedFieldValue,
    Object? supply_price = _sentinel,
    FieldValue? supply_priceFieldValue,
    Object? retail_price = _sentinel,
    FieldValue? retail_priceFieldValue,
    Object? spplr_item_cls_cd = _sentinel,
    FieldValue? spplr_item_cls_cdFieldValue,
    Object? spplr_item_cd = _sentinel,
    FieldValue? spplr_item_cdFieldValue,
    Object? spplr_item_nm = _sentinel,
    FieldValue? spplr_item_nmFieldValue,
    Object? ebm_synced = _sentinel,
    FieldValue? ebm_syncedFieldValue,
    Object? tax_type = _sentinel,
    FieldValue? tax_typeFieldValue,
    Object? branch_ids = _sentinel,
    FieldValue? branch_idsFieldValue,
    Object? stock = _sentinel,
    FieldValue? stockFieldValue,
    Object? updated_at = _sentinel,
    FieldValue? updated_atFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      variant_id == _sentinel || variant_idFieldValue == null,
      "Cannot specify both variant_id and variant_idFieldValue",
    );
    assert(
      deleted_at == _sentinel || deleted_atFieldValue == null,
      "Cannot specify both deleted_at and deleted_atFieldValue",
    );
    assert(
      name == _sentinel || nameFieldValue == null,
      "Cannot specify both name and nameFieldValue",
    );
    assert(
      color == _sentinel || colorFieldValue == null,
      "Cannot specify both color and colorFieldValue",
    );
    assert(
      sku == _sentinel || skuFieldValue == null,
      "Cannot specify both sku and skuFieldValue",
    );
    assert(
      product_id == _sentinel || product_idFieldValue == null,
      "Cannot specify both product_id and product_idFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      product_name == _sentinel || product_nameFieldValue == null,
      "Cannot specify both product_name and product_nameFieldValue",
    );
    assert(
      branch_id == _sentinel || branch_idFieldValue == null,
      "Cannot specify both branch_id and branch_idFieldValue",
    );
    assert(
      tax_name == _sentinel || tax_nameFieldValue == null,
      "Cannot specify both tax_name and tax_nameFieldValue",
    );
    assert(
      tax_percentage == _sentinel || tax_percentageFieldValue == null,
      "Cannot specify both tax_percentage and tax_percentageFieldValue",
    );
    assert(
      is_tax_exempted == _sentinel || is_tax_exemptedFieldValue == null,
      "Cannot specify both is_tax_exempted and is_tax_exemptedFieldValue",
    );
    assert(
      item_seq == _sentinel || item_seqFieldValue == null,
      "Cannot specify both item_seq and item_seqFieldValue",
    );
    assert(
      isrcc_cd == _sentinel || isrcc_cdFieldValue == null,
      "Cannot specify both isrcc_cd and isrcc_cdFieldValue",
    );
    assert(
      isrcc_nm == _sentinel || isrcc_nmFieldValue == null,
      "Cannot specify both isrcc_nm and isrcc_nmFieldValue",
    );
    assert(
      isrc_rt == _sentinel || isrc_rtFieldValue == null,
      "Cannot specify both isrc_rt and isrc_rtFieldValue",
    );
    assert(
      isrc_amt == _sentinel || isrc_amtFieldValue == null,
      "Cannot specify both isrc_amt and isrc_amtFieldValue",
    );
    assert(
      tax_ty_cd == _sentinel || tax_ty_cdFieldValue == null,
      "Cannot specify both tax_ty_cd and tax_ty_cdFieldValue",
    );
    assert(
      bcd == _sentinel || bcdFieldValue == null,
      "Cannot specify both bcd and bcdFieldValue",
    );
    assert(
      item_cls_cd == _sentinel || item_cls_cdFieldValue == null,
      "Cannot specify both item_cls_cd and item_cls_cdFieldValue",
    );
    assert(
      item_ty_cd == _sentinel || item_ty_cdFieldValue == null,
      "Cannot specify both item_ty_cd and item_ty_cdFieldValue",
    );
    assert(
      item_std_nm == _sentinel || item_std_nmFieldValue == null,
      "Cannot specify both item_std_nm and item_std_nmFieldValue",
    );
    assert(
      orgn_nat_cd == _sentinel || orgn_nat_cdFieldValue == null,
      "Cannot specify both orgn_nat_cd and orgn_nat_cdFieldValue",
    );
    assert(
      pkg == _sentinel || pkgFieldValue == null,
      "Cannot specify both pkg and pkgFieldValue",
    );
    assert(
      item_cd == _sentinel || item_cdFieldValue == null,
      "Cannot specify both item_cd and item_cdFieldValue",
    );
    assert(
      pkg_unit_cd == _sentinel || pkg_unit_cdFieldValue == null,
      "Cannot specify both pkg_unit_cd and pkg_unit_cdFieldValue",
    );
    assert(
      qty_unit_cd == _sentinel || qty_unit_cdFieldValue == null,
      "Cannot specify both qty_unit_cd and qty_unit_cdFieldValue",
    );
    assert(
      item_nm == _sentinel || item_nmFieldValue == null,
      "Cannot specify both item_nm and item_nmFieldValue",
    );
    assert(
      qty == _sentinel || qtyFieldValue == null,
      "Cannot specify both qty and qtyFieldValue",
    );
    assert(
      prc == _sentinel || prcFieldValue == null,
      "Cannot specify both prc and prcFieldValue",
    );
    assert(
      sply_amt == _sentinel || sply_amtFieldValue == null,
      "Cannot specify both sply_amt and sply_amtFieldValue",
    );
    assert(
      tin == _sentinel || tinFieldValue == null,
      "Cannot specify both tin and tinFieldValue",
    );
    assert(
      bhf_id == _sentinel || bhf_idFieldValue == null,
      "Cannot specify both bhf_id and bhf_idFieldValue",
    );
    assert(
      dft_prc == _sentinel || dft_prcFieldValue == null,
      "Cannot specify both dft_prc and dft_prcFieldValue",
    );
    assert(
      add_info == _sentinel || add_infoFieldValue == null,
      "Cannot specify both add_info and add_infoFieldValue",
    );
    assert(
      isrc_aplcb_yn == _sentinel || isrc_aplcb_ynFieldValue == null,
      "Cannot specify both isrc_aplcb_yn and isrc_aplcb_ynFieldValue",
    );
    assert(
      use_yn == _sentinel || use_ynFieldValue == null,
      "Cannot specify both use_yn and use_ynFieldValue",
    );
    assert(
      regr_id == _sentinel || regr_idFieldValue == null,
      "Cannot specify both regr_id and regr_idFieldValue",
    );
    assert(
      regr_nm == _sentinel || regr_nmFieldValue == null,
      "Cannot specify both regr_nm and regr_nmFieldValue",
    );
    assert(
      modr_id == _sentinel || modr_idFieldValue == null,
      "Cannot specify both modr_id and modr_idFieldValue",
    );
    assert(
      modr_nm == _sentinel || modr_nmFieldValue == null,
      "Cannot specify both modr_nm and modr_nmFieldValue",
    );
    assert(
      rsd_qty == _sentinel || rsd_qtyFieldValue == null,
      "Cannot specify both rsd_qty and rsd_qtyFieldValue",
    );
    assert(
      last_touched == _sentinel || last_touchedFieldValue == null,
      "Cannot specify both last_touched and last_touchedFieldValue",
    );
    assert(
      supply_price == _sentinel || supply_priceFieldValue == null,
      "Cannot specify both supply_price and supply_priceFieldValue",
    );
    assert(
      retail_price == _sentinel || retail_priceFieldValue == null,
      "Cannot specify both retail_price and retail_priceFieldValue",
    );
    assert(
      spplr_item_cls_cd == _sentinel || spplr_item_cls_cdFieldValue == null,
      "Cannot specify both spplr_item_cls_cd and spplr_item_cls_cdFieldValue",
    );
    assert(
      spplr_item_cd == _sentinel || spplr_item_cdFieldValue == null,
      "Cannot specify both spplr_item_cd and spplr_item_cdFieldValue",
    );
    assert(
      spplr_item_nm == _sentinel || spplr_item_nmFieldValue == null,
      "Cannot specify both spplr_item_nm and spplr_item_nmFieldValue",
    );
    assert(
      ebm_synced == _sentinel || ebm_syncedFieldValue == null,
      "Cannot specify both ebm_synced and ebm_syncedFieldValue",
    );
    assert(
      tax_type == _sentinel || tax_typeFieldValue == null,
      "Cannot specify both tax_type and tax_typeFieldValue",
    );
    assert(
      branch_ids == _sentinel || branch_idsFieldValue == null,
      "Cannot specify both branch_ids and branch_idsFieldValue",
    );
    assert(
      stock == _sentinel || stockFieldValue == null,
      "Cannot specify both stock and stockFieldValue",
    );
    assert(
      updated_at == _sentinel || updated_atFieldValue == null,
      "Cannot specify both updated_at and updated_atFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$VariantFieldMap['id']!: _$VariantPerFieldToJson.id(id as String?),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (variant_id != _sentinel)
        _$VariantFieldMap['variant_id']!:
            _$VariantPerFieldToJson.variant_id(variant_id as int?),
      if (variant_idFieldValue != null)
        _$VariantFieldMap['variant_id']!: variant_idFieldValue,
      if (deleted_at != _sentinel)
        _$VariantFieldMap['deleted_at']!:
            _$VariantPerFieldToJson.deleted_at(deleted_at as DateTime?),
      if (deleted_atFieldValue != null)
        _$VariantFieldMap['deleted_at']!: deleted_atFieldValue,
      if (name != _sentinel)
        _$VariantFieldMap['name']!:
            _$VariantPerFieldToJson.name(name as String?),
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (color != _sentinel)
        _$VariantFieldMap['color']!:
            _$VariantPerFieldToJson.color(color as String?),
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (sku != _sentinel)
        _$VariantFieldMap['sku']!: _$VariantPerFieldToJson.sku(sku as String?),
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (product_id != _sentinel)
        _$VariantFieldMap['product_id']!:
            _$VariantPerFieldToJson.product_id(product_id as int?),
      if (product_idFieldValue != null)
        _$VariantFieldMap['product_id']!: product_idFieldValue,
      if (unit != _sentinel)
        _$VariantFieldMap['unit']!:
            _$VariantPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (product_name != _sentinel)
        _$VariantFieldMap['product_name']!:
            _$VariantPerFieldToJson.product_name(product_name as String?),
      if (product_nameFieldValue != null)
        _$VariantFieldMap['product_name']!: product_nameFieldValue,
      if (branch_id != _sentinel)
        _$VariantFieldMap['branch_id']!:
            _$VariantPerFieldToJson.branch_id(branch_id as int?),
      if (branch_idFieldValue != null)
        _$VariantFieldMap['branch_id']!: branch_idFieldValue,
      if (tax_name != _sentinel)
        _$VariantFieldMap['tax_name']!:
            _$VariantPerFieldToJson.tax_name(tax_name as String),
      if (tax_nameFieldValue != null)
        _$VariantFieldMap['tax_name']!: tax_nameFieldValue,
      if (tax_percentage != _sentinel)
        _$VariantFieldMap['tax_percentage']!:
            _$VariantPerFieldToJson.tax_percentage(tax_percentage as double),
      if (tax_percentageFieldValue != null)
        _$VariantFieldMap['tax_percentage']!: tax_percentageFieldValue,
      if (is_tax_exempted != _sentinel)
        _$VariantFieldMap['is_tax_exempted']!:
            _$VariantPerFieldToJson.is_tax_exempted(is_tax_exempted as bool),
      if (is_tax_exemptedFieldValue != null)
        _$VariantFieldMap['is_tax_exempted']!: is_tax_exemptedFieldValue,
      if (item_seq != _sentinel)
        _$VariantFieldMap['item_seq']!:
            _$VariantPerFieldToJson.item_seq(item_seq as int?),
      if (item_seqFieldValue != null)
        _$VariantFieldMap['item_seq']!: item_seqFieldValue,
      if (isrcc_cd != _sentinel)
        _$VariantFieldMap['isrcc_cd']!:
            _$VariantPerFieldToJson.isrcc_cd(isrcc_cd as String),
      if (isrcc_cdFieldValue != null)
        _$VariantFieldMap['isrcc_cd']!: isrcc_cdFieldValue,
      if (isrcc_nm != _sentinel)
        _$VariantFieldMap['isrcc_nm']!:
            _$VariantPerFieldToJson.isrcc_nm(isrcc_nm as String),
      if (isrcc_nmFieldValue != null)
        _$VariantFieldMap['isrcc_nm']!: isrcc_nmFieldValue,
      if (isrc_rt != _sentinel)
        _$VariantFieldMap['isrc_rt']!:
            _$VariantPerFieldToJson.isrc_rt(isrc_rt as int),
      if (isrc_rtFieldValue != null)
        _$VariantFieldMap['isrc_rt']!: isrc_rtFieldValue,
      if (isrc_amt != _sentinel)
        _$VariantFieldMap['isrc_amt']!:
            _$VariantPerFieldToJson.isrc_amt(isrc_amt as int),
      if (isrc_amtFieldValue != null)
        _$VariantFieldMap['isrc_amt']!: isrc_amtFieldValue,
      if (tax_ty_cd != _sentinel)
        _$VariantFieldMap['tax_ty_cd']!:
            _$VariantPerFieldToJson.tax_ty_cd(tax_ty_cd as String),
      if (tax_ty_cdFieldValue != null)
        _$VariantFieldMap['tax_ty_cd']!: tax_ty_cdFieldValue,
      if (bcd != _sentinel)
        _$VariantFieldMap['bcd']!: _$VariantPerFieldToJson.bcd(bcd as String),
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (item_cls_cd != _sentinel)
        _$VariantFieldMap['item_cls_cd']!:
            _$VariantPerFieldToJson.item_cls_cd(item_cls_cd as String?),
      if (item_cls_cdFieldValue != null)
        _$VariantFieldMap['item_cls_cd']!: item_cls_cdFieldValue,
      if (item_ty_cd != _sentinel)
        _$VariantFieldMap['item_ty_cd']!:
            _$VariantPerFieldToJson.item_ty_cd(item_ty_cd as String?),
      if (item_ty_cdFieldValue != null)
        _$VariantFieldMap['item_ty_cd']!: item_ty_cdFieldValue,
      if (item_std_nm != _sentinel)
        _$VariantFieldMap['item_std_nm']!:
            _$VariantPerFieldToJson.item_std_nm(item_std_nm as String),
      if (item_std_nmFieldValue != null)
        _$VariantFieldMap['item_std_nm']!: item_std_nmFieldValue,
      if (orgn_nat_cd != _sentinel)
        _$VariantFieldMap['orgn_nat_cd']!:
            _$VariantPerFieldToJson.orgn_nat_cd(orgn_nat_cd as String),
      if (orgn_nat_cdFieldValue != null)
        _$VariantFieldMap['orgn_nat_cd']!: orgn_nat_cdFieldValue,
      if (pkg != _sentinel)
        _$VariantFieldMap['pkg']!: _$VariantPerFieldToJson.pkg(pkg as String),
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (item_cd != _sentinel)
        _$VariantFieldMap['item_cd']!:
            _$VariantPerFieldToJson.item_cd(item_cd as String),
      if (item_cdFieldValue != null)
        _$VariantFieldMap['item_cd']!: item_cdFieldValue,
      if (pkg_unit_cd != _sentinel)
        _$VariantFieldMap['pkg_unit_cd']!:
            _$VariantPerFieldToJson.pkg_unit_cd(pkg_unit_cd as String),
      if (pkg_unit_cdFieldValue != null)
        _$VariantFieldMap['pkg_unit_cd']!: pkg_unit_cdFieldValue,
      if (qty_unit_cd != _sentinel)
        _$VariantFieldMap['qty_unit_cd']!:
            _$VariantPerFieldToJson.qty_unit_cd(qty_unit_cd as String),
      if (qty_unit_cdFieldValue != null)
        _$VariantFieldMap['qty_unit_cd']!: qty_unit_cdFieldValue,
      if (item_nm != _sentinel)
        _$VariantFieldMap['item_nm']!:
            _$VariantPerFieldToJson.item_nm(item_nm as String?),
      if (item_nmFieldValue != null)
        _$VariantFieldMap['item_nm']!: item_nmFieldValue,
      if (qty != _sentinel)
        _$VariantFieldMap['qty']!: _$VariantPerFieldToJson.qty(qty as double),
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prc != _sentinel)
        _$VariantFieldMap['prc']!: _$VariantPerFieldToJson.prc(prc as double),
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (sply_amt != _sentinel)
        _$VariantFieldMap['sply_amt']!:
            _$VariantPerFieldToJson.sply_amt(sply_amt as double),
      if (sply_amtFieldValue != null)
        _$VariantFieldMap['sply_amt']!: sply_amtFieldValue,
      if (tin != _sentinel)
        _$VariantFieldMap['tin']!: _$VariantPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhf_id != _sentinel)
        _$VariantFieldMap['bhf_id']!:
            _$VariantPerFieldToJson.bhf_id(bhf_id as String?),
      if (bhf_idFieldValue != null)
        _$VariantFieldMap['bhf_id']!: bhf_idFieldValue,
      if (dft_prc != _sentinel)
        _$VariantFieldMap['dft_prc']!:
            _$VariantPerFieldToJson.dft_prc(dft_prc as double),
      if (dft_prcFieldValue != null)
        _$VariantFieldMap['dft_prc']!: dft_prcFieldValue,
      if (add_info != _sentinel)
        _$VariantFieldMap['add_info']!:
            _$VariantPerFieldToJson.add_info(add_info as String),
      if (add_infoFieldValue != null)
        _$VariantFieldMap['add_info']!: add_infoFieldValue,
      if (isrc_aplcb_yn != _sentinel)
        _$VariantFieldMap['isrc_aplcb_yn']!:
            _$VariantPerFieldToJson.isrc_aplcb_yn(isrc_aplcb_yn as String),
      if (isrc_aplcb_ynFieldValue != null)
        _$VariantFieldMap['isrc_aplcb_yn']!: isrc_aplcb_ynFieldValue,
      if (use_yn != _sentinel)
        _$VariantFieldMap['use_yn']!:
            _$VariantPerFieldToJson.use_yn(use_yn as String),
      if (use_ynFieldValue != null)
        _$VariantFieldMap['use_yn']!: use_ynFieldValue,
      if (regr_id != _sentinel)
        _$VariantFieldMap['regr_id']!:
            _$VariantPerFieldToJson.regr_id(regr_id as String?),
      if (regr_idFieldValue != null)
        _$VariantFieldMap['regr_id']!: regr_idFieldValue,
      if (regr_nm != _sentinel)
        _$VariantFieldMap['regr_nm']!:
            _$VariantPerFieldToJson.regr_nm(regr_nm as String?),
      if (regr_nmFieldValue != null)
        _$VariantFieldMap['regr_nm']!: regr_nmFieldValue,
      if (modr_id != _sentinel)
        _$VariantFieldMap['modr_id']!:
            _$VariantPerFieldToJson.modr_id(modr_id as String?),
      if (modr_idFieldValue != null)
        _$VariantFieldMap['modr_id']!: modr_idFieldValue,
      if (modr_nm != _sentinel)
        _$VariantFieldMap['modr_nm']!:
            _$VariantPerFieldToJson.modr_nm(modr_nm as String?),
      if (modr_nmFieldValue != null)
        _$VariantFieldMap['modr_nm']!: modr_nmFieldValue,
      if (rsd_qty != _sentinel)
        _$VariantFieldMap['rsd_qty']!:
            _$VariantPerFieldToJson.rsd_qty(rsd_qty as double),
      if (rsd_qtyFieldValue != null)
        _$VariantFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (last_touched != _sentinel)
        _$VariantFieldMap['last_touched']!:
            _$VariantPerFieldToJson.last_touched(last_touched as DateTime?),
      if (last_touchedFieldValue != null)
        _$VariantFieldMap['last_touched']!: last_touchedFieldValue,
      if (supply_price != _sentinel)
        _$VariantFieldMap['supply_price']!:
            _$VariantPerFieldToJson.supply_price(supply_price as double),
      if (supply_priceFieldValue != null)
        _$VariantFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_price != _sentinel)
        _$VariantFieldMap['retail_price']!:
            _$VariantPerFieldToJson.retail_price(retail_price as double),
      if (retail_priceFieldValue != null)
        _$VariantFieldMap['retail_price']!: retail_priceFieldValue,
      if (spplr_item_cls_cd != _sentinel)
        _$VariantFieldMap['spplr_item_cls_cd']!: _$VariantPerFieldToJson
            .spplr_item_cls_cd(spplr_item_cls_cd as String?),
      if (spplr_item_cls_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cls_cd']!: spplr_item_cls_cdFieldValue,
      if (spplr_item_cd != _sentinel)
        _$VariantFieldMap['spplr_item_cd']!:
            _$VariantPerFieldToJson.spplr_item_cd(spplr_item_cd as String?),
      if (spplr_item_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cd']!: spplr_item_cdFieldValue,
      if (spplr_item_nm != _sentinel)
        _$VariantFieldMap['spplr_item_nm']!:
            _$VariantPerFieldToJson.spplr_item_nm(spplr_item_nm as String?),
      if (spplr_item_nmFieldValue != null)
        _$VariantFieldMap['spplr_item_nm']!: spplr_item_nmFieldValue,
      if (ebm_synced != _sentinel)
        _$VariantFieldMap['ebm_synced']!:
            _$VariantPerFieldToJson.ebm_synced(ebm_synced as bool),
      if (ebm_syncedFieldValue != null)
        _$VariantFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (tax_type != _sentinel)
        _$VariantFieldMap['tax_type']!:
            _$VariantPerFieldToJson.tax_type(tax_type as String),
      if (tax_typeFieldValue != null)
        _$VariantFieldMap['tax_type']!: tax_typeFieldValue,
      if (branch_ids != _sentinel)
        _$VariantFieldMap['branch_ids']!:
            _$VariantPerFieldToJson.branch_ids(branch_ids as List<int>),
      if (branch_idsFieldValue != null)
        _$VariantFieldMap['branch_ids']!: branch_idsFieldValue,
      if (stock != _sentinel)
        _$VariantFieldMap['stock']!:
            _$VariantPerFieldToJson.stock(stock as Stock),
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
      if (updated_at != _sentinel)
        _$VariantFieldMap['updated_at']!:
            _$VariantPerFieldToJson.updated_at(updated_at as DateTime?),
      if (updated_atFieldValue != null)
        _$VariantFieldMap['updated_at']!: updated_atFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? variant_id = _sentinel,
    FieldValue? variant_idFieldValue,
    Object? deleted_at = _sentinel,
    FieldValue? deleted_atFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? sku = _sentinel,
    FieldValue? skuFieldValue,
    Object? product_id = _sentinel,
    FieldValue? product_idFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? product_name = _sentinel,
    FieldValue? product_nameFieldValue,
    Object? branch_id = _sentinel,
    FieldValue? branch_idFieldValue,
    Object? tax_name = _sentinel,
    FieldValue? tax_nameFieldValue,
    Object? tax_percentage = _sentinel,
    FieldValue? tax_percentageFieldValue,
    Object? is_tax_exempted = _sentinel,
    FieldValue? is_tax_exemptedFieldValue,
    Object? item_seq = _sentinel,
    FieldValue? item_seqFieldValue,
    Object? isrcc_cd = _sentinel,
    FieldValue? isrcc_cdFieldValue,
    Object? isrcc_nm = _sentinel,
    FieldValue? isrcc_nmFieldValue,
    Object? isrc_rt = _sentinel,
    FieldValue? isrc_rtFieldValue,
    Object? isrc_amt = _sentinel,
    FieldValue? isrc_amtFieldValue,
    Object? tax_ty_cd = _sentinel,
    FieldValue? tax_ty_cdFieldValue,
    Object? bcd = _sentinel,
    FieldValue? bcdFieldValue,
    Object? item_cls_cd = _sentinel,
    FieldValue? item_cls_cdFieldValue,
    Object? item_ty_cd = _sentinel,
    FieldValue? item_ty_cdFieldValue,
    Object? item_std_nm = _sentinel,
    FieldValue? item_std_nmFieldValue,
    Object? orgn_nat_cd = _sentinel,
    FieldValue? orgn_nat_cdFieldValue,
    Object? pkg = _sentinel,
    FieldValue? pkgFieldValue,
    Object? item_cd = _sentinel,
    FieldValue? item_cdFieldValue,
    Object? pkg_unit_cd = _sentinel,
    FieldValue? pkg_unit_cdFieldValue,
    Object? qty_unit_cd = _sentinel,
    FieldValue? qty_unit_cdFieldValue,
    Object? item_nm = _sentinel,
    FieldValue? item_nmFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? prc = _sentinel,
    FieldValue? prcFieldValue,
    Object? sply_amt = _sentinel,
    FieldValue? sply_amtFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhf_id = _sentinel,
    FieldValue? bhf_idFieldValue,
    Object? dft_prc = _sentinel,
    FieldValue? dft_prcFieldValue,
    Object? add_info = _sentinel,
    FieldValue? add_infoFieldValue,
    Object? isrc_aplcb_yn = _sentinel,
    FieldValue? isrc_aplcb_ynFieldValue,
    Object? use_yn = _sentinel,
    FieldValue? use_ynFieldValue,
    Object? regr_id = _sentinel,
    FieldValue? regr_idFieldValue,
    Object? regr_nm = _sentinel,
    FieldValue? regr_nmFieldValue,
    Object? modr_id = _sentinel,
    FieldValue? modr_idFieldValue,
    Object? modr_nm = _sentinel,
    FieldValue? modr_nmFieldValue,
    Object? rsd_qty = _sentinel,
    FieldValue? rsd_qtyFieldValue,
    Object? last_touched = _sentinel,
    FieldValue? last_touchedFieldValue,
    Object? supply_price = _sentinel,
    FieldValue? supply_priceFieldValue,
    Object? retail_price = _sentinel,
    FieldValue? retail_priceFieldValue,
    Object? spplr_item_cls_cd = _sentinel,
    FieldValue? spplr_item_cls_cdFieldValue,
    Object? spplr_item_cd = _sentinel,
    FieldValue? spplr_item_cdFieldValue,
    Object? spplr_item_nm = _sentinel,
    FieldValue? spplr_item_nmFieldValue,
    Object? ebm_synced = _sentinel,
    FieldValue? ebm_syncedFieldValue,
    Object? tax_type = _sentinel,
    FieldValue? tax_typeFieldValue,
    Object? branch_ids = _sentinel,
    FieldValue? branch_idsFieldValue,
    Object? stock = _sentinel,
    FieldValue? stockFieldValue,
    Object? updated_at = _sentinel,
    FieldValue? updated_atFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      variant_id == _sentinel || variant_idFieldValue == null,
      "Cannot specify both variant_id and variant_idFieldValue",
    );
    assert(
      deleted_at == _sentinel || deleted_atFieldValue == null,
      "Cannot specify both deleted_at and deleted_atFieldValue",
    );
    assert(
      name == _sentinel || nameFieldValue == null,
      "Cannot specify both name and nameFieldValue",
    );
    assert(
      color == _sentinel || colorFieldValue == null,
      "Cannot specify both color and colorFieldValue",
    );
    assert(
      sku == _sentinel || skuFieldValue == null,
      "Cannot specify both sku and skuFieldValue",
    );
    assert(
      product_id == _sentinel || product_idFieldValue == null,
      "Cannot specify both product_id and product_idFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      product_name == _sentinel || product_nameFieldValue == null,
      "Cannot specify both product_name and product_nameFieldValue",
    );
    assert(
      branch_id == _sentinel || branch_idFieldValue == null,
      "Cannot specify both branch_id and branch_idFieldValue",
    );
    assert(
      tax_name == _sentinel || tax_nameFieldValue == null,
      "Cannot specify both tax_name and tax_nameFieldValue",
    );
    assert(
      tax_percentage == _sentinel || tax_percentageFieldValue == null,
      "Cannot specify both tax_percentage and tax_percentageFieldValue",
    );
    assert(
      is_tax_exempted == _sentinel || is_tax_exemptedFieldValue == null,
      "Cannot specify both is_tax_exempted and is_tax_exemptedFieldValue",
    );
    assert(
      item_seq == _sentinel || item_seqFieldValue == null,
      "Cannot specify both item_seq and item_seqFieldValue",
    );
    assert(
      isrcc_cd == _sentinel || isrcc_cdFieldValue == null,
      "Cannot specify both isrcc_cd and isrcc_cdFieldValue",
    );
    assert(
      isrcc_nm == _sentinel || isrcc_nmFieldValue == null,
      "Cannot specify both isrcc_nm and isrcc_nmFieldValue",
    );
    assert(
      isrc_rt == _sentinel || isrc_rtFieldValue == null,
      "Cannot specify both isrc_rt and isrc_rtFieldValue",
    );
    assert(
      isrc_amt == _sentinel || isrc_amtFieldValue == null,
      "Cannot specify both isrc_amt and isrc_amtFieldValue",
    );
    assert(
      tax_ty_cd == _sentinel || tax_ty_cdFieldValue == null,
      "Cannot specify both tax_ty_cd and tax_ty_cdFieldValue",
    );
    assert(
      bcd == _sentinel || bcdFieldValue == null,
      "Cannot specify both bcd and bcdFieldValue",
    );
    assert(
      item_cls_cd == _sentinel || item_cls_cdFieldValue == null,
      "Cannot specify both item_cls_cd and item_cls_cdFieldValue",
    );
    assert(
      item_ty_cd == _sentinel || item_ty_cdFieldValue == null,
      "Cannot specify both item_ty_cd and item_ty_cdFieldValue",
    );
    assert(
      item_std_nm == _sentinel || item_std_nmFieldValue == null,
      "Cannot specify both item_std_nm and item_std_nmFieldValue",
    );
    assert(
      orgn_nat_cd == _sentinel || orgn_nat_cdFieldValue == null,
      "Cannot specify both orgn_nat_cd and orgn_nat_cdFieldValue",
    );
    assert(
      pkg == _sentinel || pkgFieldValue == null,
      "Cannot specify both pkg and pkgFieldValue",
    );
    assert(
      item_cd == _sentinel || item_cdFieldValue == null,
      "Cannot specify both item_cd and item_cdFieldValue",
    );
    assert(
      pkg_unit_cd == _sentinel || pkg_unit_cdFieldValue == null,
      "Cannot specify both pkg_unit_cd and pkg_unit_cdFieldValue",
    );
    assert(
      qty_unit_cd == _sentinel || qty_unit_cdFieldValue == null,
      "Cannot specify both qty_unit_cd and qty_unit_cdFieldValue",
    );
    assert(
      item_nm == _sentinel || item_nmFieldValue == null,
      "Cannot specify both item_nm and item_nmFieldValue",
    );
    assert(
      qty == _sentinel || qtyFieldValue == null,
      "Cannot specify both qty and qtyFieldValue",
    );
    assert(
      prc == _sentinel || prcFieldValue == null,
      "Cannot specify both prc and prcFieldValue",
    );
    assert(
      sply_amt == _sentinel || sply_amtFieldValue == null,
      "Cannot specify both sply_amt and sply_amtFieldValue",
    );
    assert(
      tin == _sentinel || tinFieldValue == null,
      "Cannot specify both tin and tinFieldValue",
    );
    assert(
      bhf_id == _sentinel || bhf_idFieldValue == null,
      "Cannot specify both bhf_id and bhf_idFieldValue",
    );
    assert(
      dft_prc == _sentinel || dft_prcFieldValue == null,
      "Cannot specify both dft_prc and dft_prcFieldValue",
    );
    assert(
      add_info == _sentinel || add_infoFieldValue == null,
      "Cannot specify both add_info and add_infoFieldValue",
    );
    assert(
      isrc_aplcb_yn == _sentinel || isrc_aplcb_ynFieldValue == null,
      "Cannot specify both isrc_aplcb_yn and isrc_aplcb_ynFieldValue",
    );
    assert(
      use_yn == _sentinel || use_ynFieldValue == null,
      "Cannot specify both use_yn and use_ynFieldValue",
    );
    assert(
      regr_id == _sentinel || regr_idFieldValue == null,
      "Cannot specify both regr_id and regr_idFieldValue",
    );
    assert(
      regr_nm == _sentinel || regr_nmFieldValue == null,
      "Cannot specify both regr_nm and regr_nmFieldValue",
    );
    assert(
      modr_id == _sentinel || modr_idFieldValue == null,
      "Cannot specify both modr_id and modr_idFieldValue",
    );
    assert(
      modr_nm == _sentinel || modr_nmFieldValue == null,
      "Cannot specify both modr_nm and modr_nmFieldValue",
    );
    assert(
      rsd_qty == _sentinel || rsd_qtyFieldValue == null,
      "Cannot specify both rsd_qty and rsd_qtyFieldValue",
    );
    assert(
      last_touched == _sentinel || last_touchedFieldValue == null,
      "Cannot specify both last_touched and last_touchedFieldValue",
    );
    assert(
      supply_price == _sentinel || supply_priceFieldValue == null,
      "Cannot specify both supply_price and supply_priceFieldValue",
    );
    assert(
      retail_price == _sentinel || retail_priceFieldValue == null,
      "Cannot specify both retail_price and retail_priceFieldValue",
    );
    assert(
      spplr_item_cls_cd == _sentinel || spplr_item_cls_cdFieldValue == null,
      "Cannot specify both spplr_item_cls_cd and spplr_item_cls_cdFieldValue",
    );
    assert(
      spplr_item_cd == _sentinel || spplr_item_cdFieldValue == null,
      "Cannot specify both spplr_item_cd and spplr_item_cdFieldValue",
    );
    assert(
      spplr_item_nm == _sentinel || spplr_item_nmFieldValue == null,
      "Cannot specify both spplr_item_nm and spplr_item_nmFieldValue",
    );
    assert(
      ebm_synced == _sentinel || ebm_syncedFieldValue == null,
      "Cannot specify both ebm_synced and ebm_syncedFieldValue",
    );
    assert(
      tax_type == _sentinel || tax_typeFieldValue == null,
      "Cannot specify both tax_type and tax_typeFieldValue",
    );
    assert(
      branch_ids == _sentinel || branch_idsFieldValue == null,
      "Cannot specify both branch_ids and branch_idsFieldValue",
    );
    assert(
      stock == _sentinel || stockFieldValue == null,
      "Cannot specify both stock and stockFieldValue",
    );
    assert(
      updated_at == _sentinel || updated_atFieldValue == null,
      "Cannot specify both updated_at and updated_atFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$VariantFieldMap['id']!: _$VariantPerFieldToJson.id(id as String?),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (variant_id != _sentinel)
        _$VariantFieldMap['variant_id']!:
            _$VariantPerFieldToJson.variant_id(variant_id as int?),
      if (variant_idFieldValue != null)
        _$VariantFieldMap['variant_id']!: variant_idFieldValue,
      if (deleted_at != _sentinel)
        _$VariantFieldMap['deleted_at']!:
            _$VariantPerFieldToJson.deleted_at(deleted_at as DateTime?),
      if (deleted_atFieldValue != null)
        _$VariantFieldMap['deleted_at']!: deleted_atFieldValue,
      if (name != _sentinel)
        _$VariantFieldMap['name']!:
            _$VariantPerFieldToJson.name(name as String?),
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (color != _sentinel)
        _$VariantFieldMap['color']!:
            _$VariantPerFieldToJson.color(color as String?),
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (sku != _sentinel)
        _$VariantFieldMap['sku']!: _$VariantPerFieldToJson.sku(sku as String?),
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (product_id != _sentinel)
        _$VariantFieldMap['product_id']!:
            _$VariantPerFieldToJson.product_id(product_id as int?),
      if (product_idFieldValue != null)
        _$VariantFieldMap['product_id']!: product_idFieldValue,
      if (unit != _sentinel)
        _$VariantFieldMap['unit']!:
            _$VariantPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (product_name != _sentinel)
        _$VariantFieldMap['product_name']!:
            _$VariantPerFieldToJson.product_name(product_name as String?),
      if (product_nameFieldValue != null)
        _$VariantFieldMap['product_name']!: product_nameFieldValue,
      if (branch_id != _sentinel)
        _$VariantFieldMap['branch_id']!:
            _$VariantPerFieldToJson.branch_id(branch_id as int?),
      if (branch_idFieldValue != null)
        _$VariantFieldMap['branch_id']!: branch_idFieldValue,
      if (tax_name != _sentinel)
        _$VariantFieldMap['tax_name']!:
            _$VariantPerFieldToJson.tax_name(tax_name as String),
      if (tax_nameFieldValue != null)
        _$VariantFieldMap['tax_name']!: tax_nameFieldValue,
      if (tax_percentage != _sentinel)
        _$VariantFieldMap['tax_percentage']!:
            _$VariantPerFieldToJson.tax_percentage(tax_percentage as double),
      if (tax_percentageFieldValue != null)
        _$VariantFieldMap['tax_percentage']!: tax_percentageFieldValue,
      if (is_tax_exempted != _sentinel)
        _$VariantFieldMap['is_tax_exempted']!:
            _$VariantPerFieldToJson.is_tax_exempted(is_tax_exempted as bool),
      if (is_tax_exemptedFieldValue != null)
        _$VariantFieldMap['is_tax_exempted']!: is_tax_exemptedFieldValue,
      if (item_seq != _sentinel)
        _$VariantFieldMap['item_seq']!:
            _$VariantPerFieldToJson.item_seq(item_seq as int?),
      if (item_seqFieldValue != null)
        _$VariantFieldMap['item_seq']!: item_seqFieldValue,
      if (isrcc_cd != _sentinel)
        _$VariantFieldMap['isrcc_cd']!:
            _$VariantPerFieldToJson.isrcc_cd(isrcc_cd as String),
      if (isrcc_cdFieldValue != null)
        _$VariantFieldMap['isrcc_cd']!: isrcc_cdFieldValue,
      if (isrcc_nm != _sentinel)
        _$VariantFieldMap['isrcc_nm']!:
            _$VariantPerFieldToJson.isrcc_nm(isrcc_nm as String),
      if (isrcc_nmFieldValue != null)
        _$VariantFieldMap['isrcc_nm']!: isrcc_nmFieldValue,
      if (isrc_rt != _sentinel)
        _$VariantFieldMap['isrc_rt']!:
            _$VariantPerFieldToJson.isrc_rt(isrc_rt as int),
      if (isrc_rtFieldValue != null)
        _$VariantFieldMap['isrc_rt']!: isrc_rtFieldValue,
      if (isrc_amt != _sentinel)
        _$VariantFieldMap['isrc_amt']!:
            _$VariantPerFieldToJson.isrc_amt(isrc_amt as int),
      if (isrc_amtFieldValue != null)
        _$VariantFieldMap['isrc_amt']!: isrc_amtFieldValue,
      if (tax_ty_cd != _sentinel)
        _$VariantFieldMap['tax_ty_cd']!:
            _$VariantPerFieldToJson.tax_ty_cd(tax_ty_cd as String),
      if (tax_ty_cdFieldValue != null)
        _$VariantFieldMap['tax_ty_cd']!: tax_ty_cdFieldValue,
      if (bcd != _sentinel)
        _$VariantFieldMap['bcd']!: _$VariantPerFieldToJson.bcd(bcd as String),
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (item_cls_cd != _sentinel)
        _$VariantFieldMap['item_cls_cd']!:
            _$VariantPerFieldToJson.item_cls_cd(item_cls_cd as String?),
      if (item_cls_cdFieldValue != null)
        _$VariantFieldMap['item_cls_cd']!: item_cls_cdFieldValue,
      if (item_ty_cd != _sentinel)
        _$VariantFieldMap['item_ty_cd']!:
            _$VariantPerFieldToJson.item_ty_cd(item_ty_cd as String?),
      if (item_ty_cdFieldValue != null)
        _$VariantFieldMap['item_ty_cd']!: item_ty_cdFieldValue,
      if (item_std_nm != _sentinel)
        _$VariantFieldMap['item_std_nm']!:
            _$VariantPerFieldToJson.item_std_nm(item_std_nm as String),
      if (item_std_nmFieldValue != null)
        _$VariantFieldMap['item_std_nm']!: item_std_nmFieldValue,
      if (orgn_nat_cd != _sentinel)
        _$VariantFieldMap['orgn_nat_cd']!:
            _$VariantPerFieldToJson.orgn_nat_cd(orgn_nat_cd as String),
      if (orgn_nat_cdFieldValue != null)
        _$VariantFieldMap['orgn_nat_cd']!: orgn_nat_cdFieldValue,
      if (pkg != _sentinel)
        _$VariantFieldMap['pkg']!: _$VariantPerFieldToJson.pkg(pkg as String),
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (item_cd != _sentinel)
        _$VariantFieldMap['item_cd']!:
            _$VariantPerFieldToJson.item_cd(item_cd as String),
      if (item_cdFieldValue != null)
        _$VariantFieldMap['item_cd']!: item_cdFieldValue,
      if (pkg_unit_cd != _sentinel)
        _$VariantFieldMap['pkg_unit_cd']!:
            _$VariantPerFieldToJson.pkg_unit_cd(pkg_unit_cd as String),
      if (pkg_unit_cdFieldValue != null)
        _$VariantFieldMap['pkg_unit_cd']!: pkg_unit_cdFieldValue,
      if (qty_unit_cd != _sentinel)
        _$VariantFieldMap['qty_unit_cd']!:
            _$VariantPerFieldToJson.qty_unit_cd(qty_unit_cd as String),
      if (qty_unit_cdFieldValue != null)
        _$VariantFieldMap['qty_unit_cd']!: qty_unit_cdFieldValue,
      if (item_nm != _sentinel)
        _$VariantFieldMap['item_nm']!:
            _$VariantPerFieldToJson.item_nm(item_nm as String?),
      if (item_nmFieldValue != null)
        _$VariantFieldMap['item_nm']!: item_nmFieldValue,
      if (qty != _sentinel)
        _$VariantFieldMap['qty']!: _$VariantPerFieldToJson.qty(qty as double),
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prc != _sentinel)
        _$VariantFieldMap['prc']!: _$VariantPerFieldToJson.prc(prc as double),
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (sply_amt != _sentinel)
        _$VariantFieldMap['sply_amt']!:
            _$VariantPerFieldToJson.sply_amt(sply_amt as double),
      if (sply_amtFieldValue != null)
        _$VariantFieldMap['sply_amt']!: sply_amtFieldValue,
      if (tin != _sentinel)
        _$VariantFieldMap['tin']!: _$VariantPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhf_id != _sentinel)
        _$VariantFieldMap['bhf_id']!:
            _$VariantPerFieldToJson.bhf_id(bhf_id as String?),
      if (bhf_idFieldValue != null)
        _$VariantFieldMap['bhf_id']!: bhf_idFieldValue,
      if (dft_prc != _sentinel)
        _$VariantFieldMap['dft_prc']!:
            _$VariantPerFieldToJson.dft_prc(dft_prc as double),
      if (dft_prcFieldValue != null)
        _$VariantFieldMap['dft_prc']!: dft_prcFieldValue,
      if (add_info != _sentinel)
        _$VariantFieldMap['add_info']!:
            _$VariantPerFieldToJson.add_info(add_info as String),
      if (add_infoFieldValue != null)
        _$VariantFieldMap['add_info']!: add_infoFieldValue,
      if (isrc_aplcb_yn != _sentinel)
        _$VariantFieldMap['isrc_aplcb_yn']!:
            _$VariantPerFieldToJson.isrc_aplcb_yn(isrc_aplcb_yn as String),
      if (isrc_aplcb_ynFieldValue != null)
        _$VariantFieldMap['isrc_aplcb_yn']!: isrc_aplcb_ynFieldValue,
      if (use_yn != _sentinel)
        _$VariantFieldMap['use_yn']!:
            _$VariantPerFieldToJson.use_yn(use_yn as String),
      if (use_ynFieldValue != null)
        _$VariantFieldMap['use_yn']!: use_ynFieldValue,
      if (regr_id != _sentinel)
        _$VariantFieldMap['regr_id']!:
            _$VariantPerFieldToJson.regr_id(regr_id as String?),
      if (regr_idFieldValue != null)
        _$VariantFieldMap['regr_id']!: regr_idFieldValue,
      if (regr_nm != _sentinel)
        _$VariantFieldMap['regr_nm']!:
            _$VariantPerFieldToJson.regr_nm(regr_nm as String?),
      if (regr_nmFieldValue != null)
        _$VariantFieldMap['regr_nm']!: regr_nmFieldValue,
      if (modr_id != _sentinel)
        _$VariantFieldMap['modr_id']!:
            _$VariantPerFieldToJson.modr_id(modr_id as String?),
      if (modr_idFieldValue != null)
        _$VariantFieldMap['modr_id']!: modr_idFieldValue,
      if (modr_nm != _sentinel)
        _$VariantFieldMap['modr_nm']!:
            _$VariantPerFieldToJson.modr_nm(modr_nm as String?),
      if (modr_nmFieldValue != null)
        _$VariantFieldMap['modr_nm']!: modr_nmFieldValue,
      if (rsd_qty != _sentinel)
        _$VariantFieldMap['rsd_qty']!:
            _$VariantPerFieldToJson.rsd_qty(rsd_qty as double),
      if (rsd_qtyFieldValue != null)
        _$VariantFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (last_touched != _sentinel)
        _$VariantFieldMap['last_touched']!:
            _$VariantPerFieldToJson.last_touched(last_touched as DateTime?),
      if (last_touchedFieldValue != null)
        _$VariantFieldMap['last_touched']!: last_touchedFieldValue,
      if (supply_price != _sentinel)
        _$VariantFieldMap['supply_price']!:
            _$VariantPerFieldToJson.supply_price(supply_price as double),
      if (supply_priceFieldValue != null)
        _$VariantFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_price != _sentinel)
        _$VariantFieldMap['retail_price']!:
            _$VariantPerFieldToJson.retail_price(retail_price as double),
      if (retail_priceFieldValue != null)
        _$VariantFieldMap['retail_price']!: retail_priceFieldValue,
      if (spplr_item_cls_cd != _sentinel)
        _$VariantFieldMap['spplr_item_cls_cd']!: _$VariantPerFieldToJson
            .spplr_item_cls_cd(spplr_item_cls_cd as String?),
      if (spplr_item_cls_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cls_cd']!: spplr_item_cls_cdFieldValue,
      if (spplr_item_cd != _sentinel)
        _$VariantFieldMap['spplr_item_cd']!:
            _$VariantPerFieldToJson.spplr_item_cd(spplr_item_cd as String?),
      if (spplr_item_cdFieldValue != null)
        _$VariantFieldMap['spplr_item_cd']!: spplr_item_cdFieldValue,
      if (spplr_item_nm != _sentinel)
        _$VariantFieldMap['spplr_item_nm']!:
            _$VariantPerFieldToJson.spplr_item_nm(spplr_item_nm as String?),
      if (spplr_item_nmFieldValue != null)
        _$VariantFieldMap['spplr_item_nm']!: spplr_item_nmFieldValue,
      if (ebm_synced != _sentinel)
        _$VariantFieldMap['ebm_synced']!:
            _$VariantPerFieldToJson.ebm_synced(ebm_synced as bool),
      if (ebm_syncedFieldValue != null)
        _$VariantFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (tax_type != _sentinel)
        _$VariantFieldMap['tax_type']!:
            _$VariantPerFieldToJson.tax_type(tax_type as String),
      if (tax_typeFieldValue != null)
        _$VariantFieldMap['tax_type']!: tax_typeFieldValue,
      if (branch_ids != _sentinel)
        _$VariantFieldMap['branch_ids']!:
            _$VariantPerFieldToJson.branch_ids(branch_ids as List<int>),
      if (branch_idsFieldValue != null)
        _$VariantFieldMap['branch_ids']!: branch_idsFieldValue,
      if (stock != _sentinel)
        _$VariantFieldMap['stock']!:
            _$VariantPerFieldToJson.stock(stock as Stock),
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
      if (updated_at != _sentinel)
        _$VariantFieldMap['updated_at']!:
            _$VariantPerFieldToJson.updated_at(updated_at as DateTime?),
      if (updated_atFieldValue != null)
        _$VariantFieldMap['updated_at']!: updated_atFieldValue,
    };

    batch.update(reference, json);
  }

  @override
  bool operator ==(Object other) {
    return other is VariantDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

abstract class VariantQuery
    implements QueryReference<Variant, VariantQuerySnapshot> {
  @override
  VariantQuery limit(int limit);

  @override
  VariantQuery limitToLast(int limit);

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
  VariantQuery whereFieldPath(
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

  VariantQuery whereDocumentId({
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

  VariantQuery whereId({
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

  VariantQuery whereVariant_id({
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

  VariantQuery whereDeleted_at({
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

  VariantQuery whereName({
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

  VariantQuery whereColor({
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

  VariantQuery whereSku({
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

  VariantQuery whereProduct_id({
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

  VariantQuery whereUnit({
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

  VariantQuery whereProduct_name({
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

  VariantQuery whereBranch_id({
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

  VariantQuery whereTax_name({
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

  VariantQuery whereTax_percentage({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereIs_tax_exempted({
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

  VariantQuery whereItem_seq({
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

  VariantQuery whereIsrcc_cd({
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

  VariantQuery whereIsrcc_nm({
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

  VariantQuery whereIsrc_rt({
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

  VariantQuery whereIsrc_amt({
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

  VariantQuery whereTax_ty_cd({
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

  VariantQuery whereBcd({
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

  VariantQuery whereItem_cls_cd({
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

  VariantQuery whereItem_ty_cd({
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

  VariantQuery whereItem_std_nm({
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

  VariantQuery whereOrgn_nat_cd({
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

  VariantQuery wherePkg({
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

  VariantQuery whereItem_cd({
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

  VariantQuery wherePkg_unit_cd({
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

  VariantQuery whereQty_unit_cd({
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

  VariantQuery whereItem_nm({
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

  VariantQuery whereQty({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery wherePrc({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereSply_amt({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereTin({
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

  VariantQuery whereBhf_id({
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

  VariantQuery whereDft_prc({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereAdd_info({
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

  VariantQuery whereIsrc_aplcb_yn({
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

  VariantQuery whereUse_yn({
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

  VariantQuery whereRegr_id({
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

  VariantQuery whereRegr_nm({
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

  VariantQuery whereModr_id({
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

  VariantQuery whereModr_nm({
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

  VariantQuery whereRsd_qty({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereLast_touched({
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

  VariantQuery whereSupply_price({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereRetail_price({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereSpplr_item_cls_cd({
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

  VariantQuery whereSpplr_item_cd({
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

  VariantQuery whereSpplr_item_nm({
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

  VariantQuery whereEbm_synced({
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

  VariantQuery whereTax_type({
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

  VariantQuery whereBranch_ids({
    List<int>? isEqualTo,
    List<int>? isNotEqualTo,
    List<int>? isLessThan,
    List<int>? isLessThanOrEqualTo,
    List<int>? isGreaterThan,
    List<int>? isGreaterThanOrEqualTo,
    int? arrayContains,
    List<int>? arrayContainsAny,
    bool? isNull,
  });

  VariantQuery whereStock({
    Stock? isEqualTo,
    Stock? isNotEqualTo,
    Stock? isLessThan,
    Stock? isLessThanOrEqualTo,
    Stock? isGreaterThan,
    Stock? isGreaterThanOrEqualTo,
    List<Stock>? whereIn,
    List<Stock>? whereNotIn,
    bool? isNull,
  });

  VariantQuery whereUpdated_at({
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
  VariantQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object startAt,
    Object startAfter,
    Object endAt,
    Object endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByDocumentId({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderById({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByVariant_id({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByDeleted_at({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByName({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByColor({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderBySku({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByProduct_id({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByUnit({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByProduct_name({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByBranch_id({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByTax_name({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByTax_percentage({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByIs_tax_exempted({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByItem_seq({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByIsrcc_cd({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByIsrcc_nm({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByIsrc_rt({
    bool descending = false,
    int startAt,
    int startAfter,
    int endAt,
    int endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByIsrc_amt({
    bool descending = false,
    int startAt,
    int startAfter,
    int endAt,
    int endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByTax_ty_cd({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByBcd({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByItem_cls_cd({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByItem_ty_cd({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByItem_std_nm({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByOrgn_nat_cd({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByPkg({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByItem_cd({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByPkg_unit_cd({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByQty_unit_cd({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByItem_nm({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByQty({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByPrc({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderBySply_amt({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByTin({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByBhf_id({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByDft_prc({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByAdd_info({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByIsrc_aplcb_yn({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByUse_yn({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByRegr_id({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByRegr_nm({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByModr_id({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByModr_nm({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByRsd_qty({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByLast_touched({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderBySupply_price({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByRetail_price({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderBySpplr_item_cls_cd({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderBySpplr_item_cd({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderBySpplr_item_nm({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByEbm_synced({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByTax_type({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByBranch_ids({
    bool descending = false,
    List<int> startAt,
    List<int> startAfter,
    List<int> endAt,
    List<int> endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByStock({
    bool descending = false,
    Stock startAt,
    Stock startAfter,
    Stock endAt,
    Stock endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByUpdated_at({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });
}

class _$VariantQuery extends QueryReference<Variant, VariantQuerySnapshot>
    implements VariantQuery {
  _$VariantQuery(
    this._collection, {
    required Query<Variant> $referenceWithoutCursor,
    $QueryCursor $queryCursor = const $QueryCursor(),
  }) : super(
          $referenceWithoutCursor: $referenceWithoutCursor,
          $queryCursor: $queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<VariantQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(VariantQuerySnapshot._fromQuerySnapshot);
  }

  @override
  Future<VariantQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(VariantQuerySnapshot._fromQuerySnapshot);
  }

  @override
  VariantQuery limit(int limit) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limit(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery limitToLast(int limit) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limitToLast(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereFieldPath(
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
    return _$VariantQuery(
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
  VariantQuery whereDocumentId({
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
    return _$VariantQuery(
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
  VariantQuery whereId({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.id(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.id(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.id(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.id(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.id(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.id(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.id(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereVariant_id({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['variant_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.variant_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.variant_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.variant_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.variant_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.variant_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.variant_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.variant_id(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.variant_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereDeleted_at({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['deleted_at']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.deleted_at(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.deleted_at(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.deleted_at(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .deleted_at(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.deleted_at(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .deleted_at(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.deleted_at(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.deleted_at(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereName({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['name']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.name(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.name(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.name(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.name(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.name(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.name(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.name(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.name(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereColor({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['color']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.color(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.color(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.color(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.color(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.color(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.color(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.color(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.color(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSku({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['sku']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.sku(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.sku(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.sku(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.sku(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.sku(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.sku(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.sku(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.sku(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereProduct_id({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['product_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.product_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.product_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.product_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.product_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.product_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.product_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.product_id(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.product_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereUnit({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['unit']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.unit(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.unit(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.unit(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.unit(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.unit(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.unit(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.unit(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.unit(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereProduct_name({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['product_name']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.product_name(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.product_name(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.product_name(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .product_name(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.product_name(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .product_name(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.product_name(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.product_name(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereBranch_id({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['branch_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branch_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branch_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.branch_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.branch_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.branch_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.branch_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.branch_id(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.branch_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTax_name({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['tax_name']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_name(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_name(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.tax_name(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.tax_name(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.tax_name(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.tax_name(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.tax_name(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.tax_name(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTax_percentage({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['tax_percentage']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_percentage(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_percentage(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.tax_percentage(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .tax_percentage(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.tax_percentage(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .tax_percentage(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.tax_percentage(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.tax_percentage(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIs_tax_exempted({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['is_tax_exempted']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.is_tax_exempted(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.is_tax_exempted(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.is_tax_exempted(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .is_tax_exempted(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.is_tax_exempted(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .is_tax_exempted(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn:
            whereIn?.map((e) => _$VariantPerFieldToJson.is_tax_exempted(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.is_tax_exempted(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItem_seq({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['item_seq']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_seq(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_seq(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.item_seq(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_seq(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.item_seq(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_seq(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.item_seq(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.item_seq(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrcc_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['isrcc_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcc_cd(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcc_cd(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrcc_cd(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcc_cd(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrcc_cd(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcc_cd(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrcc_cd(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrcc_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrcc_nm({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['isrcc_nm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcc_nm(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcc_nm(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrcc_nm(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcc_nm(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrcc_nm(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcc_nm(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrcc_nm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrcc_nm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrc_rt({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['isrc_rt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrc_rt(isEqualTo as int)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrc_rt(isNotEqualTo as int)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrc_rt(isLessThan as int)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrc_rt(isLessThanOrEqualTo as int)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrc_rt(isGreaterThan as int)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrc_rt(isGreaterThanOrEqualTo as int)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrc_rt(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrc_rt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrc_amt({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['isrc_amt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrc_amt(isEqualTo as int)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrc_amt(isNotEqualTo as int)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrc_amt(isLessThan as int)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrc_amt(isLessThanOrEqualTo as int)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrc_amt(isGreaterThan as int)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrc_amt(isGreaterThanOrEqualTo as int)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrc_amt(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrc_amt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTax_ty_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['tax_ty_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_ty_cd(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_ty_cd(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.tax_ty_cd(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.tax_ty_cd(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.tax_ty_cd(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .tax_ty_cd(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.tax_ty_cd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.tax_ty_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereBcd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['bcd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bcd(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bcd(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.bcd(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bcd(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.bcd(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bcd(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.bcd(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.bcd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItem_cls_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['item_cls_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_cls_cd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_cls_cd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.item_cls_cd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .item_cls_cd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.item_cls_cd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .item_cls_cd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.item_cls_cd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.item_cls_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItem_ty_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['item_ty_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_ty_cd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_ty_cd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.item_ty_cd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_ty_cd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.item_ty_cd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .item_ty_cd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.item_ty_cd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.item_ty_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItem_std_nm({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['item_std_nm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_std_nm(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_std_nm(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.item_std_nm(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_std_nm(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.item_std_nm(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .item_std_nm(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.item_std_nm(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.item_std_nm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereOrgn_nat_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['orgn_nat_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.orgn_nat_cd(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.orgn_nat_cd(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.orgn_nat_cd(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.orgn_nat_cd(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.orgn_nat_cd(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .orgn_nat_cd(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.orgn_nat_cd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.orgn_nat_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery wherePkg({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['pkg']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkg(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkg(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.pkg(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.pkg(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.pkg(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.pkg(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.pkg(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.pkg(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItem_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['item_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_cd(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_cd(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.item_cd(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_cd(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.item_cd(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_cd(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.item_cd(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.item_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery wherePkg_unit_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['pkg_unit_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkg_unit_cd(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkg_unit_cd(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.pkg_unit_cd(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.pkg_unit_cd(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.pkg_unit_cd(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .pkg_unit_cd(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.pkg_unit_cd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.pkg_unit_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereQty_unit_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['qty_unit_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.qty_unit_cd(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.qty_unit_cd(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.qty_unit_cd(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.qty_unit_cd(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.qty_unit_cd(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .qty_unit_cd(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.qty_unit_cd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.qty_unit_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItem_nm({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['item_nm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_nm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.item_nm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.item_nm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_nm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.item_nm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.item_nm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.item_nm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.item_nm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereQty({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['qty']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.qty(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.qty(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.qty(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.qty(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.qty(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.qty(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.qty(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.qty(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery wherePrc({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['prc']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.prc(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.prc(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.prc(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.prc(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.prc(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.prc(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.prc(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.prc(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSply_amt({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['sply_amt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.sply_amt(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.sply_amt(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.sply_amt(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.sply_amt(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.sply_amt(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.sply_amt(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.sply_amt(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.sply_amt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTin({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['tin']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tin(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tin(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.tin(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.tin(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.tin(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.tin(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.tin(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.tin(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereBhf_id({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['bhf_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bhf_id(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bhf_id(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.bhf_id(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bhf_id(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.bhf_id(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bhf_id(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.bhf_id(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.bhf_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereDft_prc({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['dft_prc']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.dft_prc(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.dft_prc(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.dft_prc(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.dft_prc(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.dft_prc(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.dft_prc(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.dft_prc(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.dft_prc(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereAdd_info({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['add_info']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.add_info(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.add_info(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.add_info(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.add_info(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.add_info(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.add_info(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.add_info(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.add_info(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrc_aplcb_yn({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['isrc_aplcb_yn']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrc_aplcb_yn(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrc_aplcb_yn(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrc_aplcb_yn(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .isrc_aplcb_yn(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrc_aplcb_yn(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .isrc_aplcb_yn(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrc_aplcb_yn(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.isrc_aplcb_yn(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereUse_yn({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['use_yn']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.use_yn(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.use_yn(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.use_yn(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.use_yn(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.use_yn(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.use_yn(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.use_yn(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.use_yn(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRegr_id({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['regr_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regr_id(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regr_id(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.regr_id(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regr_id(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.regr_id(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regr_id(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.regr_id(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.regr_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRegr_nm({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['regr_nm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regr_nm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regr_nm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.regr_nm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regr_nm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.regr_nm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regr_nm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.regr_nm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.regr_nm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereModr_id({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['modr_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modr_id(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modr_id(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.modr_id(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modr_id(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.modr_id(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modr_id(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.modr_id(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.modr_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereModr_nm({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['modr_nm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modr_nm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modr_nm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.modr_nm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modr_nm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.modr_nm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modr_nm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.modr_nm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.modr_nm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRsd_qty({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['rsd_qty']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.rsd_qty(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.rsd_qty(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.rsd_qty(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.rsd_qty(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.rsd_qty(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.rsd_qty(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.rsd_qty(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.rsd_qty(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereLast_touched({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['last_touched']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.last_touched(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.last_touched(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.last_touched(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .last_touched(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.last_touched(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .last_touched(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.last_touched(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.last_touched(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSupply_price({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['supply_price']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.supply_price(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.supply_price(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.supply_price(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .supply_price(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.supply_price(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .supply_price(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.supply_price(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.supply_price(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRetail_price({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['retail_price']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.retail_price(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.retail_price(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.retail_price(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .retail_price(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.retail_price(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .retail_price(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.retail_price(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.retail_price(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSpplr_item_cls_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['spplr_item_cls_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplr_item_cls_cd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplr_item_cls_cd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.spplr_item_cls_cd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplr_item_cls_cd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson
                .spplr_item_cls_cd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplr_item_cls_cd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn:
            whereIn?.map((e) => _$VariantPerFieldToJson.spplr_item_cls_cd(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$VariantPerFieldToJson.spplr_item_cls_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSpplr_item_cd({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['spplr_item_cd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplr_item_cd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplr_item_cd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.spplr_item_cd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplr_item_cd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.spplr_item_cd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplr_item_cd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.spplr_item_cd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.spplr_item_cd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSpplr_item_nm({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['spplr_item_nm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplr_item_nm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplr_item_nm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.spplr_item_nm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplr_item_nm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.spplr_item_nm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplr_item_nm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.spplr_item_nm(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.spplr_item_nm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereEbm_synced({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['ebm_synced']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.ebm_synced(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.ebm_synced(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.ebm_synced(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.ebm_synced(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.ebm_synced(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.ebm_synced(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.ebm_synced(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.ebm_synced(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTax_type({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['tax_type']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_type(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.tax_type(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.tax_type(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.tax_type(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.tax_type(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.tax_type(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.tax_type(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.tax_type(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereBranch_ids({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<int>? arrayContainsAny,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['branch_ids']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branch_ids(isEqualTo as List<int>)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branch_ids(isNotEqualTo as List<int>)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.branch_ids(isLessThan as List<int>)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .branch_ids(isLessThanOrEqualTo as List<int>)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.branch_ids(isGreaterThan as List<int>)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .branch_ids(isGreaterThanOrEqualTo as List<int>)
            : null,
        arrayContains: arrayContains != null
            ? (_$VariantPerFieldToJson.branch_ids([arrayContains as int])
                    as List?)!
                .single
            : null,
        arrayContainsAny: arrayContainsAny != null
            ? _$VariantPerFieldToJson.branch_ids(arrayContainsAny)
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
  VariantQuery whereStock({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<Stock>? whereIn,
    List<Stock>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['stock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.stock(isEqualTo as Stock)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.stock(isNotEqualTo as Stock)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.stock(isLessThan as Stock)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.stock(isLessThanOrEqualTo as Stock)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.stock(isGreaterThan as Stock)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.stock(isGreaterThanOrEqualTo as Stock)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.stock(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.stock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereUpdated_at({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['updated_at']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.updated_at(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.updated_at(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.updated_at(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .updated_at(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.updated_at(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .updated_at(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.updated_at(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.updated_at(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByDocumentId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderById({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['id']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByVariant_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['variant_id']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByDeleted_at({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['deleted_at']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByName({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['name']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByColor({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['color']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderBySku({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['sku']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByProduct_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['product_id']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByUnit({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['unit']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByProduct_name({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['product_name']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByBranch_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['branch_id']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByTax_name({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['tax_name']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByTax_percentage({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['tax_percentage']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByIs_tax_exempted({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['is_tax_exempted']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByItem_seq({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['item_seq']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByIsrcc_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['isrcc_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByIsrcc_nm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['isrcc_nm']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByIsrc_rt({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['isrc_rt']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByIsrc_amt({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['isrc_amt']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByTax_ty_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['tax_ty_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByBcd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['bcd']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByItem_cls_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['item_cls_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByItem_ty_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['item_ty_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByItem_std_nm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['item_std_nm']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByOrgn_nat_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['orgn_nat_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByPkg({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['pkg']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByItem_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['item_cd']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByPkg_unit_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['pkg_unit_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByQty_unit_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['qty_unit_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByItem_nm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['item_nm']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByQty({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['qty']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByPrc({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['prc']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderBySply_amt({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['sply_amt']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByTin({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['tin']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByBhf_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['bhf_id']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByDft_prc({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['dft_prc']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByAdd_info({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['add_info']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByIsrc_aplcb_yn({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['isrc_aplcb_yn']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByUse_yn({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['use_yn']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByRegr_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['regr_id']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByRegr_nm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['regr_nm']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByModr_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['modr_id']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByModr_nm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['modr_nm']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByRsd_qty({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['rsd_qty']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByLast_touched({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['last_touched']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderBySupply_price({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['supply_price']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByRetail_price({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['retail_price']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderBySpplr_item_cls_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$VariantFieldMap['spplr_item_cls_cd']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderBySpplr_item_cd({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['spplr_item_cd']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderBySpplr_item_nm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['spplr_item_nm']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByEbm_synced({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['ebm_synced']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByTax_type({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['tax_type']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByBranch_ids({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['branch_ids']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByStock({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['stock']!,
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  VariantQuery orderByUpdated_at({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$VariantFieldMap['updated_at']!, descending: descending);
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

    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$VariantQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class VariantDocumentSnapshot extends FirestoreDocumentSnapshot<Variant> {
  VariantDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final DocumentSnapshot<Variant> snapshot;

  @override
  VariantDocumentReference get reference {
    return VariantDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Variant? data;
}

class VariantQuerySnapshot
    extends FirestoreQuerySnapshot<Variant, VariantQueryDocumentSnapshot> {
  VariantQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  factory VariantQuerySnapshot._fromQuerySnapshot(
    QuerySnapshot<Variant> snapshot,
  ) {
    final docs = snapshot.docs.map(VariantQueryDocumentSnapshot._).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return _decodeDocumentChange(
        change,
        VariantDocumentSnapshot._,
      );
    }).toList();

    return VariantQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  static FirestoreDocumentChange<VariantDocumentSnapshot>
      _decodeDocumentChange<T>(
    DocumentChange<T> docChange,
    VariantDocumentSnapshot Function(DocumentSnapshot<T> doc) decodeDoc,
  ) {
    return FirestoreDocumentChange<VariantDocumentSnapshot>(
      type: docChange.type,
      oldIndex: docChange.oldIndex,
      newIndex: docChange.newIndex,
      doc: decodeDoc(docChange.doc),
    );
  }

  final QuerySnapshot<Variant> snapshot;

  @override
  final List<VariantQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<VariantDocumentSnapshot>> docChanges;
}

class VariantQueryDocumentSnapshot
    extends FirestoreQueryDocumentSnapshot<Variant>
    implements VariantDocumentSnapshot {
  VariantQueryDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final QueryDocumentSnapshot<Variant> snapshot;

  @override
  final Variant data;

  @override
  VariantDocumentReference get reference {
    return VariantDocumentReference(snapshot.reference);
  }
}

/// A collection reference object can be used for adding documents,
/// getting document references, and querying for documents
/// (using the methods inherited from Query).
abstract class StockCollectionReference
    implements
        StockQuery,
        FirestoreCollectionReference<Stock, StockQuerySnapshot> {
  factory StockCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$StockCollectionReference;

  static Stock fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return Stock.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    Stock value,
    SetOptions? options,
  ) {
    return value.toJson();
  }

  @override
  CollectionReference<Stock> get reference;

  @override
  StockDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<StockDocumentReference> add(Stock value);
}

class _$StockCollectionReference extends _$StockQuery
    implements StockCollectionReference {
  factory _$StockCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$StockCollectionReference._(
      firestore.collection('stocks').withConverter(
            fromFirestore: StockCollectionReference.fromFirestore,
            toFirestore: StockCollectionReference.toFirestore,
          ),
    );
  }

  _$StockCollectionReference._(
    CollectionReference<Stock> reference,
  ) : super(reference, $referenceWithoutCursor: reference);

  String get path => reference.path;

  @override
  CollectionReference<Stock> get reference =>
      super.reference as CollectionReference<Stock>;

  @override
  StockDocumentReference doc([String? id]) {
    assert(
      id == null || id.split('/').length == 1,
      'The document ID cannot be from a different collection',
    );
    return StockDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<StockDocumentReference> add(Stock value) {
    return reference.add(value).then((ref) => StockDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$StockCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class StockDocumentReference
    extends FirestoreDocumentReference<Stock, StockDocumentSnapshot> {
  factory StockDocumentReference(DocumentReference<Stock> reference) =
      _$StockDocumentReference;

  DocumentReference<Stock> get reference;

  /// A reference to the [StockCollectionReference] containing this document.
  StockCollectionReference get parent {
    return _$StockCollectionReference(reference.firestore);
  }

  @override
  Stream<StockDocumentSnapshot> snapshots();

  @override
  Future<StockDocumentSnapshot> get([GetOptions? options]);

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
    Stock model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhf_idFieldValue,
    FieldValue branch_idFieldValue,
    FieldValue variant_idFieldValue,
    FieldValue current_stockFieldValue,
    FieldValue low_stockFieldValue,
    FieldValue can_tracking_stockFieldValue,
    FieldValue show_low_stock_alertFieldValue,
    FieldValue product_idFieldValue,
    FieldValue activeFieldValue,
    FieldValue valueFieldValue,
    FieldValue rsd_qtyFieldValue,
    FieldValue supply_priceFieldValue,
    FieldValue retail_priceFieldValue,
    FieldValue last_touchedFieldValue,
    FieldValue deleted_atFieldValue,
    FieldValue ebm_syncedFieldValue,
    FieldValue cloud_syncedFieldValue,
    FieldValue variantFieldValue,
    FieldValue initial_stockFieldValue,
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
    Stock model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhf_idFieldValue,
    FieldValue branch_idFieldValue,
    FieldValue variant_idFieldValue,
    FieldValue current_stockFieldValue,
    FieldValue low_stockFieldValue,
    FieldValue can_tracking_stockFieldValue,
    FieldValue show_low_stock_alertFieldValue,
    FieldValue product_idFieldValue,
    FieldValue activeFieldValue,
    FieldValue valueFieldValue,
    FieldValue rsd_qtyFieldValue,
    FieldValue supply_priceFieldValue,
    FieldValue retail_priceFieldValue,
    FieldValue last_touchedFieldValue,
    FieldValue deleted_atFieldValue,
    FieldValue ebm_syncedFieldValue,
    FieldValue cloud_syncedFieldValue,
    FieldValue variantFieldValue,
    FieldValue initial_stockFieldValue,
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
    Stock model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhf_idFieldValue,
    FieldValue branch_idFieldValue,
    FieldValue variant_idFieldValue,
    FieldValue current_stockFieldValue,
    FieldValue low_stockFieldValue,
    FieldValue can_tracking_stockFieldValue,
    FieldValue show_low_stock_alertFieldValue,
    FieldValue product_idFieldValue,
    FieldValue activeFieldValue,
    FieldValue valueFieldValue,
    FieldValue rsd_qtyFieldValue,
    FieldValue supply_priceFieldValue,
    FieldValue retail_priceFieldValue,
    FieldValue last_touchedFieldValue,
    FieldValue deleted_atFieldValue,
    FieldValue ebm_syncedFieldValue,
    FieldValue cloud_syncedFieldValue,
    FieldValue variantFieldValue,
    FieldValue initial_stockFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int? id,
    FieldValue idFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhf_id,
    FieldValue bhf_idFieldValue,
    int? branch_id,
    FieldValue branch_idFieldValue,
    int? variant_id,
    FieldValue variant_idFieldValue,
    double current_stock,
    FieldValue current_stockFieldValue,
    double low_stock,
    FieldValue low_stockFieldValue,
    bool? can_tracking_stock,
    FieldValue can_tracking_stockFieldValue,
    bool? show_low_stock_alert,
    FieldValue show_low_stock_alertFieldValue,
    int? product_id,
    FieldValue product_idFieldValue,
    bool? active,
    FieldValue activeFieldValue,
    double value,
    FieldValue valueFieldValue,
    double rsd_qty,
    FieldValue rsd_qtyFieldValue,
    double supply_price,
    FieldValue supply_priceFieldValue,
    double retail_price,
    FieldValue retail_priceFieldValue,
    DateTime? last_touched,
    FieldValue last_touchedFieldValue,
    DateTime? deleted_at,
    FieldValue deleted_atFieldValue,
    bool ebm_synced,
    FieldValue ebm_syncedFieldValue,
    bool cloud_synced,
    FieldValue cloud_syncedFieldValue,
    Variant? variant,
    FieldValue variantFieldValue,
    double? initial_stock,
    FieldValue initial_stockFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int? id,
    FieldValue idFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhf_id,
    FieldValue bhf_idFieldValue,
    int? branch_id,
    FieldValue branch_idFieldValue,
    int? variant_id,
    FieldValue variant_idFieldValue,
    double current_stock,
    FieldValue current_stockFieldValue,
    double low_stock,
    FieldValue low_stockFieldValue,
    bool? can_tracking_stock,
    FieldValue can_tracking_stockFieldValue,
    bool? show_low_stock_alert,
    FieldValue show_low_stock_alertFieldValue,
    int? product_id,
    FieldValue product_idFieldValue,
    bool? active,
    FieldValue activeFieldValue,
    double value,
    FieldValue valueFieldValue,
    double rsd_qty,
    FieldValue rsd_qtyFieldValue,
    double supply_price,
    FieldValue supply_priceFieldValue,
    double retail_price,
    FieldValue retail_priceFieldValue,
    DateTime? last_touched,
    FieldValue last_touchedFieldValue,
    DateTime? deleted_at,
    FieldValue deleted_atFieldValue,
    bool ebm_synced,
    FieldValue ebm_syncedFieldValue,
    bool cloud_synced,
    FieldValue cloud_syncedFieldValue,
    Variant? variant,
    FieldValue variantFieldValue,
    double? initial_stock,
    FieldValue initial_stockFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int? id,
    FieldValue idFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhf_id,
    FieldValue bhf_idFieldValue,
    int? branch_id,
    FieldValue branch_idFieldValue,
    int? variant_id,
    FieldValue variant_idFieldValue,
    double current_stock,
    FieldValue current_stockFieldValue,
    double low_stock,
    FieldValue low_stockFieldValue,
    bool? can_tracking_stock,
    FieldValue can_tracking_stockFieldValue,
    bool? show_low_stock_alert,
    FieldValue show_low_stock_alertFieldValue,
    int? product_id,
    FieldValue product_idFieldValue,
    bool? active,
    FieldValue activeFieldValue,
    double value,
    FieldValue valueFieldValue,
    double rsd_qty,
    FieldValue rsd_qtyFieldValue,
    double supply_price,
    FieldValue supply_priceFieldValue,
    double retail_price,
    FieldValue retail_priceFieldValue,
    DateTime? last_touched,
    FieldValue last_touchedFieldValue,
    DateTime? deleted_at,
    FieldValue deleted_atFieldValue,
    bool ebm_synced,
    FieldValue ebm_syncedFieldValue,
    bool cloud_synced,
    FieldValue cloud_syncedFieldValue,
    Variant? variant,
    FieldValue variantFieldValue,
    double? initial_stock,
    FieldValue initial_stockFieldValue,
  });
}

class _$StockDocumentReference
    extends FirestoreDocumentReference<Stock, StockDocumentSnapshot>
    implements StockDocumentReference {
  _$StockDocumentReference(this.reference);

  @override
  final DocumentReference<Stock> reference;

  /// A reference to the [StockCollectionReference] containing this document.
  StockCollectionReference get parent {
    return _$StockCollectionReference(reference.firestore);
  }

  @override
  Stream<StockDocumentSnapshot> snapshots() {
    return reference.snapshots().map(StockDocumentSnapshot._);
  }

  @override
  Future<StockDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then(StockDocumentSnapshot._);
  }

  @override
  Future<StockDocumentSnapshot> transactionGet(Transaction transaction) {
    return transaction.get(reference).then(StockDocumentSnapshot._);
  }

  Future<void> set(
    Stock model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhf_idFieldValue,
    FieldValue? branch_idFieldValue,
    FieldValue? variant_idFieldValue,
    FieldValue? current_stockFieldValue,
    FieldValue? low_stockFieldValue,
    FieldValue? can_tracking_stockFieldValue,
    FieldValue? show_low_stock_alertFieldValue,
    FieldValue? product_idFieldValue,
    FieldValue? activeFieldValue,
    FieldValue? valueFieldValue,
    FieldValue? rsd_qtyFieldValue,
    FieldValue? supply_priceFieldValue,
    FieldValue? retail_priceFieldValue,
    FieldValue? last_touchedFieldValue,
    FieldValue? deleted_atFieldValue,
    FieldValue? ebm_syncedFieldValue,
    FieldValue? cloud_syncedFieldValue,
    FieldValue? variantFieldValue,
    FieldValue? initial_stockFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhf_idFieldValue != null)
        _$StockFieldMap['bhf_id']!: bhf_idFieldValue,
      if (branch_idFieldValue != null)
        _$StockFieldMap['branch_id']!: branch_idFieldValue,
      if (variant_idFieldValue != null)
        _$StockFieldMap['variant_id']!: variant_idFieldValue,
      if (current_stockFieldValue != null)
        _$StockFieldMap['current_stock']!: current_stockFieldValue,
      if (low_stockFieldValue != null)
        _$StockFieldMap['low_stock']!: low_stockFieldValue,
      if (can_tracking_stockFieldValue != null)
        _$StockFieldMap['can_tracking_stock']!: can_tracking_stockFieldValue,
      if (show_low_stock_alertFieldValue != null)
        _$StockFieldMap['show_low_stock_alert']!:
            show_low_stock_alertFieldValue,
      if (product_idFieldValue != null)
        _$StockFieldMap['product_id']!: product_idFieldValue,
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsd_qtyFieldValue != null)
        _$StockFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (supply_priceFieldValue != null)
        _$StockFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_priceFieldValue != null)
        _$StockFieldMap['retail_price']!: retail_priceFieldValue,
      if (last_touchedFieldValue != null)
        _$StockFieldMap['last_touched']!: last_touchedFieldValue,
      if (deleted_atFieldValue != null)
        _$StockFieldMap['deleted_at']!: deleted_atFieldValue,
      if (ebm_syncedFieldValue != null)
        _$StockFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (cloud_syncedFieldValue != null)
        _$StockFieldMap['cloud_synced']!: cloud_syncedFieldValue,
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initial_stockFieldValue != null)
        _$StockFieldMap['initial_stock']!: initial_stockFieldValue,
    };

    final castedReference = reference.withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, options) => throw UnimplementedError(),
      toFirestore: (value, options) => value,
    );
    return castedReference.set(json, options);
  }

  void transactionSet(
    Transaction transaction,
    Stock model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhf_idFieldValue,
    FieldValue? branch_idFieldValue,
    FieldValue? variant_idFieldValue,
    FieldValue? current_stockFieldValue,
    FieldValue? low_stockFieldValue,
    FieldValue? can_tracking_stockFieldValue,
    FieldValue? show_low_stock_alertFieldValue,
    FieldValue? product_idFieldValue,
    FieldValue? activeFieldValue,
    FieldValue? valueFieldValue,
    FieldValue? rsd_qtyFieldValue,
    FieldValue? supply_priceFieldValue,
    FieldValue? retail_priceFieldValue,
    FieldValue? last_touchedFieldValue,
    FieldValue? deleted_atFieldValue,
    FieldValue? ebm_syncedFieldValue,
    FieldValue? cloud_syncedFieldValue,
    FieldValue? variantFieldValue,
    FieldValue? initial_stockFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhf_idFieldValue != null)
        _$StockFieldMap['bhf_id']!: bhf_idFieldValue,
      if (branch_idFieldValue != null)
        _$StockFieldMap['branch_id']!: branch_idFieldValue,
      if (variant_idFieldValue != null)
        _$StockFieldMap['variant_id']!: variant_idFieldValue,
      if (current_stockFieldValue != null)
        _$StockFieldMap['current_stock']!: current_stockFieldValue,
      if (low_stockFieldValue != null)
        _$StockFieldMap['low_stock']!: low_stockFieldValue,
      if (can_tracking_stockFieldValue != null)
        _$StockFieldMap['can_tracking_stock']!: can_tracking_stockFieldValue,
      if (show_low_stock_alertFieldValue != null)
        _$StockFieldMap['show_low_stock_alert']!:
            show_low_stock_alertFieldValue,
      if (product_idFieldValue != null)
        _$StockFieldMap['product_id']!: product_idFieldValue,
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsd_qtyFieldValue != null)
        _$StockFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (supply_priceFieldValue != null)
        _$StockFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_priceFieldValue != null)
        _$StockFieldMap['retail_price']!: retail_priceFieldValue,
      if (last_touchedFieldValue != null)
        _$StockFieldMap['last_touched']!: last_touchedFieldValue,
      if (deleted_atFieldValue != null)
        _$StockFieldMap['deleted_at']!: deleted_atFieldValue,
      if (ebm_syncedFieldValue != null)
        _$StockFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (cloud_syncedFieldValue != null)
        _$StockFieldMap['cloud_synced']!: cloud_syncedFieldValue,
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initial_stockFieldValue != null)
        _$StockFieldMap['initial_stock']!: initial_stockFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Stock model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhf_idFieldValue,
    FieldValue? branch_idFieldValue,
    FieldValue? variant_idFieldValue,
    FieldValue? current_stockFieldValue,
    FieldValue? low_stockFieldValue,
    FieldValue? can_tracking_stockFieldValue,
    FieldValue? show_low_stock_alertFieldValue,
    FieldValue? product_idFieldValue,
    FieldValue? activeFieldValue,
    FieldValue? valueFieldValue,
    FieldValue? rsd_qtyFieldValue,
    FieldValue? supply_priceFieldValue,
    FieldValue? retail_priceFieldValue,
    FieldValue? last_touchedFieldValue,
    FieldValue? deleted_atFieldValue,
    FieldValue? ebm_syncedFieldValue,
    FieldValue? cloud_syncedFieldValue,
    FieldValue? variantFieldValue,
    FieldValue? initial_stockFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhf_idFieldValue != null)
        _$StockFieldMap['bhf_id']!: bhf_idFieldValue,
      if (branch_idFieldValue != null)
        _$StockFieldMap['branch_id']!: branch_idFieldValue,
      if (variant_idFieldValue != null)
        _$StockFieldMap['variant_id']!: variant_idFieldValue,
      if (current_stockFieldValue != null)
        _$StockFieldMap['current_stock']!: current_stockFieldValue,
      if (low_stockFieldValue != null)
        _$StockFieldMap['low_stock']!: low_stockFieldValue,
      if (can_tracking_stockFieldValue != null)
        _$StockFieldMap['can_tracking_stock']!: can_tracking_stockFieldValue,
      if (show_low_stock_alertFieldValue != null)
        _$StockFieldMap['show_low_stock_alert']!:
            show_low_stock_alertFieldValue,
      if (product_idFieldValue != null)
        _$StockFieldMap['product_id']!: product_idFieldValue,
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsd_qtyFieldValue != null)
        _$StockFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (supply_priceFieldValue != null)
        _$StockFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_priceFieldValue != null)
        _$StockFieldMap['retail_price']!: retail_priceFieldValue,
      if (last_touchedFieldValue != null)
        _$StockFieldMap['last_touched']!: last_touchedFieldValue,
      if (deleted_atFieldValue != null)
        _$StockFieldMap['deleted_at']!: deleted_atFieldValue,
      if (ebm_syncedFieldValue != null)
        _$StockFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (cloud_syncedFieldValue != null)
        _$StockFieldMap['cloud_synced']!: cloud_syncedFieldValue,
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initial_stockFieldValue != null)
        _$StockFieldMap['initial_stock']!: initial_stockFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhf_id = _sentinel,
    FieldValue? bhf_idFieldValue,
    Object? branch_id = _sentinel,
    FieldValue? branch_idFieldValue,
    Object? variant_id = _sentinel,
    FieldValue? variant_idFieldValue,
    Object? current_stock = _sentinel,
    FieldValue? current_stockFieldValue,
    Object? low_stock = _sentinel,
    FieldValue? low_stockFieldValue,
    Object? can_tracking_stock = _sentinel,
    FieldValue? can_tracking_stockFieldValue,
    Object? show_low_stock_alert = _sentinel,
    FieldValue? show_low_stock_alertFieldValue,
    Object? product_id = _sentinel,
    FieldValue? product_idFieldValue,
    Object? active = _sentinel,
    FieldValue? activeFieldValue,
    Object? value = _sentinel,
    FieldValue? valueFieldValue,
    Object? rsd_qty = _sentinel,
    FieldValue? rsd_qtyFieldValue,
    Object? supply_price = _sentinel,
    FieldValue? supply_priceFieldValue,
    Object? retail_price = _sentinel,
    FieldValue? retail_priceFieldValue,
    Object? last_touched = _sentinel,
    FieldValue? last_touchedFieldValue,
    Object? deleted_at = _sentinel,
    FieldValue? deleted_atFieldValue,
    Object? ebm_synced = _sentinel,
    FieldValue? ebm_syncedFieldValue,
    Object? cloud_synced = _sentinel,
    FieldValue? cloud_syncedFieldValue,
    Object? variant = _sentinel,
    FieldValue? variantFieldValue,
    Object? initial_stock = _sentinel,
    FieldValue? initial_stockFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      tin == _sentinel || tinFieldValue == null,
      "Cannot specify both tin and tinFieldValue",
    );
    assert(
      bhf_id == _sentinel || bhf_idFieldValue == null,
      "Cannot specify both bhf_id and bhf_idFieldValue",
    );
    assert(
      branch_id == _sentinel || branch_idFieldValue == null,
      "Cannot specify both branch_id and branch_idFieldValue",
    );
    assert(
      variant_id == _sentinel || variant_idFieldValue == null,
      "Cannot specify both variant_id and variant_idFieldValue",
    );
    assert(
      current_stock == _sentinel || current_stockFieldValue == null,
      "Cannot specify both current_stock and current_stockFieldValue",
    );
    assert(
      low_stock == _sentinel || low_stockFieldValue == null,
      "Cannot specify both low_stock and low_stockFieldValue",
    );
    assert(
      can_tracking_stock == _sentinel || can_tracking_stockFieldValue == null,
      "Cannot specify both can_tracking_stock and can_tracking_stockFieldValue",
    );
    assert(
      show_low_stock_alert == _sentinel ||
          show_low_stock_alertFieldValue == null,
      "Cannot specify both show_low_stock_alert and show_low_stock_alertFieldValue",
    );
    assert(
      product_id == _sentinel || product_idFieldValue == null,
      "Cannot specify both product_id and product_idFieldValue",
    );
    assert(
      active == _sentinel || activeFieldValue == null,
      "Cannot specify both active and activeFieldValue",
    );
    assert(
      value == _sentinel || valueFieldValue == null,
      "Cannot specify both value and valueFieldValue",
    );
    assert(
      rsd_qty == _sentinel || rsd_qtyFieldValue == null,
      "Cannot specify both rsd_qty and rsd_qtyFieldValue",
    );
    assert(
      supply_price == _sentinel || supply_priceFieldValue == null,
      "Cannot specify both supply_price and supply_priceFieldValue",
    );
    assert(
      retail_price == _sentinel || retail_priceFieldValue == null,
      "Cannot specify both retail_price and retail_priceFieldValue",
    );
    assert(
      last_touched == _sentinel || last_touchedFieldValue == null,
      "Cannot specify both last_touched and last_touchedFieldValue",
    );
    assert(
      deleted_at == _sentinel || deleted_atFieldValue == null,
      "Cannot specify both deleted_at and deleted_atFieldValue",
    );
    assert(
      ebm_synced == _sentinel || ebm_syncedFieldValue == null,
      "Cannot specify both ebm_synced and ebm_syncedFieldValue",
    );
    assert(
      cloud_synced == _sentinel || cloud_syncedFieldValue == null,
      "Cannot specify both cloud_synced and cloud_syncedFieldValue",
    );
    assert(
      variant == _sentinel || variantFieldValue == null,
      "Cannot specify both variant and variantFieldValue",
    );
    assert(
      initial_stock == _sentinel || initial_stockFieldValue == null,
      "Cannot specify both initial_stock and initial_stockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockFieldMap['id']!: _$StockPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tin != _sentinel)
        _$StockFieldMap['tin']!: _$StockPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhf_id != _sentinel)
        _$StockFieldMap['bhf_id']!:
            _$StockPerFieldToJson.bhf_id(bhf_id as String?),
      if (bhf_idFieldValue != null)
        _$StockFieldMap['bhf_id']!: bhf_idFieldValue,
      if (branch_id != _sentinel)
        _$StockFieldMap['branch_id']!:
            _$StockPerFieldToJson.branch_id(branch_id as int?),
      if (branch_idFieldValue != null)
        _$StockFieldMap['branch_id']!: branch_idFieldValue,
      if (variant_id != _sentinel)
        _$StockFieldMap['variant_id']!:
            _$StockPerFieldToJson.variant_id(variant_id as int?),
      if (variant_idFieldValue != null)
        _$StockFieldMap['variant_id']!: variant_idFieldValue,
      if (current_stock != _sentinel)
        _$StockFieldMap['current_stock']!:
            _$StockPerFieldToJson.current_stock(current_stock as double),
      if (current_stockFieldValue != null)
        _$StockFieldMap['current_stock']!: current_stockFieldValue,
      if (low_stock != _sentinel)
        _$StockFieldMap['low_stock']!:
            _$StockPerFieldToJson.low_stock(low_stock as double),
      if (low_stockFieldValue != null)
        _$StockFieldMap['low_stock']!: low_stockFieldValue,
      if (can_tracking_stock != _sentinel)
        _$StockFieldMap['can_tracking_stock']!: _$StockPerFieldToJson
            .can_tracking_stock(can_tracking_stock as bool?),
      if (can_tracking_stockFieldValue != null)
        _$StockFieldMap['can_tracking_stock']!: can_tracking_stockFieldValue,
      if (show_low_stock_alert != _sentinel)
        _$StockFieldMap['show_low_stock_alert']!: _$StockPerFieldToJson
            .show_low_stock_alert(show_low_stock_alert as bool?),
      if (show_low_stock_alertFieldValue != null)
        _$StockFieldMap['show_low_stock_alert']!:
            show_low_stock_alertFieldValue,
      if (product_id != _sentinel)
        _$StockFieldMap['product_id']!:
            _$StockPerFieldToJson.product_id(product_id as int?),
      if (product_idFieldValue != null)
        _$StockFieldMap['product_id']!: product_idFieldValue,
      if (active != _sentinel)
        _$StockFieldMap['active']!:
            _$StockPerFieldToJson.active(active as bool?),
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (value != _sentinel)
        _$StockFieldMap['value']!: _$StockPerFieldToJson.value(value as double),
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsd_qty != _sentinel)
        _$StockFieldMap['rsd_qty']!:
            _$StockPerFieldToJson.rsd_qty(rsd_qty as double),
      if (rsd_qtyFieldValue != null)
        _$StockFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (supply_price != _sentinel)
        _$StockFieldMap['supply_price']!:
            _$StockPerFieldToJson.supply_price(supply_price as double),
      if (supply_priceFieldValue != null)
        _$StockFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_price != _sentinel)
        _$StockFieldMap['retail_price']!:
            _$StockPerFieldToJson.retail_price(retail_price as double),
      if (retail_priceFieldValue != null)
        _$StockFieldMap['retail_price']!: retail_priceFieldValue,
      if (last_touched != _sentinel)
        _$StockFieldMap['last_touched']!:
            _$StockPerFieldToJson.last_touched(last_touched as DateTime?),
      if (last_touchedFieldValue != null)
        _$StockFieldMap['last_touched']!: last_touchedFieldValue,
      if (deleted_at != _sentinel)
        _$StockFieldMap['deleted_at']!:
            _$StockPerFieldToJson.deleted_at(deleted_at as DateTime?),
      if (deleted_atFieldValue != null)
        _$StockFieldMap['deleted_at']!: deleted_atFieldValue,
      if (ebm_synced != _sentinel)
        _$StockFieldMap['ebm_synced']!:
            _$StockPerFieldToJson.ebm_synced(ebm_synced as bool),
      if (ebm_syncedFieldValue != null)
        _$StockFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (cloud_synced != _sentinel)
        _$StockFieldMap['cloud_synced']!:
            _$StockPerFieldToJson.cloud_synced(cloud_synced as bool),
      if (cloud_syncedFieldValue != null)
        _$StockFieldMap['cloud_synced']!: cloud_syncedFieldValue,
      if (variant != _sentinel)
        _$StockFieldMap['variant']!:
            _$StockPerFieldToJson.variant(variant as Variant?),
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initial_stock != _sentinel)
        _$StockFieldMap['initial_stock']!:
            _$StockPerFieldToJson.initial_stock(initial_stock as double?),
      if (initial_stockFieldValue != null)
        _$StockFieldMap['initial_stock']!: initial_stockFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhf_id = _sentinel,
    FieldValue? bhf_idFieldValue,
    Object? branch_id = _sentinel,
    FieldValue? branch_idFieldValue,
    Object? variant_id = _sentinel,
    FieldValue? variant_idFieldValue,
    Object? current_stock = _sentinel,
    FieldValue? current_stockFieldValue,
    Object? low_stock = _sentinel,
    FieldValue? low_stockFieldValue,
    Object? can_tracking_stock = _sentinel,
    FieldValue? can_tracking_stockFieldValue,
    Object? show_low_stock_alert = _sentinel,
    FieldValue? show_low_stock_alertFieldValue,
    Object? product_id = _sentinel,
    FieldValue? product_idFieldValue,
    Object? active = _sentinel,
    FieldValue? activeFieldValue,
    Object? value = _sentinel,
    FieldValue? valueFieldValue,
    Object? rsd_qty = _sentinel,
    FieldValue? rsd_qtyFieldValue,
    Object? supply_price = _sentinel,
    FieldValue? supply_priceFieldValue,
    Object? retail_price = _sentinel,
    FieldValue? retail_priceFieldValue,
    Object? last_touched = _sentinel,
    FieldValue? last_touchedFieldValue,
    Object? deleted_at = _sentinel,
    FieldValue? deleted_atFieldValue,
    Object? ebm_synced = _sentinel,
    FieldValue? ebm_syncedFieldValue,
    Object? cloud_synced = _sentinel,
    FieldValue? cloud_syncedFieldValue,
    Object? variant = _sentinel,
    FieldValue? variantFieldValue,
    Object? initial_stock = _sentinel,
    FieldValue? initial_stockFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      tin == _sentinel || tinFieldValue == null,
      "Cannot specify both tin and tinFieldValue",
    );
    assert(
      bhf_id == _sentinel || bhf_idFieldValue == null,
      "Cannot specify both bhf_id and bhf_idFieldValue",
    );
    assert(
      branch_id == _sentinel || branch_idFieldValue == null,
      "Cannot specify both branch_id and branch_idFieldValue",
    );
    assert(
      variant_id == _sentinel || variant_idFieldValue == null,
      "Cannot specify both variant_id and variant_idFieldValue",
    );
    assert(
      current_stock == _sentinel || current_stockFieldValue == null,
      "Cannot specify both current_stock and current_stockFieldValue",
    );
    assert(
      low_stock == _sentinel || low_stockFieldValue == null,
      "Cannot specify both low_stock and low_stockFieldValue",
    );
    assert(
      can_tracking_stock == _sentinel || can_tracking_stockFieldValue == null,
      "Cannot specify both can_tracking_stock and can_tracking_stockFieldValue",
    );
    assert(
      show_low_stock_alert == _sentinel ||
          show_low_stock_alertFieldValue == null,
      "Cannot specify both show_low_stock_alert and show_low_stock_alertFieldValue",
    );
    assert(
      product_id == _sentinel || product_idFieldValue == null,
      "Cannot specify both product_id and product_idFieldValue",
    );
    assert(
      active == _sentinel || activeFieldValue == null,
      "Cannot specify both active and activeFieldValue",
    );
    assert(
      value == _sentinel || valueFieldValue == null,
      "Cannot specify both value and valueFieldValue",
    );
    assert(
      rsd_qty == _sentinel || rsd_qtyFieldValue == null,
      "Cannot specify both rsd_qty and rsd_qtyFieldValue",
    );
    assert(
      supply_price == _sentinel || supply_priceFieldValue == null,
      "Cannot specify both supply_price and supply_priceFieldValue",
    );
    assert(
      retail_price == _sentinel || retail_priceFieldValue == null,
      "Cannot specify both retail_price and retail_priceFieldValue",
    );
    assert(
      last_touched == _sentinel || last_touchedFieldValue == null,
      "Cannot specify both last_touched and last_touchedFieldValue",
    );
    assert(
      deleted_at == _sentinel || deleted_atFieldValue == null,
      "Cannot specify both deleted_at and deleted_atFieldValue",
    );
    assert(
      ebm_synced == _sentinel || ebm_syncedFieldValue == null,
      "Cannot specify both ebm_synced and ebm_syncedFieldValue",
    );
    assert(
      cloud_synced == _sentinel || cloud_syncedFieldValue == null,
      "Cannot specify both cloud_synced and cloud_syncedFieldValue",
    );
    assert(
      variant == _sentinel || variantFieldValue == null,
      "Cannot specify both variant and variantFieldValue",
    );
    assert(
      initial_stock == _sentinel || initial_stockFieldValue == null,
      "Cannot specify both initial_stock and initial_stockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockFieldMap['id']!: _$StockPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tin != _sentinel)
        _$StockFieldMap['tin']!: _$StockPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhf_id != _sentinel)
        _$StockFieldMap['bhf_id']!:
            _$StockPerFieldToJson.bhf_id(bhf_id as String?),
      if (bhf_idFieldValue != null)
        _$StockFieldMap['bhf_id']!: bhf_idFieldValue,
      if (branch_id != _sentinel)
        _$StockFieldMap['branch_id']!:
            _$StockPerFieldToJson.branch_id(branch_id as int?),
      if (branch_idFieldValue != null)
        _$StockFieldMap['branch_id']!: branch_idFieldValue,
      if (variant_id != _sentinel)
        _$StockFieldMap['variant_id']!:
            _$StockPerFieldToJson.variant_id(variant_id as int?),
      if (variant_idFieldValue != null)
        _$StockFieldMap['variant_id']!: variant_idFieldValue,
      if (current_stock != _sentinel)
        _$StockFieldMap['current_stock']!:
            _$StockPerFieldToJson.current_stock(current_stock as double),
      if (current_stockFieldValue != null)
        _$StockFieldMap['current_stock']!: current_stockFieldValue,
      if (low_stock != _sentinel)
        _$StockFieldMap['low_stock']!:
            _$StockPerFieldToJson.low_stock(low_stock as double),
      if (low_stockFieldValue != null)
        _$StockFieldMap['low_stock']!: low_stockFieldValue,
      if (can_tracking_stock != _sentinel)
        _$StockFieldMap['can_tracking_stock']!: _$StockPerFieldToJson
            .can_tracking_stock(can_tracking_stock as bool?),
      if (can_tracking_stockFieldValue != null)
        _$StockFieldMap['can_tracking_stock']!: can_tracking_stockFieldValue,
      if (show_low_stock_alert != _sentinel)
        _$StockFieldMap['show_low_stock_alert']!: _$StockPerFieldToJson
            .show_low_stock_alert(show_low_stock_alert as bool?),
      if (show_low_stock_alertFieldValue != null)
        _$StockFieldMap['show_low_stock_alert']!:
            show_low_stock_alertFieldValue,
      if (product_id != _sentinel)
        _$StockFieldMap['product_id']!:
            _$StockPerFieldToJson.product_id(product_id as int?),
      if (product_idFieldValue != null)
        _$StockFieldMap['product_id']!: product_idFieldValue,
      if (active != _sentinel)
        _$StockFieldMap['active']!:
            _$StockPerFieldToJson.active(active as bool?),
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (value != _sentinel)
        _$StockFieldMap['value']!: _$StockPerFieldToJson.value(value as double),
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsd_qty != _sentinel)
        _$StockFieldMap['rsd_qty']!:
            _$StockPerFieldToJson.rsd_qty(rsd_qty as double),
      if (rsd_qtyFieldValue != null)
        _$StockFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (supply_price != _sentinel)
        _$StockFieldMap['supply_price']!:
            _$StockPerFieldToJson.supply_price(supply_price as double),
      if (supply_priceFieldValue != null)
        _$StockFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_price != _sentinel)
        _$StockFieldMap['retail_price']!:
            _$StockPerFieldToJson.retail_price(retail_price as double),
      if (retail_priceFieldValue != null)
        _$StockFieldMap['retail_price']!: retail_priceFieldValue,
      if (last_touched != _sentinel)
        _$StockFieldMap['last_touched']!:
            _$StockPerFieldToJson.last_touched(last_touched as DateTime?),
      if (last_touchedFieldValue != null)
        _$StockFieldMap['last_touched']!: last_touchedFieldValue,
      if (deleted_at != _sentinel)
        _$StockFieldMap['deleted_at']!:
            _$StockPerFieldToJson.deleted_at(deleted_at as DateTime?),
      if (deleted_atFieldValue != null)
        _$StockFieldMap['deleted_at']!: deleted_atFieldValue,
      if (ebm_synced != _sentinel)
        _$StockFieldMap['ebm_synced']!:
            _$StockPerFieldToJson.ebm_synced(ebm_synced as bool),
      if (ebm_syncedFieldValue != null)
        _$StockFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (cloud_synced != _sentinel)
        _$StockFieldMap['cloud_synced']!:
            _$StockPerFieldToJson.cloud_synced(cloud_synced as bool),
      if (cloud_syncedFieldValue != null)
        _$StockFieldMap['cloud_synced']!: cloud_syncedFieldValue,
      if (variant != _sentinel)
        _$StockFieldMap['variant']!:
            _$StockPerFieldToJson.variant(variant as Variant?),
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initial_stock != _sentinel)
        _$StockFieldMap['initial_stock']!:
            _$StockPerFieldToJson.initial_stock(initial_stock as double?),
      if (initial_stockFieldValue != null)
        _$StockFieldMap['initial_stock']!: initial_stockFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhf_id = _sentinel,
    FieldValue? bhf_idFieldValue,
    Object? branch_id = _sentinel,
    FieldValue? branch_idFieldValue,
    Object? variant_id = _sentinel,
    FieldValue? variant_idFieldValue,
    Object? current_stock = _sentinel,
    FieldValue? current_stockFieldValue,
    Object? low_stock = _sentinel,
    FieldValue? low_stockFieldValue,
    Object? can_tracking_stock = _sentinel,
    FieldValue? can_tracking_stockFieldValue,
    Object? show_low_stock_alert = _sentinel,
    FieldValue? show_low_stock_alertFieldValue,
    Object? product_id = _sentinel,
    FieldValue? product_idFieldValue,
    Object? active = _sentinel,
    FieldValue? activeFieldValue,
    Object? value = _sentinel,
    FieldValue? valueFieldValue,
    Object? rsd_qty = _sentinel,
    FieldValue? rsd_qtyFieldValue,
    Object? supply_price = _sentinel,
    FieldValue? supply_priceFieldValue,
    Object? retail_price = _sentinel,
    FieldValue? retail_priceFieldValue,
    Object? last_touched = _sentinel,
    FieldValue? last_touchedFieldValue,
    Object? deleted_at = _sentinel,
    FieldValue? deleted_atFieldValue,
    Object? ebm_synced = _sentinel,
    FieldValue? ebm_syncedFieldValue,
    Object? cloud_synced = _sentinel,
    FieldValue? cloud_syncedFieldValue,
    Object? variant = _sentinel,
    FieldValue? variantFieldValue,
    Object? initial_stock = _sentinel,
    FieldValue? initial_stockFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      tin == _sentinel || tinFieldValue == null,
      "Cannot specify both tin and tinFieldValue",
    );
    assert(
      bhf_id == _sentinel || bhf_idFieldValue == null,
      "Cannot specify both bhf_id and bhf_idFieldValue",
    );
    assert(
      branch_id == _sentinel || branch_idFieldValue == null,
      "Cannot specify both branch_id and branch_idFieldValue",
    );
    assert(
      variant_id == _sentinel || variant_idFieldValue == null,
      "Cannot specify both variant_id and variant_idFieldValue",
    );
    assert(
      current_stock == _sentinel || current_stockFieldValue == null,
      "Cannot specify both current_stock and current_stockFieldValue",
    );
    assert(
      low_stock == _sentinel || low_stockFieldValue == null,
      "Cannot specify both low_stock and low_stockFieldValue",
    );
    assert(
      can_tracking_stock == _sentinel || can_tracking_stockFieldValue == null,
      "Cannot specify both can_tracking_stock and can_tracking_stockFieldValue",
    );
    assert(
      show_low_stock_alert == _sentinel ||
          show_low_stock_alertFieldValue == null,
      "Cannot specify both show_low_stock_alert and show_low_stock_alertFieldValue",
    );
    assert(
      product_id == _sentinel || product_idFieldValue == null,
      "Cannot specify both product_id and product_idFieldValue",
    );
    assert(
      active == _sentinel || activeFieldValue == null,
      "Cannot specify both active and activeFieldValue",
    );
    assert(
      value == _sentinel || valueFieldValue == null,
      "Cannot specify both value and valueFieldValue",
    );
    assert(
      rsd_qty == _sentinel || rsd_qtyFieldValue == null,
      "Cannot specify both rsd_qty and rsd_qtyFieldValue",
    );
    assert(
      supply_price == _sentinel || supply_priceFieldValue == null,
      "Cannot specify both supply_price and supply_priceFieldValue",
    );
    assert(
      retail_price == _sentinel || retail_priceFieldValue == null,
      "Cannot specify both retail_price and retail_priceFieldValue",
    );
    assert(
      last_touched == _sentinel || last_touchedFieldValue == null,
      "Cannot specify both last_touched and last_touchedFieldValue",
    );
    assert(
      deleted_at == _sentinel || deleted_atFieldValue == null,
      "Cannot specify both deleted_at and deleted_atFieldValue",
    );
    assert(
      ebm_synced == _sentinel || ebm_syncedFieldValue == null,
      "Cannot specify both ebm_synced and ebm_syncedFieldValue",
    );
    assert(
      cloud_synced == _sentinel || cloud_syncedFieldValue == null,
      "Cannot specify both cloud_synced and cloud_syncedFieldValue",
    );
    assert(
      variant == _sentinel || variantFieldValue == null,
      "Cannot specify both variant and variantFieldValue",
    );
    assert(
      initial_stock == _sentinel || initial_stockFieldValue == null,
      "Cannot specify both initial_stock and initial_stockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockFieldMap['id']!: _$StockPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tin != _sentinel)
        _$StockFieldMap['tin']!: _$StockPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhf_id != _sentinel)
        _$StockFieldMap['bhf_id']!:
            _$StockPerFieldToJson.bhf_id(bhf_id as String?),
      if (bhf_idFieldValue != null)
        _$StockFieldMap['bhf_id']!: bhf_idFieldValue,
      if (branch_id != _sentinel)
        _$StockFieldMap['branch_id']!:
            _$StockPerFieldToJson.branch_id(branch_id as int?),
      if (branch_idFieldValue != null)
        _$StockFieldMap['branch_id']!: branch_idFieldValue,
      if (variant_id != _sentinel)
        _$StockFieldMap['variant_id']!:
            _$StockPerFieldToJson.variant_id(variant_id as int?),
      if (variant_idFieldValue != null)
        _$StockFieldMap['variant_id']!: variant_idFieldValue,
      if (current_stock != _sentinel)
        _$StockFieldMap['current_stock']!:
            _$StockPerFieldToJson.current_stock(current_stock as double),
      if (current_stockFieldValue != null)
        _$StockFieldMap['current_stock']!: current_stockFieldValue,
      if (low_stock != _sentinel)
        _$StockFieldMap['low_stock']!:
            _$StockPerFieldToJson.low_stock(low_stock as double),
      if (low_stockFieldValue != null)
        _$StockFieldMap['low_stock']!: low_stockFieldValue,
      if (can_tracking_stock != _sentinel)
        _$StockFieldMap['can_tracking_stock']!: _$StockPerFieldToJson
            .can_tracking_stock(can_tracking_stock as bool?),
      if (can_tracking_stockFieldValue != null)
        _$StockFieldMap['can_tracking_stock']!: can_tracking_stockFieldValue,
      if (show_low_stock_alert != _sentinel)
        _$StockFieldMap['show_low_stock_alert']!: _$StockPerFieldToJson
            .show_low_stock_alert(show_low_stock_alert as bool?),
      if (show_low_stock_alertFieldValue != null)
        _$StockFieldMap['show_low_stock_alert']!:
            show_low_stock_alertFieldValue,
      if (product_id != _sentinel)
        _$StockFieldMap['product_id']!:
            _$StockPerFieldToJson.product_id(product_id as int?),
      if (product_idFieldValue != null)
        _$StockFieldMap['product_id']!: product_idFieldValue,
      if (active != _sentinel)
        _$StockFieldMap['active']!:
            _$StockPerFieldToJson.active(active as bool?),
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (value != _sentinel)
        _$StockFieldMap['value']!: _$StockPerFieldToJson.value(value as double),
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsd_qty != _sentinel)
        _$StockFieldMap['rsd_qty']!:
            _$StockPerFieldToJson.rsd_qty(rsd_qty as double),
      if (rsd_qtyFieldValue != null)
        _$StockFieldMap['rsd_qty']!: rsd_qtyFieldValue,
      if (supply_price != _sentinel)
        _$StockFieldMap['supply_price']!:
            _$StockPerFieldToJson.supply_price(supply_price as double),
      if (supply_priceFieldValue != null)
        _$StockFieldMap['supply_price']!: supply_priceFieldValue,
      if (retail_price != _sentinel)
        _$StockFieldMap['retail_price']!:
            _$StockPerFieldToJson.retail_price(retail_price as double),
      if (retail_priceFieldValue != null)
        _$StockFieldMap['retail_price']!: retail_priceFieldValue,
      if (last_touched != _sentinel)
        _$StockFieldMap['last_touched']!:
            _$StockPerFieldToJson.last_touched(last_touched as DateTime?),
      if (last_touchedFieldValue != null)
        _$StockFieldMap['last_touched']!: last_touchedFieldValue,
      if (deleted_at != _sentinel)
        _$StockFieldMap['deleted_at']!:
            _$StockPerFieldToJson.deleted_at(deleted_at as DateTime?),
      if (deleted_atFieldValue != null)
        _$StockFieldMap['deleted_at']!: deleted_atFieldValue,
      if (ebm_synced != _sentinel)
        _$StockFieldMap['ebm_synced']!:
            _$StockPerFieldToJson.ebm_synced(ebm_synced as bool),
      if (ebm_syncedFieldValue != null)
        _$StockFieldMap['ebm_synced']!: ebm_syncedFieldValue,
      if (cloud_synced != _sentinel)
        _$StockFieldMap['cloud_synced']!:
            _$StockPerFieldToJson.cloud_synced(cloud_synced as bool),
      if (cloud_syncedFieldValue != null)
        _$StockFieldMap['cloud_synced']!: cloud_syncedFieldValue,
      if (variant != _sentinel)
        _$StockFieldMap['variant']!:
            _$StockPerFieldToJson.variant(variant as Variant?),
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initial_stock != _sentinel)
        _$StockFieldMap['initial_stock']!:
            _$StockPerFieldToJson.initial_stock(initial_stock as double?),
      if (initial_stockFieldValue != null)
        _$StockFieldMap['initial_stock']!: initial_stockFieldValue,
    };

    batch.update(reference, json);
  }

  @override
  bool operator ==(Object other) {
    return other is StockDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

abstract class StockQuery implements QueryReference<Stock, StockQuerySnapshot> {
  @override
  StockQuery limit(int limit);

  @override
  StockQuery limitToLast(int limit);

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
  StockQuery whereFieldPath(
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

  StockQuery whereDocumentId({
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

  StockQuery whereId({
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

  StockQuery whereTin({
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

  StockQuery whereBhf_id({
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

  StockQuery whereBranch_id({
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

  StockQuery whereVariant_id({
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

  StockQuery whereCurrent_stock({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereLow_stock({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereCan_tracking_stock({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereShow_low_stock_alert({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereProduct_id({
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

  StockQuery whereActive({
    bool? isEqualTo,
    bool? isNotEqualTo,
    bool? isLessThan,
    bool? isLessThanOrEqualTo,
    bool? isGreaterThan,
    bool? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereValue({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereRsd_qty({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereSupply_price({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereRetail_price({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereLast_touched({
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

  StockQuery whereDeleted_at({
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

  StockQuery whereEbm_synced({
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

  StockQuery whereCloud_synced({
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

  StockQuery whereVariant({
    Variant? isEqualTo,
    Variant? isNotEqualTo,
    Variant? isLessThan,
    Variant? isLessThanOrEqualTo,
    Variant? isGreaterThan,
    Variant? isGreaterThanOrEqualTo,
    List<Variant?>? whereIn,
    List<Variant?>? whereNotIn,
    bool? isNull,
  });

  StockQuery whereInitial_stock({
    double? isEqualTo,
    double? isNotEqualTo,
    double? isLessThan,
    double? isLessThanOrEqualTo,
    double? isGreaterThan,
    double? isGreaterThanOrEqualTo,
    List<double?>? whereIn,
    List<double?>? whereNotIn,
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
  StockQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object startAt,
    Object startAfter,
    Object endAt,
    Object endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByDocumentId({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderById({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByTin({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByBhf_id({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByBranch_id({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByVariant_id({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByCurrent_stock({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByLow_stock({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByCan_tracking_stock({
    bool descending = false,
    bool? startAt,
    bool? startAfter,
    bool? endAt,
    bool? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByShow_low_stock_alert({
    bool descending = false,
    bool? startAt,
    bool? startAfter,
    bool? endAt,
    bool? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByProduct_id({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByActive({
    bool descending = false,
    bool? startAt,
    bool? startAfter,
    bool? endAt,
    bool? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByValue({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByRsd_qty({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderBySupply_price({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByRetail_price({
    bool descending = false,
    double startAt,
    double startAfter,
    double endAt,
    double endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByLast_touched({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByDeleted_at({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByEbm_synced({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByCloud_synced({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByVariant({
    bool descending = false,
    Variant? startAt,
    Variant? startAfter,
    Variant? endAt,
    Variant? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });

  StockQuery orderByInitial_stock({
    bool descending = false,
    double? startAt,
    double? startAfter,
    double? endAt,
    double? endBefore,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  });
}

class _$StockQuery extends QueryReference<Stock, StockQuerySnapshot>
    implements StockQuery {
  _$StockQuery(
    this._collection, {
    required Query<Stock> $referenceWithoutCursor,
    $QueryCursor $queryCursor = const $QueryCursor(),
  }) : super(
          $referenceWithoutCursor: $referenceWithoutCursor,
          $queryCursor: $queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<StockQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(StockQuerySnapshot._fromQuerySnapshot);
  }

  @override
  Future<StockQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(StockQuerySnapshot._fromQuerySnapshot);
  }

  @override
  StockQuery limit(int limit) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limit(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery limitToLast(int limit) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limitToLast(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereFieldPath(
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
    return _$StockQuery(
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
  StockQuery whereDocumentId({
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
    return _$StockQuery(
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
  StockQuery whereId({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.id(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereTin({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['tin']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.tin(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.tin(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.tin(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.tin(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.tin(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.tin(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.tin(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.tin(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereBhf_id({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['bhf_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.bhf_id(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.bhf_id(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.bhf_id(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.bhf_id(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.bhf_id(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.bhf_id(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.bhf_id(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.bhf_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereBranch_id({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['branch_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.branch_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.branch_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.branch_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.branch_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.branch_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.branch_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.branch_id(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.branch_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereVariant_id({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['variant_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.variant_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.variant_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.variant_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.variant_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.variant_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.variant_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.variant_id(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.variant_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereCurrent_stock({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['current_stock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.current_stock(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.current_stock(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.current_stock(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.current_stock(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.current_stock(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .current_stock(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.current_stock(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.current_stock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereLow_stock({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['low_stock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.low_stock(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.low_stock(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.low_stock(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.low_stock(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.low_stock(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.low_stock(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.low_stock(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.low_stock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereCan_tracking_stock({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['can_tracking_stock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.can_tracking_stock(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.can_tracking_stock(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.can_tracking_stock(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .can_tracking_stock(isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.can_tracking_stock(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .can_tracking_stock(isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockPerFieldToJson.can_tracking_stock(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.can_tracking_stock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereShow_low_stock_alert({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['show_low_stock_alert']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.show_low_stock_alert(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.show_low_stock_alert(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.show_low_stock_alert(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .show_low_stock_alert(isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.show_low_stock_alert(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .show_low_stock_alert(isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockPerFieldToJson.show_low_stock_alert(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$StockPerFieldToJson.show_low_stock_alert(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereProduct_id({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['product_id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.product_id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.product_id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.product_id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.product_id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.product_id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.product_id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.product_id(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.product_id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereActive({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<bool?>? whereIn,
    List<bool?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['active']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.active(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.active(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.active(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.active(isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.active(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.active(isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.active(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.active(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereValue({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['value']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.value(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.value(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.value(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.value(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.value(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.value(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.value(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.value(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereRsd_qty({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['rsd_qty']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.rsd_qty(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.rsd_qty(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.rsd_qty(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.rsd_qty(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.rsd_qty(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.rsd_qty(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.rsd_qty(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.rsd_qty(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereSupply_price({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['supply_price']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.supply_price(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.supply_price(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.supply_price(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.supply_price(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.supply_price(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .supply_price(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.supply_price(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.supply_price(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereRetail_price({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double>? whereIn,
    List<double>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['retail_price']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.retail_price(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.retail_price(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.retail_price(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.retail_price(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.retail_price(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .retail_price(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.retail_price(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.retail_price(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereLast_touched({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['last_touched']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.last_touched(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.last_touched(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.last_touched(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .last_touched(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.last_touched(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .last_touched(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.last_touched(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.last_touched(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereDeleted_at({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['deleted_at']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.deleted_at(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.deleted_at(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.deleted_at(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.deleted_at(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.deleted_at(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .deleted_at(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.deleted_at(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.deleted_at(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereEbm_synced({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['ebm_synced']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.ebm_synced(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.ebm_synced(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.ebm_synced(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.ebm_synced(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.ebm_synced(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.ebm_synced(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.ebm_synced(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.ebm_synced(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereCloud_synced({
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
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['cloud_synced']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.cloud_synced(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.cloud_synced(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.cloud_synced(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.cloud_synced(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.cloud_synced(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.cloud_synced(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.cloud_synced(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.cloud_synced(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereVariant({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<Variant?>? whereIn,
    List<Variant?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['variant']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.variant(isEqualTo as Variant?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.variant(isNotEqualTo as Variant?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.variant(isLessThan as Variant?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.variant(isLessThanOrEqualTo as Variant?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.variant(isGreaterThan as Variant?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.variant(isGreaterThanOrEqualTo as Variant?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.variant(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.variant(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereInitial_stock({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    List<double?>? whereIn,
    List<double?>? whereNotIn,
    bool? isNull,
  }) {
    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$StockFieldMap['initial_stock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.initial_stock(isEqualTo as double?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.initial_stock(isNotEqualTo as double?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.initial_stock(isLessThan as double?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .initial_stock(isLessThanOrEqualTo as double?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.initial_stock(isGreaterThan as double?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .initial_stock(isGreaterThanOrEqualTo as double?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.initial_stock(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.initial_stock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByDocumentId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderById({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['id']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByTin({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['tin']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByBhf_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['bhf_id']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByBranch_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['branch_id']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByVariant_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['variant_id']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByCurrent_stock({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['current_stock']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByLow_stock({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['low_stock']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByCan_tracking_stock({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockFieldMap['can_tracking_stock']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByShow_low_stock_alert({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$StockFieldMap['show_low_stock_alert']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByProduct_id({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['product_id']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByActive({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['active']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByValue({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['value']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByRsd_qty({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['rsd_qty']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderBySupply_price({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['supply_price']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByRetail_price({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['retail_price']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByLast_touched({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['last_touched']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByDeleted_at({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['deleted_at']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByEbm_synced({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['ebm_synced']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByCloud_synced({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['cloud_synced']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByVariant({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['variant']!,
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  StockQuery orderByInitial_stock({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    StockDocumentSnapshot? startAtDocument,
    StockDocumentSnapshot? endAtDocument,
    StockDocumentSnapshot? endBeforeDocument,
    StockDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$StockFieldMap['initial_stock']!, descending: descending);
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

    return _$StockQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$StockQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class StockDocumentSnapshot extends FirestoreDocumentSnapshot<Stock> {
  StockDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final DocumentSnapshot<Stock> snapshot;

  @override
  StockDocumentReference get reference {
    return StockDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Stock? data;
}

class StockQuerySnapshot
    extends FirestoreQuerySnapshot<Stock, StockQueryDocumentSnapshot> {
  StockQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  factory StockQuerySnapshot._fromQuerySnapshot(
    QuerySnapshot<Stock> snapshot,
  ) {
    final docs = snapshot.docs.map(StockQueryDocumentSnapshot._).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return _decodeDocumentChange(
        change,
        StockDocumentSnapshot._,
      );
    }).toList();

    return StockQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  static FirestoreDocumentChange<StockDocumentSnapshot>
      _decodeDocumentChange<T>(
    DocumentChange<T> docChange,
    StockDocumentSnapshot Function(DocumentSnapshot<T> doc) decodeDoc,
  ) {
    return FirestoreDocumentChange<StockDocumentSnapshot>(
      type: docChange.type,
      oldIndex: docChange.oldIndex,
      newIndex: docChange.newIndex,
      doc: decodeDoc(docChange.doc),
    );
  }

  final QuerySnapshot<Stock> snapshot;

  @override
  final List<StockQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<StockDocumentSnapshot>> docChanges;
}

class StockQueryDocumentSnapshot extends FirestoreQueryDocumentSnapshot<Stock>
    implements StockDocumentSnapshot {
  StockQueryDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final QueryDocumentSnapshot<Stock> snapshot;

  @override
  final Stock data;

  @override
  StockDocumentReference get reference {
    return StockDocumentReference(snapshot.reference);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockRequest _$StockRequestFromJson(Map<String, dynamic> json) => StockRequest(
      id: const NullableIntConverter().fromJson(json['id']),
      main_branch_id:
          const NullableIntConverter().fromJson(json['main_branch_id']),
      sub_branch_id:
          const NullableIntConverter().fromJson(json['sub_branch_id']),
      created_at: const TimestampConverter().fromJson(json['created_at']),
      status: json['status'] as String?,
      delivery_date: const TimestampConverter().fromJson(json['delivery_date']),
      delivery_note: json['delivery_note'] as String?,
      order_note: json['order_note'] as String?,
      customer_received_order:
          json['customer_received_order'] as bool? ?? false,
      driver_request_delivery_confirmation:
          json['driver_request_delivery_confirmation'] as bool? ?? false,
      driver_id: const NullableIntConverter().fromJson(json['driver_id']),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => TransactionItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      updated_at: const TimestampConverter().fromJson(json['updated_at']),
    );

const _$StockRequestFieldMap = <String, String>{
  'id': 'id',
  'main_branch_id': 'main_branch_id',
  'sub_branch_id': 'sub_branch_id',
  'created_at': 'created_at',
  'status': 'status',
  'delivery_date': 'delivery_date',
  'delivery_note': 'delivery_note',
  'order_note': 'order_note',
  'customer_received_order': 'customer_received_order',
  'driver_request_delivery_confirmation':
      'driver_request_delivery_confirmation',
  'driver_id': 'driver_id',
  'items': 'items',
  'updated_at': 'updated_at',
};

// ignore: unused_element
abstract class _$StockRequestPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? main_branch_id(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? sub_branch_id(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? created_at(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
  // ignore: unused_element
  static Object? status(String? instance) => instance;
  // ignore: unused_element
  static Object? delivery_date(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
  // ignore: unused_element
  static Object? delivery_note(String? instance) => instance;
  // ignore: unused_element
  static Object? order_note(String? instance) => instance;
  // ignore: unused_element
  static Object? customer_received_order(bool? instance) => instance;
  // ignore: unused_element
  static Object? driver_request_delivery_confirmation(bool? instance) =>
      instance;
  // ignore: unused_element
  static Object? driver_id(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? items(List<TransactionItem>? instance) =>
      instance?.map((e) => e.toJson()).toList();
  // ignore: unused_element
  static Object? updated_at(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
}

Map<String, dynamic> _$StockRequestToJson(StockRequest instance) =>
    <String, dynamic>{
      'id': const NullableIntConverter().toJson(instance.id),
      'main_branch_id':
          const NullableIntConverter().toJson(instance.main_branch_id),
      'sub_branch_id':
          const NullableIntConverter().toJson(instance.sub_branch_id),
      'created_at': const TimestampConverter().toJson(instance.created_at),
      'status': instance.status,
      'delivery_date':
          const TimestampConverter().toJson(instance.delivery_date),
      'delivery_note': instance.delivery_note,
      'order_note': instance.order_note,
      'customer_received_order': instance.customer_received_order,
      'driver_request_delivery_confirmation':
          instance.driver_request_delivery_confirmation,
      'driver_id': const NullableIntConverter().toJson(instance.driver_id),
      'items': instance.items?.map((e) => e.toJson()).toList(),
      'updated_at': const TimestampConverter().toJson(instance.updated_at),
    };

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      isTaxExempted: json['isTaxExempted'] as bool?,
      isRefunded: json['isRefunded'] as bool?,
      doneWithTransaction: json['doneWithTransaction'] as bool?,
      dcRt: const NullableDoubleConverter().fromJson(json['dcRt']),
      dcAmt: const NullableDoubleConverter().fromJson(json['dcAmt']),
      taxblAmt: const NullableDoubleConverter().fromJson(json['taxblAmt']),
      taxAmt: const NullableDoubleConverter().fromJson(json['taxAmt']),
      totAmt: const NullableDoubleConverter().fromJson(json['totAmt']),
      itemSeq: const NullableIntConverter().fromJson(json['itemSeq']),
      id: const NullableIntConverter().fromJson(json['id']),
      name: json['name'] as String?,
      quantityRequested:
          const NullableIntConverter().fromJson(json['quantityRequested']),
      quantityApproved:
          const NullableIntConverter().fromJson(json['quantityApproved']),
      quantityShipped:
          const NullableIntConverter().fromJson(json['quantityShipped']),
      transactionId:
          const NullableIntConverter().fromJson(json['transactionId']),
      variantId: const NullableIntConverter().fromJson(json['variantId']),
      qty: const NullableDoubleConverter().fromJson(json['qty']),
      price: const NullableDoubleConverter().fromJson(json['price']),
      discount: const NullableDoubleConverter().fromJson(json['discount']),
      type: json['type'] as String?,
      remainingStock:
          const NullableDoubleConverter().fromJson(json['remainingStock']),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      active: json['active'] as bool?,
      isrccCd: json['isrccCd'] as String?,
      isrccNm: json['isrccNm'] as String?,
      isrcRt: const NullableIntConverter().fromJson(json['isrcRt']),
      isrcAmt: const NullableIntConverter().fromJson(json['isrcAmt']),
      taxTyCd: json['taxTyCd'] as String?,
      bcd: json['bcd'] as String?,
      itemClsCd: json['itemClsCd'] as String?,
      itemTyCd: json['itemTyCd'] as String?,
      itemStdNm: json['itemStdNm'] as String?,
      orgnNatCd: json['orgnNatCd'] as String?,
      pkg: json['pkg'] as String?,
      itemCd: json['itemCd'] as String?,
      pkgUnitCd: json['pkgUnitCd'] as String?,
      qtyUnitCd: json['qtyUnitCd'] as String?,
      itemNm: json['itemNm'] as String?,
      prc: const NullableDoubleConverter().fromJson(json['prc']),
      splyAmt: const NullableDoubleConverter().fromJson(json['splyAmt']),
      tin: const NullableIntConverter().fromJson(json['tin']),
      bhfId: json['bhfId'] as String?,
      dftPrc: const NullableDoubleConverter().fromJson(json['dftPrc']),
      addInfo: json['addInfo'] as String?,
      isrcAplcbYn: json['isrcAplcbYn'] as String?,
      useYn: json['useYn'] as String?,
      regrId: json['regrId'] as String?,
      regrNm: json['regrNm'] as String?,
      modrId: json['modrId'] as String?,
      modrNm: json['modrNm'] as String?,
      lastTouched: const TimestampConverter().fromJson(json['lastTouched']),
      deletedAt: const TimestampConverter().fromJson(json['deletedAt']),
      action: json['action'] as String?,
      branchId: const NullableIntConverter().fromJson(json['branchId']),
      ebmSynced: json['ebmSynced'] as bool?,
      partOfComposite: json['partOfComposite'] as bool?,
      compositePrice:
          const NullableDoubleConverter().fromJson(json['compositePrice']),
    );

const _$TransactionItemFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'quantityRequested': 'quantityRequested',
  'quantityApproved': 'quantityApproved',
  'quantityShipped': 'quantityShipped',
  'transactionId': 'transactionId',
  'variantId': 'variantId',
  'qty': 'qty',
  'price': 'price',
  'discount': 'discount',
  'type': 'type',
  'remainingStock': 'remainingStock',
  'createdAt': 'createdAt',
  'updatedAt': 'updatedAt',
  'isTaxExempted': 'isTaxExempted',
  'isRefunded': 'isRefunded',
  'doneWithTransaction': 'doneWithTransaction',
  'active': 'active',
  'dcRt': 'dcRt',
  'dcAmt': 'dcAmt',
  'taxblAmt': 'taxblAmt',
  'taxAmt': 'taxAmt',
  'totAmt': 'totAmt',
  'itemSeq': 'itemSeq',
  'isrccCd': 'isrccCd',
  'isrccNm': 'isrccNm',
  'isrcRt': 'isrcRt',
  'isrcAmt': 'isrcAmt',
  'taxTyCd': 'taxTyCd',
  'bcd': 'bcd',
  'itemClsCd': 'itemClsCd',
  'itemTyCd': 'itemTyCd',
  'itemStdNm': 'itemStdNm',
  'orgnNatCd': 'orgnNatCd',
  'pkg': 'pkg',
  'itemCd': 'itemCd',
  'pkgUnitCd': 'pkgUnitCd',
  'qtyUnitCd': 'qtyUnitCd',
  'itemNm': 'itemNm',
  'prc': 'prc',
  'splyAmt': 'splyAmt',
  'tin': 'tin',
  'bhfId': 'bhfId',
  'dftPrc': 'dftPrc',
  'addInfo': 'addInfo',
  'isrcAplcbYn': 'isrcAplcbYn',
  'useYn': 'useYn',
  'regrId': 'regrId',
  'regrNm': 'regrNm',
  'modrId': 'modrId',
  'modrNm': 'modrNm',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'action': 'action',
  'branchId': 'branchId',
  'ebmSynced': 'ebmSynced',
  'partOfComposite': 'partOfComposite',
  'compositePrice': 'compositePrice',
};

// ignore: unused_element
abstract class _$TransactionItemPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? quantityRequested(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? quantityApproved(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? quantityShipped(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? transactionId(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? variantId(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? qty(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? price(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? discount(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? type(String? instance) => instance;
  // ignore: unused_element
  static Object? remainingStock(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? updatedAt(String? instance) => instance;
  // ignore: unused_element
  static Object? isTaxExempted(bool? instance) => instance;
  // ignore: unused_element
  static Object? isRefunded(bool? instance) => instance;
  // ignore: unused_element
  static Object? doneWithTransaction(bool? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? dcRt(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? dcAmt(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? taxblAmt(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? taxAmt(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? totAmt(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? itemSeq(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? isrccCd(String? instance) => instance;
  // ignore: unused_element
  static Object? isrccNm(String? instance) => instance;
  // ignore: unused_element
  static Object? isrcRt(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? isrcAmt(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? taxTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? bcd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemClsCd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemTyCd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemStdNm(String? instance) => instance;
  // ignore: unused_element
  static Object? orgnNatCd(String? instance) => instance;
  // ignore: unused_element
  static Object? pkg(String? instance) => instance;
  // ignore: unused_element
  static Object? itemCd(String? instance) => instance;
  // ignore: unused_element
  static Object? pkgUnitCd(String? instance) => instance;
  // ignore: unused_element
  static Object? qtyUnitCd(String? instance) => instance;
  // ignore: unused_element
  static Object? itemNm(String? instance) => instance;
  // ignore: unused_element
  static Object? prc(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? splyAmt(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? tin(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? dftPrc(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
  // ignore: unused_element
  static Object? addInfo(String? instance) => instance;
  // ignore: unused_element
  static Object? isrcAplcbYn(String? instance) => instance;
  // ignore: unused_element
  static Object? useYn(String? instance) => instance;
  // ignore: unused_element
  static Object? regrId(String? instance) => instance;
  // ignore: unused_element
  static Object? regrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? modrId(String? instance) => instance;
  // ignore: unused_element
  static Object? modrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
  // ignore: unused_element
  static Object? action(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) =>
      const NullableIntConverter().toJson(instance);
  // ignore: unused_element
  static Object? ebmSynced(bool? instance) => instance;
  // ignore: unused_element
  static Object? partOfComposite(bool? instance) => instance;
  // ignore: unused_element
  static Object? compositePrice(double? instance) =>
      const NullableDoubleConverter().toJson(instance);
}

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'id': const NullableIntConverter().toJson(instance.id),
      'name': instance.name,
      'quantityRequested':
          const NullableIntConverter().toJson(instance.quantityRequested),
      'quantityApproved':
          const NullableIntConverter().toJson(instance.quantityApproved),
      'quantityShipped':
          const NullableIntConverter().toJson(instance.quantityShipped),
      'transactionId':
          const NullableIntConverter().toJson(instance.transactionId),
      'variantId': const NullableIntConverter().toJson(instance.variantId),
      'qty': const NullableDoubleConverter().toJson(instance.qty),
      'price': const NullableDoubleConverter().toJson(instance.price),
      'discount': const NullableDoubleConverter().toJson(instance.discount),
      'type': instance.type,
      'remainingStock':
          const NullableDoubleConverter().toJson(instance.remainingStock),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isTaxExempted': instance.isTaxExempted,
      'isRefunded': instance.isRefunded,
      'doneWithTransaction': instance.doneWithTransaction,
      'active': instance.active,
      'dcRt': const NullableDoubleConverter().toJson(instance.dcRt),
      'dcAmt': const NullableDoubleConverter().toJson(instance.dcAmt),
      'taxblAmt': const NullableDoubleConverter().toJson(instance.taxblAmt),
      'taxAmt': const NullableDoubleConverter().toJson(instance.taxAmt),
      'totAmt': const NullableDoubleConverter().toJson(instance.totAmt),
      'itemSeq': const NullableIntConverter().toJson(instance.itemSeq),
      'isrccCd': instance.isrccCd,
      'isrccNm': instance.isrccNm,
      'isrcRt': const NullableIntConverter().toJson(instance.isrcRt),
      'isrcAmt': const NullableIntConverter().toJson(instance.isrcAmt),
      'taxTyCd': instance.taxTyCd,
      'bcd': instance.bcd,
      'itemClsCd': instance.itemClsCd,
      'itemTyCd': instance.itemTyCd,
      'itemStdNm': instance.itemStdNm,
      'orgnNatCd': instance.orgnNatCd,
      'pkg': instance.pkg,
      'itemCd': instance.itemCd,
      'pkgUnitCd': instance.pkgUnitCd,
      'qtyUnitCd': instance.qtyUnitCd,
      'itemNm': instance.itemNm,
      'prc': const NullableDoubleConverter().toJson(instance.prc),
      'splyAmt': const NullableDoubleConverter().toJson(instance.splyAmt),
      'tin': const NullableIntConverter().toJson(instance.tin),
      'bhfId': instance.bhfId,
      'dftPrc': const NullableDoubleConverter().toJson(instance.dftPrc),
      'addInfo': instance.addInfo,
      'isrcAplcbYn': instance.isrcAplcbYn,
      'useYn': instance.useYn,
      'regrId': instance.regrId,
      'regrNm': instance.regrNm,
      'modrId': instance.modrId,
      'modrNm': instance.modrNm,
      'lastTouched': const TimestampConverter().toJson(instance.lastTouched),
      'deletedAt': const TimestampConverter().toJson(instance.deletedAt),
      'action': instance.action,
      'branchId': const NullableIntConverter().toJson(instance.branchId),
      'ebmSynced': instance.ebmSynced,
      'partOfComposite': instance.partOfComposite,
      'compositePrice':
          const NullableDoubleConverter().toJson(instance.compositePrice),
    };

Variant _$VariantFromJson(Map<String, dynamic> json) => Variant(
      id: json['id'] as String?,
      variant_id: (json['variant_id'] as num?)?.toInt(),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      name: json['name'] as String?,
      color: json['color'] as String?,
      sku: json['sku'] as String?,
      product_id: (json['product_id'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      product_name: json['product_name'] as String?,
      branch_id: (json['branch_id'] as num?)?.toInt(),
      tax_name: json['tax_name'] as String,
      tax_percentage: (json['tax_percentage'] as num).toDouble(),
      is_tax_exempted: json['is_tax_exempted'] as bool,
      item_seq: (json['item_seq'] as num?)?.toInt(),
      isrcc_cd: json['isrcc_cd'] as String,
      isrcc_nm: json['isrcc_nm'] as String,
      isrc_rt: (json['isrc_rt'] as num).toInt(),
      isrc_amt: (json['isrc_amt'] as num).toInt(),
      tax_ty_cd: json['tax_ty_cd'] as String,
      bcd: json['bcd'] as String,
      item_cls_cd: json['item_cls_cd'] as String?,
      item_ty_cd: json['item_ty_cd'] as String?,
      item_std_nm: json['item_std_nm'] as String,
      orgn_nat_cd: json['orgn_nat_cd'] as String,
      pkg: json['pkg'] as String,
      item_cd: json['item_cd'] as String,
      pkg_unit_cd: json['pkg_unit_cd'] as String,
      qty_unit_cd: json['qty_unit_cd'] as String,
      item_nm: json['item_nm'] as String?,
      qty: (json['qty'] as num).toDouble(),
      prc: (json['prc'] as num).toDouble(),
      sply_amt: (json['sply_amt'] as num).toDouble(),
      tin: (json['tin'] as num?)?.toInt(),
      bhf_id: json['bhf_id'] as String?,
      dft_prc: (json['dft_prc'] as num).toDouble(),
      add_info: json['add_info'] as String,
      isrc_aplcb_yn: json['isrc_aplcb_yn'] as String,
      use_yn: json['use_yn'] as String,
      regr_id: json['regr_id'] as String?,
      regr_nm: json['regr_nm'] as String?,
      modr_id: json['modr_id'] as String?,
      modr_nm: json['modr_nm'] as String?,
      rsd_qty: (json['rsd_qty'] as num).toDouble(),
      last_touched: const TimestampConverter().fromJson(json['last_touched']),
      supply_price: (json['supply_price'] as num).toDouble(),
      retail_price: (json['retail_price'] as num).toDouble(),
      spplr_item_cls_cd: json['spplr_item_cls_cd'] as String?,
      spplr_item_cd: json['spplr_item_cd'] as String?,
      spplr_item_nm: json['spplr_item_nm'] as String?,
      ebm_synced: json['ebm_synced'] as bool,
      tax_type: json['tax_type'] as String,
      branch_ids: (json['branch_ids'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      stock: Stock.fromJson(json['stock'] as Map<String, dynamic>),
      updated_at: const TimestampConverter().fromJson(json['updated_at']),
    );

const _$VariantFieldMap = <String, String>{
  'id': 'id',
  'variant_id': 'variant_id',
  'deleted_at': 'deleted_at',
  'name': 'name',
  'color': 'color',
  'sku': 'sku',
  'product_id': 'product_id',
  'unit': 'unit',
  'product_name': 'product_name',
  'branch_id': 'branch_id',
  'tax_name': 'tax_name',
  'tax_percentage': 'tax_percentage',
  'is_tax_exempted': 'is_tax_exempted',
  'item_seq': 'item_seq',
  'isrcc_cd': 'isrcc_cd',
  'isrcc_nm': 'isrcc_nm',
  'isrc_rt': 'isrc_rt',
  'isrc_amt': 'isrc_amt',
  'tax_ty_cd': 'tax_ty_cd',
  'bcd': 'bcd',
  'item_cls_cd': 'item_cls_cd',
  'item_ty_cd': 'item_ty_cd',
  'item_std_nm': 'item_std_nm',
  'orgn_nat_cd': 'orgn_nat_cd',
  'pkg': 'pkg',
  'item_cd': 'item_cd',
  'pkg_unit_cd': 'pkg_unit_cd',
  'qty_unit_cd': 'qty_unit_cd',
  'item_nm': 'item_nm',
  'qty': 'qty',
  'prc': 'prc',
  'sply_amt': 'sply_amt',
  'tin': 'tin',
  'bhf_id': 'bhf_id',
  'dft_prc': 'dft_prc',
  'add_info': 'add_info',
  'isrc_aplcb_yn': 'isrc_aplcb_yn',
  'use_yn': 'use_yn',
  'regr_id': 'regr_id',
  'regr_nm': 'regr_nm',
  'modr_id': 'modr_id',
  'modr_nm': 'modr_nm',
  'rsd_qty': 'rsd_qty',
  'last_touched': 'last_touched',
  'supply_price': 'supply_price',
  'retail_price': 'retail_price',
  'spplr_item_cls_cd': 'spplr_item_cls_cd',
  'spplr_item_cd': 'spplr_item_cd',
  'spplr_item_nm': 'spplr_item_nm',
  'ebm_synced': 'ebm_synced',
  'tax_type': 'tax_type',
  'branch_ids': 'branch_ids',
  'stock': 'stock',
  'updated_at': 'updated_at',
};

// ignore: unused_element
abstract class _$VariantPerFieldToJson {
  // ignore: unused_element
  static Object? id(String? instance) => instance;
  // ignore: unused_element
  static Object? variant_id(int? instance) => instance;
  // ignore: unused_element
  static Object? deleted_at(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? color(String? instance) => instance;
  // ignore: unused_element
  static Object? sku(String? instance) => instance;
  // ignore: unused_element
  static Object? product_id(int? instance) => instance;
  // ignore: unused_element
  static Object? unit(String? instance) => instance;
  // ignore: unused_element
  static Object? product_name(String? instance) => instance;
  // ignore: unused_element
  static Object? branch_id(int? instance) => instance;
  // ignore: unused_element
  static Object? tax_name(String instance) => instance;
  // ignore: unused_element
  static Object? tax_percentage(double instance) => instance;
  // ignore: unused_element
  static Object? is_tax_exempted(bool instance) => instance;
  // ignore: unused_element
  static Object? item_seq(int? instance) => instance;
  // ignore: unused_element
  static Object? isrcc_cd(String instance) => instance;
  // ignore: unused_element
  static Object? isrcc_nm(String instance) => instance;
  // ignore: unused_element
  static Object? isrc_rt(int instance) => instance;
  // ignore: unused_element
  static Object? isrc_amt(int instance) => instance;
  // ignore: unused_element
  static Object? tax_ty_cd(String instance) => instance;
  // ignore: unused_element
  static Object? bcd(String instance) => instance;
  // ignore: unused_element
  static Object? item_cls_cd(String? instance) => instance;
  // ignore: unused_element
  static Object? item_ty_cd(String? instance) => instance;
  // ignore: unused_element
  static Object? item_std_nm(String instance) => instance;
  // ignore: unused_element
  static Object? orgn_nat_cd(String instance) => instance;
  // ignore: unused_element
  static Object? pkg(String instance) => instance;
  // ignore: unused_element
  static Object? item_cd(String instance) => instance;
  // ignore: unused_element
  static Object? pkg_unit_cd(String instance) => instance;
  // ignore: unused_element
  static Object? qty_unit_cd(String instance) => instance;
  // ignore: unused_element
  static Object? item_nm(String? instance) => instance;
  // ignore: unused_element
  static Object? qty(double instance) => instance;
  // ignore: unused_element
  static Object? prc(double instance) => instance;
  // ignore: unused_element
  static Object? sply_amt(double instance) => instance;
  // ignore: unused_element
  static Object? tin(int? instance) => instance;
  // ignore: unused_element
  static Object? bhf_id(String? instance) => instance;
  // ignore: unused_element
  static Object? dft_prc(double instance) => instance;
  // ignore: unused_element
  static Object? add_info(String instance) => instance;
  // ignore: unused_element
  static Object? isrc_aplcb_yn(String instance) => instance;
  // ignore: unused_element
  static Object? use_yn(String instance) => instance;
  // ignore: unused_element
  static Object? regr_id(String? instance) => instance;
  // ignore: unused_element
  static Object? regr_nm(String? instance) => instance;
  // ignore: unused_element
  static Object? modr_id(String? instance) => instance;
  // ignore: unused_element
  static Object? modr_nm(String? instance) => instance;
  // ignore: unused_element
  static Object? rsd_qty(double instance) => instance;
  // ignore: unused_element
  static Object? last_touched(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
  // ignore: unused_element
  static Object? supply_price(double instance) => instance;
  // ignore: unused_element
  static Object? retail_price(double instance) => instance;
  // ignore: unused_element
  static Object? spplr_item_cls_cd(String? instance) => instance;
  // ignore: unused_element
  static Object? spplr_item_cd(String? instance) => instance;
  // ignore: unused_element
  static Object? spplr_item_nm(String? instance) => instance;
  // ignore: unused_element
  static Object? ebm_synced(bool instance) => instance;
  // ignore: unused_element
  static Object? tax_type(String instance) => instance;
  // ignore: unused_element
  static Object? branch_ids(List<int> instance) => instance;
  // ignore: unused_element
  static Object? stock(Stock instance) => instance.toJson();
  // ignore: unused_element
  static Object? updated_at(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
}

Map<String, dynamic> _$VariantToJson(Variant instance) => <String, dynamic>{
      'id': instance.id,
      'variant_id': instance.variant_id,
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'name': instance.name,
      'color': instance.color,
      'sku': instance.sku,
      'product_id': instance.product_id,
      'unit': instance.unit,
      'product_name': instance.product_name,
      'branch_id': instance.branch_id,
      'tax_name': instance.tax_name,
      'tax_percentage': instance.tax_percentage,
      'is_tax_exempted': instance.is_tax_exempted,
      'item_seq': instance.item_seq,
      'isrcc_cd': instance.isrcc_cd,
      'isrcc_nm': instance.isrcc_nm,
      'isrc_rt': instance.isrc_rt,
      'isrc_amt': instance.isrc_amt,
      'tax_ty_cd': instance.tax_ty_cd,
      'bcd': instance.bcd,
      'item_cls_cd': instance.item_cls_cd,
      'item_ty_cd': instance.item_ty_cd,
      'item_std_nm': instance.item_std_nm,
      'orgn_nat_cd': instance.orgn_nat_cd,
      'pkg': instance.pkg,
      'item_cd': instance.item_cd,
      'pkg_unit_cd': instance.pkg_unit_cd,
      'qty_unit_cd': instance.qty_unit_cd,
      'item_nm': instance.item_nm,
      'qty': instance.qty,
      'prc': instance.prc,
      'sply_amt': instance.sply_amt,
      'tin': instance.tin,
      'bhf_id': instance.bhf_id,
      'dft_prc': instance.dft_prc,
      'add_info': instance.add_info,
      'isrc_aplcb_yn': instance.isrc_aplcb_yn,
      'use_yn': instance.use_yn,
      'regr_id': instance.regr_id,
      'regr_nm': instance.regr_nm,
      'modr_id': instance.modr_id,
      'modr_nm': instance.modr_nm,
      'rsd_qty': instance.rsd_qty,
      'last_touched': const TimestampConverter().toJson(instance.last_touched),
      'supply_price': instance.supply_price,
      'retail_price': instance.retail_price,
      'spplr_item_cls_cd': instance.spplr_item_cls_cd,
      'spplr_item_cd': instance.spplr_item_cd,
      'spplr_item_nm': instance.spplr_item_nm,
      'ebm_synced': instance.ebm_synced,
      'tax_type': instance.tax_type,
      'branch_ids': instance.branch_ids,
      'stock': instance.stock.toJson(),
      'updated_at': const TimestampConverter().toJson(instance.updated_at),
    };

Stock _$StockFromJson(Map<String, dynamic> json) => Stock(
      id: (json['id'] as num?)?.toInt(),
      tin: (json['tin'] as num?)?.toInt(),
      bhf_id: json['bhf_id'] as String?,
      branch_id: (json['branch_id'] as num?)?.toInt(),
      variant_id: (json['variant_id'] as num?)?.toInt(),
      current_stock: (json['current_stock'] as num).toDouble(),
      low_stock: (json['low_stock'] as num?)?.toDouble() ?? 0,
      can_tracking_stock: json['can_tracking_stock'] as bool?,
      show_low_stock_alert: json['show_low_stock_alert'] as bool?,
      product_id: (json['product_id'] as num?)?.toInt(),
      active: json['active'] as bool?,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rsd_qty: (json['rsd_qty'] as num?)?.toDouble() ?? 0.0,
      supply_price: (json['supply_price'] as num?)?.toDouble() ?? 0.0,
      retail_price: (json['retail_price'] as num?)?.toDouble() ?? 0.0,
      last_touched: json['last_touched'] == null
          ? null
          : DateTime.parse(json['last_touched'] as String),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      ebm_synced: json['ebm_synced'] as bool? ?? false,
      cloud_synced: json['cloud_synced'] as bool? ?? true,
      variant: json['variant'] == null
          ? null
          : Variant.fromJson(json['variant'] as Map<String, dynamic>),
      initial_stock: (json['initial_stock'] as num?)?.toDouble(),
    );

const _$StockFieldMap = <String, String>{
  'id': 'id',
  'tin': 'tin',
  'bhf_id': 'bhf_id',
  'branch_id': 'branch_id',
  'variant_id': 'variant_id',
  'current_stock': 'current_stock',
  'low_stock': 'low_stock',
  'can_tracking_stock': 'can_tracking_stock',
  'show_low_stock_alert': 'show_low_stock_alert',
  'product_id': 'product_id',
  'active': 'active',
  'value': 'value',
  'rsd_qty': 'rsd_qty',
  'supply_price': 'supply_price',
  'retail_price': 'retail_price',
  'last_touched': 'last_touched',
  'deleted_at': 'deleted_at',
  'ebm_synced': 'ebm_synced',
  'cloud_synced': 'cloud_synced',
  'variant': 'variant',
  'initial_stock': 'initial_stock',
};

// ignore: unused_element
abstract class _$StockPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? tin(int? instance) => instance;
  // ignore: unused_element
  static Object? bhf_id(String? instance) => instance;
  // ignore: unused_element
  static Object? branch_id(int? instance) => instance;
  // ignore: unused_element
  static Object? variant_id(int? instance) => instance;
  // ignore: unused_element
  static Object? current_stock(double instance) => instance;
  // ignore: unused_element
  static Object? low_stock(double instance) => instance;
  // ignore: unused_element
  static Object? can_tracking_stock(bool? instance) => instance;
  // ignore: unused_element
  static Object? show_low_stock_alert(bool? instance) => instance;
  // ignore: unused_element
  static Object? product_id(int? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? value(double instance) => instance;
  // ignore: unused_element
  static Object? rsd_qty(double instance) => instance;
  // ignore: unused_element
  static Object? supply_price(double instance) => instance;
  // ignore: unused_element
  static Object? retail_price(double instance) => instance;
  // ignore: unused_element
  static Object? last_touched(DateTime? instance) =>
      instance?.toIso8601String();
  // ignore: unused_element
  static Object? deleted_at(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? ebm_synced(bool instance) => instance;
  // ignore: unused_element
  static Object? cloud_synced(bool instance) => instance;
  // ignore: unused_element
  static Object? variant(Variant? instance) => instance?.toJson();
  // ignore: unused_element
  static Object? initial_stock(double? instance) => instance;
}

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'id': instance.id,
      'tin': instance.tin,
      'bhf_id': instance.bhf_id,
      'branch_id': instance.branch_id,
      'variant_id': instance.variant_id,
      'current_stock': instance.current_stock,
      'low_stock': instance.low_stock,
      'can_tracking_stock': instance.can_tracking_stock,
      'show_low_stock_alert': instance.show_low_stock_alert,
      'product_id': instance.product_id,
      'active': instance.active,
      'value': instance.value,
      'rsd_qty': instance.rsd_qty,
      'supply_price': instance.supply_price,
      'retail_price': instance.retail_price,
      'last_touched': instance.last_touched?.toIso8601String(),
      'deleted_at': instance.deleted_at?.toIso8601String(),
      'ebm_synced': instance.ebm_synced,
      'cloud_synced': instance.cloud_synced,
      'variant': instance.variant?.toJson(),
      'initial_stock': instance.initial_stock,
    };
