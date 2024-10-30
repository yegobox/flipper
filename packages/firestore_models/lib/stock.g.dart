// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

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
    FieldValue bhfIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue variantIdFieldValue,
    FieldValue currentStockFieldValue,
    FieldValue lowStockFieldValue,
    FieldValue canTrackingStockFieldValue,
    FieldValue showLowStockAlertFieldValue,
    FieldValue productIdFieldValue,
    FieldValue activeFieldValue,
    FieldValue valueFieldValue,
    FieldValue rsdQtyFieldValue,
    FieldValue supplyPriceFieldValue,
    FieldValue retailPriceFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue deletedAtFieldValue,
    FieldValue ebmSyncedFieldValue,
    FieldValue cloudSyncedFieldValue,
    FieldValue variantFieldValue,
    FieldValue initialStockFieldValue,
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
    FieldValue bhfIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue variantIdFieldValue,
    FieldValue currentStockFieldValue,
    FieldValue lowStockFieldValue,
    FieldValue canTrackingStockFieldValue,
    FieldValue showLowStockAlertFieldValue,
    FieldValue productIdFieldValue,
    FieldValue activeFieldValue,
    FieldValue valueFieldValue,
    FieldValue rsdQtyFieldValue,
    FieldValue supplyPriceFieldValue,
    FieldValue retailPriceFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue deletedAtFieldValue,
    FieldValue ebmSyncedFieldValue,
    FieldValue cloudSyncedFieldValue,
    FieldValue variantFieldValue,
    FieldValue initialStockFieldValue,
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
    FieldValue bhfIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue variantIdFieldValue,
    FieldValue currentStockFieldValue,
    FieldValue lowStockFieldValue,
    FieldValue canTrackingStockFieldValue,
    FieldValue showLowStockAlertFieldValue,
    FieldValue productIdFieldValue,
    FieldValue activeFieldValue,
    FieldValue valueFieldValue,
    FieldValue rsdQtyFieldValue,
    FieldValue supplyPriceFieldValue,
    FieldValue retailPriceFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue deletedAtFieldValue,
    FieldValue ebmSyncedFieldValue,
    FieldValue cloudSyncedFieldValue,
    FieldValue variantFieldValue,
    FieldValue initialStockFieldValue,
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
    String? bhfId,
    FieldValue bhfIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    int? variantId,
    FieldValue variantIdFieldValue,
    double currentStock,
    FieldValue currentStockFieldValue,
    double lowStock,
    FieldValue lowStockFieldValue,
    bool? canTrackingStock,
    FieldValue canTrackingStockFieldValue,
    bool? showLowStockAlert,
    FieldValue showLowStockAlertFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    bool? active,
    FieldValue activeFieldValue,
    double value,
    FieldValue valueFieldValue,
    double rsdQty,
    FieldValue rsdQtyFieldValue,
    double supplyPrice,
    FieldValue supplyPriceFieldValue,
    double retailPrice,
    FieldValue retailPriceFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    bool ebmSynced,
    FieldValue ebmSyncedFieldValue,
    bool cloudSynced,
    FieldValue cloudSyncedFieldValue,
    Variant? variant,
    FieldValue variantFieldValue,
    double? initialStock,
    FieldValue initialStockFieldValue,
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
    String? bhfId,
    FieldValue bhfIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    int? variantId,
    FieldValue variantIdFieldValue,
    double currentStock,
    FieldValue currentStockFieldValue,
    double lowStock,
    FieldValue lowStockFieldValue,
    bool? canTrackingStock,
    FieldValue canTrackingStockFieldValue,
    bool? showLowStockAlert,
    FieldValue showLowStockAlertFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    bool? active,
    FieldValue activeFieldValue,
    double value,
    FieldValue valueFieldValue,
    double rsdQty,
    FieldValue rsdQtyFieldValue,
    double supplyPrice,
    FieldValue supplyPriceFieldValue,
    double retailPrice,
    FieldValue retailPriceFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    bool ebmSynced,
    FieldValue ebmSyncedFieldValue,
    bool cloudSynced,
    FieldValue cloudSyncedFieldValue,
    Variant? variant,
    FieldValue variantFieldValue,
    double? initialStock,
    FieldValue initialStockFieldValue,
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
    String? bhfId,
    FieldValue bhfIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    int? variantId,
    FieldValue variantIdFieldValue,
    double currentStock,
    FieldValue currentStockFieldValue,
    double lowStock,
    FieldValue lowStockFieldValue,
    bool? canTrackingStock,
    FieldValue canTrackingStockFieldValue,
    bool? showLowStockAlert,
    FieldValue showLowStockAlertFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    bool? active,
    FieldValue activeFieldValue,
    double value,
    FieldValue valueFieldValue,
    double rsdQty,
    FieldValue rsdQtyFieldValue,
    double supplyPrice,
    FieldValue supplyPriceFieldValue,
    double retailPrice,
    FieldValue retailPriceFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    bool ebmSynced,
    FieldValue ebmSyncedFieldValue,
    bool cloudSynced,
    FieldValue cloudSyncedFieldValue,
    Variant? variant,
    FieldValue variantFieldValue,
    double? initialStock,
    FieldValue initialStockFieldValue,
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
    FieldValue? bhfIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? variantIdFieldValue,
    FieldValue? currentStockFieldValue,
    FieldValue? lowStockFieldValue,
    FieldValue? canTrackingStockFieldValue,
    FieldValue? showLowStockAlertFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? activeFieldValue,
    FieldValue? valueFieldValue,
    FieldValue? rsdQtyFieldValue,
    FieldValue? supplyPriceFieldValue,
    FieldValue? retailPriceFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? deletedAtFieldValue,
    FieldValue? ebmSyncedFieldValue,
    FieldValue? cloudSyncedFieldValue,
    FieldValue? variantFieldValue,
    FieldValue? initialStockFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhfIdFieldValue != null) _$StockFieldMap['bhfId']!: bhfIdFieldValue,
      if (branchIdFieldValue != null)
        _$StockFieldMap['branchId']!: branchIdFieldValue,
      if (variantIdFieldValue != null)
        _$StockFieldMap['variantId']!: variantIdFieldValue,
      if (currentStockFieldValue != null)
        _$StockFieldMap['currentStock']!: currentStockFieldValue,
      if (lowStockFieldValue != null)
        _$StockFieldMap['lowStock']!: lowStockFieldValue,
      if (canTrackingStockFieldValue != null)
        _$StockFieldMap['canTrackingStock']!: canTrackingStockFieldValue,
      if (showLowStockAlertFieldValue != null)
        _$StockFieldMap['showLowStockAlert']!: showLowStockAlertFieldValue,
      if (productIdFieldValue != null)
        _$StockFieldMap['productId']!: productIdFieldValue,
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsdQtyFieldValue != null)
        _$StockFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (supplyPriceFieldValue != null)
        _$StockFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPriceFieldValue != null)
        _$StockFieldMap['retailPrice']!: retailPriceFieldValue,
      if (lastTouchedFieldValue != null)
        _$StockFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAtFieldValue != null)
        _$StockFieldMap['deletedAt']!: deletedAtFieldValue,
      if (ebmSyncedFieldValue != null)
        _$StockFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (cloudSyncedFieldValue != null)
        _$StockFieldMap['cloudSynced']!: cloudSyncedFieldValue,
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initialStockFieldValue != null)
        _$StockFieldMap['initialStock']!: initialStockFieldValue,
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
    FieldValue? bhfIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? variantIdFieldValue,
    FieldValue? currentStockFieldValue,
    FieldValue? lowStockFieldValue,
    FieldValue? canTrackingStockFieldValue,
    FieldValue? showLowStockAlertFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? activeFieldValue,
    FieldValue? valueFieldValue,
    FieldValue? rsdQtyFieldValue,
    FieldValue? supplyPriceFieldValue,
    FieldValue? retailPriceFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? deletedAtFieldValue,
    FieldValue? ebmSyncedFieldValue,
    FieldValue? cloudSyncedFieldValue,
    FieldValue? variantFieldValue,
    FieldValue? initialStockFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhfIdFieldValue != null) _$StockFieldMap['bhfId']!: bhfIdFieldValue,
      if (branchIdFieldValue != null)
        _$StockFieldMap['branchId']!: branchIdFieldValue,
      if (variantIdFieldValue != null)
        _$StockFieldMap['variantId']!: variantIdFieldValue,
      if (currentStockFieldValue != null)
        _$StockFieldMap['currentStock']!: currentStockFieldValue,
      if (lowStockFieldValue != null)
        _$StockFieldMap['lowStock']!: lowStockFieldValue,
      if (canTrackingStockFieldValue != null)
        _$StockFieldMap['canTrackingStock']!: canTrackingStockFieldValue,
      if (showLowStockAlertFieldValue != null)
        _$StockFieldMap['showLowStockAlert']!: showLowStockAlertFieldValue,
      if (productIdFieldValue != null)
        _$StockFieldMap['productId']!: productIdFieldValue,
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsdQtyFieldValue != null)
        _$StockFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (supplyPriceFieldValue != null)
        _$StockFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPriceFieldValue != null)
        _$StockFieldMap['retailPrice']!: retailPriceFieldValue,
      if (lastTouchedFieldValue != null)
        _$StockFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAtFieldValue != null)
        _$StockFieldMap['deletedAt']!: deletedAtFieldValue,
      if (ebmSyncedFieldValue != null)
        _$StockFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (cloudSyncedFieldValue != null)
        _$StockFieldMap['cloudSynced']!: cloudSyncedFieldValue,
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initialStockFieldValue != null)
        _$StockFieldMap['initialStock']!: initialStockFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Stock model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhfIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? variantIdFieldValue,
    FieldValue? currentStockFieldValue,
    FieldValue? lowStockFieldValue,
    FieldValue? canTrackingStockFieldValue,
    FieldValue? showLowStockAlertFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? activeFieldValue,
    FieldValue? valueFieldValue,
    FieldValue? rsdQtyFieldValue,
    FieldValue? supplyPriceFieldValue,
    FieldValue? retailPriceFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? deletedAtFieldValue,
    FieldValue? ebmSyncedFieldValue,
    FieldValue? cloudSyncedFieldValue,
    FieldValue? variantFieldValue,
    FieldValue? initialStockFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhfIdFieldValue != null) _$StockFieldMap['bhfId']!: bhfIdFieldValue,
      if (branchIdFieldValue != null)
        _$StockFieldMap['branchId']!: branchIdFieldValue,
      if (variantIdFieldValue != null)
        _$StockFieldMap['variantId']!: variantIdFieldValue,
      if (currentStockFieldValue != null)
        _$StockFieldMap['currentStock']!: currentStockFieldValue,
      if (lowStockFieldValue != null)
        _$StockFieldMap['lowStock']!: lowStockFieldValue,
      if (canTrackingStockFieldValue != null)
        _$StockFieldMap['canTrackingStock']!: canTrackingStockFieldValue,
      if (showLowStockAlertFieldValue != null)
        _$StockFieldMap['showLowStockAlert']!: showLowStockAlertFieldValue,
      if (productIdFieldValue != null)
        _$StockFieldMap['productId']!: productIdFieldValue,
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsdQtyFieldValue != null)
        _$StockFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (supplyPriceFieldValue != null)
        _$StockFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPriceFieldValue != null)
        _$StockFieldMap['retailPrice']!: retailPriceFieldValue,
      if (lastTouchedFieldValue != null)
        _$StockFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAtFieldValue != null)
        _$StockFieldMap['deletedAt']!: deletedAtFieldValue,
      if (ebmSyncedFieldValue != null)
        _$StockFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (cloudSyncedFieldValue != null)
        _$StockFieldMap['cloudSynced']!: cloudSyncedFieldValue,
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initialStockFieldValue != null)
        _$StockFieldMap['initialStock']!: initialStockFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhfId = _sentinel,
    FieldValue? bhfIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? variantId = _sentinel,
    FieldValue? variantIdFieldValue,
    Object? currentStock = _sentinel,
    FieldValue? currentStockFieldValue,
    Object? lowStock = _sentinel,
    FieldValue? lowStockFieldValue,
    Object? canTrackingStock = _sentinel,
    FieldValue? canTrackingStockFieldValue,
    Object? showLowStockAlert = _sentinel,
    FieldValue? showLowStockAlertFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? active = _sentinel,
    FieldValue? activeFieldValue,
    Object? value = _sentinel,
    FieldValue? valueFieldValue,
    Object? rsdQty = _sentinel,
    FieldValue? rsdQtyFieldValue,
    Object? supplyPrice = _sentinel,
    FieldValue? supplyPriceFieldValue,
    Object? retailPrice = _sentinel,
    FieldValue? retailPriceFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? ebmSynced = _sentinel,
    FieldValue? ebmSyncedFieldValue,
    Object? cloudSynced = _sentinel,
    FieldValue? cloudSyncedFieldValue,
    Object? variant = _sentinel,
    FieldValue? variantFieldValue,
    Object? initialStock = _sentinel,
    FieldValue? initialStockFieldValue,
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
      bhfId == _sentinel || bhfIdFieldValue == null,
      "Cannot specify both bhfId and bhfIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      variantId == _sentinel || variantIdFieldValue == null,
      "Cannot specify both variantId and variantIdFieldValue",
    );
    assert(
      currentStock == _sentinel || currentStockFieldValue == null,
      "Cannot specify both currentStock and currentStockFieldValue",
    );
    assert(
      lowStock == _sentinel || lowStockFieldValue == null,
      "Cannot specify both lowStock and lowStockFieldValue",
    );
    assert(
      canTrackingStock == _sentinel || canTrackingStockFieldValue == null,
      "Cannot specify both canTrackingStock and canTrackingStockFieldValue",
    );
    assert(
      showLowStockAlert == _sentinel || showLowStockAlertFieldValue == null,
      "Cannot specify both showLowStockAlert and showLowStockAlertFieldValue",
    );
    assert(
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
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
      rsdQty == _sentinel || rsdQtyFieldValue == null,
      "Cannot specify both rsdQty and rsdQtyFieldValue",
    );
    assert(
      supplyPrice == _sentinel || supplyPriceFieldValue == null,
      "Cannot specify both supplyPrice and supplyPriceFieldValue",
    );
    assert(
      retailPrice == _sentinel || retailPriceFieldValue == null,
      "Cannot specify both retailPrice and retailPriceFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
    );
    assert(
      deletedAt == _sentinel || deletedAtFieldValue == null,
      "Cannot specify both deletedAt and deletedAtFieldValue",
    );
    assert(
      ebmSynced == _sentinel || ebmSyncedFieldValue == null,
      "Cannot specify both ebmSynced and ebmSyncedFieldValue",
    );
    assert(
      cloudSynced == _sentinel || cloudSyncedFieldValue == null,
      "Cannot specify both cloudSynced and cloudSyncedFieldValue",
    );
    assert(
      variant == _sentinel || variantFieldValue == null,
      "Cannot specify both variant and variantFieldValue",
    );
    assert(
      initialStock == _sentinel || initialStockFieldValue == null,
      "Cannot specify both initialStock and initialStockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockFieldMap['id']!: _$StockPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tin != _sentinel)
        _$StockFieldMap['tin']!: _$StockPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhfId != _sentinel)
        _$StockFieldMap['bhfId']!:
            _$StockPerFieldToJson.bhfId(bhfId as String?),
      if (bhfIdFieldValue != null) _$StockFieldMap['bhfId']!: bhfIdFieldValue,
      if (branchId != _sentinel)
        _$StockFieldMap['branchId']!:
            _$StockPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$StockFieldMap['branchId']!: branchIdFieldValue,
      if (variantId != _sentinel)
        _$StockFieldMap['variantId']!:
            _$StockPerFieldToJson.variantId(variantId as int?),
      if (variantIdFieldValue != null)
        _$StockFieldMap['variantId']!: variantIdFieldValue,
      if (currentStock != _sentinel)
        _$StockFieldMap['currentStock']!:
            _$StockPerFieldToJson.currentStock(currentStock as double),
      if (currentStockFieldValue != null)
        _$StockFieldMap['currentStock']!: currentStockFieldValue,
      if (lowStock != _sentinel)
        _$StockFieldMap['lowStock']!:
            _$StockPerFieldToJson.lowStock(lowStock as double),
      if (lowStockFieldValue != null)
        _$StockFieldMap['lowStock']!: lowStockFieldValue,
      if (canTrackingStock != _sentinel)
        _$StockFieldMap['canTrackingStock']!:
            _$StockPerFieldToJson.canTrackingStock(canTrackingStock as bool?),
      if (canTrackingStockFieldValue != null)
        _$StockFieldMap['canTrackingStock']!: canTrackingStockFieldValue,
      if (showLowStockAlert != _sentinel)
        _$StockFieldMap['showLowStockAlert']!:
            _$StockPerFieldToJson.showLowStockAlert(showLowStockAlert as bool?),
      if (showLowStockAlertFieldValue != null)
        _$StockFieldMap['showLowStockAlert']!: showLowStockAlertFieldValue,
      if (productId != _sentinel)
        _$StockFieldMap['productId']!:
            _$StockPerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$StockFieldMap['productId']!: productIdFieldValue,
      if (active != _sentinel)
        _$StockFieldMap['active']!:
            _$StockPerFieldToJson.active(active as bool?),
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (value != _sentinel)
        _$StockFieldMap['value']!: _$StockPerFieldToJson.value(value as double),
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsdQty != _sentinel)
        _$StockFieldMap['rsdQty']!:
            _$StockPerFieldToJson.rsdQty(rsdQty as double),
      if (rsdQtyFieldValue != null)
        _$StockFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (supplyPrice != _sentinel)
        _$StockFieldMap['supplyPrice']!:
            _$StockPerFieldToJson.supplyPrice(supplyPrice as double),
      if (supplyPriceFieldValue != null)
        _$StockFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPrice != _sentinel)
        _$StockFieldMap['retailPrice']!:
            _$StockPerFieldToJson.retailPrice(retailPrice as double),
      if (retailPriceFieldValue != null)
        _$StockFieldMap['retailPrice']!: retailPriceFieldValue,
      if (lastTouched != _sentinel)
        _$StockFieldMap['lastTouched']!:
            _$StockPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$StockFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAt != _sentinel)
        _$StockFieldMap['deletedAt']!:
            _$StockPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$StockFieldMap['deletedAt']!: deletedAtFieldValue,
      if (ebmSynced != _sentinel)
        _$StockFieldMap['ebmSynced']!:
            _$StockPerFieldToJson.ebmSynced(ebmSynced as bool),
      if (ebmSyncedFieldValue != null)
        _$StockFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (cloudSynced != _sentinel)
        _$StockFieldMap['cloudSynced']!:
            _$StockPerFieldToJson.cloudSynced(cloudSynced as bool),
      if (cloudSyncedFieldValue != null)
        _$StockFieldMap['cloudSynced']!: cloudSyncedFieldValue,
      if (variant != _sentinel)
        _$StockFieldMap['variant']!:
            _$StockPerFieldToJson.variant(variant as Variant?),
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initialStock != _sentinel)
        _$StockFieldMap['initialStock']!:
            _$StockPerFieldToJson.initialStock(initialStock as double?),
      if (initialStockFieldValue != null)
        _$StockFieldMap['initialStock']!: initialStockFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhfId = _sentinel,
    FieldValue? bhfIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? variantId = _sentinel,
    FieldValue? variantIdFieldValue,
    Object? currentStock = _sentinel,
    FieldValue? currentStockFieldValue,
    Object? lowStock = _sentinel,
    FieldValue? lowStockFieldValue,
    Object? canTrackingStock = _sentinel,
    FieldValue? canTrackingStockFieldValue,
    Object? showLowStockAlert = _sentinel,
    FieldValue? showLowStockAlertFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? active = _sentinel,
    FieldValue? activeFieldValue,
    Object? value = _sentinel,
    FieldValue? valueFieldValue,
    Object? rsdQty = _sentinel,
    FieldValue? rsdQtyFieldValue,
    Object? supplyPrice = _sentinel,
    FieldValue? supplyPriceFieldValue,
    Object? retailPrice = _sentinel,
    FieldValue? retailPriceFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? ebmSynced = _sentinel,
    FieldValue? ebmSyncedFieldValue,
    Object? cloudSynced = _sentinel,
    FieldValue? cloudSyncedFieldValue,
    Object? variant = _sentinel,
    FieldValue? variantFieldValue,
    Object? initialStock = _sentinel,
    FieldValue? initialStockFieldValue,
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
      bhfId == _sentinel || bhfIdFieldValue == null,
      "Cannot specify both bhfId and bhfIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      variantId == _sentinel || variantIdFieldValue == null,
      "Cannot specify both variantId and variantIdFieldValue",
    );
    assert(
      currentStock == _sentinel || currentStockFieldValue == null,
      "Cannot specify both currentStock and currentStockFieldValue",
    );
    assert(
      lowStock == _sentinel || lowStockFieldValue == null,
      "Cannot specify both lowStock and lowStockFieldValue",
    );
    assert(
      canTrackingStock == _sentinel || canTrackingStockFieldValue == null,
      "Cannot specify both canTrackingStock and canTrackingStockFieldValue",
    );
    assert(
      showLowStockAlert == _sentinel || showLowStockAlertFieldValue == null,
      "Cannot specify both showLowStockAlert and showLowStockAlertFieldValue",
    );
    assert(
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
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
      rsdQty == _sentinel || rsdQtyFieldValue == null,
      "Cannot specify both rsdQty and rsdQtyFieldValue",
    );
    assert(
      supplyPrice == _sentinel || supplyPriceFieldValue == null,
      "Cannot specify both supplyPrice and supplyPriceFieldValue",
    );
    assert(
      retailPrice == _sentinel || retailPriceFieldValue == null,
      "Cannot specify both retailPrice and retailPriceFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
    );
    assert(
      deletedAt == _sentinel || deletedAtFieldValue == null,
      "Cannot specify both deletedAt and deletedAtFieldValue",
    );
    assert(
      ebmSynced == _sentinel || ebmSyncedFieldValue == null,
      "Cannot specify both ebmSynced and ebmSyncedFieldValue",
    );
    assert(
      cloudSynced == _sentinel || cloudSyncedFieldValue == null,
      "Cannot specify both cloudSynced and cloudSyncedFieldValue",
    );
    assert(
      variant == _sentinel || variantFieldValue == null,
      "Cannot specify both variant and variantFieldValue",
    );
    assert(
      initialStock == _sentinel || initialStockFieldValue == null,
      "Cannot specify both initialStock and initialStockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockFieldMap['id']!: _$StockPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tin != _sentinel)
        _$StockFieldMap['tin']!: _$StockPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhfId != _sentinel)
        _$StockFieldMap['bhfId']!:
            _$StockPerFieldToJson.bhfId(bhfId as String?),
      if (bhfIdFieldValue != null) _$StockFieldMap['bhfId']!: bhfIdFieldValue,
      if (branchId != _sentinel)
        _$StockFieldMap['branchId']!:
            _$StockPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$StockFieldMap['branchId']!: branchIdFieldValue,
      if (variantId != _sentinel)
        _$StockFieldMap['variantId']!:
            _$StockPerFieldToJson.variantId(variantId as int?),
      if (variantIdFieldValue != null)
        _$StockFieldMap['variantId']!: variantIdFieldValue,
      if (currentStock != _sentinel)
        _$StockFieldMap['currentStock']!:
            _$StockPerFieldToJson.currentStock(currentStock as double),
      if (currentStockFieldValue != null)
        _$StockFieldMap['currentStock']!: currentStockFieldValue,
      if (lowStock != _sentinel)
        _$StockFieldMap['lowStock']!:
            _$StockPerFieldToJson.lowStock(lowStock as double),
      if (lowStockFieldValue != null)
        _$StockFieldMap['lowStock']!: lowStockFieldValue,
      if (canTrackingStock != _sentinel)
        _$StockFieldMap['canTrackingStock']!:
            _$StockPerFieldToJson.canTrackingStock(canTrackingStock as bool?),
      if (canTrackingStockFieldValue != null)
        _$StockFieldMap['canTrackingStock']!: canTrackingStockFieldValue,
      if (showLowStockAlert != _sentinel)
        _$StockFieldMap['showLowStockAlert']!:
            _$StockPerFieldToJson.showLowStockAlert(showLowStockAlert as bool?),
      if (showLowStockAlertFieldValue != null)
        _$StockFieldMap['showLowStockAlert']!: showLowStockAlertFieldValue,
      if (productId != _sentinel)
        _$StockFieldMap['productId']!:
            _$StockPerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$StockFieldMap['productId']!: productIdFieldValue,
      if (active != _sentinel)
        _$StockFieldMap['active']!:
            _$StockPerFieldToJson.active(active as bool?),
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (value != _sentinel)
        _$StockFieldMap['value']!: _$StockPerFieldToJson.value(value as double),
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsdQty != _sentinel)
        _$StockFieldMap['rsdQty']!:
            _$StockPerFieldToJson.rsdQty(rsdQty as double),
      if (rsdQtyFieldValue != null)
        _$StockFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (supplyPrice != _sentinel)
        _$StockFieldMap['supplyPrice']!:
            _$StockPerFieldToJson.supplyPrice(supplyPrice as double),
      if (supplyPriceFieldValue != null)
        _$StockFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPrice != _sentinel)
        _$StockFieldMap['retailPrice']!:
            _$StockPerFieldToJson.retailPrice(retailPrice as double),
      if (retailPriceFieldValue != null)
        _$StockFieldMap['retailPrice']!: retailPriceFieldValue,
      if (lastTouched != _sentinel)
        _$StockFieldMap['lastTouched']!:
            _$StockPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$StockFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAt != _sentinel)
        _$StockFieldMap['deletedAt']!:
            _$StockPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$StockFieldMap['deletedAt']!: deletedAtFieldValue,
      if (ebmSynced != _sentinel)
        _$StockFieldMap['ebmSynced']!:
            _$StockPerFieldToJson.ebmSynced(ebmSynced as bool),
      if (ebmSyncedFieldValue != null)
        _$StockFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (cloudSynced != _sentinel)
        _$StockFieldMap['cloudSynced']!:
            _$StockPerFieldToJson.cloudSynced(cloudSynced as bool),
      if (cloudSyncedFieldValue != null)
        _$StockFieldMap['cloudSynced']!: cloudSyncedFieldValue,
      if (variant != _sentinel)
        _$StockFieldMap['variant']!:
            _$StockPerFieldToJson.variant(variant as Variant?),
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initialStock != _sentinel)
        _$StockFieldMap['initialStock']!:
            _$StockPerFieldToJson.initialStock(initialStock as double?),
      if (initialStockFieldValue != null)
        _$StockFieldMap['initialStock']!: initialStockFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhfId = _sentinel,
    FieldValue? bhfIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? variantId = _sentinel,
    FieldValue? variantIdFieldValue,
    Object? currentStock = _sentinel,
    FieldValue? currentStockFieldValue,
    Object? lowStock = _sentinel,
    FieldValue? lowStockFieldValue,
    Object? canTrackingStock = _sentinel,
    FieldValue? canTrackingStockFieldValue,
    Object? showLowStockAlert = _sentinel,
    FieldValue? showLowStockAlertFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? active = _sentinel,
    FieldValue? activeFieldValue,
    Object? value = _sentinel,
    FieldValue? valueFieldValue,
    Object? rsdQty = _sentinel,
    FieldValue? rsdQtyFieldValue,
    Object? supplyPrice = _sentinel,
    FieldValue? supplyPriceFieldValue,
    Object? retailPrice = _sentinel,
    FieldValue? retailPriceFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? ebmSynced = _sentinel,
    FieldValue? ebmSyncedFieldValue,
    Object? cloudSynced = _sentinel,
    FieldValue? cloudSyncedFieldValue,
    Object? variant = _sentinel,
    FieldValue? variantFieldValue,
    Object? initialStock = _sentinel,
    FieldValue? initialStockFieldValue,
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
      bhfId == _sentinel || bhfIdFieldValue == null,
      "Cannot specify both bhfId and bhfIdFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      variantId == _sentinel || variantIdFieldValue == null,
      "Cannot specify both variantId and variantIdFieldValue",
    );
    assert(
      currentStock == _sentinel || currentStockFieldValue == null,
      "Cannot specify both currentStock and currentStockFieldValue",
    );
    assert(
      lowStock == _sentinel || lowStockFieldValue == null,
      "Cannot specify both lowStock and lowStockFieldValue",
    );
    assert(
      canTrackingStock == _sentinel || canTrackingStockFieldValue == null,
      "Cannot specify both canTrackingStock and canTrackingStockFieldValue",
    );
    assert(
      showLowStockAlert == _sentinel || showLowStockAlertFieldValue == null,
      "Cannot specify both showLowStockAlert and showLowStockAlertFieldValue",
    );
    assert(
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
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
      rsdQty == _sentinel || rsdQtyFieldValue == null,
      "Cannot specify both rsdQty and rsdQtyFieldValue",
    );
    assert(
      supplyPrice == _sentinel || supplyPriceFieldValue == null,
      "Cannot specify both supplyPrice and supplyPriceFieldValue",
    );
    assert(
      retailPrice == _sentinel || retailPriceFieldValue == null,
      "Cannot specify both retailPrice and retailPriceFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
    );
    assert(
      deletedAt == _sentinel || deletedAtFieldValue == null,
      "Cannot specify both deletedAt and deletedAtFieldValue",
    );
    assert(
      ebmSynced == _sentinel || ebmSyncedFieldValue == null,
      "Cannot specify both ebmSynced and ebmSyncedFieldValue",
    );
    assert(
      cloudSynced == _sentinel || cloudSyncedFieldValue == null,
      "Cannot specify both cloudSynced and cloudSyncedFieldValue",
    );
    assert(
      variant == _sentinel || variantFieldValue == null,
      "Cannot specify both variant and variantFieldValue",
    );
    assert(
      initialStock == _sentinel || initialStockFieldValue == null,
      "Cannot specify both initialStock and initialStockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$StockFieldMap['id']!: _$StockPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$StockFieldMap['id']!: idFieldValue,
      if (tin != _sentinel)
        _$StockFieldMap['tin']!: _$StockPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$StockFieldMap['tin']!: tinFieldValue,
      if (bhfId != _sentinel)
        _$StockFieldMap['bhfId']!:
            _$StockPerFieldToJson.bhfId(bhfId as String?),
      if (bhfIdFieldValue != null) _$StockFieldMap['bhfId']!: bhfIdFieldValue,
      if (branchId != _sentinel)
        _$StockFieldMap['branchId']!:
            _$StockPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$StockFieldMap['branchId']!: branchIdFieldValue,
      if (variantId != _sentinel)
        _$StockFieldMap['variantId']!:
            _$StockPerFieldToJson.variantId(variantId as int?),
      if (variantIdFieldValue != null)
        _$StockFieldMap['variantId']!: variantIdFieldValue,
      if (currentStock != _sentinel)
        _$StockFieldMap['currentStock']!:
            _$StockPerFieldToJson.currentStock(currentStock as double),
      if (currentStockFieldValue != null)
        _$StockFieldMap['currentStock']!: currentStockFieldValue,
      if (lowStock != _sentinel)
        _$StockFieldMap['lowStock']!:
            _$StockPerFieldToJson.lowStock(lowStock as double),
      if (lowStockFieldValue != null)
        _$StockFieldMap['lowStock']!: lowStockFieldValue,
      if (canTrackingStock != _sentinel)
        _$StockFieldMap['canTrackingStock']!:
            _$StockPerFieldToJson.canTrackingStock(canTrackingStock as bool?),
      if (canTrackingStockFieldValue != null)
        _$StockFieldMap['canTrackingStock']!: canTrackingStockFieldValue,
      if (showLowStockAlert != _sentinel)
        _$StockFieldMap['showLowStockAlert']!:
            _$StockPerFieldToJson.showLowStockAlert(showLowStockAlert as bool?),
      if (showLowStockAlertFieldValue != null)
        _$StockFieldMap['showLowStockAlert']!: showLowStockAlertFieldValue,
      if (productId != _sentinel)
        _$StockFieldMap['productId']!:
            _$StockPerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$StockFieldMap['productId']!: productIdFieldValue,
      if (active != _sentinel)
        _$StockFieldMap['active']!:
            _$StockPerFieldToJson.active(active as bool?),
      if (activeFieldValue != null)
        _$StockFieldMap['active']!: activeFieldValue,
      if (value != _sentinel)
        _$StockFieldMap['value']!: _$StockPerFieldToJson.value(value as double),
      if (valueFieldValue != null) _$StockFieldMap['value']!: valueFieldValue,
      if (rsdQty != _sentinel)
        _$StockFieldMap['rsdQty']!:
            _$StockPerFieldToJson.rsdQty(rsdQty as double),
      if (rsdQtyFieldValue != null)
        _$StockFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (supplyPrice != _sentinel)
        _$StockFieldMap['supplyPrice']!:
            _$StockPerFieldToJson.supplyPrice(supplyPrice as double),
      if (supplyPriceFieldValue != null)
        _$StockFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPrice != _sentinel)
        _$StockFieldMap['retailPrice']!:
            _$StockPerFieldToJson.retailPrice(retailPrice as double),
      if (retailPriceFieldValue != null)
        _$StockFieldMap['retailPrice']!: retailPriceFieldValue,
      if (lastTouched != _sentinel)
        _$StockFieldMap['lastTouched']!:
            _$StockPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$StockFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAt != _sentinel)
        _$StockFieldMap['deletedAt']!:
            _$StockPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$StockFieldMap['deletedAt']!: deletedAtFieldValue,
      if (ebmSynced != _sentinel)
        _$StockFieldMap['ebmSynced']!:
            _$StockPerFieldToJson.ebmSynced(ebmSynced as bool),
      if (ebmSyncedFieldValue != null)
        _$StockFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (cloudSynced != _sentinel)
        _$StockFieldMap['cloudSynced']!:
            _$StockPerFieldToJson.cloudSynced(cloudSynced as bool),
      if (cloudSyncedFieldValue != null)
        _$StockFieldMap['cloudSynced']!: cloudSyncedFieldValue,
      if (variant != _sentinel)
        _$StockFieldMap['variant']!:
            _$StockPerFieldToJson.variant(variant as Variant?),
      if (variantFieldValue != null)
        _$StockFieldMap['variant']!: variantFieldValue,
      if (initialStock != _sentinel)
        _$StockFieldMap['initialStock']!:
            _$StockPerFieldToJson.initialStock(initialStock as double?),
      if (initialStockFieldValue != null)
        _$StockFieldMap['initialStock']!: initialStockFieldValue,
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

  StockQuery whereBhfId({
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

  StockQuery whereBranchId({
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

  StockQuery whereVariantId({
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

  StockQuery whereCurrentStock({
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

  StockQuery whereLowStock({
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

  StockQuery whereCanTrackingStock({
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

  StockQuery whereShowLowStockAlert({
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

  StockQuery whereProductId({
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

  StockQuery whereRsdQty({
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

  StockQuery whereSupplyPrice({
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

  StockQuery whereRetailPrice({
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

  StockQuery whereLastTouched({
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

  StockQuery whereDeletedAt({
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

  StockQuery whereEbmSynced({
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

  StockQuery whereCloudSynced({
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

  StockQuery whereInitialStock({
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

  StockQuery orderByBhfId({
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

  StockQuery orderByBranchId({
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

  StockQuery orderByVariantId({
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

  StockQuery orderByCurrentStock({
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

  StockQuery orderByLowStock({
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

  StockQuery orderByCanTrackingStock({
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

  StockQuery orderByShowLowStockAlert({
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

  StockQuery orderByProductId({
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

  StockQuery orderByRsdQty({
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

  StockQuery orderBySupplyPrice({
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

  StockQuery orderByRetailPrice({
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

  StockQuery orderByLastTouched({
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

  StockQuery orderByDeletedAt({
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

  StockQuery orderByEbmSynced({
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

  StockQuery orderByCloudSynced({
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

  StockQuery orderByInitialStock({
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
  StockQuery whereBhfId({
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
        _$StockFieldMap['bhfId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.bhfId(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.bhfId(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.bhfId(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.bhfId(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.bhfId(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.bhfId(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.bhfId(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.bhfId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereBranchId({
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
        _$StockFieldMap['branchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.branchId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.branchId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.branchId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.branchId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.branchId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.branchId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.branchId(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.branchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereVariantId({
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
        _$StockFieldMap['variantId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.variantId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.variantId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.variantId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.variantId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.variantId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.variantId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.variantId(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.variantId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereCurrentStock({
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
        _$StockFieldMap['currentStock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.currentStock(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.currentStock(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.currentStock(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.currentStock(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.currentStock(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .currentStock(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.currentStock(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.currentStock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereLowStock({
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
        _$StockFieldMap['lowStock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.lowStock(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.lowStock(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.lowStock(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.lowStock(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.lowStock(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.lowStock(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.lowStock(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.lowStock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereCanTrackingStock({
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
        _$StockFieldMap['canTrackingStock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.canTrackingStock(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.canTrackingStock(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.canTrackingStock(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .canTrackingStock(isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.canTrackingStock(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .canTrackingStock(isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.canTrackingStock(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.canTrackingStock(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereShowLowStockAlert({
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
        _$StockFieldMap['showLowStockAlert']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.showLowStockAlert(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.showLowStockAlert(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.showLowStockAlert(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .showLowStockAlert(isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.showLowStockAlert(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .showLowStockAlert(isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn:
            whereIn?.map((e) => _$StockPerFieldToJson.showLowStockAlert(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.showLowStockAlert(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereProductId({
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
        _$StockFieldMap['productId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.productId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.productId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.productId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.productId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.productId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.productId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.productId(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.productId(e)),
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
  StockQuery whereRsdQty({
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
        _$StockFieldMap['rsdQty']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.rsdQty(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.rsdQty(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.rsdQty(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.rsdQty(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.rsdQty(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.rsdQty(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.rsdQty(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.rsdQty(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereSupplyPrice({
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
        _$StockFieldMap['supplyPrice']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.supplyPrice(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.supplyPrice(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.supplyPrice(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.supplyPrice(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.supplyPrice(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .supplyPrice(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.supplyPrice(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.supplyPrice(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereRetailPrice({
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
        _$StockFieldMap['retailPrice']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.retailPrice(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.retailPrice(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.retailPrice(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.retailPrice(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.retailPrice(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .retailPrice(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.retailPrice(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.retailPrice(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereLastTouched({
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
        _$StockFieldMap['lastTouched']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.lastTouched(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.lastTouched(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.lastTouched(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .lastTouched(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.lastTouched(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .lastTouched(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.lastTouched(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.lastTouched(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereDeletedAt({
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
        _$StockFieldMap['deletedAt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.deletedAt(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.deletedAt(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.deletedAt(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.deletedAt(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.deletedAt(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .deletedAt(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.deletedAt(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.deletedAt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereEbmSynced({
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
        _$StockFieldMap['ebmSynced']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.ebmSynced(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.ebmSynced(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.ebmSynced(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.ebmSynced(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.ebmSynced(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.ebmSynced(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.ebmSynced(e)),
        whereNotIn: whereNotIn?.map((e) => _$StockPerFieldToJson.ebmSynced(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  StockQuery whereCloudSynced({
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
        _$StockFieldMap['cloudSynced']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.cloudSynced(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.cloudSynced(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.cloudSynced(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.cloudSynced(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.cloudSynced(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson.cloudSynced(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.cloudSynced(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.cloudSynced(e)),
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
  StockQuery whereInitialStock({
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
        _$StockFieldMap['initialStock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$StockPerFieldToJson.initialStock(isEqualTo as double?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$StockPerFieldToJson.initialStock(isNotEqualTo as double?)
            : null,
        isLessThan: isLessThan != null
            ? _$StockPerFieldToJson.initialStock(isLessThan as double?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$StockPerFieldToJson.initialStock(isLessThanOrEqualTo as double?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$StockPerFieldToJson.initialStock(isGreaterThan as double?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$StockPerFieldToJson
                .initialStock(isGreaterThanOrEqualTo as double?)
            : null,
        whereIn: whereIn?.map((e) => _$StockPerFieldToJson.initialStock(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$StockPerFieldToJson.initialStock(e)),
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
  StockQuery orderByBhfId({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['bhfId']!,
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
  StockQuery orderByBranchId({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['branchId']!,
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
  StockQuery orderByVariantId({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['variantId']!,
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
  StockQuery orderByCurrentStock({
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
        .orderBy(_$StockFieldMap['currentStock']!, descending: descending);
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
  StockQuery orderByLowStock({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['lowStock']!,
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
  StockQuery orderByCanTrackingStock({
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
        .orderBy(_$StockFieldMap['canTrackingStock']!, descending: descending);
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
  StockQuery orderByShowLowStockAlert({
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
        .orderBy(_$StockFieldMap['showLowStockAlert']!, descending: descending);
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
  StockQuery orderByProductId({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['productId']!,
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
  StockQuery orderByRsdQty({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['rsdQty']!,
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
  StockQuery orderBySupplyPrice({
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
        .orderBy(_$StockFieldMap['supplyPrice']!, descending: descending);
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
  StockQuery orderByRetailPrice({
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
        .orderBy(_$StockFieldMap['retailPrice']!, descending: descending);
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
  StockQuery orderByLastTouched({
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
        .orderBy(_$StockFieldMap['lastTouched']!, descending: descending);
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
  StockQuery orderByDeletedAt({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['deletedAt']!,
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
  StockQuery orderByEbmSynced({
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
    final query = $referenceWithoutCursor.orderBy(_$StockFieldMap['ebmSynced']!,
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
  StockQuery orderByCloudSynced({
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
        .orderBy(_$StockFieldMap['cloudSynced']!, descending: descending);
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
  StockQuery orderByInitialStock({
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
        .orderBy(_$StockFieldMap['initialStock']!, descending: descending);
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

Stock _$StockFromJson(Map<String, dynamic> json) => Stock(
      id: (json['id'] as num?)?.toInt(),
      tin: (json['tin'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      variantId: (json['variantId'] as num?)?.toInt(),
      currentStock: (json['currentStock'] as num?)?.toDouble() ?? 0.0,
      lowStock: (json['lowStock'] as num?)?.toDouble() ?? 0.0,
      canTrackingStock: json['canTrackingStock'] as bool? ?? true,
      showLowStockAlert: json['showLowStockAlert'] as bool? ?? true,
      productId: (json['productId'] as num?)?.toInt(),
      active: json['active'] as bool?,
      value: (json['value'] as num?)?.toDouble() ?? 0.0,
      rsdQty: (json['rsdQty'] as num?)?.toDouble() ?? 0.0,
      supplyPrice: (json['supplyPrice'] as num?)?.toDouble() ?? 0.0,
      retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0.0,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      cloudSynced: json['cloudSynced'] as bool? ?? true,
      variant: json['variant'] == null
          ? null
          : Variant.fromJson(json['variant'] as Map<String, dynamic>),
      initialStock: (json['initialStock'] as num?)?.toDouble(),
    );

const _$StockFieldMap = <String, String>{
  'id': 'id',
  'tin': 'tin',
  'bhfId': 'bhfId',
  'branchId': 'branchId',
  'variantId': 'variantId',
  'currentStock': 'currentStock',
  'lowStock': 'lowStock',
  'canTrackingStock': 'canTrackingStock',
  'showLowStockAlert': 'showLowStockAlert',
  'productId': 'productId',
  'active': 'active',
  'value': 'value',
  'rsdQty': 'rsdQty',
  'supplyPrice': 'supplyPrice',
  'retailPrice': 'retailPrice',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'ebmSynced': 'ebmSynced',
  'cloudSynced': 'cloudSynced',
  'variant': 'variant',
  'initialStock': 'initialStock',
};

// ignore: unused_element
abstract class _$StockPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? tin(int? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? variantId(int? instance) => instance;
  // ignore: unused_element
  static Object? currentStock(double instance) => instance;
  // ignore: unused_element
  static Object? lowStock(double instance) => instance;
  // ignore: unused_element
  static Object? canTrackingStock(bool? instance) => instance;
  // ignore: unused_element
  static Object? showLowStockAlert(bool? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
  // ignore: unused_element
  static Object? active(bool? instance) => instance;
  // ignore: unused_element
  static Object? value(double instance) => instance;
  // ignore: unused_element
  static Object? rsdQty(double instance) => instance;
  // ignore: unused_element
  static Object? supplyPrice(double instance) => instance;
  // ignore: unused_element
  static Object? retailPrice(double instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? ebmSynced(bool instance) => instance;
  // ignore: unused_element
  static Object? cloudSynced(bool instance) => instance;
  // ignore: unused_element
  static Object? variant(Variant? instance) => instance;
  // ignore: unused_element
  static Object? initialStock(double? instance) => instance;
}

Map<String, dynamic> _$StockToJson(Stock instance) => <String, dynamic>{
      'id': instance.id,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'branchId': instance.branchId,
      'variantId': instance.variantId,
      'currentStock': instance.currentStock,
      'lowStock': instance.lowStock,
      'canTrackingStock': instance.canTrackingStock,
      'showLowStockAlert': instance.showLowStockAlert,
      'productId': instance.productId,
      'active': instance.active,
      'value': instance.value,
      'rsdQty': instance.rsdQty,
      'supplyPrice': instance.supplyPrice,
      'retailPrice': instance.retailPrice,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'ebmSynced': instance.ebmSynced,
      'cloudSynced': instance.cloudSynced,
      'variant': instance.variant,
      'initialStock': instance.initialStock,
    };
