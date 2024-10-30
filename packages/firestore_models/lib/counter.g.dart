// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter.dart';

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
abstract class CounterCollectionReference
    implements
        CounterQuery,
        FirestoreCollectionReference<Counter, CounterQuerySnapshot> {
  factory CounterCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$CounterCollectionReference;

  static Counter fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return Counter.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    Counter value,
    SetOptions? options,
  ) {
    return value.toJson();
  }

  @override
  CollectionReference<Counter> get reference;

  @override
  CounterDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<CounterDocumentReference> add(Counter value);
}

class _$CounterCollectionReference extends _$CounterQuery
    implements CounterCollectionReference {
  factory _$CounterCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$CounterCollectionReference._(
      firestore.collection('counters').withConverter(
            fromFirestore: CounterCollectionReference.fromFirestore,
            toFirestore: CounterCollectionReference.toFirestore,
          ),
    );
  }

  _$CounterCollectionReference._(
    CollectionReference<Counter> reference,
  ) : super(reference, $referenceWithoutCursor: reference);

  String get path => reference.path;

  @override
  CollectionReference<Counter> get reference =>
      super.reference as CollectionReference<Counter>;

  @override
  CounterDocumentReference doc([String? id]) {
    assert(
      id == null || id.split('/').length == 1,
      'The document ID cannot be from a different collection',
    );
    return CounterDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<CounterDocumentReference> add(Counter value) {
    return reference.add(value).then((ref) => CounterDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$CounterCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class CounterDocumentReference
    extends FirestoreDocumentReference<Counter, CounterDocumentSnapshot> {
  factory CounterDocumentReference(DocumentReference<Counter> reference) =
      _$CounterDocumentReference;

  DocumentReference<Counter> get reference;

  /// A reference to the [CounterCollectionReference] containing this document.
  CounterCollectionReference get parent {
    return _$CounterCollectionReference(reference.firestore);
  }

  @override
  Stream<CounterDocumentSnapshot> snapshots();

  @override
  Future<CounterDocumentSnapshot> get([GetOptions? options]);

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
    Counter model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue receiptTypeFieldValue,
    FieldValue totRcptNoFieldValue,
    FieldValue curRcptNoFieldValue,
    FieldValue invcNoFieldValue,
    FieldValue lastTouchedFieldValue,
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
    Counter model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue receiptTypeFieldValue,
    FieldValue totRcptNoFieldValue,
    FieldValue curRcptNoFieldValue,
    FieldValue invcNoFieldValue,
    FieldValue lastTouchedFieldValue,
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
    Counter model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue receiptTypeFieldValue,
    FieldValue totRcptNoFieldValue,
    FieldValue curRcptNoFieldValue,
    FieldValue invcNoFieldValue,
    FieldValue lastTouchedFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int? id,
    FieldValue idFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? receiptType,
    FieldValue receiptTypeFieldValue,
    int? totRcptNo,
    FieldValue totRcptNoFieldValue,
    int? curRcptNo,
    FieldValue curRcptNoFieldValue,
    int? invcNo,
    FieldValue invcNoFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int? id,
    FieldValue idFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? receiptType,
    FieldValue receiptTypeFieldValue,
    int? totRcptNo,
    FieldValue totRcptNoFieldValue,
    int? curRcptNo,
    FieldValue curRcptNoFieldValue,
    int? invcNo,
    FieldValue invcNoFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int? id,
    FieldValue idFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? receiptType,
    FieldValue receiptTypeFieldValue,
    int? totRcptNo,
    FieldValue totRcptNoFieldValue,
    int? curRcptNo,
    FieldValue curRcptNoFieldValue,
    int? invcNo,
    FieldValue invcNoFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
  });
}

class _$CounterDocumentReference
    extends FirestoreDocumentReference<Counter, CounterDocumentSnapshot>
    implements CounterDocumentReference {
  _$CounterDocumentReference(this.reference);

  @override
  final DocumentReference<Counter> reference;

  /// A reference to the [CounterCollectionReference] containing this document.
  CounterCollectionReference get parent {
    return _$CounterCollectionReference(reference.firestore);
  }

  @override
  Stream<CounterDocumentSnapshot> snapshots() {
    return reference.snapshots().map(CounterDocumentSnapshot._);
  }

  @override
  Future<CounterDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then(CounterDocumentSnapshot._);
  }

  @override
  Future<CounterDocumentSnapshot> transactionGet(Transaction transaction) {
    return transaction.get(reference).then(CounterDocumentSnapshot._);
  }

  Future<void> set(
    Counter model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? receiptTypeFieldValue,
    FieldValue? totRcptNoFieldValue,
    FieldValue? curRcptNoFieldValue,
    FieldValue? invcNoFieldValue,
    FieldValue? lastTouchedFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$CounterFieldMap['id']!: idFieldValue,
      if (businessIdFieldValue != null)
        _$CounterFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$CounterFieldMap['branchId']!: branchIdFieldValue,
      if (receiptTypeFieldValue != null)
        _$CounterFieldMap['receiptType']!: receiptTypeFieldValue,
      if (totRcptNoFieldValue != null)
        _$CounterFieldMap['totRcptNo']!: totRcptNoFieldValue,
      if (curRcptNoFieldValue != null)
        _$CounterFieldMap['curRcptNo']!: curRcptNoFieldValue,
      if (invcNoFieldValue != null)
        _$CounterFieldMap['invcNo']!: invcNoFieldValue,
      if (lastTouchedFieldValue != null)
        _$CounterFieldMap['lastTouched']!: lastTouchedFieldValue,
    };

    final castedReference = reference.withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, options) => throw UnimplementedError(),
      toFirestore: (value, options) => value,
    );
    return castedReference.set(json, options);
  }

  void transactionSet(
    Transaction transaction,
    Counter model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? receiptTypeFieldValue,
    FieldValue? totRcptNoFieldValue,
    FieldValue? curRcptNoFieldValue,
    FieldValue? invcNoFieldValue,
    FieldValue? lastTouchedFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$CounterFieldMap['id']!: idFieldValue,
      if (businessIdFieldValue != null)
        _$CounterFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$CounterFieldMap['branchId']!: branchIdFieldValue,
      if (receiptTypeFieldValue != null)
        _$CounterFieldMap['receiptType']!: receiptTypeFieldValue,
      if (totRcptNoFieldValue != null)
        _$CounterFieldMap['totRcptNo']!: totRcptNoFieldValue,
      if (curRcptNoFieldValue != null)
        _$CounterFieldMap['curRcptNo']!: curRcptNoFieldValue,
      if (invcNoFieldValue != null)
        _$CounterFieldMap['invcNo']!: invcNoFieldValue,
      if (lastTouchedFieldValue != null)
        _$CounterFieldMap['lastTouched']!: lastTouchedFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Counter model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? receiptTypeFieldValue,
    FieldValue? totRcptNoFieldValue,
    FieldValue? curRcptNoFieldValue,
    FieldValue? invcNoFieldValue,
    FieldValue? lastTouchedFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$CounterFieldMap['id']!: idFieldValue,
      if (businessIdFieldValue != null)
        _$CounterFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$CounterFieldMap['branchId']!: branchIdFieldValue,
      if (receiptTypeFieldValue != null)
        _$CounterFieldMap['receiptType']!: receiptTypeFieldValue,
      if (totRcptNoFieldValue != null)
        _$CounterFieldMap['totRcptNo']!: totRcptNoFieldValue,
      if (curRcptNoFieldValue != null)
        _$CounterFieldMap['curRcptNo']!: curRcptNoFieldValue,
      if (invcNoFieldValue != null)
        _$CounterFieldMap['invcNo']!: invcNoFieldValue,
      if (lastTouchedFieldValue != null)
        _$CounterFieldMap['lastTouched']!: lastTouchedFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? receiptType = _sentinel,
    FieldValue? receiptTypeFieldValue,
    Object? totRcptNo = _sentinel,
    FieldValue? totRcptNoFieldValue,
    Object? curRcptNo = _sentinel,
    FieldValue? curRcptNoFieldValue,
    Object? invcNo = _sentinel,
    FieldValue? invcNoFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      receiptType == _sentinel || receiptTypeFieldValue == null,
      "Cannot specify both receiptType and receiptTypeFieldValue",
    );
    assert(
      totRcptNo == _sentinel || totRcptNoFieldValue == null,
      "Cannot specify both totRcptNo and totRcptNoFieldValue",
    );
    assert(
      curRcptNo == _sentinel || curRcptNoFieldValue == null,
      "Cannot specify both curRcptNo and curRcptNoFieldValue",
    );
    assert(
      invcNo == _sentinel || invcNoFieldValue == null,
      "Cannot specify both invcNo and invcNoFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$CounterFieldMap['id']!: _$CounterPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$CounterFieldMap['id']!: idFieldValue,
      if (businessId != _sentinel)
        _$CounterFieldMap['businessId']!:
            _$CounterPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$CounterFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$CounterFieldMap['branchId']!:
            _$CounterPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$CounterFieldMap['branchId']!: branchIdFieldValue,
      if (receiptType != _sentinel)
        _$CounterFieldMap['receiptType']!:
            _$CounterPerFieldToJson.receiptType(receiptType as String?),
      if (receiptTypeFieldValue != null)
        _$CounterFieldMap['receiptType']!: receiptTypeFieldValue,
      if (totRcptNo != _sentinel)
        _$CounterFieldMap['totRcptNo']!:
            _$CounterPerFieldToJson.totRcptNo(totRcptNo as int?),
      if (totRcptNoFieldValue != null)
        _$CounterFieldMap['totRcptNo']!: totRcptNoFieldValue,
      if (curRcptNo != _sentinel)
        _$CounterFieldMap['curRcptNo']!:
            _$CounterPerFieldToJson.curRcptNo(curRcptNo as int?),
      if (curRcptNoFieldValue != null)
        _$CounterFieldMap['curRcptNo']!: curRcptNoFieldValue,
      if (invcNo != _sentinel)
        _$CounterFieldMap['invcNo']!:
            _$CounterPerFieldToJson.invcNo(invcNo as int?),
      if (invcNoFieldValue != null)
        _$CounterFieldMap['invcNo']!: invcNoFieldValue,
      if (lastTouched != _sentinel)
        _$CounterFieldMap['lastTouched']!:
            _$CounterPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$CounterFieldMap['lastTouched']!: lastTouchedFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? receiptType = _sentinel,
    FieldValue? receiptTypeFieldValue,
    Object? totRcptNo = _sentinel,
    FieldValue? totRcptNoFieldValue,
    Object? curRcptNo = _sentinel,
    FieldValue? curRcptNoFieldValue,
    Object? invcNo = _sentinel,
    FieldValue? invcNoFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      receiptType == _sentinel || receiptTypeFieldValue == null,
      "Cannot specify both receiptType and receiptTypeFieldValue",
    );
    assert(
      totRcptNo == _sentinel || totRcptNoFieldValue == null,
      "Cannot specify both totRcptNo and totRcptNoFieldValue",
    );
    assert(
      curRcptNo == _sentinel || curRcptNoFieldValue == null,
      "Cannot specify both curRcptNo and curRcptNoFieldValue",
    );
    assert(
      invcNo == _sentinel || invcNoFieldValue == null,
      "Cannot specify both invcNo and invcNoFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$CounterFieldMap['id']!: _$CounterPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$CounterFieldMap['id']!: idFieldValue,
      if (businessId != _sentinel)
        _$CounterFieldMap['businessId']!:
            _$CounterPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$CounterFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$CounterFieldMap['branchId']!:
            _$CounterPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$CounterFieldMap['branchId']!: branchIdFieldValue,
      if (receiptType != _sentinel)
        _$CounterFieldMap['receiptType']!:
            _$CounterPerFieldToJson.receiptType(receiptType as String?),
      if (receiptTypeFieldValue != null)
        _$CounterFieldMap['receiptType']!: receiptTypeFieldValue,
      if (totRcptNo != _sentinel)
        _$CounterFieldMap['totRcptNo']!:
            _$CounterPerFieldToJson.totRcptNo(totRcptNo as int?),
      if (totRcptNoFieldValue != null)
        _$CounterFieldMap['totRcptNo']!: totRcptNoFieldValue,
      if (curRcptNo != _sentinel)
        _$CounterFieldMap['curRcptNo']!:
            _$CounterPerFieldToJson.curRcptNo(curRcptNo as int?),
      if (curRcptNoFieldValue != null)
        _$CounterFieldMap['curRcptNo']!: curRcptNoFieldValue,
      if (invcNo != _sentinel)
        _$CounterFieldMap['invcNo']!:
            _$CounterPerFieldToJson.invcNo(invcNo as int?),
      if (invcNoFieldValue != null)
        _$CounterFieldMap['invcNo']!: invcNoFieldValue,
      if (lastTouched != _sentinel)
        _$CounterFieldMap['lastTouched']!:
            _$CounterPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$CounterFieldMap['lastTouched']!: lastTouchedFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? receiptType = _sentinel,
    FieldValue? receiptTypeFieldValue,
    Object? totRcptNo = _sentinel,
    FieldValue? totRcptNoFieldValue,
    Object? curRcptNo = _sentinel,
    FieldValue? curRcptNoFieldValue,
    Object? invcNo = _sentinel,
    FieldValue? invcNoFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      receiptType == _sentinel || receiptTypeFieldValue == null,
      "Cannot specify both receiptType and receiptTypeFieldValue",
    );
    assert(
      totRcptNo == _sentinel || totRcptNoFieldValue == null,
      "Cannot specify both totRcptNo and totRcptNoFieldValue",
    );
    assert(
      curRcptNo == _sentinel || curRcptNoFieldValue == null,
      "Cannot specify both curRcptNo and curRcptNoFieldValue",
    );
    assert(
      invcNo == _sentinel || invcNoFieldValue == null,
      "Cannot specify both invcNo and invcNoFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$CounterFieldMap['id']!: _$CounterPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$CounterFieldMap['id']!: idFieldValue,
      if (businessId != _sentinel)
        _$CounterFieldMap['businessId']!:
            _$CounterPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$CounterFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$CounterFieldMap['branchId']!:
            _$CounterPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$CounterFieldMap['branchId']!: branchIdFieldValue,
      if (receiptType != _sentinel)
        _$CounterFieldMap['receiptType']!:
            _$CounterPerFieldToJson.receiptType(receiptType as String?),
      if (receiptTypeFieldValue != null)
        _$CounterFieldMap['receiptType']!: receiptTypeFieldValue,
      if (totRcptNo != _sentinel)
        _$CounterFieldMap['totRcptNo']!:
            _$CounterPerFieldToJson.totRcptNo(totRcptNo as int?),
      if (totRcptNoFieldValue != null)
        _$CounterFieldMap['totRcptNo']!: totRcptNoFieldValue,
      if (curRcptNo != _sentinel)
        _$CounterFieldMap['curRcptNo']!:
            _$CounterPerFieldToJson.curRcptNo(curRcptNo as int?),
      if (curRcptNoFieldValue != null)
        _$CounterFieldMap['curRcptNo']!: curRcptNoFieldValue,
      if (invcNo != _sentinel)
        _$CounterFieldMap['invcNo']!:
            _$CounterPerFieldToJson.invcNo(invcNo as int?),
      if (invcNoFieldValue != null)
        _$CounterFieldMap['invcNo']!: invcNoFieldValue,
      if (lastTouched != _sentinel)
        _$CounterFieldMap['lastTouched']!:
            _$CounterPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$CounterFieldMap['lastTouched']!: lastTouchedFieldValue,
    };

    batch.update(reference, json);
  }

  @override
  bool operator ==(Object other) {
    return other is CounterDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

abstract class CounterQuery
    implements QueryReference<Counter, CounterQuerySnapshot> {
  @override
  CounterQuery limit(int limit);

  @override
  CounterQuery limitToLast(int limit);

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
  CounterQuery whereFieldPath(
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

  CounterQuery whereDocumentId({
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

  CounterQuery whereId({
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

  CounterQuery whereBusinessId({
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

  CounterQuery whereBranchId({
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

  CounterQuery whereReceiptType({
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

  CounterQuery whereTotRcptNo({
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

  CounterQuery whereCurRcptNo({
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

  CounterQuery whereInvcNo({
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

  CounterQuery whereLastTouched({
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
  CounterQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object startAt,
    Object startAfter,
    Object endAt,
    Object endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByDocumentId({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderById({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByBusinessId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByBranchId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByReceiptType({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByTotRcptNo({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByCurRcptNo({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByInvcNo({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });

  CounterQuery orderByLastTouched({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  });
}

class _$CounterQuery extends QueryReference<Counter, CounterQuerySnapshot>
    implements CounterQuery {
  _$CounterQuery(
    this._collection, {
    required Query<Counter> $referenceWithoutCursor,
    $QueryCursor $queryCursor = const $QueryCursor(),
  }) : super(
          $referenceWithoutCursor: $referenceWithoutCursor,
          $queryCursor: $queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<CounterQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(CounterQuerySnapshot._fromQuerySnapshot);
  }

  @override
  Future<CounterQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(CounterQuerySnapshot._fromQuerySnapshot);
  }

  @override
  CounterQuery limit(int limit) {
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limit(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery limitToLast(int limit) {
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limitToLast(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereFieldPath(
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
    return _$CounterQuery(
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
  CounterQuery whereDocumentId({
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
    return _$CounterQuery(
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
  CounterQuery whereId({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson.id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson.id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.id(e)),
        whereNotIn: whereNotIn?.map((e) => _$CounterPerFieldToJson.id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereBusinessId({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['businessId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.businessId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.businessId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.businessId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson.businessId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.businessId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson.businessId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.businessId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CounterPerFieldToJson.businessId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereBranchId({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['branchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.branchId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.branchId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.branchId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson.branchId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.branchId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson.branchId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.branchId(e)),
        whereNotIn: whereNotIn?.map((e) => _$CounterPerFieldToJson.branchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereReceiptType({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['receiptType']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.receiptType(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.receiptType(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.receiptType(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson
                .receiptType(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.receiptType(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson
                .receiptType(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.receiptType(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CounterPerFieldToJson.receiptType(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereTotRcptNo({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['totRcptNo']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.totRcptNo(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.totRcptNo(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.totRcptNo(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson.totRcptNo(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.totRcptNo(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson.totRcptNo(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.totRcptNo(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CounterPerFieldToJson.totRcptNo(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereCurRcptNo({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['curRcptNo']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.curRcptNo(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.curRcptNo(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.curRcptNo(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson.curRcptNo(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.curRcptNo(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson.curRcptNo(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.curRcptNo(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CounterPerFieldToJson.curRcptNo(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereInvcNo({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['invcNo']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.invcNo(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.invcNo(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.invcNo(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson.invcNo(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.invcNo(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson.invcNo(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.invcNo(e)),
        whereNotIn: whereNotIn?.map((e) => _$CounterPerFieldToJson.invcNo(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery whereLastTouched({
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
    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CounterFieldMap['lastTouched']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CounterPerFieldToJson.lastTouched(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CounterPerFieldToJson.lastTouched(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$CounterPerFieldToJson.lastTouched(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CounterPerFieldToJson
                .lastTouched(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CounterPerFieldToJson.lastTouched(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CounterPerFieldToJson
                .lastTouched(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$CounterPerFieldToJson.lastTouched(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CounterPerFieldToJson.lastTouched(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CounterQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByDocumentId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderById({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$CounterFieldMap['id']!,
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByBusinessId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CounterFieldMap['businessId']!, descending: descending);
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByBranchId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CounterFieldMap['branchId']!, descending: descending);
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByReceiptType({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CounterFieldMap['receiptType']!, descending: descending);
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByTotRcptNo({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CounterFieldMap['totRcptNo']!, descending: descending);
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByCurRcptNo({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CounterFieldMap['curRcptNo']!, descending: descending);
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByInvcNo({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$CounterFieldMap['invcNo']!,
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CounterQuery orderByLastTouched({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CounterDocumentSnapshot? startAtDocument,
    CounterDocumentSnapshot? endAtDocument,
    CounterDocumentSnapshot? endBeforeDocument,
    CounterDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CounterFieldMap['lastTouched']!, descending: descending);
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

    return _$CounterQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$CounterQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class CounterDocumentSnapshot extends FirestoreDocumentSnapshot<Counter> {
  CounterDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final DocumentSnapshot<Counter> snapshot;

  @override
  CounterDocumentReference get reference {
    return CounterDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Counter? data;
}

class CounterQuerySnapshot
    extends FirestoreQuerySnapshot<Counter, CounterQueryDocumentSnapshot> {
  CounterQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  factory CounterQuerySnapshot._fromQuerySnapshot(
    QuerySnapshot<Counter> snapshot,
  ) {
    final docs = snapshot.docs.map(CounterQueryDocumentSnapshot._).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return _decodeDocumentChange(
        change,
        CounterDocumentSnapshot._,
      );
    }).toList();

    return CounterQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  static FirestoreDocumentChange<CounterDocumentSnapshot>
      _decodeDocumentChange<T>(
    DocumentChange<T> docChange,
    CounterDocumentSnapshot Function(DocumentSnapshot<T> doc) decodeDoc,
  ) {
    return FirestoreDocumentChange<CounterDocumentSnapshot>(
      type: docChange.type,
      oldIndex: docChange.oldIndex,
      newIndex: docChange.newIndex,
      doc: decodeDoc(docChange.doc),
    );
  }

  final QuerySnapshot<Counter> snapshot;

  @override
  final List<CounterQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<CounterDocumentSnapshot>> docChanges;
}

class CounterQueryDocumentSnapshot
    extends FirestoreQueryDocumentSnapshot<Counter>
    implements CounterDocumentSnapshot {
  CounterQueryDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final QueryDocumentSnapshot<Counter> snapshot;

  @override
  final Counter data;

  @override
  CounterDocumentReference get reference {
    return CounterDocumentReference(snapshot.reference);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Counter _$CounterFromJson(Map<String, dynamic> json) => Counter(
      id: (json['id'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      receiptType: json['receiptType'] as String?,
      totRcptNo: (json['totRcptNo'] as num?)?.toInt(),
      curRcptNo: (json['curRcptNo'] as num?)?.toInt(),
      invcNo: (json['invcNo'] as num?)?.toInt(),
      lastTouched: const TimestampConverter().fromJson(json['lastTouched']),
    );

const _$CounterFieldMap = <String, String>{
  'id': 'id',
  'businessId': 'businessId',
  'branchId': 'branchId',
  'receiptType': 'receiptType',
  'totRcptNo': 'totRcptNo',
  'curRcptNo': 'curRcptNo',
  'invcNo': 'invcNo',
  'lastTouched': 'lastTouched',
};

// ignore: unused_element
abstract class _$CounterPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? receiptType(String? instance) => instance;
  // ignore: unused_element
  static Object? totRcptNo(int? instance) => instance;
  // ignore: unused_element
  static Object? curRcptNo(int? instance) => instance;
  // ignore: unused_element
  static Object? invcNo(int? instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) =>
      const TimestampConverter().toJson(instance);
}

Map<String, dynamic> _$CounterToJson(Counter instance) => <String, dynamic>{
      'id': instance.id,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
      'receiptType': instance.receiptType,
      'totRcptNo': instance.totRcptNo,
      'curRcptNo': instance.curRcptNo,
      'invcNo': instance.invcNo,
      'lastTouched': const TimestampConverter().toJson(instance.lastTouched),
    };
