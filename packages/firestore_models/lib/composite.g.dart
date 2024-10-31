// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composite.dart';

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
abstract class CompositeCollectionReference
    implements
        CompositeQuery,
        FirestoreCollectionReference<Composite, CompositeQuerySnapshot> {
  factory CompositeCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$CompositeCollectionReference;

  static Composite fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return Composite.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    Composite value,
    SetOptions? options,
  ) {
    return value.toJson();
  }

  @override
  CollectionReference<Composite> get reference;

  @override
  CompositeDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<CompositeDocumentReference> add(Composite value);
}

class _$CompositeCollectionReference extends _$CompositeQuery
    implements CompositeCollectionReference {
  factory _$CompositeCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$CompositeCollectionReference._(
      firestore.collection('composites').withConverter(
            fromFirestore: CompositeCollectionReference.fromFirestore,
            toFirestore: CompositeCollectionReference.toFirestore,
          ),
    );
  }

  _$CompositeCollectionReference._(
    CollectionReference<Composite> reference,
  ) : super(reference, $referenceWithoutCursor: reference);

  String get path => reference.path;

  @override
  CollectionReference<Composite> get reference =>
      super.reference as CollectionReference<Composite>;

  @override
  CompositeDocumentReference doc([String? id]) {
    assert(
      id == null || id.split('/').length == 1,
      'The document ID cannot be from a different collection',
    );
    return CompositeDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<CompositeDocumentReference> add(Composite value) {
    return reference.add(value).then((ref) => CompositeDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$CompositeCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class CompositeDocumentReference
    extends FirestoreDocumentReference<Composite, CompositeDocumentSnapshot> {
  factory CompositeDocumentReference(DocumentReference<Composite> reference) =
      _$CompositeDocumentReference;

  DocumentReference<Composite> get reference;

  /// A reference to the [CompositeCollectionReference] containing this document.
  CompositeCollectionReference get parent {
    return _$CompositeCollectionReference(reference.firestore);
  }

  @override
  Stream<CompositeDocumentSnapshot> snapshots();

  @override
  Future<CompositeDocumentSnapshot> get([GetOptions? options]);

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
    Composite model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue productIdFieldValue,
    FieldValue variantIdFieldValue,
    FieldValue qtyFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue actualPriceFieldValue,
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
    Composite model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue productIdFieldValue,
    FieldValue variantIdFieldValue,
    FieldValue qtyFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue actualPriceFieldValue,
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
    Composite model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue productIdFieldValue,
    FieldValue variantIdFieldValue,
    FieldValue qtyFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue actualPriceFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int? id,
    FieldValue idFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    int? variantId,
    FieldValue variantIdFieldValue,
    double? qty,
    FieldValue qtyFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    double? actualPrice,
    FieldValue actualPriceFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int? id,
    FieldValue idFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    int? variantId,
    FieldValue variantIdFieldValue,
    double? qty,
    FieldValue qtyFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    double? actualPrice,
    FieldValue actualPriceFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int? id,
    FieldValue idFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    int? variantId,
    FieldValue variantIdFieldValue,
    double? qty,
    FieldValue qtyFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    double? actualPrice,
    FieldValue actualPriceFieldValue,
  });
}

class _$CompositeDocumentReference
    extends FirestoreDocumentReference<Composite, CompositeDocumentSnapshot>
    implements CompositeDocumentReference {
  _$CompositeDocumentReference(this.reference);

  @override
  final DocumentReference<Composite> reference;

  /// A reference to the [CompositeCollectionReference] containing this document.
  CompositeCollectionReference get parent {
    return _$CompositeCollectionReference(reference.firestore);
  }

  @override
  Stream<CompositeDocumentSnapshot> snapshots() {
    return reference.snapshots().map(CompositeDocumentSnapshot._);
  }

  @override
  Future<CompositeDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then(CompositeDocumentSnapshot._);
  }

  @override
  Future<CompositeDocumentSnapshot> transactionGet(Transaction transaction) {
    return transaction.get(reference).then(CompositeDocumentSnapshot._);
  }

  Future<void> set(
    Composite model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? variantIdFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? actualPriceFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$CompositeFieldMap['id']!: idFieldValue,
      if (productIdFieldValue != null)
        _$CompositeFieldMap['productId']!: productIdFieldValue,
      if (variantIdFieldValue != null)
        _$CompositeFieldMap['variantId']!: variantIdFieldValue,
      if (qtyFieldValue != null) _$CompositeFieldMap['qty']!: qtyFieldValue,
      if (branchIdFieldValue != null)
        _$CompositeFieldMap['branchId']!: branchIdFieldValue,
      if (businessIdFieldValue != null)
        _$CompositeFieldMap['businessId']!: businessIdFieldValue,
      if (actualPriceFieldValue != null)
        _$CompositeFieldMap['actualPrice']!: actualPriceFieldValue,
    };

    final castedReference = reference.withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, options) => throw UnimplementedError(),
      toFirestore: (value, options) => value,
    );
    return castedReference.set(json, options);
  }

  void transactionSet(
    Transaction transaction,
    Composite model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? variantIdFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? actualPriceFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$CompositeFieldMap['id']!: idFieldValue,
      if (productIdFieldValue != null)
        _$CompositeFieldMap['productId']!: productIdFieldValue,
      if (variantIdFieldValue != null)
        _$CompositeFieldMap['variantId']!: variantIdFieldValue,
      if (qtyFieldValue != null) _$CompositeFieldMap['qty']!: qtyFieldValue,
      if (branchIdFieldValue != null)
        _$CompositeFieldMap['branchId']!: branchIdFieldValue,
      if (businessIdFieldValue != null)
        _$CompositeFieldMap['businessId']!: businessIdFieldValue,
      if (actualPriceFieldValue != null)
        _$CompositeFieldMap['actualPrice']!: actualPriceFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Composite model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? variantIdFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? actualPriceFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$CompositeFieldMap['id']!: idFieldValue,
      if (productIdFieldValue != null)
        _$CompositeFieldMap['productId']!: productIdFieldValue,
      if (variantIdFieldValue != null)
        _$CompositeFieldMap['variantId']!: variantIdFieldValue,
      if (qtyFieldValue != null) _$CompositeFieldMap['qty']!: qtyFieldValue,
      if (branchIdFieldValue != null)
        _$CompositeFieldMap['branchId']!: branchIdFieldValue,
      if (businessIdFieldValue != null)
        _$CompositeFieldMap['businessId']!: businessIdFieldValue,
      if (actualPriceFieldValue != null)
        _$CompositeFieldMap['actualPrice']!: actualPriceFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? variantId = _sentinel,
    FieldValue? variantIdFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? actualPrice = _sentinel,
    FieldValue? actualPriceFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
    );
    assert(
      variantId == _sentinel || variantIdFieldValue == null,
      "Cannot specify both variantId and variantIdFieldValue",
    );
    assert(
      qty == _sentinel || qtyFieldValue == null,
      "Cannot specify both qty and qtyFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      actualPrice == _sentinel || actualPriceFieldValue == null,
      "Cannot specify both actualPrice and actualPriceFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$CompositeFieldMap['id']!: _$CompositePerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$CompositeFieldMap['id']!: idFieldValue,
      if (productId != _sentinel)
        _$CompositeFieldMap['productId']!:
            _$CompositePerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$CompositeFieldMap['productId']!: productIdFieldValue,
      if (variantId != _sentinel)
        _$CompositeFieldMap['variantId']!:
            _$CompositePerFieldToJson.variantId(variantId as int?),
      if (variantIdFieldValue != null)
        _$CompositeFieldMap['variantId']!: variantIdFieldValue,
      if (qty != _sentinel)
        _$CompositeFieldMap['qty']!:
            _$CompositePerFieldToJson.qty(qty as double?),
      if (qtyFieldValue != null) _$CompositeFieldMap['qty']!: qtyFieldValue,
      if (branchId != _sentinel)
        _$CompositeFieldMap['branchId']!:
            _$CompositePerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$CompositeFieldMap['branchId']!: branchIdFieldValue,
      if (businessId != _sentinel)
        _$CompositeFieldMap['businessId']!:
            _$CompositePerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$CompositeFieldMap['businessId']!: businessIdFieldValue,
      if (actualPrice != _sentinel)
        _$CompositeFieldMap['actualPrice']!:
            _$CompositePerFieldToJson.actualPrice(actualPrice as double?),
      if (actualPriceFieldValue != null)
        _$CompositeFieldMap['actualPrice']!: actualPriceFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? variantId = _sentinel,
    FieldValue? variantIdFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? actualPrice = _sentinel,
    FieldValue? actualPriceFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
    );
    assert(
      variantId == _sentinel || variantIdFieldValue == null,
      "Cannot specify both variantId and variantIdFieldValue",
    );
    assert(
      qty == _sentinel || qtyFieldValue == null,
      "Cannot specify both qty and qtyFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      actualPrice == _sentinel || actualPriceFieldValue == null,
      "Cannot specify both actualPrice and actualPriceFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$CompositeFieldMap['id']!: _$CompositePerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$CompositeFieldMap['id']!: idFieldValue,
      if (productId != _sentinel)
        _$CompositeFieldMap['productId']!:
            _$CompositePerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$CompositeFieldMap['productId']!: productIdFieldValue,
      if (variantId != _sentinel)
        _$CompositeFieldMap['variantId']!:
            _$CompositePerFieldToJson.variantId(variantId as int?),
      if (variantIdFieldValue != null)
        _$CompositeFieldMap['variantId']!: variantIdFieldValue,
      if (qty != _sentinel)
        _$CompositeFieldMap['qty']!:
            _$CompositePerFieldToJson.qty(qty as double?),
      if (qtyFieldValue != null) _$CompositeFieldMap['qty']!: qtyFieldValue,
      if (branchId != _sentinel)
        _$CompositeFieldMap['branchId']!:
            _$CompositePerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$CompositeFieldMap['branchId']!: branchIdFieldValue,
      if (businessId != _sentinel)
        _$CompositeFieldMap['businessId']!:
            _$CompositePerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$CompositeFieldMap['businessId']!: businessIdFieldValue,
      if (actualPrice != _sentinel)
        _$CompositeFieldMap['actualPrice']!:
            _$CompositePerFieldToJson.actualPrice(actualPrice as double?),
      if (actualPriceFieldValue != null)
        _$CompositeFieldMap['actualPrice']!: actualPriceFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? variantId = _sentinel,
    FieldValue? variantIdFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? actualPrice = _sentinel,
    FieldValue? actualPriceFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
    );
    assert(
      variantId == _sentinel || variantIdFieldValue == null,
      "Cannot specify both variantId and variantIdFieldValue",
    );
    assert(
      qty == _sentinel || qtyFieldValue == null,
      "Cannot specify both qty and qtyFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      actualPrice == _sentinel || actualPriceFieldValue == null,
      "Cannot specify both actualPrice and actualPriceFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$CompositeFieldMap['id']!: _$CompositePerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$CompositeFieldMap['id']!: idFieldValue,
      if (productId != _sentinel)
        _$CompositeFieldMap['productId']!:
            _$CompositePerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$CompositeFieldMap['productId']!: productIdFieldValue,
      if (variantId != _sentinel)
        _$CompositeFieldMap['variantId']!:
            _$CompositePerFieldToJson.variantId(variantId as int?),
      if (variantIdFieldValue != null)
        _$CompositeFieldMap['variantId']!: variantIdFieldValue,
      if (qty != _sentinel)
        _$CompositeFieldMap['qty']!:
            _$CompositePerFieldToJson.qty(qty as double?),
      if (qtyFieldValue != null) _$CompositeFieldMap['qty']!: qtyFieldValue,
      if (branchId != _sentinel)
        _$CompositeFieldMap['branchId']!:
            _$CompositePerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$CompositeFieldMap['branchId']!: branchIdFieldValue,
      if (businessId != _sentinel)
        _$CompositeFieldMap['businessId']!:
            _$CompositePerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$CompositeFieldMap['businessId']!: businessIdFieldValue,
      if (actualPrice != _sentinel)
        _$CompositeFieldMap['actualPrice']!:
            _$CompositePerFieldToJson.actualPrice(actualPrice as double?),
      if (actualPriceFieldValue != null)
        _$CompositeFieldMap['actualPrice']!: actualPriceFieldValue,
    };

    batch.update(reference, json);
  }

  @override
  bool operator ==(Object other) {
    return other is CompositeDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

abstract class CompositeQuery
    implements QueryReference<Composite, CompositeQuerySnapshot> {
  @override
  CompositeQuery limit(int limit);

  @override
  CompositeQuery limitToLast(int limit);

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
  CompositeQuery whereFieldPath(
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

  CompositeQuery whereDocumentId({
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

  CompositeQuery whereId({
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

  CompositeQuery whereProductId({
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

  CompositeQuery whereVariantId({
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

  CompositeQuery whereQty({
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

  CompositeQuery whereBranchId({
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

  CompositeQuery whereBusinessId({
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

  CompositeQuery whereActualPrice({
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
  CompositeQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object startAt,
    Object startAfter,
    Object endAt,
    Object endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderByDocumentId({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderById({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderByProductId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderByVariantId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderByQty({
    bool descending = false,
    double? startAt,
    double? startAfter,
    double? endAt,
    double? endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderByBranchId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderByBusinessId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });

  CompositeQuery orderByActualPrice({
    bool descending = false,
    double? startAt,
    double? startAfter,
    double? endAt,
    double? endBefore,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  });
}

class _$CompositeQuery extends QueryReference<Composite, CompositeQuerySnapshot>
    implements CompositeQuery {
  _$CompositeQuery(
    this._collection, {
    required Query<Composite> $referenceWithoutCursor,
    $QueryCursor $queryCursor = const $QueryCursor(),
  }) : super(
          $referenceWithoutCursor: $referenceWithoutCursor,
          $queryCursor: $queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<CompositeQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(CompositeQuerySnapshot._fromQuerySnapshot);
  }

  @override
  Future<CompositeQuerySnapshot> get([GetOptions? options]) {
    return reference
        .get(options)
        .then(CompositeQuerySnapshot._fromQuerySnapshot);
  }

  @override
  CompositeQuery limit(int limit) {
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limit(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery limitToLast(int limit) {
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limitToLast(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery whereFieldPath(
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
    return _$CompositeQuery(
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
  CompositeQuery whereDocumentId({
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
    return _$CompositeQuery(
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
  CompositeQuery whereId({
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
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CompositeFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CompositePerFieldToJson.id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CompositePerFieldToJson.id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CompositePerFieldToJson.id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CompositePerFieldToJson.id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CompositePerFieldToJson.id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CompositePerFieldToJson.id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CompositePerFieldToJson.id(e)),
        whereNotIn: whereNotIn?.map((e) => _$CompositePerFieldToJson.id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery whereProductId({
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
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CompositeFieldMap['productId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CompositePerFieldToJson.productId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CompositePerFieldToJson.productId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CompositePerFieldToJson.productId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CompositePerFieldToJson.productId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CompositePerFieldToJson.productId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CompositePerFieldToJson
                .productId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CompositePerFieldToJson.productId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CompositePerFieldToJson.productId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery whereVariantId({
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
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CompositeFieldMap['variantId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CompositePerFieldToJson.variantId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CompositePerFieldToJson.variantId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CompositePerFieldToJson.variantId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CompositePerFieldToJson.variantId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CompositePerFieldToJson.variantId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CompositePerFieldToJson
                .variantId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CompositePerFieldToJson.variantId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CompositePerFieldToJson.variantId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery whereQty({
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
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CompositeFieldMap['qty']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CompositePerFieldToJson.qty(isEqualTo as double?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CompositePerFieldToJson.qty(isNotEqualTo as double?)
            : null,
        isLessThan: isLessThan != null
            ? _$CompositePerFieldToJson.qty(isLessThan as double?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CompositePerFieldToJson.qty(isLessThanOrEqualTo as double?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CompositePerFieldToJson.qty(isGreaterThan as double?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CompositePerFieldToJson.qty(isGreaterThanOrEqualTo as double?)
            : null,
        whereIn: whereIn?.map((e) => _$CompositePerFieldToJson.qty(e)),
        whereNotIn: whereNotIn?.map((e) => _$CompositePerFieldToJson.qty(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery whereBranchId({
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
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CompositeFieldMap['branchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CompositePerFieldToJson.branchId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CompositePerFieldToJson.branchId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CompositePerFieldToJson.branchId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CompositePerFieldToJson.branchId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CompositePerFieldToJson.branchId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CompositePerFieldToJson.branchId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CompositePerFieldToJson.branchId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CompositePerFieldToJson.branchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery whereBusinessId({
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
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CompositeFieldMap['businessId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CompositePerFieldToJson.businessId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CompositePerFieldToJson.businessId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$CompositePerFieldToJson.businessId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CompositePerFieldToJson.businessId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CompositePerFieldToJson.businessId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CompositePerFieldToJson
                .businessId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$CompositePerFieldToJson.businessId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CompositePerFieldToJson.businessId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery whereActualPrice({
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
    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$CompositeFieldMap['actualPrice']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$CompositePerFieldToJson.actualPrice(isEqualTo as double?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$CompositePerFieldToJson.actualPrice(isNotEqualTo as double?)
            : null,
        isLessThan: isLessThan != null
            ? _$CompositePerFieldToJson.actualPrice(isLessThan as double?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$CompositePerFieldToJson
                .actualPrice(isLessThanOrEqualTo as double?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$CompositePerFieldToJson.actualPrice(isGreaterThan as double?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$CompositePerFieldToJson
                .actualPrice(isGreaterThanOrEqualTo as double?)
            : null,
        whereIn: whereIn?.map((e) => _$CompositePerFieldToJson.actualPrice(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$CompositePerFieldToJson.actualPrice(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  CompositeQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderByDocumentId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderById({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$CompositeFieldMap['id']!,
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderByProductId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CompositeFieldMap['productId']!, descending: descending);
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderByVariantId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CompositeFieldMap['variantId']!, descending: descending);
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderByQty({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$CompositeFieldMap['qty']!,
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderByBranchId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CompositeFieldMap['branchId']!, descending: descending);
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderByBusinessId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CompositeFieldMap['businessId']!, descending: descending);
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  CompositeQuery orderByActualPrice({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    CompositeDocumentSnapshot? startAtDocument,
    CompositeDocumentSnapshot? endAtDocument,
    CompositeDocumentSnapshot? endBeforeDocument,
    CompositeDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$CompositeFieldMap['actualPrice']!, descending: descending);
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

    return _$CompositeQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$CompositeQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class CompositeDocumentSnapshot extends FirestoreDocumentSnapshot<Composite> {
  CompositeDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final DocumentSnapshot<Composite> snapshot;

  @override
  CompositeDocumentReference get reference {
    return CompositeDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Composite? data;
}

class CompositeQuerySnapshot
    extends FirestoreQuerySnapshot<Composite, CompositeQueryDocumentSnapshot> {
  CompositeQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  factory CompositeQuerySnapshot._fromQuerySnapshot(
    QuerySnapshot<Composite> snapshot,
  ) {
    final docs = snapshot.docs.map(CompositeQueryDocumentSnapshot._).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return _decodeDocumentChange(
        change,
        CompositeDocumentSnapshot._,
      );
    }).toList();

    return CompositeQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  static FirestoreDocumentChange<CompositeDocumentSnapshot>
      _decodeDocumentChange<T>(
    DocumentChange<T> docChange,
    CompositeDocumentSnapshot Function(DocumentSnapshot<T> doc) decodeDoc,
  ) {
    return FirestoreDocumentChange<CompositeDocumentSnapshot>(
      type: docChange.type,
      oldIndex: docChange.oldIndex,
      newIndex: docChange.newIndex,
      doc: decodeDoc(docChange.doc),
    );
  }

  final QuerySnapshot<Composite> snapshot;

  @override
  final List<CompositeQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<CompositeDocumentSnapshot>> docChanges;
}

class CompositeQueryDocumentSnapshot
    extends FirestoreQueryDocumentSnapshot<Composite>
    implements CompositeDocumentSnapshot {
  CompositeQueryDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final QueryDocumentSnapshot<Composite> snapshot;

  @override
  final Composite data;

  @override
  CompositeDocumentReference get reference {
    return CompositeDocumentReference(snapshot.reference);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Composite _$CompositeFromJson(Map<String, dynamic> json) => Composite(
      id: (json['id'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
      variantId: (json['variantId'] as num?)?.toInt(),
      qty: (json['qty'] as num?)?.toDouble(),
      branchId: (json['branchId'] as num?)?.toInt(),
      businessId: (json['businessId'] as num?)?.toInt(),
      actualPrice: (json['actualPrice'] as num?)?.toDouble(),
    );

const _$CompositeFieldMap = <String, String>{
  'id': 'id',
  'productId': 'productId',
  'variantId': 'variantId',
  'qty': 'qty',
  'branchId': 'branchId',
  'businessId': 'businessId',
  'actualPrice': 'actualPrice',
};

// ignore: unused_element
abstract class _$CompositePerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
  // ignore: unused_element
  static Object? variantId(int? instance) => instance;
  // ignore: unused_element
  static Object? qty(double? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? actualPrice(double? instance) => instance;
}

Map<String, dynamic> _$CompositeToJson(Composite instance) => <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'branchId': instance.branchId,
      'businessId': instance.businessId,
      'actualPrice': instance.actualPrice,
    };
