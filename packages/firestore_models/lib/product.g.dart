// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

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
abstract class ProductCollectionReference
    implements
        ProductQuery,
        FirestoreCollectionReference<Product, ProductQuerySnapshot> {
  factory ProductCollectionReference([
    FirebaseFirestore? firestore,
  ]) = _$ProductCollectionReference;

  static Product fromFirestore(
    DocumentSnapshot<Map<String, Object?>> snapshot,
    SnapshotOptions? options,
  ) {
    return Product.fromJson(snapshot.data()!);
  }

  static Map<String, Object?> toFirestore(
    Product value,
    SetOptions? options,
  ) {
    return value.toJson();
  }

  @override
  CollectionReference<Product> get reference;

  @override
  ProductDocumentReference doc([String? id]);

  /// Add a new document to this collection with the specified data,
  /// assigning it a document ID automatically.
  Future<ProductDocumentReference> add(Product value);
}

class _$ProductCollectionReference extends _$ProductQuery
    implements ProductCollectionReference {
  factory _$ProductCollectionReference([FirebaseFirestore? firestore]) {
    firestore ??= FirebaseFirestore.instance;

    return _$ProductCollectionReference._(
      firestore.collection('products').withConverter(
            fromFirestore: ProductCollectionReference.fromFirestore,
            toFirestore: ProductCollectionReference.toFirestore,
          ),
    );
  }

  _$ProductCollectionReference._(
    CollectionReference<Product> reference,
  ) : super(reference, $referenceWithoutCursor: reference);

  String get path => reference.path;

  @override
  CollectionReference<Product> get reference =>
      super.reference as CollectionReference<Product>;

  @override
  ProductDocumentReference doc([String? id]) {
    assert(
      id == null || id.split('/').length == 1,
      'The document ID cannot be from a different collection',
    );
    return ProductDocumentReference(
      reference.doc(id),
    );
  }

  @override
  Future<ProductDocumentReference> add(Product value) {
    return reference.add(value).then((ref) => ProductDocumentReference(ref));
  }

  @override
  bool operator ==(Object other) {
    return other is _$ProductCollectionReference &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

abstract class ProductDocumentReference
    extends FirestoreDocumentReference<Product, ProductDocumentSnapshot> {
  factory ProductDocumentReference(DocumentReference<Product> reference) =
      _$ProductDocumentReference;

  DocumentReference<Product> get reference;

  /// A reference to the [ProductCollectionReference] containing this document.
  ProductCollectionReference get parent {
    return _$ProductCollectionReference(reference.firestore);
  }

  @override
  Stream<ProductDocumentSnapshot> snapshots();

  @override
  Future<ProductDocumentSnapshot> get([GetOptions? options]);

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
    Product model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue nameFieldValue,
    FieldValue descriptionFieldValue,
    FieldValue taxIdFieldValue,
    FieldValue colorFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue supplierIdFieldValue,
    FieldValue categoryIdFieldValue,
    FieldValue createdAtFieldValue,
    FieldValue unitFieldValue,
    FieldValue imageUrlFieldValue,
    FieldValue expiryDateFieldValue,
    FieldValue barCodeFieldValue,
    FieldValue nfcEnabledFieldValue,
    FieldValue bindedToTenantIdFieldValue,
    FieldValue isFavoriteFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue deletedAtFieldValue,
    FieldValue spplrNmFieldValue,
    FieldValue isCompositeFieldValue,
    FieldValue compositesFieldValue,
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
    Product model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue nameFieldValue,
    FieldValue descriptionFieldValue,
    FieldValue taxIdFieldValue,
    FieldValue colorFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue supplierIdFieldValue,
    FieldValue categoryIdFieldValue,
    FieldValue createdAtFieldValue,
    FieldValue unitFieldValue,
    FieldValue imageUrlFieldValue,
    FieldValue expiryDateFieldValue,
    FieldValue barCodeFieldValue,
    FieldValue nfcEnabledFieldValue,
    FieldValue bindedToTenantIdFieldValue,
    FieldValue isFavoriteFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue deletedAtFieldValue,
    FieldValue spplrNmFieldValue,
    FieldValue isCompositeFieldValue,
    FieldValue compositesFieldValue,
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
    Product model, {
    SetOptions? options,
    FieldValue idFieldValue,
    FieldValue nameFieldValue,
    FieldValue descriptionFieldValue,
    FieldValue taxIdFieldValue,
    FieldValue colorFieldValue,
    FieldValue businessIdFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue supplierIdFieldValue,
    FieldValue categoryIdFieldValue,
    FieldValue createdAtFieldValue,
    FieldValue unitFieldValue,
    FieldValue imageUrlFieldValue,
    FieldValue expiryDateFieldValue,
    FieldValue barCodeFieldValue,
    FieldValue nfcEnabledFieldValue,
    FieldValue bindedToTenantIdFieldValue,
    FieldValue isFavoriteFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue deletedAtFieldValue,
    FieldValue spplrNmFieldValue,
    FieldValue isCompositeFieldValue,
    FieldValue compositesFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int? id,
    FieldValue idFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? description,
    FieldValue descriptionFieldValue,
    String? taxId,
    FieldValue taxIdFieldValue,
    String color,
    FieldValue colorFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? supplierId,
    FieldValue supplierIdFieldValue,
    int? categoryId,
    FieldValue categoryIdFieldValue,
    String? createdAt,
    FieldValue createdAtFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? imageUrl,
    FieldValue imageUrlFieldValue,
    String? expiryDate,
    FieldValue expiryDateFieldValue,
    String? barCode,
    FieldValue barCodeFieldValue,
    bool nfcEnabled,
    FieldValue nfcEnabledFieldValue,
    int? bindedToTenantId,
    FieldValue bindedToTenantIdFieldValue,
    bool isFavorite,
    FieldValue isFavoriteFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    String? spplrNm,
    FieldValue spplrNmFieldValue,
    bool? isComposite,
    FieldValue isCompositeFieldValue,
    List<Composite> composites,
    FieldValue compositesFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int? id,
    FieldValue idFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? description,
    FieldValue descriptionFieldValue,
    String? taxId,
    FieldValue taxIdFieldValue,
    String color,
    FieldValue colorFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? supplierId,
    FieldValue supplierIdFieldValue,
    int? categoryId,
    FieldValue categoryIdFieldValue,
    String? createdAt,
    FieldValue createdAtFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? imageUrl,
    FieldValue imageUrlFieldValue,
    String? expiryDate,
    FieldValue expiryDateFieldValue,
    String? barCode,
    FieldValue barCodeFieldValue,
    bool nfcEnabled,
    FieldValue nfcEnabledFieldValue,
    int? bindedToTenantId,
    FieldValue bindedToTenantIdFieldValue,
    bool isFavorite,
    FieldValue isFavoriteFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    String? spplrNm,
    FieldValue spplrNmFieldValue,
    bool? isComposite,
    FieldValue isCompositeFieldValue,
    List<Composite> composites,
    FieldValue compositesFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int? id,
    FieldValue idFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? description,
    FieldValue descriptionFieldValue,
    String? taxId,
    FieldValue taxIdFieldValue,
    String color,
    FieldValue colorFieldValue,
    int? businessId,
    FieldValue businessIdFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? supplierId,
    FieldValue supplierIdFieldValue,
    int? categoryId,
    FieldValue categoryIdFieldValue,
    String? createdAt,
    FieldValue createdAtFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? imageUrl,
    FieldValue imageUrlFieldValue,
    String? expiryDate,
    FieldValue expiryDateFieldValue,
    String? barCode,
    FieldValue barCodeFieldValue,
    bool nfcEnabled,
    FieldValue nfcEnabledFieldValue,
    int? bindedToTenantId,
    FieldValue bindedToTenantIdFieldValue,
    bool isFavorite,
    FieldValue isFavoriteFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    String? spplrNm,
    FieldValue spplrNmFieldValue,
    bool? isComposite,
    FieldValue isCompositeFieldValue,
    List<Composite> composites,
    FieldValue compositesFieldValue,
  });
}

class _$ProductDocumentReference
    extends FirestoreDocumentReference<Product, ProductDocumentSnapshot>
    implements ProductDocumentReference {
  _$ProductDocumentReference(this.reference);

  @override
  final DocumentReference<Product> reference;

  /// A reference to the [ProductCollectionReference] containing this document.
  ProductCollectionReference get parent {
    return _$ProductCollectionReference(reference.firestore);
  }

  @override
  Stream<ProductDocumentSnapshot> snapshots() {
    return reference.snapshots().map(ProductDocumentSnapshot._);
  }

  @override
  Future<ProductDocumentSnapshot> get([GetOptions? options]) {
    return reference.get(options).then(ProductDocumentSnapshot._);
  }

  @override
  Future<ProductDocumentSnapshot> transactionGet(Transaction transaction) {
    return transaction.get(reference).then(ProductDocumentSnapshot._);
  }

  Future<void> set(
    Product model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? descriptionFieldValue,
    FieldValue? taxIdFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? supplierIdFieldValue,
    FieldValue? categoryIdFieldValue,
    FieldValue? createdAtFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? imageUrlFieldValue,
    FieldValue? expiryDateFieldValue,
    FieldValue? barCodeFieldValue,
    FieldValue? nfcEnabledFieldValue,
    FieldValue? bindedToTenantIdFieldValue,
    FieldValue? isFavoriteFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? deletedAtFieldValue,
    FieldValue? spplrNmFieldValue,
    FieldValue? isCompositeFieldValue,
    FieldValue? compositesFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$ProductFieldMap['id']!: idFieldValue,
      if (nameFieldValue != null) _$ProductFieldMap['name']!: nameFieldValue,
      if (descriptionFieldValue != null)
        _$ProductFieldMap['description']!: descriptionFieldValue,
      if (taxIdFieldValue != null) _$ProductFieldMap['taxId']!: taxIdFieldValue,
      if (colorFieldValue != null) _$ProductFieldMap['color']!: colorFieldValue,
      if (businessIdFieldValue != null)
        _$ProductFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$ProductFieldMap['branchId']!: branchIdFieldValue,
      if (supplierIdFieldValue != null)
        _$ProductFieldMap['supplierId']!: supplierIdFieldValue,
      if (categoryIdFieldValue != null)
        _$ProductFieldMap['categoryId']!: categoryIdFieldValue,
      if (createdAtFieldValue != null)
        _$ProductFieldMap['createdAt']!: createdAtFieldValue,
      if (unitFieldValue != null) _$ProductFieldMap['unit']!: unitFieldValue,
      if (imageUrlFieldValue != null)
        _$ProductFieldMap['imageUrl']!: imageUrlFieldValue,
      if (expiryDateFieldValue != null)
        _$ProductFieldMap['expiryDate']!: expiryDateFieldValue,
      if (barCodeFieldValue != null)
        _$ProductFieldMap['barCode']!: barCodeFieldValue,
      if (nfcEnabledFieldValue != null)
        _$ProductFieldMap['nfcEnabled']!: nfcEnabledFieldValue,
      if (bindedToTenantIdFieldValue != null)
        _$ProductFieldMap['bindedToTenantId']!: bindedToTenantIdFieldValue,
      if (isFavoriteFieldValue != null)
        _$ProductFieldMap['isFavorite']!: isFavoriteFieldValue,
      if (lastTouchedFieldValue != null)
        _$ProductFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAtFieldValue != null)
        _$ProductFieldMap['deletedAt']!: deletedAtFieldValue,
      if (spplrNmFieldValue != null)
        _$ProductFieldMap['spplrNm']!: spplrNmFieldValue,
      if (isCompositeFieldValue != null)
        _$ProductFieldMap['isComposite']!: isCompositeFieldValue,
      if (compositesFieldValue != null)
        _$ProductFieldMap['composites']!: compositesFieldValue,
    };

    final castedReference = reference.withConverter<Map<String, dynamic>>(
      fromFirestore: (snapshot, options) => throw UnimplementedError(),
      toFirestore: (value, options) => value,
    );
    return castedReference.set(json, options);
  }

  void transactionSet(
    Transaction transaction,
    Product model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? descriptionFieldValue,
    FieldValue? taxIdFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? supplierIdFieldValue,
    FieldValue? categoryIdFieldValue,
    FieldValue? createdAtFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? imageUrlFieldValue,
    FieldValue? expiryDateFieldValue,
    FieldValue? barCodeFieldValue,
    FieldValue? nfcEnabledFieldValue,
    FieldValue? bindedToTenantIdFieldValue,
    FieldValue? isFavoriteFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? deletedAtFieldValue,
    FieldValue? spplrNmFieldValue,
    FieldValue? isCompositeFieldValue,
    FieldValue? compositesFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$ProductFieldMap['id']!: idFieldValue,
      if (nameFieldValue != null) _$ProductFieldMap['name']!: nameFieldValue,
      if (descriptionFieldValue != null)
        _$ProductFieldMap['description']!: descriptionFieldValue,
      if (taxIdFieldValue != null) _$ProductFieldMap['taxId']!: taxIdFieldValue,
      if (colorFieldValue != null) _$ProductFieldMap['color']!: colorFieldValue,
      if (businessIdFieldValue != null)
        _$ProductFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$ProductFieldMap['branchId']!: branchIdFieldValue,
      if (supplierIdFieldValue != null)
        _$ProductFieldMap['supplierId']!: supplierIdFieldValue,
      if (categoryIdFieldValue != null)
        _$ProductFieldMap['categoryId']!: categoryIdFieldValue,
      if (createdAtFieldValue != null)
        _$ProductFieldMap['createdAt']!: createdAtFieldValue,
      if (unitFieldValue != null) _$ProductFieldMap['unit']!: unitFieldValue,
      if (imageUrlFieldValue != null)
        _$ProductFieldMap['imageUrl']!: imageUrlFieldValue,
      if (expiryDateFieldValue != null)
        _$ProductFieldMap['expiryDate']!: expiryDateFieldValue,
      if (barCodeFieldValue != null)
        _$ProductFieldMap['barCode']!: barCodeFieldValue,
      if (nfcEnabledFieldValue != null)
        _$ProductFieldMap['nfcEnabled']!: nfcEnabledFieldValue,
      if (bindedToTenantIdFieldValue != null)
        _$ProductFieldMap['bindedToTenantId']!: bindedToTenantIdFieldValue,
      if (isFavoriteFieldValue != null)
        _$ProductFieldMap['isFavorite']!: isFavoriteFieldValue,
      if (lastTouchedFieldValue != null)
        _$ProductFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAtFieldValue != null)
        _$ProductFieldMap['deletedAt']!: deletedAtFieldValue,
      if (spplrNmFieldValue != null)
        _$ProductFieldMap['spplrNm']!: spplrNmFieldValue,
      if (isCompositeFieldValue != null)
        _$ProductFieldMap['isComposite']!: isCompositeFieldValue,
      if (compositesFieldValue != null)
        _$ProductFieldMap['composites']!: compositesFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Product model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? descriptionFieldValue,
    FieldValue? taxIdFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? businessIdFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? supplierIdFieldValue,
    FieldValue? categoryIdFieldValue,
    FieldValue? createdAtFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? imageUrlFieldValue,
    FieldValue? expiryDateFieldValue,
    FieldValue? barCodeFieldValue,
    FieldValue? nfcEnabledFieldValue,
    FieldValue? bindedToTenantIdFieldValue,
    FieldValue? isFavoriteFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? deletedAtFieldValue,
    FieldValue? spplrNmFieldValue,
    FieldValue? isCompositeFieldValue,
    FieldValue? compositesFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$ProductFieldMap['id']!: idFieldValue,
      if (nameFieldValue != null) _$ProductFieldMap['name']!: nameFieldValue,
      if (descriptionFieldValue != null)
        _$ProductFieldMap['description']!: descriptionFieldValue,
      if (taxIdFieldValue != null) _$ProductFieldMap['taxId']!: taxIdFieldValue,
      if (colorFieldValue != null) _$ProductFieldMap['color']!: colorFieldValue,
      if (businessIdFieldValue != null)
        _$ProductFieldMap['businessId']!: businessIdFieldValue,
      if (branchIdFieldValue != null)
        _$ProductFieldMap['branchId']!: branchIdFieldValue,
      if (supplierIdFieldValue != null)
        _$ProductFieldMap['supplierId']!: supplierIdFieldValue,
      if (categoryIdFieldValue != null)
        _$ProductFieldMap['categoryId']!: categoryIdFieldValue,
      if (createdAtFieldValue != null)
        _$ProductFieldMap['createdAt']!: createdAtFieldValue,
      if (unitFieldValue != null) _$ProductFieldMap['unit']!: unitFieldValue,
      if (imageUrlFieldValue != null)
        _$ProductFieldMap['imageUrl']!: imageUrlFieldValue,
      if (expiryDateFieldValue != null)
        _$ProductFieldMap['expiryDate']!: expiryDateFieldValue,
      if (barCodeFieldValue != null)
        _$ProductFieldMap['barCode']!: barCodeFieldValue,
      if (nfcEnabledFieldValue != null)
        _$ProductFieldMap['nfcEnabled']!: nfcEnabledFieldValue,
      if (bindedToTenantIdFieldValue != null)
        _$ProductFieldMap['bindedToTenantId']!: bindedToTenantIdFieldValue,
      if (isFavoriteFieldValue != null)
        _$ProductFieldMap['isFavorite']!: isFavoriteFieldValue,
      if (lastTouchedFieldValue != null)
        _$ProductFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAtFieldValue != null)
        _$ProductFieldMap['deletedAt']!: deletedAtFieldValue,
      if (spplrNmFieldValue != null)
        _$ProductFieldMap['spplrNm']!: spplrNmFieldValue,
      if (isCompositeFieldValue != null)
        _$ProductFieldMap['isComposite']!: isCompositeFieldValue,
      if (compositesFieldValue != null)
        _$ProductFieldMap['composites']!: compositesFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? description = _sentinel,
    FieldValue? descriptionFieldValue,
    Object? taxId = _sentinel,
    FieldValue? taxIdFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? supplierId = _sentinel,
    FieldValue? supplierIdFieldValue,
    Object? categoryId = _sentinel,
    FieldValue? categoryIdFieldValue,
    Object? createdAt = _sentinel,
    FieldValue? createdAtFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? imageUrl = _sentinel,
    FieldValue? imageUrlFieldValue,
    Object? expiryDate = _sentinel,
    FieldValue? expiryDateFieldValue,
    Object? barCode = _sentinel,
    FieldValue? barCodeFieldValue,
    Object? nfcEnabled = _sentinel,
    FieldValue? nfcEnabledFieldValue,
    Object? bindedToTenantId = _sentinel,
    FieldValue? bindedToTenantIdFieldValue,
    Object? isFavorite = _sentinel,
    FieldValue? isFavoriteFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? spplrNm = _sentinel,
    FieldValue? spplrNmFieldValue,
    Object? isComposite = _sentinel,
    FieldValue? isCompositeFieldValue,
    Object? composites = _sentinel,
    FieldValue? compositesFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      name == _sentinel || nameFieldValue == null,
      "Cannot specify both name and nameFieldValue",
    );
    assert(
      description == _sentinel || descriptionFieldValue == null,
      "Cannot specify both description and descriptionFieldValue",
    );
    assert(
      taxId == _sentinel || taxIdFieldValue == null,
      "Cannot specify both taxId and taxIdFieldValue",
    );
    assert(
      color == _sentinel || colorFieldValue == null,
      "Cannot specify both color and colorFieldValue",
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
      supplierId == _sentinel || supplierIdFieldValue == null,
      "Cannot specify both supplierId and supplierIdFieldValue",
    );
    assert(
      categoryId == _sentinel || categoryIdFieldValue == null,
      "Cannot specify both categoryId and categoryIdFieldValue",
    );
    assert(
      createdAt == _sentinel || createdAtFieldValue == null,
      "Cannot specify both createdAt and createdAtFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      imageUrl == _sentinel || imageUrlFieldValue == null,
      "Cannot specify both imageUrl and imageUrlFieldValue",
    );
    assert(
      expiryDate == _sentinel || expiryDateFieldValue == null,
      "Cannot specify both expiryDate and expiryDateFieldValue",
    );
    assert(
      barCode == _sentinel || barCodeFieldValue == null,
      "Cannot specify both barCode and barCodeFieldValue",
    );
    assert(
      nfcEnabled == _sentinel || nfcEnabledFieldValue == null,
      "Cannot specify both nfcEnabled and nfcEnabledFieldValue",
    );
    assert(
      bindedToTenantId == _sentinel || bindedToTenantIdFieldValue == null,
      "Cannot specify both bindedToTenantId and bindedToTenantIdFieldValue",
    );
    assert(
      isFavorite == _sentinel || isFavoriteFieldValue == null,
      "Cannot specify both isFavorite and isFavoriteFieldValue",
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
      spplrNm == _sentinel || spplrNmFieldValue == null,
      "Cannot specify both spplrNm and spplrNmFieldValue",
    );
    assert(
      isComposite == _sentinel || isCompositeFieldValue == null,
      "Cannot specify both isComposite and isCompositeFieldValue",
    );
    assert(
      composites == _sentinel || compositesFieldValue == null,
      "Cannot specify both composites and compositesFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$ProductFieldMap['id']!: _$ProductPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$ProductFieldMap['id']!: idFieldValue,
      if (name != _sentinel)
        _$ProductFieldMap['name']!:
            _$ProductPerFieldToJson.name(name as String?),
      if (nameFieldValue != null) _$ProductFieldMap['name']!: nameFieldValue,
      if (description != _sentinel)
        _$ProductFieldMap['description']!:
            _$ProductPerFieldToJson.description(description as String?),
      if (descriptionFieldValue != null)
        _$ProductFieldMap['description']!: descriptionFieldValue,
      if (taxId != _sentinel)
        _$ProductFieldMap['taxId']!:
            _$ProductPerFieldToJson.taxId(taxId as String?),
      if (taxIdFieldValue != null) _$ProductFieldMap['taxId']!: taxIdFieldValue,
      if (color != _sentinel)
        _$ProductFieldMap['color']!:
            _$ProductPerFieldToJson.color(color as String),
      if (colorFieldValue != null) _$ProductFieldMap['color']!: colorFieldValue,
      if (businessId != _sentinel)
        _$ProductFieldMap['businessId']!:
            _$ProductPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$ProductFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$ProductFieldMap['branchId']!:
            _$ProductPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$ProductFieldMap['branchId']!: branchIdFieldValue,
      if (supplierId != _sentinel)
        _$ProductFieldMap['supplierId']!:
            _$ProductPerFieldToJson.supplierId(supplierId as String?),
      if (supplierIdFieldValue != null)
        _$ProductFieldMap['supplierId']!: supplierIdFieldValue,
      if (categoryId != _sentinel)
        _$ProductFieldMap['categoryId']!:
            _$ProductPerFieldToJson.categoryId(categoryId as int?),
      if (categoryIdFieldValue != null)
        _$ProductFieldMap['categoryId']!: categoryIdFieldValue,
      if (createdAt != _sentinel)
        _$ProductFieldMap['createdAt']!:
            _$ProductPerFieldToJson.createdAt(createdAt as String?),
      if (createdAtFieldValue != null)
        _$ProductFieldMap['createdAt']!: createdAtFieldValue,
      if (unit != _sentinel)
        _$ProductFieldMap['unit']!:
            _$ProductPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$ProductFieldMap['unit']!: unitFieldValue,
      if (imageUrl != _sentinel)
        _$ProductFieldMap['imageUrl']!:
            _$ProductPerFieldToJson.imageUrl(imageUrl as String?),
      if (imageUrlFieldValue != null)
        _$ProductFieldMap['imageUrl']!: imageUrlFieldValue,
      if (expiryDate != _sentinel)
        _$ProductFieldMap['expiryDate']!:
            _$ProductPerFieldToJson.expiryDate(expiryDate as String?),
      if (expiryDateFieldValue != null)
        _$ProductFieldMap['expiryDate']!: expiryDateFieldValue,
      if (barCode != _sentinel)
        _$ProductFieldMap['barCode']!:
            _$ProductPerFieldToJson.barCode(barCode as String?),
      if (barCodeFieldValue != null)
        _$ProductFieldMap['barCode']!: barCodeFieldValue,
      if (nfcEnabled != _sentinel)
        _$ProductFieldMap['nfcEnabled']!:
            _$ProductPerFieldToJson.nfcEnabled(nfcEnabled as bool),
      if (nfcEnabledFieldValue != null)
        _$ProductFieldMap['nfcEnabled']!: nfcEnabledFieldValue,
      if (bindedToTenantId != _sentinel)
        _$ProductFieldMap['bindedToTenantId']!:
            _$ProductPerFieldToJson.bindedToTenantId(bindedToTenantId as int?),
      if (bindedToTenantIdFieldValue != null)
        _$ProductFieldMap['bindedToTenantId']!: bindedToTenantIdFieldValue,
      if (isFavorite != _sentinel)
        _$ProductFieldMap['isFavorite']!:
            _$ProductPerFieldToJson.isFavorite(isFavorite as bool),
      if (isFavoriteFieldValue != null)
        _$ProductFieldMap['isFavorite']!: isFavoriteFieldValue,
      if (lastTouched != _sentinel)
        _$ProductFieldMap['lastTouched']!:
            _$ProductPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$ProductFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAt != _sentinel)
        _$ProductFieldMap['deletedAt']!:
            _$ProductPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$ProductFieldMap['deletedAt']!: deletedAtFieldValue,
      if (spplrNm != _sentinel)
        _$ProductFieldMap['spplrNm']!:
            _$ProductPerFieldToJson.spplrNm(spplrNm as String?),
      if (spplrNmFieldValue != null)
        _$ProductFieldMap['spplrNm']!: spplrNmFieldValue,
      if (isComposite != _sentinel)
        _$ProductFieldMap['isComposite']!:
            _$ProductPerFieldToJson.isComposite(isComposite as bool?),
      if (isCompositeFieldValue != null)
        _$ProductFieldMap['isComposite']!: isCompositeFieldValue,
      if (composites != _sentinel)
        _$ProductFieldMap['composites']!:
            _$ProductPerFieldToJson.composites(composites as List<Composite>),
      if (compositesFieldValue != null)
        _$ProductFieldMap['composites']!: compositesFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? description = _sentinel,
    FieldValue? descriptionFieldValue,
    Object? taxId = _sentinel,
    FieldValue? taxIdFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? supplierId = _sentinel,
    FieldValue? supplierIdFieldValue,
    Object? categoryId = _sentinel,
    FieldValue? categoryIdFieldValue,
    Object? createdAt = _sentinel,
    FieldValue? createdAtFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? imageUrl = _sentinel,
    FieldValue? imageUrlFieldValue,
    Object? expiryDate = _sentinel,
    FieldValue? expiryDateFieldValue,
    Object? barCode = _sentinel,
    FieldValue? barCodeFieldValue,
    Object? nfcEnabled = _sentinel,
    FieldValue? nfcEnabledFieldValue,
    Object? bindedToTenantId = _sentinel,
    FieldValue? bindedToTenantIdFieldValue,
    Object? isFavorite = _sentinel,
    FieldValue? isFavoriteFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? spplrNm = _sentinel,
    FieldValue? spplrNmFieldValue,
    Object? isComposite = _sentinel,
    FieldValue? isCompositeFieldValue,
    Object? composites = _sentinel,
    FieldValue? compositesFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      name == _sentinel || nameFieldValue == null,
      "Cannot specify both name and nameFieldValue",
    );
    assert(
      description == _sentinel || descriptionFieldValue == null,
      "Cannot specify both description and descriptionFieldValue",
    );
    assert(
      taxId == _sentinel || taxIdFieldValue == null,
      "Cannot specify both taxId and taxIdFieldValue",
    );
    assert(
      color == _sentinel || colorFieldValue == null,
      "Cannot specify both color and colorFieldValue",
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
      supplierId == _sentinel || supplierIdFieldValue == null,
      "Cannot specify both supplierId and supplierIdFieldValue",
    );
    assert(
      categoryId == _sentinel || categoryIdFieldValue == null,
      "Cannot specify both categoryId and categoryIdFieldValue",
    );
    assert(
      createdAt == _sentinel || createdAtFieldValue == null,
      "Cannot specify both createdAt and createdAtFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      imageUrl == _sentinel || imageUrlFieldValue == null,
      "Cannot specify both imageUrl and imageUrlFieldValue",
    );
    assert(
      expiryDate == _sentinel || expiryDateFieldValue == null,
      "Cannot specify both expiryDate and expiryDateFieldValue",
    );
    assert(
      barCode == _sentinel || barCodeFieldValue == null,
      "Cannot specify both barCode and barCodeFieldValue",
    );
    assert(
      nfcEnabled == _sentinel || nfcEnabledFieldValue == null,
      "Cannot specify both nfcEnabled and nfcEnabledFieldValue",
    );
    assert(
      bindedToTenantId == _sentinel || bindedToTenantIdFieldValue == null,
      "Cannot specify both bindedToTenantId and bindedToTenantIdFieldValue",
    );
    assert(
      isFavorite == _sentinel || isFavoriteFieldValue == null,
      "Cannot specify both isFavorite and isFavoriteFieldValue",
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
      spplrNm == _sentinel || spplrNmFieldValue == null,
      "Cannot specify both spplrNm and spplrNmFieldValue",
    );
    assert(
      isComposite == _sentinel || isCompositeFieldValue == null,
      "Cannot specify both isComposite and isCompositeFieldValue",
    );
    assert(
      composites == _sentinel || compositesFieldValue == null,
      "Cannot specify both composites and compositesFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$ProductFieldMap['id']!: _$ProductPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$ProductFieldMap['id']!: idFieldValue,
      if (name != _sentinel)
        _$ProductFieldMap['name']!:
            _$ProductPerFieldToJson.name(name as String?),
      if (nameFieldValue != null) _$ProductFieldMap['name']!: nameFieldValue,
      if (description != _sentinel)
        _$ProductFieldMap['description']!:
            _$ProductPerFieldToJson.description(description as String?),
      if (descriptionFieldValue != null)
        _$ProductFieldMap['description']!: descriptionFieldValue,
      if (taxId != _sentinel)
        _$ProductFieldMap['taxId']!:
            _$ProductPerFieldToJson.taxId(taxId as String?),
      if (taxIdFieldValue != null) _$ProductFieldMap['taxId']!: taxIdFieldValue,
      if (color != _sentinel)
        _$ProductFieldMap['color']!:
            _$ProductPerFieldToJson.color(color as String),
      if (colorFieldValue != null) _$ProductFieldMap['color']!: colorFieldValue,
      if (businessId != _sentinel)
        _$ProductFieldMap['businessId']!:
            _$ProductPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$ProductFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$ProductFieldMap['branchId']!:
            _$ProductPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$ProductFieldMap['branchId']!: branchIdFieldValue,
      if (supplierId != _sentinel)
        _$ProductFieldMap['supplierId']!:
            _$ProductPerFieldToJson.supplierId(supplierId as String?),
      if (supplierIdFieldValue != null)
        _$ProductFieldMap['supplierId']!: supplierIdFieldValue,
      if (categoryId != _sentinel)
        _$ProductFieldMap['categoryId']!:
            _$ProductPerFieldToJson.categoryId(categoryId as int?),
      if (categoryIdFieldValue != null)
        _$ProductFieldMap['categoryId']!: categoryIdFieldValue,
      if (createdAt != _sentinel)
        _$ProductFieldMap['createdAt']!:
            _$ProductPerFieldToJson.createdAt(createdAt as String?),
      if (createdAtFieldValue != null)
        _$ProductFieldMap['createdAt']!: createdAtFieldValue,
      if (unit != _sentinel)
        _$ProductFieldMap['unit']!:
            _$ProductPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$ProductFieldMap['unit']!: unitFieldValue,
      if (imageUrl != _sentinel)
        _$ProductFieldMap['imageUrl']!:
            _$ProductPerFieldToJson.imageUrl(imageUrl as String?),
      if (imageUrlFieldValue != null)
        _$ProductFieldMap['imageUrl']!: imageUrlFieldValue,
      if (expiryDate != _sentinel)
        _$ProductFieldMap['expiryDate']!:
            _$ProductPerFieldToJson.expiryDate(expiryDate as String?),
      if (expiryDateFieldValue != null)
        _$ProductFieldMap['expiryDate']!: expiryDateFieldValue,
      if (barCode != _sentinel)
        _$ProductFieldMap['barCode']!:
            _$ProductPerFieldToJson.barCode(barCode as String?),
      if (barCodeFieldValue != null)
        _$ProductFieldMap['barCode']!: barCodeFieldValue,
      if (nfcEnabled != _sentinel)
        _$ProductFieldMap['nfcEnabled']!:
            _$ProductPerFieldToJson.nfcEnabled(nfcEnabled as bool),
      if (nfcEnabledFieldValue != null)
        _$ProductFieldMap['nfcEnabled']!: nfcEnabledFieldValue,
      if (bindedToTenantId != _sentinel)
        _$ProductFieldMap['bindedToTenantId']!:
            _$ProductPerFieldToJson.bindedToTenantId(bindedToTenantId as int?),
      if (bindedToTenantIdFieldValue != null)
        _$ProductFieldMap['bindedToTenantId']!: bindedToTenantIdFieldValue,
      if (isFavorite != _sentinel)
        _$ProductFieldMap['isFavorite']!:
            _$ProductPerFieldToJson.isFavorite(isFavorite as bool),
      if (isFavoriteFieldValue != null)
        _$ProductFieldMap['isFavorite']!: isFavoriteFieldValue,
      if (lastTouched != _sentinel)
        _$ProductFieldMap['lastTouched']!:
            _$ProductPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$ProductFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAt != _sentinel)
        _$ProductFieldMap['deletedAt']!:
            _$ProductPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$ProductFieldMap['deletedAt']!: deletedAtFieldValue,
      if (spplrNm != _sentinel)
        _$ProductFieldMap['spplrNm']!:
            _$ProductPerFieldToJson.spplrNm(spplrNm as String?),
      if (spplrNmFieldValue != null)
        _$ProductFieldMap['spplrNm']!: spplrNmFieldValue,
      if (isComposite != _sentinel)
        _$ProductFieldMap['isComposite']!:
            _$ProductPerFieldToJson.isComposite(isComposite as bool?),
      if (isCompositeFieldValue != null)
        _$ProductFieldMap['isComposite']!: isCompositeFieldValue,
      if (composites != _sentinel)
        _$ProductFieldMap['composites']!:
            _$ProductPerFieldToJson.composites(composites as List<Composite>),
      if (compositesFieldValue != null)
        _$ProductFieldMap['composites']!: compositesFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? description = _sentinel,
    FieldValue? descriptionFieldValue,
    Object? taxId = _sentinel,
    FieldValue? taxIdFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? businessId = _sentinel,
    FieldValue? businessIdFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? supplierId = _sentinel,
    FieldValue? supplierIdFieldValue,
    Object? categoryId = _sentinel,
    FieldValue? categoryIdFieldValue,
    Object? createdAt = _sentinel,
    FieldValue? createdAtFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? imageUrl = _sentinel,
    FieldValue? imageUrlFieldValue,
    Object? expiryDate = _sentinel,
    FieldValue? expiryDateFieldValue,
    Object? barCode = _sentinel,
    FieldValue? barCodeFieldValue,
    Object? nfcEnabled = _sentinel,
    FieldValue? nfcEnabledFieldValue,
    Object? bindedToTenantId = _sentinel,
    FieldValue? bindedToTenantIdFieldValue,
    Object? isFavorite = _sentinel,
    FieldValue? isFavoriteFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? spplrNm = _sentinel,
    FieldValue? spplrNmFieldValue,
    Object? isComposite = _sentinel,
    FieldValue? isCompositeFieldValue,
    Object? composites = _sentinel,
    FieldValue? compositesFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      name == _sentinel || nameFieldValue == null,
      "Cannot specify both name and nameFieldValue",
    );
    assert(
      description == _sentinel || descriptionFieldValue == null,
      "Cannot specify both description and descriptionFieldValue",
    );
    assert(
      taxId == _sentinel || taxIdFieldValue == null,
      "Cannot specify both taxId and taxIdFieldValue",
    );
    assert(
      color == _sentinel || colorFieldValue == null,
      "Cannot specify both color and colorFieldValue",
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
      supplierId == _sentinel || supplierIdFieldValue == null,
      "Cannot specify both supplierId and supplierIdFieldValue",
    );
    assert(
      categoryId == _sentinel || categoryIdFieldValue == null,
      "Cannot specify both categoryId and categoryIdFieldValue",
    );
    assert(
      createdAt == _sentinel || createdAtFieldValue == null,
      "Cannot specify both createdAt and createdAtFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      imageUrl == _sentinel || imageUrlFieldValue == null,
      "Cannot specify both imageUrl and imageUrlFieldValue",
    );
    assert(
      expiryDate == _sentinel || expiryDateFieldValue == null,
      "Cannot specify both expiryDate and expiryDateFieldValue",
    );
    assert(
      barCode == _sentinel || barCodeFieldValue == null,
      "Cannot specify both barCode and barCodeFieldValue",
    );
    assert(
      nfcEnabled == _sentinel || nfcEnabledFieldValue == null,
      "Cannot specify both nfcEnabled and nfcEnabledFieldValue",
    );
    assert(
      bindedToTenantId == _sentinel || bindedToTenantIdFieldValue == null,
      "Cannot specify both bindedToTenantId and bindedToTenantIdFieldValue",
    );
    assert(
      isFavorite == _sentinel || isFavoriteFieldValue == null,
      "Cannot specify both isFavorite and isFavoriteFieldValue",
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
      spplrNm == _sentinel || spplrNmFieldValue == null,
      "Cannot specify both spplrNm and spplrNmFieldValue",
    );
    assert(
      isComposite == _sentinel || isCompositeFieldValue == null,
      "Cannot specify both isComposite and isCompositeFieldValue",
    );
    assert(
      composites == _sentinel || compositesFieldValue == null,
      "Cannot specify both composites and compositesFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$ProductFieldMap['id']!: _$ProductPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$ProductFieldMap['id']!: idFieldValue,
      if (name != _sentinel)
        _$ProductFieldMap['name']!:
            _$ProductPerFieldToJson.name(name as String?),
      if (nameFieldValue != null) _$ProductFieldMap['name']!: nameFieldValue,
      if (description != _sentinel)
        _$ProductFieldMap['description']!:
            _$ProductPerFieldToJson.description(description as String?),
      if (descriptionFieldValue != null)
        _$ProductFieldMap['description']!: descriptionFieldValue,
      if (taxId != _sentinel)
        _$ProductFieldMap['taxId']!:
            _$ProductPerFieldToJson.taxId(taxId as String?),
      if (taxIdFieldValue != null) _$ProductFieldMap['taxId']!: taxIdFieldValue,
      if (color != _sentinel)
        _$ProductFieldMap['color']!:
            _$ProductPerFieldToJson.color(color as String),
      if (colorFieldValue != null) _$ProductFieldMap['color']!: colorFieldValue,
      if (businessId != _sentinel)
        _$ProductFieldMap['businessId']!:
            _$ProductPerFieldToJson.businessId(businessId as int?),
      if (businessIdFieldValue != null)
        _$ProductFieldMap['businessId']!: businessIdFieldValue,
      if (branchId != _sentinel)
        _$ProductFieldMap['branchId']!:
            _$ProductPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$ProductFieldMap['branchId']!: branchIdFieldValue,
      if (supplierId != _sentinel)
        _$ProductFieldMap['supplierId']!:
            _$ProductPerFieldToJson.supplierId(supplierId as String?),
      if (supplierIdFieldValue != null)
        _$ProductFieldMap['supplierId']!: supplierIdFieldValue,
      if (categoryId != _sentinel)
        _$ProductFieldMap['categoryId']!:
            _$ProductPerFieldToJson.categoryId(categoryId as int?),
      if (categoryIdFieldValue != null)
        _$ProductFieldMap['categoryId']!: categoryIdFieldValue,
      if (createdAt != _sentinel)
        _$ProductFieldMap['createdAt']!:
            _$ProductPerFieldToJson.createdAt(createdAt as String?),
      if (createdAtFieldValue != null)
        _$ProductFieldMap['createdAt']!: createdAtFieldValue,
      if (unit != _sentinel)
        _$ProductFieldMap['unit']!:
            _$ProductPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$ProductFieldMap['unit']!: unitFieldValue,
      if (imageUrl != _sentinel)
        _$ProductFieldMap['imageUrl']!:
            _$ProductPerFieldToJson.imageUrl(imageUrl as String?),
      if (imageUrlFieldValue != null)
        _$ProductFieldMap['imageUrl']!: imageUrlFieldValue,
      if (expiryDate != _sentinel)
        _$ProductFieldMap['expiryDate']!:
            _$ProductPerFieldToJson.expiryDate(expiryDate as String?),
      if (expiryDateFieldValue != null)
        _$ProductFieldMap['expiryDate']!: expiryDateFieldValue,
      if (barCode != _sentinel)
        _$ProductFieldMap['barCode']!:
            _$ProductPerFieldToJson.barCode(barCode as String?),
      if (barCodeFieldValue != null)
        _$ProductFieldMap['barCode']!: barCodeFieldValue,
      if (nfcEnabled != _sentinel)
        _$ProductFieldMap['nfcEnabled']!:
            _$ProductPerFieldToJson.nfcEnabled(nfcEnabled as bool),
      if (nfcEnabledFieldValue != null)
        _$ProductFieldMap['nfcEnabled']!: nfcEnabledFieldValue,
      if (bindedToTenantId != _sentinel)
        _$ProductFieldMap['bindedToTenantId']!:
            _$ProductPerFieldToJson.bindedToTenantId(bindedToTenantId as int?),
      if (bindedToTenantIdFieldValue != null)
        _$ProductFieldMap['bindedToTenantId']!: bindedToTenantIdFieldValue,
      if (isFavorite != _sentinel)
        _$ProductFieldMap['isFavorite']!:
            _$ProductPerFieldToJson.isFavorite(isFavorite as bool),
      if (isFavoriteFieldValue != null)
        _$ProductFieldMap['isFavorite']!: isFavoriteFieldValue,
      if (lastTouched != _sentinel)
        _$ProductFieldMap['lastTouched']!:
            _$ProductPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$ProductFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (deletedAt != _sentinel)
        _$ProductFieldMap['deletedAt']!:
            _$ProductPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$ProductFieldMap['deletedAt']!: deletedAtFieldValue,
      if (spplrNm != _sentinel)
        _$ProductFieldMap['spplrNm']!:
            _$ProductPerFieldToJson.spplrNm(spplrNm as String?),
      if (spplrNmFieldValue != null)
        _$ProductFieldMap['spplrNm']!: spplrNmFieldValue,
      if (isComposite != _sentinel)
        _$ProductFieldMap['isComposite']!:
            _$ProductPerFieldToJson.isComposite(isComposite as bool?),
      if (isCompositeFieldValue != null)
        _$ProductFieldMap['isComposite']!: isCompositeFieldValue,
      if (composites != _sentinel)
        _$ProductFieldMap['composites']!:
            _$ProductPerFieldToJson.composites(composites as List<Composite>),
      if (compositesFieldValue != null)
        _$ProductFieldMap['composites']!: compositesFieldValue,
    };

    batch.update(reference, json);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDocumentReference &&
        other.runtimeType == runtimeType &&
        other.parent == parent &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, parent, id);
}

abstract class ProductQuery
    implements QueryReference<Product, ProductQuerySnapshot> {
  @override
  ProductQuery limit(int limit);

  @override
  ProductQuery limitToLast(int limit);

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
  ProductQuery whereFieldPath(
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

  ProductQuery whereDocumentId({
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

  ProductQuery whereId({
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

  ProductQuery whereName({
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

  ProductQuery whereDescription({
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

  ProductQuery whereTaxId({
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

  ProductQuery whereColor({
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

  ProductQuery whereBusinessId({
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

  ProductQuery whereBranchId({
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

  ProductQuery whereSupplierId({
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

  ProductQuery whereCategoryId({
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

  ProductQuery whereCreatedAt({
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

  ProductQuery whereUnit({
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

  ProductQuery whereImageUrl({
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

  ProductQuery whereExpiryDate({
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

  ProductQuery whereBarCode({
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

  ProductQuery whereNfcEnabled({
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

  ProductQuery whereBindedToTenantId({
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

  ProductQuery whereIsFavorite({
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

  ProductQuery whereLastTouched({
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

  ProductQuery whereDeletedAt({
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

  ProductQuery whereSpplrNm({
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

  ProductQuery whereIsComposite({
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

  ProductQuery whereComposites({
    List<Composite>? isEqualTo,
    List<Composite>? isNotEqualTo,
    List<Composite>? isLessThan,
    List<Composite>? isLessThanOrEqualTo,
    List<Composite>? isGreaterThan,
    List<Composite>? isGreaterThanOrEqualTo,
    Composite? arrayContains,
    List<Composite>? arrayContainsAny,
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
  ProductQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object startAt,
    Object startAfter,
    Object endAt,
    Object endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByDocumentId({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderById({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByName({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByDescription({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByTaxId({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByColor({
    bool descending = false,
    String startAt,
    String startAfter,
    String endAt,
    String endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByBusinessId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByBranchId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderBySupplierId({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByCategoryId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByCreatedAt({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByUnit({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByImageUrl({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByExpiryDate({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByBarCode({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByNfcEnabled({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByBindedToTenantId({
    bool descending = false,
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByIsFavorite({
    bool descending = false,
    bool startAt,
    bool startAfter,
    bool endAt,
    bool endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByLastTouched({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByDeletedAt({
    bool descending = false,
    DateTime? startAt,
    DateTime? startAfter,
    DateTime? endAt,
    DateTime? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderBySpplrNm({
    bool descending = false,
    String? startAt,
    String? startAfter,
    String? endAt,
    String? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByIsComposite({
    bool descending = false,
    bool? startAt,
    bool? startAfter,
    bool? endAt,
    bool? endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });

  ProductQuery orderByComposites({
    bool descending = false,
    List<Composite> startAt,
    List<Composite> startAfter,
    List<Composite> endAt,
    List<Composite> endBefore,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  });
}

class _$ProductQuery extends QueryReference<Product, ProductQuerySnapshot>
    implements ProductQuery {
  _$ProductQuery(
    this._collection, {
    required Query<Product> $referenceWithoutCursor,
    $QueryCursor $queryCursor = const $QueryCursor(),
  }) : super(
          $referenceWithoutCursor: $referenceWithoutCursor,
          $queryCursor: $queryCursor,
        );

  final CollectionReference<Object?> _collection;

  @override
  Stream<ProductQuerySnapshot> snapshots([SnapshotOptions? options]) {
    return reference.snapshots().map(ProductQuerySnapshot._fromQuerySnapshot);
  }

  @override
  Future<ProductQuerySnapshot> get([GetOptions? options]) {
    return reference.get(options).then(ProductQuerySnapshot._fromQuerySnapshot);
  }

  @override
  ProductQuery limit(int limit) {
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limit(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery limitToLast(int limit) {
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.limitToLast(limit),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereFieldPath(
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
    return _$ProductQuery(
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
  ProductQuery whereDocumentId({
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
    return _$ProductQuery(
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
  ProductQuery whereId({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.id(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.id(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.id(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereName({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['name']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.name(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.name(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.name(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.name(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.name(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.name(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.name(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.name(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereDescription({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['description']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.description(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.description(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.description(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .description(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.description(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .description(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.description(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.description(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereTaxId({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['taxId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.taxId(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.taxId(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.taxId(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.taxId(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.taxId(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.taxId(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.taxId(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.taxId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereColor({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['color']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.color(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.color(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.color(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.color(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.color(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.color(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.color(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.color(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereBusinessId({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['businessId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.businessId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.businessId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.businessId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.businessId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.businessId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.businessId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.businessId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.businessId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereBranchId({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['branchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.branchId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.branchId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.branchId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.branchId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.branchId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.branchId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.branchId(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.branchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereSupplierId({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['supplierId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.supplierId(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.supplierId(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.supplierId(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.supplierId(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.supplierId(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .supplierId(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.supplierId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.supplierId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereCategoryId({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['categoryId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.categoryId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.categoryId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.categoryId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.categoryId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.categoryId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.categoryId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.categoryId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.categoryId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereCreatedAt({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['createdAt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.createdAt(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.createdAt(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.createdAt(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.createdAt(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.createdAt(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .createdAt(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.createdAt(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.createdAt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereUnit({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['unit']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.unit(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.unit(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.unit(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.unit(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.unit(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.unit(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.unit(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.unit(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereImageUrl({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['imageUrl']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.imageUrl(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.imageUrl(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.imageUrl(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.imageUrl(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.imageUrl(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .imageUrl(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.imageUrl(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.imageUrl(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereExpiryDate({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['expiryDate']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.expiryDate(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.expiryDate(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.expiryDate(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.expiryDate(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.expiryDate(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .expiryDate(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.expiryDate(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.expiryDate(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereBarCode({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['barCode']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.barCode(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.barCode(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.barCode(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.barCode(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.barCode(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.barCode(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.barCode(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.barCode(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereNfcEnabled({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['nfcEnabled']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.nfcEnabled(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.nfcEnabled(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.nfcEnabled(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.nfcEnabled(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.nfcEnabled(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.nfcEnabled(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.nfcEnabled(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.nfcEnabled(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereBindedToTenantId({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['bindedToTenantId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.bindedToTenantId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.bindedToTenantId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.bindedToTenantId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .bindedToTenantId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.bindedToTenantId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .bindedToTenantId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn:
            whereIn?.map((e) => _$ProductPerFieldToJson.bindedToTenantId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.bindedToTenantId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereIsFavorite({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['isFavorite']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.isFavorite(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.isFavorite(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.isFavorite(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.isFavorite(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.isFavorite(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.isFavorite(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.isFavorite(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.isFavorite(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereLastTouched({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['lastTouched']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.lastTouched(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.lastTouched(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.lastTouched(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .lastTouched(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.lastTouched(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .lastTouched(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.lastTouched(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.lastTouched(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereDeletedAt({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['deletedAt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.deletedAt(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.deletedAt(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.deletedAt(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .deletedAt(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.deletedAt(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .deletedAt(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.deletedAt(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.deletedAt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereSpplrNm({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['spplrNm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.spplrNm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.spplrNm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.spplrNm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.spplrNm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.spplrNm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson.spplrNm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.spplrNm(e)),
        whereNotIn: whereNotIn?.map((e) => _$ProductPerFieldToJson.spplrNm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereIsComposite({
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
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['isComposite']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.isComposite(isEqualTo as bool?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson.isComposite(isNotEqualTo as bool?)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.isComposite(isLessThan as bool?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson.isComposite(isLessThanOrEqualTo as bool?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson.isComposite(isGreaterThan as bool?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .isComposite(isGreaterThanOrEqualTo as bool?)
            : null,
        whereIn: whereIn?.map((e) => _$ProductPerFieldToJson.isComposite(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$ProductPerFieldToJson.isComposite(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  ProductQuery whereComposites({
    Object? isEqualTo = _sentinel,
    Object? isNotEqualTo = _sentinel,
    Object? isLessThan,
    Object? isLessThanOrEqualTo,
    Object? isGreaterThan,
    Object? isGreaterThanOrEqualTo,
    Object? arrayContains,
    List<Composite>? arrayContainsAny,
    bool? isNull,
  }) {
    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$ProductFieldMap['composites']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$ProductPerFieldToJson.composites(isEqualTo as List<Composite>)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$ProductPerFieldToJson
                .composites(isNotEqualTo as List<Composite>)
            : null,
        isLessThan: isLessThan != null
            ? _$ProductPerFieldToJson.composites(isLessThan as List<Composite>)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .composites(isLessThanOrEqualTo as List<Composite>)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$ProductPerFieldToJson
                .composites(isGreaterThan as List<Composite>)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$ProductPerFieldToJson
                .composites(isGreaterThanOrEqualTo as List<Composite>)
            : null,
        arrayContains: arrayContains != null
            ? (_$ProductPerFieldToJson.composites([arrayContains as Composite])
                    as List?)!
                .single
            : null,
        arrayContainsAny: arrayContainsAny != null
            ? _$ProductPerFieldToJson.composites(arrayContainsAny)
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
  ProductQuery orderByFieldPath(
    Object fieldPath, {
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByDocumentId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderById({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$ProductFieldMap['id']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByName({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$ProductFieldMap['name']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByDescription({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['description']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByTaxId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$ProductFieldMap['taxId']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByColor({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$ProductFieldMap['color']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByBusinessId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['businessId']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByBranchId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['branchId']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderBySupplierId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['supplierId']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByCategoryId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['categoryId']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByCreatedAt({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['createdAt']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByUnit({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$ProductFieldMap['unit']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByImageUrl({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['imageUrl']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByExpiryDate({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['expiryDate']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByBarCode({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$ProductFieldMap['barCode']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByNfcEnabled({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['nfcEnabled']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByBindedToTenantId({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(
        _$ProductFieldMap['bindedToTenantId']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByIsFavorite({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['isFavorite']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByLastTouched({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['lastTouched']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByDeletedAt({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['deletedAt']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderBySpplrNm({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor.orderBy(_$ProductFieldMap['spplrNm']!,
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByIsComposite({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['isComposite']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  ProductQuery orderByComposites({
    bool descending = false,
    Object? startAt = _sentinel,
    Object? startAfter = _sentinel,
    Object? endAt = _sentinel,
    Object? endBefore = _sentinel,
    ProductDocumentSnapshot? startAtDocument,
    ProductDocumentSnapshot? endAtDocument,
    ProductDocumentSnapshot? endBeforeDocument,
    ProductDocumentSnapshot? startAfterDocument,
  }) {
    final query = $referenceWithoutCursor
        .orderBy(_$ProductFieldMap['composites']!, descending: descending);
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

    return _$ProductQuery(
      _collection,
      $referenceWithoutCursor: query,
      $queryCursor: queryCursor,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is _$ProductQuery &&
        other.runtimeType == runtimeType &&
        other.reference == reference;
  }

  @override
  int get hashCode => Object.hash(runtimeType, reference);
}

class ProductDocumentSnapshot extends FirestoreDocumentSnapshot<Product> {
  ProductDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final DocumentSnapshot<Product> snapshot;

  @override
  ProductDocumentReference get reference {
    return ProductDocumentReference(
      snapshot.reference,
    );
  }

  @override
  final Product? data;
}

class ProductQuerySnapshot
    extends FirestoreQuerySnapshot<Product, ProductQueryDocumentSnapshot> {
  ProductQuerySnapshot._(
    this.snapshot,
    this.docs,
    this.docChanges,
  );

  factory ProductQuerySnapshot._fromQuerySnapshot(
    QuerySnapshot<Product> snapshot,
  ) {
    final docs = snapshot.docs.map(ProductQueryDocumentSnapshot._).toList();

    final docChanges = snapshot.docChanges.map((change) {
      return _decodeDocumentChange(
        change,
        ProductDocumentSnapshot._,
      );
    }).toList();

    return ProductQuerySnapshot._(
      snapshot,
      docs,
      docChanges,
    );
  }

  static FirestoreDocumentChange<ProductDocumentSnapshot>
      _decodeDocumentChange<T>(
    DocumentChange<T> docChange,
    ProductDocumentSnapshot Function(DocumentSnapshot<T> doc) decodeDoc,
  ) {
    return FirestoreDocumentChange<ProductDocumentSnapshot>(
      type: docChange.type,
      oldIndex: docChange.oldIndex,
      newIndex: docChange.newIndex,
      doc: decodeDoc(docChange.doc),
    );
  }

  final QuerySnapshot<Product> snapshot;

  @override
  final List<ProductQueryDocumentSnapshot> docs;

  @override
  final List<FirestoreDocumentChange<ProductDocumentSnapshot>> docChanges;
}

class ProductQueryDocumentSnapshot
    extends FirestoreQueryDocumentSnapshot<Product>
    implements ProductDocumentSnapshot {
  ProductQueryDocumentSnapshot._(this.snapshot) : data = snapshot.data();

  @override
  final QueryDocumentSnapshot<Product> snapshot;

  @override
  final Product data;

  @override
  ProductDocumentReference get reference {
    return ProductDocumentReference(snapshot.reference);
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      taxId: json['taxId'] as String?,
      color: json['color'] as String? ?? '#e74c3c',
      businessId: (json['businessId'] as num?)?.toInt(),
      branchId: (json['branchId'] as num?)?.toInt(),
      supplierId: json['supplierId'] as String?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      unit: json['unit'] as String?,
      imageUrl: json['imageUrl'] as String?,
      expiryDate: json['expiryDate'] as String?,
      barCode: json['barCode'] as String?,
      nfcEnabled: json['nfcEnabled'] as bool? ?? false,
      bindedToTenantId: (json['bindedToTenantId'] as num?)?.toInt(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      searchMatch: json['searchMatch'] as bool? ?? false,
      spplrNm: json['spplrNm'] as String?,
      isComposite: json['isComposite'] as bool? ?? false,
      composites: (json['composites'] as List<dynamic>?)
              ?.map((e) => Composite.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

const _$ProductFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'description': 'description',
  'taxId': 'taxId',
  'color': 'color',
  'businessId': 'businessId',
  'branchId': 'branchId',
  'supplierId': 'supplierId',
  'categoryId': 'categoryId',
  'createdAt': 'createdAt',
  'unit': 'unit',
  'imageUrl': 'imageUrl',
  'expiryDate': 'expiryDate',
  'barCode': 'barCode',
  'nfcEnabled': 'nfcEnabled',
  'bindedToTenantId': 'bindedToTenantId',
  'isFavorite': 'isFavorite',
  'lastTouched': 'lastTouched',
  'deletedAt': 'deletedAt',
  'spplrNm': 'spplrNm',
  'isComposite': 'isComposite',
  'composites': 'composites',
};

// ignore: unused_element
abstract class _$ProductPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? description(String? instance) => instance;
  // ignore: unused_element
  static Object? taxId(String? instance) => instance;
  // ignore: unused_element
  static Object? color(String instance) => instance;
  // ignore: unused_element
  static Object? businessId(int? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? supplierId(String? instance) => instance;
  // ignore: unused_element
  static Object? categoryId(int? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(String? instance) => instance;
  // ignore: unused_element
  static Object? unit(String? instance) => instance;
  // ignore: unused_element
  static Object? imageUrl(String? instance) => instance;
  // ignore: unused_element
  static Object? expiryDate(String? instance) => instance;
  // ignore: unused_element
  static Object? barCode(String? instance) => instance;
  // ignore: unused_element
  static Object? nfcEnabled(bool instance) => instance;
  // ignore: unused_element
  static Object? bindedToTenantId(int? instance) => instance;
  // ignore: unused_element
  static Object? isFavorite(bool instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? spplrNm(String? instance) => instance;
  // ignore: unused_element
  static Object? isComposite(bool? instance) => instance;
  // ignore: unused_element
  static Object? composites(List<Composite> instance) => instance;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'taxId': instance.taxId,
      'color': instance.color,
      'businessId': instance.businessId,
      'branchId': instance.branchId,
      'supplierId': instance.supplierId,
      'categoryId': instance.categoryId,
      'createdAt': instance.createdAt,
      'unit': instance.unit,
      'imageUrl': instance.imageUrl,
      'expiryDate': instance.expiryDate,
      'barCode': instance.barCode,
      'nfcEnabled': instance.nfcEnabled,
      'bindedToTenantId': instance.bindedToTenantId,
      'isFavorite': instance.isFavorite,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'spplrNm': instance.spplrNm,
      'isComposite': instance.isComposite,
      'composites': instance.composites,
    };
