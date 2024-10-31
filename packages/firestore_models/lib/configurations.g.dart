// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configurations.dart';

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
abstract class ConfigurationsCollectionReference
    implements
        ConfigurationsQuery,
        FirestoreCollectionReference<Configurations,
            ConfigurationsQuerySnapshot> {
  factory ConfigurationsCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$ConfigurationsCollectionReference;

  static Configurations fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return Configurations.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    Configurations value,
    SetOptions? options,
  ) {
    return value.toJson();
  }

  @override
  CollectionReference<Configurations> get reference;

  @override
  ConfigurationsDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<ConfigurationsDocumentReference> add(Configurations value);
}

class _$ConfigurationsCollectionReference extends _$ConfigurationsQuery
    implements ConfigurationsCollectionReference {
  factory _$ConfigurationsCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$ConfigurationsCollectionReference._(
      firestore.collection('configurations').withConverter(
            fromFirestore: ConfigurationsCollectionReference.fromFirestore,
            toFirestore: ConfigurationsCollectionReference.toFirestore,
          ),
    );
  }

  _$ConfigurationsCollectionReference._(
    CollectionReference<Configurations> reference,
  ) : super(reference, $referenceWithoutCursor: reference);

  String get path => reference.path;

  @override
  CollectionReference<Configurations> get reference =>
      super.reference as CollectionReference<Configurations>;

  @override
  ConfigurationsDocumentReference doc([String? id]) {
    assert(
      id == null || id.split('/').length == 1,
      'The document ID cannot be from a different collection',
    );
    return ConfigurationsDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<ConfigurationsDocumentReference> add(Configurations value) {
    return reference
        .add(value)
        .then((ref) => ConfigurationsDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$ConfigurationsCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class ConfigurationsDocumentReference
    extends FirestoreDocumentReference<Configurations,
        ConfigurationsDocumentSnapshot> {
  factory ConfigurationsDocumentReference(
          DocumentReference<Configurations> reference) =
      _$ConfigurationsDocumentReference;

  DocumentReference<Configurations> get reference;

  /// A reference to the [ConfigurationsCollectionReference] containing this document.
  ConfigurationsCollectionReference get parent {
    return _$ConfigurationsCollectionReference(reference.firestore);
  }

  @override
  Stream<ConfigurationsDocumentSnapshot> snapshots();

  @override
  Future<ConfigurationsDocumentSnapshot> get([GetOptions? options]);

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
    Configurations model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue taxTypeFieldValue,
    FieldValue taxPercentageFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
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
    Configurations model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue taxTypeFieldValue,
    FieldValue taxPercentageFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
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
    Configurations model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue taxTypeFieldValue,
    FieldValue taxPercentageFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int? id,
    FieldValue idFieldValue,
    String? taxType,
    FieldValue taxTypeFieldValue,
    double? taxPercentage,
    FieldValue taxPercentageFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int? id,
    FieldValue idFieldValue,
    String? taxType,
    FieldValue taxTypeFieldValue,
    double? taxPercentage,
    FieldValue taxPercentageFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int? id,
    FieldValue idFieldValue,
    String? taxType,
    FieldValue taxTypeFieldValue,
    double? taxPercentage,
    FieldValue taxPercentageFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
  });
}

class _$ConfigurationsDocumentReference extends FirestoreDocumentReference<
    Configurations,
    ConfigurationsDocumentSnapshot> implements ConfigurationsDocumentReference {
  _$ConfigurationsDocumentReference(this.reference);

  @override
  final DocumentReference<Configurations> reference;

  /// A reference to the [ConfigurationsCollectionReference] containing this document.
  ConfigurationsCollectionReference get parent {
    return _$ConfigurationsCollectionReference(reference.firestore);
  }

  @override
  Stream<ConfigurationsDocumentSnapshot> snapshots() {
    return reference.snapshots().map(ConfigurationsDocumentSnapshot._);
  }

  @override
  Future<ConfigurationsDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then(ConfigurationsDocumentSnapshot._);
  }

  @override
  Future<ConfigurationsDocumentSnapshot> transactionGet(
      Transaction transaction) {
    return transaction.get(reference).then(ConfigurationsDocumentSnapshot._);
  }

  Future<void> set(
    Configurations model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? taxTypeFieldValue,
    FieldValue? taxPercentageFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$ConfigurationsFieldMap['id']!: idFieldValue,
      if (taxTypeFieldValue != null)
        _$ConfigurationsFieldMap['taxType']!: taxTypeFieldValue,
      if (taxPercentageFieldValue != null)
        _$ConfigurationsFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (businessIdFieldValue != null)
        _$ConfigurationsFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$ConfigurationsFieldMap['branchId']!: branchIdFieldValue,
    };

    final castedReference = reference.withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, options) => throw UnimplementedError(),
      toFirestore: (value, options) => value,
    );
    return castedReference.set(json, options);
  }

  void transactionSet(
    Transaction transaction,
    Configurations model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? taxTypeFieldValue,
    FieldValue? taxPercentageFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$ConfigurationsFieldMap['id']!: idFieldValue,
      if (taxTypeFieldValue != null)
        _$ConfigurationsFieldMap['taxType']!: taxTypeFieldValue,
      if (taxPercentageFieldValue != null)
        _$ConfigurationsFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (businessIdFieldValue != null)
        _$ConfigurationsFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$ConfigurationsFieldMap['branchId']!: branchIdFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Configurations model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? taxTypeFieldValue,
    FieldValue? taxPercentageFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$ConfigurationsFieldMap['id']!: idFieldValue,
      if (taxTypeFieldValue != null)
        _$ConfigurationsFieldMap['taxType']!: taxTypeFieldValue,
      if (taxPercentageFieldValue != null)
        _$ConfigurationsFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (businessIdFieldValue != null)
        _$ConfigurationsFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$ConfigurationsFieldMap['branchId']!: branchIdFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? taxType = _sentinel,
    FieldValue? taxTypeFieldValue,
    Object? taxPercentage = _sentinel,
    FieldValue? taxPercentageFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      taxType == _sentinel || taxTypeFieldValue == null,
      "Cannot specify both taxType and taxTypeFieldValue",
    );
    assert(
      taxPercentage == _sentinel || taxPercentageFieldValue == null,
      "Cannot specify both taxPercentage and taxPercentageFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$ConfigurationsFieldMap['id']!:
            _$ConfigurationsPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$ConfigurationsFieldMap['id']!: idFieldValue,
      if (taxType != _sentinel)
        _$ConfigurationsFieldMap['taxType']!:
            _$ConfigurationsPerFieldToJson.taxType(taxType as String?),
      if (taxTypeFieldValue != null)
        _$ConfigurationsFieldMap['taxType']!: taxTypeFieldValue,
      if (taxPercentage != _sentinel)
        _$ConfigurationsFieldMap['taxPercentage']!:
            _$ConfigurationsPerFieldToJson
                .taxPercentage(taxPercentage as double?),
      if (taxPercentageFieldValue != null)
        _$ConfigurationsFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (businessId != _sentinel)
        _$ConfigurationsFieldMap['businessId']!:
            _$ConfigurationsPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$ConfigurationsFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$ConfigurationsFieldMap['branchId']!:
            _$ConfigurationsPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$ConfigurationsFieldMap['branchId']!: branchIdFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? taxType = _sentinel,
    FieldValue? taxTypeFieldValue,
    Object? taxPercentage = _sentinel,
    FieldValue? taxPercentageFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      taxType == _sentinel || taxTypeFieldValue == null,
      "Cannot specify both taxType and taxTypeFieldValue",
    );
    assert(
      taxPercentage == _sentinel || taxPercentageFieldValue == null,
      "Cannot specify both taxPercentage and taxPercentageFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$ConfigurationsFieldMap['id']!:
            _$ConfigurationsPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$ConfigurationsFieldMap['id']!: idFieldValue,
      if (taxType != _sentinel)
        _$ConfigurationsFieldMap['taxType']!:
            _$ConfigurationsPerFieldToJson.taxType(taxType as String?),
      if (taxTypeFieldValue != null)
        _$ConfigurationsFieldMap['taxType']!: taxTypeFieldValue,
      if (taxPercentage != _sentinel)
        _$ConfigurationsFieldMap['taxPercentage']!:
            _$ConfigurationsPerFieldToJson
                .taxPercentage(taxPercentage as double?),
      if (taxPercentageFieldValue != null)
        _$ConfigurationsFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (businessId != _sentinel)
        _$ConfigurationsFieldMap['businessId']!:
            _$ConfigurationsPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$ConfigurationsFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$ConfigurationsFieldMap['branchId']!:
            _$ConfigurationsPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$ConfigurationsFieldMap['branchId']!: branchIdFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? taxType = _sentinel,
    FieldValue? taxTypeFieldValue,
    Object? taxPercentage = _sentinel,
    FieldValue? taxPercentageFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      taxType == _sentinel || taxTypeFieldValue == null,
      "Cannot specify both taxType and taxTypeFieldValue",
    );
    assert(
      taxPercentage == _sentinel || taxPercentageFieldValue == null,
      "Cannot specify both taxPercentage and taxPercentageFieldValue",
    );
    assert(
      businessId == _sentinel || businessIdFieldValue == null,
      "Cannot specify both businessId and businessIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$ConfigurationsFieldMap['id']!:
            _$ConfigurationsPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$ConfigurationsFieldMap['id']!: idFieldValue,
      if (taxType != _sentinel)
        _$ConfigurationsFieldMap['taxType']!:
            _$ConfigurationsPerFieldToJson.taxType(taxType as String?),
      if (taxTypeFieldValue != null)
        _$ConfigurationsFieldMap['taxType']!: taxTypeFieldValue,
      if (taxPercentage != _sentinel)
        _$ConfigurationsFieldMap['taxPercentage']!:
            _$ConfigurationsPerFieldToJson
                .taxPercentage(taxPercentage as double?),
      if (taxPercentageFieldValue != null)
        _$ConfigurationsFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (businessId != _sentinel)
        _$ConfigurationsFieldMap['businessId']!:
            _$ConfigurationsPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$ConfigurationsFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$ConfigurationsFieldMap['branchId']!:
            _$ConfigurationsPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$ConfigurationsFieldMap['branchId']!: branchIdFieldValue,
    };

    batch.update(reference, json);
  }

  @override
  bool operator ==(Object other) {
    return other is ConfigurationsDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

abstract class ConfigurationsQuery
    implements QueryReference<Configurations, ConfigurationsQuerySnapshot> {
  @override
  ConfigurationsQuery limit(int limit);

  @override
  ConfigurationsQuery limitToLast(int limit);

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
  ConfigurationsQuery whereFieldPath(
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

  ConfigurationsQuery whereDocumentId({
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

  ConfigurationsQuery whereId({
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

  ConfigurationsQuery whereTaxType({
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

  ConfigurationsQuery whereTaxPercentage({
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

  ConfigurationsQuery whereBusinessId({
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

  ConfigurationsQuery whereBranchId({
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
  ConfigurationsQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object startAt,
    Object startAfter,
    Object endAt,
    Object endBefore,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  });

  ConfigurationsQuery orderByDocumentId({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  });

  ConfigurationsQuery orderById({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  });

  ConfigurationsQuery orderByTaxType({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  });

  ConfigurationsQuery orderByTaxPercentage({
    bool descending = false,
    double? startAt,
    double? startAfter,
    double? endAt,
    double? endBefore,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  });

  ConfigurationsQuery orderByBusinessId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  });

  ConfigurationsQuery orderByBranchId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  });
}

class _$ConfigurationsQuery
    extends QueryReference<Configurations, ConfigurationsQuerySnapshot>
    implements ConfigurationsQuery {
  _$ConfigurationsQuery(
    this._collection, {
    required Query<Configurations> $referenceWithoutCursor,
    $QueryCursor $queryCursor = const $QueryCursor(),
  }) : super(
          $referenceWithoutCursor: $referenceWithoutCursor,
          $queryCursor: $queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<ConfigurationsQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference
        .snapshots()
        .map(ConfigurationsQuerySnapshot._fromQuerySnapshot);
  }

  @override
  Future<ConfigurationsQuerySnapshot> get([GetOptions? options]) {
    return reference
        .get(options)
        .then(ConfigurationsQuerySnapshot._fromQuerySnapshot);
  }

  @override
  ConfigurationsQuery limit(int limit) {
    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limit(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ConfigurationsQuery limitToLast(int limit) {
    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limitToLast(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ConfigurationsQuery whereFieldPath(
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
    return _$ConfigurationsQuery(
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
  ConfigurationsQuery whereDocumentId({
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
    return _$ConfigurationsQuery(
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
  ConfigurationsQuery whereId({
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
    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ConfigurationsFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ConfigurationsPerFieldToJson.id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson.id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ConfigurationsPerFieldToJson.id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson.id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$ConfigurationsPerFieldToJson.id(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ConfigurationsPerFieldToJson.id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ConfigurationsQuery whereTaxType({
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
    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ConfigurationsFieldMap['taxType']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.taxType(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.taxType(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ConfigurationsPerFieldToJson.taxType(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .taxType(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ConfigurationsPerFieldToJson.taxType(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .taxType(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ConfigurationsPerFieldToJson.taxType(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ConfigurationsPerFieldToJson.taxType(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ConfigurationsQuery whereTaxPercentage({
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
    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ConfigurationsFieldMap['taxPercentage']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.taxPercentage(isEqualTo as double?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson
                .taxPercentage(isNotEqualTo as double?)
            : null,
        isLessThan: isLessThan != null
            ? _$ConfigurationsPerFieldToJson
                .taxPercentage(isLessThan as double?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .taxPercentage(isLessThanOrEqualTo as double?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ConfigurationsPerFieldToJson
                .taxPercentage(isGreaterThan as double?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .taxPercentage(isGreaterThanOrEqualTo as double?)
            : null,
        whereIn: whereIn
            ?.map((e) => _$ConfigurationsPerFieldToJson.taxPercentage(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$ConfigurationsPerFieldToJson.taxPercentage(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ConfigurationsQuery whereBusinessId({
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
    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ConfigurationsFieldMap['businessId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.businessId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.businessId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ConfigurationsPerFieldToJson.businessId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .businessId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ConfigurationsPerFieldToJson.businessId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .businessId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn:
            whereIn?.map((e) => _$ConfigurationsPerFieldToJson.businessId(e)),
        whereNotIn: whereNotIn
            ?.map((e) => _$ConfigurationsPerFieldToJson.businessId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ConfigurationsQuery whereBranchId({
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
    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ConfigurationsFieldMap['branchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.branchId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ConfigurationsPerFieldToJson.branchId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ConfigurationsPerFieldToJson.branchId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .branchId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ConfigurationsPerFieldToJson.branchId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ConfigurationsPerFieldToJson
                .branchId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn:
            whereIn?.map((e) => _$ConfigurationsPerFieldToJson.branchId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ConfigurationsPerFieldToJson.branchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ConfigurationsQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
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

    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ConfigurationsQuery orderByDocumentId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
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

    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ConfigurationsQuery orderById({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ConfigurationsFieldMap['id']!, descending: descending);
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

    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ConfigurationsQuery orderByTaxType({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ConfigurationsFieldMap['taxType']!, descending: descending);
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

    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ConfigurationsQuery orderByTaxPercentage({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$ConfigurationsFieldMap['taxPercentage']!,
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

    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ConfigurationsQuery orderByBusinessId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$ConfigurationsFieldMap['businessId']!,
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

    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ConfigurationsQuery orderByBranchId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ConfigurationsDocumentSnapshot? startAtDocument,
    ConfigurationsDocumentSnapshot? endAtDocument,
    ConfigurationsDocumentSnapshot? endBeforeDocument,
    ConfigurationsDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ConfigurationsFieldMap['branchId']!, descending: descending);
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

    return _$ConfigurationsQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$ConfigurationsQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class ConfigurationsDocumentSnapshot
    extends FirestoreDocumentSnapshot<Configurations> {
  ConfigurationsDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final DocumentSnapshot<Configurations> snapshot;

  @override
  ConfigurationsDocumentReference get reference {
    return ConfigurationsDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Configurations? data;
}

class ConfigurationsQuerySnapshot extends FirestoreQuerySnapshot<Configurations,
    ConfigurationsQueryDocumentSnapshot> {
  ConfigurationsQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  factory ConfigurationsQuerySnapshot._fromQuerySnapshot(
    QuerySnapshot<Configurations> snapshot,
  ) {
    final docs =
        snapshot.docs.map(ConfigurationsQueryDocumentSnapshot._).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return _decodeDocumentChange(
        change,
        ConfigurationsDocumentSnapshot._,
      );
    }).toList();

    return ConfigurationsQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  static FirestoreDocumentChange<ConfigurationsDocumentSnapshot>
      _decodeDocumentChange<T>(
    DocumentChange<T> docChange,
    ConfigurationsDocumentSnapshot Function(DocumentSnapshot<T> doc) decodeDoc,
  ) {
    return FirestoreDocumentChange<ConfigurationsDocumentSnapshot>(
      type: docChange.type,
      oldIndex: docChange.oldIndex,
      newIndex: docChange.newIndex,
      doc: decodeDoc(docChange.doc),
    );
  }

  final QuerySnapshot<Configurations> snapshot;

  @override
  final List<ConfigurationsQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<ConfigurationsDocumentSnapshot>>
      docChanges;
}

class ConfigurationsQueryDocumentSnapshot
    extends FirestoreQueryDocumentSnapshot<Configurations>
    implements ConfigurationsDocumentSnapshot {
  ConfigurationsQueryDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final QueryDocumentSnapshot<Configurations> snapshot;

  @override
  final Configurations data;

  @override
  ConfigurationsDocumentReference get reference {
    return ConfigurationsDocumentReference(snapshot.reference);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Configurations _$ConfigurationsFromJson(Map<String, dynamic> json) =>
    Configurations(
      id: (json['id'] as num?)?.toInt(),
      taxType: json['taxType'] as String?,
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble(),
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
    );

const _$ConfigurationsFieldMap = <String, String>{
  'id': 'id',
  'taxType': 'taxType',
  'taxPercentage': 'taxPercentage',
  'businessId': 'businessId',
  'branchId': 'branchId',
};

// ignore: unused_element
abstract class _$ConfigurationsPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? taxType(String? instance) => instance;
  // ignore: unused_element
  static Object? taxPercentage(double? instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
}

Map<String, dynamic> _$ConfigurationsToJson(Configurations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taxType': instance.taxType,
      'taxPercentage': instance.taxPercentage,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
    };
