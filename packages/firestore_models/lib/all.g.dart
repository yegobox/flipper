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
