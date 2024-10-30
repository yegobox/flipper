// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant.dart';

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
    FieldValue deletedAtFieldValue,
    FieldValue nameFieldValue,
    FieldValue colorFieldValue,
    FieldValue skuFieldValue,
    FieldValue productIdFieldValue,
    FieldValue unitFieldValue,
    FieldValue productNameFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue taxNameFieldValue,
    FieldValue taxPercentageFieldValue,
    FieldValue itemSeqFieldValue,
    FieldValue isrccCdFieldValue,
    FieldValue isrccNmFieldValue,
    FieldValue isrcRtFieldValue,
    FieldValue isrcAmtFieldValue,
    FieldValue taxTyCdFieldValue,
    FieldValue bcdFieldValue,
    FieldValue itemClsCdFieldValue,
    FieldValue itemTyCdFieldValue,
    FieldValue itemStdNmFieldValue,
    FieldValue orgnNatCdFieldValue,
    FieldValue pkgFieldValue,
    FieldValue itemCdFieldValue,
    FieldValue pkgUnitCdFieldValue,
    FieldValue qtyUnitCdFieldValue,
    FieldValue itemNmFieldValue,
    FieldValue qtyFieldValue,
    FieldValue prcFieldValue,
    FieldValue splyAmtFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhfIdFieldValue,
    FieldValue dftPrcFieldValue,
    FieldValue addInfoFieldValue,
    FieldValue isrcAplcbYnFieldValue,
    FieldValue useYnFieldValue,
    FieldValue regrIdFieldValue,
    FieldValue regrNmFieldValue,
    FieldValue modrIdFieldValue,
    FieldValue modrNmFieldValue,
    FieldValue rsdQtyFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue supplyPriceFieldValue,
    FieldValue retailPriceFieldValue,
    FieldValue spplrItemClsCdFieldValue,
    FieldValue spplrItemCdFieldValue,
    FieldValue spplrItemNmFieldValue,
    FieldValue ebmSyncedFieldValue,
    FieldValue isTaxExemptedFieldValue,
    FieldValue taxTypeFieldValue,
    FieldValue branchIdsFieldValue,
    FieldValue stockFieldValue,
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
    FieldValue deletedAtFieldValue,
    FieldValue nameFieldValue,
    FieldValue colorFieldValue,
    FieldValue skuFieldValue,
    FieldValue productIdFieldValue,
    FieldValue unitFieldValue,
    FieldValue productNameFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue taxNameFieldValue,
    FieldValue taxPercentageFieldValue,
    FieldValue itemSeqFieldValue,
    FieldValue isrccCdFieldValue,
    FieldValue isrccNmFieldValue,
    FieldValue isrcRtFieldValue,
    FieldValue isrcAmtFieldValue,
    FieldValue taxTyCdFieldValue,
    FieldValue bcdFieldValue,
    FieldValue itemClsCdFieldValue,
    FieldValue itemTyCdFieldValue,
    FieldValue itemStdNmFieldValue,
    FieldValue orgnNatCdFieldValue,
    FieldValue pkgFieldValue,
    FieldValue itemCdFieldValue,
    FieldValue pkgUnitCdFieldValue,
    FieldValue qtyUnitCdFieldValue,
    FieldValue itemNmFieldValue,
    FieldValue qtyFieldValue,
    FieldValue prcFieldValue,
    FieldValue splyAmtFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhfIdFieldValue,
    FieldValue dftPrcFieldValue,
    FieldValue addInfoFieldValue,
    FieldValue isrcAplcbYnFieldValue,
    FieldValue useYnFieldValue,
    FieldValue regrIdFieldValue,
    FieldValue regrNmFieldValue,
    FieldValue modrIdFieldValue,
    FieldValue modrNmFieldValue,
    FieldValue rsdQtyFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue supplyPriceFieldValue,
    FieldValue retailPriceFieldValue,
    FieldValue spplrItemClsCdFieldValue,
    FieldValue spplrItemCdFieldValue,
    FieldValue spplrItemNmFieldValue,
    FieldValue ebmSyncedFieldValue,
    FieldValue isTaxExemptedFieldValue,
    FieldValue taxTypeFieldValue,
    FieldValue branchIdsFieldValue,
    FieldValue stockFieldValue,
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
    FieldValue deletedAtFieldValue,
    FieldValue nameFieldValue,
    FieldValue colorFieldValue,
    FieldValue skuFieldValue,
    FieldValue productIdFieldValue,
    FieldValue unitFieldValue,
    FieldValue productNameFieldValue,
    FieldValue branchIdFieldValue,
    FieldValue taxNameFieldValue,
    FieldValue taxPercentageFieldValue,
    FieldValue itemSeqFieldValue,
    FieldValue isrccCdFieldValue,
    FieldValue isrccNmFieldValue,
    FieldValue isrcRtFieldValue,
    FieldValue isrcAmtFieldValue,
    FieldValue taxTyCdFieldValue,
    FieldValue bcdFieldValue,
    FieldValue itemClsCdFieldValue,
    FieldValue itemTyCdFieldValue,
    FieldValue itemStdNmFieldValue,
    FieldValue orgnNatCdFieldValue,
    FieldValue pkgFieldValue,
    FieldValue itemCdFieldValue,
    FieldValue pkgUnitCdFieldValue,
    FieldValue qtyUnitCdFieldValue,
    FieldValue itemNmFieldValue,
    FieldValue qtyFieldValue,
    FieldValue prcFieldValue,
    FieldValue splyAmtFieldValue,
    FieldValue tinFieldValue,
    FieldValue bhfIdFieldValue,
    FieldValue dftPrcFieldValue,
    FieldValue addInfoFieldValue,
    FieldValue isrcAplcbYnFieldValue,
    FieldValue useYnFieldValue,
    FieldValue regrIdFieldValue,
    FieldValue regrNmFieldValue,
    FieldValue modrIdFieldValue,
    FieldValue modrNmFieldValue,
    FieldValue rsdQtyFieldValue,
    FieldValue lastTouchedFieldValue,
    FieldValue supplyPriceFieldValue,
    FieldValue retailPriceFieldValue,
    FieldValue spplrItemClsCdFieldValue,
    FieldValue spplrItemCdFieldValue,
    FieldValue spplrItemNmFieldValue,
    FieldValue ebmSyncedFieldValue,
    FieldValue isTaxExemptedFieldValue,
    FieldValue taxTypeFieldValue,
    FieldValue branchIdsFieldValue,
    FieldValue stockFieldValue,
  });

  /// Updates data on the document. Data will be merged with any existing
  /// document data.
  ///
  /// If no document exists yet, the update will fail.
  Future<void> update({
    int? id,
    FieldValue idFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? color,
    FieldValue colorFieldValue,
    String? sku,
    FieldValue skuFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? productName,
    FieldValue productNameFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? taxName,
    FieldValue taxNameFieldValue,
    double taxPercentage,
    FieldValue taxPercentageFieldValue,
    int? itemSeq,
    FieldValue itemSeqFieldValue,
    String? isrccCd,
    FieldValue isrccCdFieldValue,
    String? isrccNm,
    FieldValue isrccNmFieldValue,
    int? isrcRt,
    FieldValue isrcRtFieldValue,
    int? isrcAmt,
    FieldValue isrcAmtFieldValue,
    String? taxTyCd,
    FieldValue taxTyCdFieldValue,
    String? bcd,
    FieldValue bcdFieldValue,
    String? itemClsCd,
    FieldValue itemClsCdFieldValue,
    String? itemTyCd,
    FieldValue itemTyCdFieldValue,
    String? itemStdNm,
    FieldValue itemStdNmFieldValue,
    String? orgnNatCd,
    FieldValue orgnNatCdFieldValue,
    String? pkg,
    FieldValue pkgFieldValue,
    String? itemCd,
    FieldValue itemCdFieldValue,
    String? pkgUnitCd,
    FieldValue pkgUnitCdFieldValue,
    String? qtyUnitCd,
    FieldValue qtyUnitCdFieldValue,
    String? itemNm,
    FieldValue itemNmFieldValue,
    double qty,
    FieldValue qtyFieldValue,
    double prc,
    FieldValue prcFieldValue,
    double splyAmt,
    FieldValue splyAmtFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhfId,
    FieldValue bhfIdFieldValue,
    double? dftPrc,
    FieldValue dftPrcFieldValue,
    String? addInfo,
    FieldValue addInfoFieldValue,
    String? isrcAplcbYn,
    FieldValue isrcAplcbYnFieldValue,
    String? useYn,
    FieldValue useYnFieldValue,
    String? regrId,
    FieldValue regrIdFieldValue,
    String? regrNm,
    FieldValue regrNmFieldValue,
    String? modrId,
    FieldValue modrIdFieldValue,
    String? modrNm,
    FieldValue modrNmFieldValue,
    double rsdQty,
    FieldValue rsdQtyFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    double supplyPrice,
    FieldValue supplyPriceFieldValue,
    double retailPrice,
    FieldValue retailPriceFieldValue,
    String? spplrItemClsCd,
    FieldValue spplrItemClsCdFieldValue,
    String? spplrItemCd,
    FieldValue spplrItemCdFieldValue,
    String? spplrItemNm,
    FieldValue spplrItemNmFieldValue,
    bool ebmSynced,
    FieldValue ebmSyncedFieldValue,
    bool isTaxExempted,
    FieldValue isTaxExemptedFieldValue,
    String taxType,
    FieldValue taxTypeFieldValue,
    List<int> branchIds,
    FieldValue branchIdsFieldValue,
    Stock? stock,
    FieldValue stockFieldValue,
  });

  /// Updates fields in the current document using the transaction API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void transactionUpdate(
    Transaction transaction, {
    int? id,
    FieldValue idFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? color,
    FieldValue colorFieldValue,
    String? sku,
    FieldValue skuFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? productName,
    FieldValue productNameFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? taxName,
    FieldValue taxNameFieldValue,
    double taxPercentage,
    FieldValue taxPercentageFieldValue,
    int? itemSeq,
    FieldValue itemSeqFieldValue,
    String? isrccCd,
    FieldValue isrccCdFieldValue,
    String? isrccNm,
    FieldValue isrccNmFieldValue,
    int? isrcRt,
    FieldValue isrcRtFieldValue,
    int? isrcAmt,
    FieldValue isrcAmtFieldValue,
    String? taxTyCd,
    FieldValue taxTyCdFieldValue,
    String? bcd,
    FieldValue bcdFieldValue,
    String? itemClsCd,
    FieldValue itemClsCdFieldValue,
    String? itemTyCd,
    FieldValue itemTyCdFieldValue,
    String? itemStdNm,
    FieldValue itemStdNmFieldValue,
    String? orgnNatCd,
    FieldValue orgnNatCdFieldValue,
    String? pkg,
    FieldValue pkgFieldValue,
    String? itemCd,
    FieldValue itemCdFieldValue,
    String? pkgUnitCd,
    FieldValue pkgUnitCdFieldValue,
    String? qtyUnitCd,
    FieldValue qtyUnitCdFieldValue,
    String? itemNm,
    FieldValue itemNmFieldValue,
    double qty,
    FieldValue qtyFieldValue,
    double prc,
    FieldValue prcFieldValue,
    double splyAmt,
    FieldValue splyAmtFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhfId,
    FieldValue bhfIdFieldValue,
    double? dftPrc,
    FieldValue dftPrcFieldValue,
    String? addInfo,
    FieldValue addInfoFieldValue,
    String? isrcAplcbYn,
    FieldValue isrcAplcbYnFieldValue,
    String? useYn,
    FieldValue useYnFieldValue,
    String? regrId,
    FieldValue regrIdFieldValue,
    String? regrNm,
    FieldValue regrNmFieldValue,
    String? modrId,
    FieldValue modrIdFieldValue,
    String? modrNm,
    FieldValue modrNmFieldValue,
    double rsdQty,
    FieldValue rsdQtyFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    double supplyPrice,
    FieldValue supplyPriceFieldValue,
    double retailPrice,
    FieldValue retailPriceFieldValue,
    String? spplrItemClsCd,
    FieldValue spplrItemClsCdFieldValue,
    String? spplrItemCd,
    FieldValue spplrItemCdFieldValue,
    String? spplrItemNm,
    FieldValue spplrItemNmFieldValue,
    bool ebmSynced,
    FieldValue ebmSyncedFieldValue,
    bool isTaxExempted,
    FieldValue isTaxExemptedFieldValue,
    String taxType,
    FieldValue taxTypeFieldValue,
    List<int> branchIds,
    FieldValue branchIdsFieldValue,
    Stock? stock,
    FieldValue stockFieldValue,
  });

  /// Updates fields in the current document using the batch API.
  ///
  /// The update will fail if applied to a document that does not exist.
  void batchUpdate(
    WriteBatch batch, {
    int? id,
    FieldValue idFieldValue,
    DateTime? deletedAt,
    FieldValue deletedAtFieldValue,
    String? name,
    FieldValue nameFieldValue,
    String? color,
    FieldValue colorFieldValue,
    String? sku,
    FieldValue skuFieldValue,
    int? productId,
    FieldValue productIdFieldValue,
    String? unit,
    FieldValue unitFieldValue,
    String? productName,
    FieldValue productNameFieldValue,
    int? branchId,
    FieldValue branchIdFieldValue,
    String? taxName,
    FieldValue taxNameFieldValue,
    double taxPercentage,
    FieldValue taxPercentageFieldValue,
    int? itemSeq,
    FieldValue itemSeqFieldValue,
    String? isrccCd,
    FieldValue isrccCdFieldValue,
    String? isrccNm,
    FieldValue isrccNmFieldValue,
    int? isrcRt,
    FieldValue isrcRtFieldValue,
    int? isrcAmt,
    FieldValue isrcAmtFieldValue,
    String? taxTyCd,
    FieldValue taxTyCdFieldValue,
    String? bcd,
    FieldValue bcdFieldValue,
    String? itemClsCd,
    FieldValue itemClsCdFieldValue,
    String? itemTyCd,
    FieldValue itemTyCdFieldValue,
    String? itemStdNm,
    FieldValue itemStdNmFieldValue,
    String? orgnNatCd,
    FieldValue orgnNatCdFieldValue,
    String? pkg,
    FieldValue pkgFieldValue,
    String? itemCd,
    FieldValue itemCdFieldValue,
    String? pkgUnitCd,
    FieldValue pkgUnitCdFieldValue,
    String? qtyUnitCd,
    FieldValue qtyUnitCdFieldValue,
    String? itemNm,
    FieldValue itemNmFieldValue,
    double qty,
    FieldValue qtyFieldValue,
    double prc,
    FieldValue prcFieldValue,
    double splyAmt,
    FieldValue splyAmtFieldValue,
    int? tin,
    FieldValue tinFieldValue,
    String? bhfId,
    FieldValue bhfIdFieldValue,
    double? dftPrc,
    FieldValue dftPrcFieldValue,
    String? addInfo,
    FieldValue addInfoFieldValue,
    String? isrcAplcbYn,
    FieldValue isrcAplcbYnFieldValue,
    String? useYn,
    FieldValue useYnFieldValue,
    String? regrId,
    FieldValue regrIdFieldValue,
    String? regrNm,
    FieldValue regrNmFieldValue,
    String? modrId,
    FieldValue modrIdFieldValue,
    String? modrNm,
    FieldValue modrNmFieldValue,
    double rsdQty,
    FieldValue rsdQtyFieldValue,
    DateTime? lastTouched,
    FieldValue lastTouchedFieldValue,
    double supplyPrice,
    FieldValue supplyPriceFieldValue,
    double retailPrice,
    FieldValue retailPriceFieldValue,
    String? spplrItemClsCd,
    FieldValue spplrItemClsCdFieldValue,
    String? spplrItemCd,
    FieldValue spplrItemCdFieldValue,
    String? spplrItemNm,
    FieldValue spplrItemNmFieldValue,
    bool ebmSynced,
    FieldValue ebmSyncedFieldValue,
    bool isTaxExempted,
    FieldValue isTaxExemptedFieldValue,
    String taxType,
    FieldValue taxTypeFieldValue,
    List<int> branchIds,
    FieldValue branchIdsFieldValue,
    Stock? stock,
    FieldValue stockFieldValue,
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
    FieldValue? deletedAtFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? skuFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? productNameFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? taxNameFieldValue,
    FieldValue? taxPercentageFieldValue,
    FieldValue? itemSeqFieldValue,
    FieldValue? isrccCdFieldValue,
    FieldValue? isrccNmFieldValue,
    FieldValue? isrcRtFieldValue,
    FieldValue? isrcAmtFieldValue,
    FieldValue? taxTyCdFieldValue,
    FieldValue? bcdFieldValue,
    FieldValue? itemClsCdFieldValue,
    FieldValue? itemTyCdFieldValue,
    FieldValue? itemStdNmFieldValue,
    FieldValue? orgnNatCdFieldValue,
    FieldValue? pkgFieldValue,
    FieldValue? itemCdFieldValue,
    FieldValue? pkgUnitCdFieldValue,
    FieldValue? qtyUnitCdFieldValue,
    FieldValue? itemNmFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? prcFieldValue,
    FieldValue? splyAmtFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhfIdFieldValue,
    FieldValue? dftPrcFieldValue,
    FieldValue? addInfoFieldValue,
    FieldValue? isrcAplcbYnFieldValue,
    FieldValue? useYnFieldValue,
    FieldValue? regrIdFieldValue,
    FieldValue? regrNmFieldValue,
    FieldValue? modrIdFieldValue,
    FieldValue? modrNmFieldValue,
    FieldValue? rsdQtyFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? supplyPriceFieldValue,
    FieldValue? retailPriceFieldValue,
    FieldValue? spplrItemClsCdFieldValue,
    FieldValue? spplrItemCdFieldValue,
    FieldValue? spplrItemNmFieldValue,
    FieldValue? ebmSyncedFieldValue,
    FieldValue? isTaxExemptedFieldValue,
    FieldValue? taxTypeFieldValue,
    FieldValue? branchIdsFieldValue,
    FieldValue? stockFieldValue,
  }) async {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (deletedAtFieldValue != null)
        _$VariantFieldMap['deletedAt']!: deletedAtFieldValue,
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (productIdFieldValue != null)
        _$VariantFieldMap['productId']!: productIdFieldValue,
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (productNameFieldValue != null)
        _$VariantFieldMap['productName']!: productNameFieldValue,
      if (branchIdFieldValue != null)
        _$VariantFieldMap['branchId']!: branchIdFieldValue,
      if (taxNameFieldValue != null)
        _$VariantFieldMap['taxName']!: taxNameFieldValue,
      if (taxPercentageFieldValue != null)
        _$VariantFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (itemSeqFieldValue != null)
        _$VariantFieldMap['itemSeq']!: itemSeqFieldValue,
      if (isrccCdFieldValue != null)
        _$VariantFieldMap['isrccCd']!: isrccCdFieldValue,
      if (isrccNmFieldValue != null)
        _$VariantFieldMap['isrccNm']!: isrccNmFieldValue,
      if (isrcRtFieldValue != null)
        _$VariantFieldMap['isrcRt']!: isrcRtFieldValue,
      if (isrcAmtFieldValue != null)
        _$VariantFieldMap['isrcAmt']!: isrcAmtFieldValue,
      if (taxTyCdFieldValue != null)
        _$VariantFieldMap['taxTyCd']!: taxTyCdFieldValue,
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (itemClsCdFieldValue != null)
        _$VariantFieldMap['itemClsCd']!: itemClsCdFieldValue,
      if (itemTyCdFieldValue != null)
        _$VariantFieldMap['itemTyCd']!: itemTyCdFieldValue,
      if (itemStdNmFieldValue != null)
        _$VariantFieldMap['itemStdNm']!: itemStdNmFieldValue,
      if (orgnNatCdFieldValue != null)
        _$VariantFieldMap['orgnNatCd']!: orgnNatCdFieldValue,
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (itemCdFieldValue != null)
        _$VariantFieldMap['itemCd']!: itemCdFieldValue,
      if (pkgUnitCdFieldValue != null)
        _$VariantFieldMap['pkgUnitCd']!: pkgUnitCdFieldValue,
      if (qtyUnitCdFieldValue != null)
        _$VariantFieldMap['qtyUnitCd']!: qtyUnitCdFieldValue,
      if (itemNmFieldValue != null)
        _$VariantFieldMap['itemNm']!: itemNmFieldValue,
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (splyAmtFieldValue != null)
        _$VariantFieldMap['splyAmt']!: splyAmtFieldValue,
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhfIdFieldValue != null) _$VariantFieldMap['bhfId']!: bhfIdFieldValue,
      if (dftPrcFieldValue != null)
        _$VariantFieldMap['dftPrc']!: dftPrcFieldValue,
      if (addInfoFieldValue != null)
        _$VariantFieldMap['addInfo']!: addInfoFieldValue,
      if (isrcAplcbYnFieldValue != null)
        _$VariantFieldMap['isrcAplcbYn']!: isrcAplcbYnFieldValue,
      if (useYnFieldValue != null) _$VariantFieldMap['useYn']!: useYnFieldValue,
      if (regrIdFieldValue != null)
        _$VariantFieldMap['regrId']!: regrIdFieldValue,
      if (regrNmFieldValue != null)
        _$VariantFieldMap['regrNm']!: regrNmFieldValue,
      if (modrIdFieldValue != null)
        _$VariantFieldMap['modrId']!: modrIdFieldValue,
      if (modrNmFieldValue != null)
        _$VariantFieldMap['modrNm']!: modrNmFieldValue,
      if (rsdQtyFieldValue != null)
        _$VariantFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (lastTouchedFieldValue != null)
        _$VariantFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (supplyPriceFieldValue != null)
        _$VariantFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPriceFieldValue != null)
        _$VariantFieldMap['retailPrice']!: retailPriceFieldValue,
      if (spplrItemClsCdFieldValue != null)
        _$VariantFieldMap['spplrItemClsCd']!: spplrItemClsCdFieldValue,
      if (spplrItemCdFieldValue != null)
        _$VariantFieldMap['spplrItemCd']!: spplrItemCdFieldValue,
      if (spplrItemNmFieldValue != null)
        _$VariantFieldMap['spplrItemNm']!: spplrItemNmFieldValue,
      if (ebmSyncedFieldValue != null)
        _$VariantFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (isTaxExemptedFieldValue != null)
        _$VariantFieldMap['isTaxExempted']!: isTaxExemptedFieldValue,
      if (taxTypeFieldValue != null)
        _$VariantFieldMap['taxType']!: taxTypeFieldValue,
      if (branchIdsFieldValue != null)
        _$VariantFieldMap['branchIds']!: branchIdsFieldValue,
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
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
    FieldValue? deletedAtFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? skuFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? productNameFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? taxNameFieldValue,
    FieldValue? taxPercentageFieldValue,
    FieldValue? itemSeqFieldValue,
    FieldValue? isrccCdFieldValue,
    FieldValue? isrccNmFieldValue,
    FieldValue? isrcRtFieldValue,
    FieldValue? isrcAmtFieldValue,
    FieldValue? taxTyCdFieldValue,
    FieldValue? bcdFieldValue,
    FieldValue? itemClsCdFieldValue,
    FieldValue? itemTyCdFieldValue,
    FieldValue? itemStdNmFieldValue,
    FieldValue? orgnNatCdFieldValue,
    FieldValue? pkgFieldValue,
    FieldValue? itemCdFieldValue,
    FieldValue? pkgUnitCdFieldValue,
    FieldValue? qtyUnitCdFieldValue,
    FieldValue? itemNmFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? prcFieldValue,
    FieldValue? splyAmtFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhfIdFieldValue,
    FieldValue? dftPrcFieldValue,
    FieldValue? addInfoFieldValue,
    FieldValue? isrcAplcbYnFieldValue,
    FieldValue? useYnFieldValue,
    FieldValue? regrIdFieldValue,
    FieldValue? regrNmFieldValue,
    FieldValue? modrIdFieldValue,
    FieldValue? modrNmFieldValue,
    FieldValue? rsdQtyFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? supplyPriceFieldValue,
    FieldValue? retailPriceFieldValue,
    FieldValue? spplrItemClsCdFieldValue,
    FieldValue? spplrItemCdFieldValue,
    FieldValue? spplrItemNmFieldValue,
    FieldValue? ebmSyncedFieldValue,
    FieldValue? isTaxExemptedFieldValue,
    FieldValue? taxTypeFieldValue,
    FieldValue? branchIdsFieldValue,
    FieldValue? stockFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (deletedAtFieldValue != null)
        _$VariantFieldMap['deletedAt']!: deletedAtFieldValue,
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (productIdFieldValue != null)
        _$VariantFieldMap['productId']!: productIdFieldValue,
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (productNameFieldValue != null)
        _$VariantFieldMap['productName']!: productNameFieldValue,
      if (branchIdFieldValue != null)
        _$VariantFieldMap['branchId']!: branchIdFieldValue,
      if (taxNameFieldValue != null)
        _$VariantFieldMap['taxName']!: taxNameFieldValue,
      if (taxPercentageFieldValue != null)
        _$VariantFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (itemSeqFieldValue != null)
        _$VariantFieldMap['itemSeq']!: itemSeqFieldValue,
      if (isrccCdFieldValue != null)
        _$VariantFieldMap['isrccCd']!: isrccCdFieldValue,
      if (isrccNmFieldValue != null)
        _$VariantFieldMap['isrccNm']!: isrccNmFieldValue,
      if (isrcRtFieldValue != null)
        _$VariantFieldMap['isrcRt']!: isrcRtFieldValue,
      if (isrcAmtFieldValue != null)
        _$VariantFieldMap['isrcAmt']!: isrcAmtFieldValue,
      if (taxTyCdFieldValue != null)
        _$VariantFieldMap['taxTyCd']!: taxTyCdFieldValue,
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (itemClsCdFieldValue != null)
        _$VariantFieldMap['itemClsCd']!: itemClsCdFieldValue,
      if (itemTyCdFieldValue != null)
        _$VariantFieldMap['itemTyCd']!: itemTyCdFieldValue,
      if (itemStdNmFieldValue != null)
        _$VariantFieldMap['itemStdNm']!: itemStdNmFieldValue,
      if (orgnNatCdFieldValue != null)
        _$VariantFieldMap['orgnNatCd']!: orgnNatCdFieldValue,
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (itemCdFieldValue != null)
        _$VariantFieldMap['itemCd']!: itemCdFieldValue,
      if (pkgUnitCdFieldValue != null)
        _$VariantFieldMap['pkgUnitCd']!: pkgUnitCdFieldValue,
      if (qtyUnitCdFieldValue != null)
        _$VariantFieldMap['qtyUnitCd']!: qtyUnitCdFieldValue,
      if (itemNmFieldValue != null)
        _$VariantFieldMap['itemNm']!: itemNmFieldValue,
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (splyAmtFieldValue != null)
        _$VariantFieldMap['splyAmt']!: splyAmtFieldValue,
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhfIdFieldValue != null) _$VariantFieldMap['bhfId']!: bhfIdFieldValue,
      if (dftPrcFieldValue != null)
        _$VariantFieldMap['dftPrc']!: dftPrcFieldValue,
      if (addInfoFieldValue != null)
        _$VariantFieldMap['addInfo']!: addInfoFieldValue,
      if (isrcAplcbYnFieldValue != null)
        _$VariantFieldMap['isrcAplcbYn']!: isrcAplcbYnFieldValue,
      if (useYnFieldValue != null) _$VariantFieldMap['useYn']!: useYnFieldValue,
      if (regrIdFieldValue != null)
        _$VariantFieldMap['regrId']!: regrIdFieldValue,
      if (regrNmFieldValue != null)
        _$VariantFieldMap['regrNm']!: regrNmFieldValue,
      if (modrIdFieldValue != null)
        _$VariantFieldMap['modrId']!: modrIdFieldValue,
      if (modrNmFieldValue != null)
        _$VariantFieldMap['modrNm']!: modrNmFieldValue,
      if (rsdQtyFieldValue != null)
        _$VariantFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (lastTouchedFieldValue != null)
        _$VariantFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (supplyPriceFieldValue != null)
        _$VariantFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPriceFieldValue != null)
        _$VariantFieldMap['retailPrice']!: retailPriceFieldValue,
      if (spplrItemClsCdFieldValue != null)
        _$VariantFieldMap['spplrItemClsCd']!: spplrItemClsCdFieldValue,
      if (spplrItemCdFieldValue != null)
        _$VariantFieldMap['spplrItemCd']!: spplrItemCdFieldValue,
      if (spplrItemNmFieldValue != null)
        _$VariantFieldMap['spplrItemNm']!: spplrItemNmFieldValue,
      if (ebmSyncedFieldValue != null)
        _$VariantFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (isTaxExemptedFieldValue != null)
        _$VariantFieldMap['isTaxExempted']!: isTaxExemptedFieldValue,
      if (taxTypeFieldValue != null)
        _$VariantFieldMap['taxType']!: taxTypeFieldValue,
      if (branchIdsFieldValue != null)
        _$VariantFieldMap['branchIds']!: branchIdsFieldValue,
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
    };

    transaction.set(reference, json, options);
  }

  void batchSet(
    WriteBatch batch,
    Variant model, {
    SetOptions? options,
    FieldValue? idFieldValue,
    FieldValue? deletedAtFieldValue,
    FieldValue? nameFieldValue,
    FieldValue? colorFieldValue,
    FieldValue? skuFieldValue,
    FieldValue? productIdFieldValue,
    FieldValue? unitFieldValue,
    FieldValue? productNameFieldValue,
    FieldValue? branchIdFieldValue,
    FieldValue? taxNameFieldValue,
    FieldValue? taxPercentageFieldValue,
    FieldValue? itemSeqFieldValue,
    FieldValue? isrccCdFieldValue,
    FieldValue? isrccNmFieldValue,
    FieldValue? isrcRtFieldValue,
    FieldValue? isrcAmtFieldValue,
    FieldValue? taxTyCdFieldValue,
    FieldValue? bcdFieldValue,
    FieldValue? itemClsCdFieldValue,
    FieldValue? itemTyCdFieldValue,
    FieldValue? itemStdNmFieldValue,
    FieldValue? orgnNatCdFieldValue,
    FieldValue? pkgFieldValue,
    FieldValue? itemCdFieldValue,
    FieldValue? pkgUnitCdFieldValue,
    FieldValue? qtyUnitCdFieldValue,
    FieldValue? itemNmFieldValue,
    FieldValue? qtyFieldValue,
    FieldValue? prcFieldValue,
    FieldValue? splyAmtFieldValue,
    FieldValue? tinFieldValue,
    FieldValue? bhfIdFieldValue,
    FieldValue? dftPrcFieldValue,
    FieldValue? addInfoFieldValue,
    FieldValue? isrcAplcbYnFieldValue,
    FieldValue? useYnFieldValue,
    FieldValue? regrIdFieldValue,
    FieldValue? regrNmFieldValue,
    FieldValue? modrIdFieldValue,
    FieldValue? modrNmFieldValue,
    FieldValue? rsdQtyFieldValue,
    FieldValue? lastTouchedFieldValue,
    FieldValue? supplyPriceFieldValue,
    FieldValue? retailPriceFieldValue,
    FieldValue? spplrItemClsCdFieldValue,
    FieldValue? spplrItemCdFieldValue,
    FieldValue? spplrItemNmFieldValue,
    FieldValue? ebmSyncedFieldValue,
    FieldValue? isTaxExemptedFieldValue,
    FieldValue? taxTypeFieldValue,
    FieldValue? branchIdsFieldValue,
    FieldValue? stockFieldValue,
  }) {
    final json = {
      ...model.toJson(),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (deletedAtFieldValue != null)
        _$VariantFieldMap['deletedAt']!: deletedAtFieldValue,
      if (nameFieldValue != null) _$VariantFieldMap['name']!: nameFieldValue,
      if (colorFieldValue != null) _$VariantFieldMap['color']!: colorFieldValue,
      if (skuFieldValue != null) _$VariantFieldMap['sku']!: skuFieldValue,
      if (productIdFieldValue != null)
        _$VariantFieldMap['productId']!: productIdFieldValue,
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (productNameFieldValue != null)
        _$VariantFieldMap['productName']!: productNameFieldValue,
      if (branchIdFieldValue != null)
        _$VariantFieldMap['branchId']!: branchIdFieldValue,
      if (taxNameFieldValue != null)
        _$VariantFieldMap['taxName']!: taxNameFieldValue,
      if (taxPercentageFieldValue != null)
        _$VariantFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (itemSeqFieldValue != null)
        _$VariantFieldMap['itemSeq']!: itemSeqFieldValue,
      if (isrccCdFieldValue != null)
        _$VariantFieldMap['isrccCd']!: isrccCdFieldValue,
      if (isrccNmFieldValue != null)
        _$VariantFieldMap['isrccNm']!: isrccNmFieldValue,
      if (isrcRtFieldValue != null)
        _$VariantFieldMap['isrcRt']!: isrcRtFieldValue,
      if (isrcAmtFieldValue != null)
        _$VariantFieldMap['isrcAmt']!: isrcAmtFieldValue,
      if (taxTyCdFieldValue != null)
        _$VariantFieldMap['taxTyCd']!: taxTyCdFieldValue,
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (itemClsCdFieldValue != null)
        _$VariantFieldMap['itemClsCd']!: itemClsCdFieldValue,
      if (itemTyCdFieldValue != null)
        _$VariantFieldMap['itemTyCd']!: itemTyCdFieldValue,
      if (itemStdNmFieldValue != null)
        _$VariantFieldMap['itemStdNm']!: itemStdNmFieldValue,
      if (orgnNatCdFieldValue != null)
        _$VariantFieldMap['orgnNatCd']!: orgnNatCdFieldValue,
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (itemCdFieldValue != null)
        _$VariantFieldMap['itemCd']!: itemCdFieldValue,
      if (pkgUnitCdFieldValue != null)
        _$VariantFieldMap['pkgUnitCd']!: pkgUnitCdFieldValue,
      if (qtyUnitCdFieldValue != null)
        _$VariantFieldMap['qtyUnitCd']!: qtyUnitCdFieldValue,
      if (itemNmFieldValue != null)
        _$VariantFieldMap['itemNm']!: itemNmFieldValue,
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (splyAmtFieldValue != null)
        _$VariantFieldMap['splyAmt']!: splyAmtFieldValue,
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhfIdFieldValue != null) _$VariantFieldMap['bhfId']!: bhfIdFieldValue,
      if (dftPrcFieldValue != null)
        _$VariantFieldMap['dftPrc']!: dftPrcFieldValue,
      if (addInfoFieldValue != null)
        _$VariantFieldMap['addInfo']!: addInfoFieldValue,
      if (isrcAplcbYnFieldValue != null)
        _$VariantFieldMap['isrcAplcbYn']!: isrcAplcbYnFieldValue,
      if (useYnFieldValue != null) _$VariantFieldMap['useYn']!: useYnFieldValue,
      if (regrIdFieldValue != null)
        _$VariantFieldMap['regrId']!: regrIdFieldValue,
      if (regrNmFieldValue != null)
        _$VariantFieldMap['regrNm']!: regrNmFieldValue,
      if (modrIdFieldValue != null)
        _$VariantFieldMap['modrId']!: modrIdFieldValue,
      if (modrNmFieldValue != null)
        _$VariantFieldMap['modrNm']!: modrNmFieldValue,
      if (rsdQtyFieldValue != null)
        _$VariantFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (lastTouchedFieldValue != null)
        _$VariantFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (supplyPriceFieldValue != null)
        _$VariantFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPriceFieldValue != null)
        _$VariantFieldMap['retailPrice']!: retailPriceFieldValue,
      if (spplrItemClsCdFieldValue != null)
        _$VariantFieldMap['spplrItemClsCd']!: spplrItemClsCdFieldValue,
      if (spplrItemCdFieldValue != null)
        _$VariantFieldMap['spplrItemCd']!: spplrItemCdFieldValue,
      if (spplrItemNmFieldValue != null)
        _$VariantFieldMap['spplrItemNm']!: spplrItemNmFieldValue,
      if (ebmSyncedFieldValue != null)
        _$VariantFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (isTaxExemptedFieldValue != null)
        _$VariantFieldMap['isTaxExempted']!: isTaxExemptedFieldValue,
      if (taxTypeFieldValue != null)
        _$VariantFieldMap['taxType']!: taxTypeFieldValue,
      if (branchIdsFieldValue != null)
        _$VariantFieldMap['branchIds']!: branchIdsFieldValue,
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
    };

    batch.set(reference, json, options);
  }

  Future<void> update({
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? sku = _sentinel,
    FieldValue? skuFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? productName = _sentinel,
    FieldValue? productNameFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? taxName = _sentinel,
    FieldValue? taxNameFieldValue,
    Object? taxPercentage = _sentinel,
    FieldValue? taxPercentageFieldValue,
    Object? itemSeq = _sentinel,
    FieldValue? itemSeqFieldValue,
    Object? isrccCd = _sentinel,
    FieldValue? isrccCdFieldValue,
    Object? isrccNm = _sentinel,
    FieldValue? isrccNmFieldValue,
    Object? isrcRt = _sentinel,
    FieldValue? isrcRtFieldValue,
    Object? isrcAmt = _sentinel,
    FieldValue? isrcAmtFieldValue,
    Object? taxTyCd = _sentinel,
    FieldValue? taxTyCdFieldValue,
    Object? bcd = _sentinel,
    FieldValue? bcdFieldValue,
    Object? itemClsCd = _sentinel,
    FieldValue? itemClsCdFieldValue,
    Object? itemTyCd = _sentinel,
    FieldValue? itemTyCdFieldValue,
    Object? itemStdNm = _sentinel,
    FieldValue? itemStdNmFieldValue,
    Object? orgnNatCd = _sentinel,
    FieldValue? orgnNatCdFieldValue,
    Object? pkg = _sentinel,
    FieldValue? pkgFieldValue,
    Object? itemCd = _sentinel,
    FieldValue? itemCdFieldValue,
    Object? pkgUnitCd = _sentinel,
    FieldValue? pkgUnitCdFieldValue,
    Object? qtyUnitCd = _sentinel,
    FieldValue? qtyUnitCdFieldValue,
    Object? itemNm = _sentinel,
    FieldValue? itemNmFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? prc = _sentinel,
    FieldValue? prcFieldValue,
    Object? splyAmt = _sentinel,
    FieldValue? splyAmtFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhfId = _sentinel,
    FieldValue? bhfIdFieldValue,
    Object? dftPrc = _sentinel,
    FieldValue? dftPrcFieldValue,
    Object? addInfo = _sentinel,
    FieldValue? addInfoFieldValue,
    Object? isrcAplcbYn = _sentinel,
    FieldValue? isrcAplcbYnFieldValue,
    Object? useYn = _sentinel,
    FieldValue? useYnFieldValue,
    Object? regrId = _sentinel,
    FieldValue? regrIdFieldValue,
    Object? regrNm = _sentinel,
    FieldValue? regrNmFieldValue,
    Object? modrId = _sentinel,
    FieldValue? modrIdFieldValue,
    Object? modrNm = _sentinel,
    FieldValue? modrNmFieldValue,
    Object? rsdQty = _sentinel,
    FieldValue? rsdQtyFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? supplyPrice = _sentinel,
    FieldValue? supplyPriceFieldValue,
    Object? retailPrice = _sentinel,
    FieldValue? retailPriceFieldValue,
    Object? spplrItemClsCd = _sentinel,
    FieldValue? spplrItemClsCdFieldValue,
    Object? spplrItemCd = _sentinel,
    FieldValue? spplrItemCdFieldValue,
    Object? spplrItemNm = _sentinel,
    FieldValue? spplrItemNmFieldValue,
    Object? ebmSynced = _sentinel,
    FieldValue? ebmSyncedFieldValue,
    Object? isTaxExempted = _sentinel,
    FieldValue? isTaxExemptedFieldValue,
    Object? taxType = _sentinel,
    FieldValue? taxTypeFieldValue,
    Object? branchIds = _sentinel,
    FieldValue? branchIdsFieldValue,
    Object? stock = _sentinel,
    FieldValue? stockFieldValue,
  }) async {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      deletedAt == _sentinel || deletedAtFieldValue == null,
      "Cannot specify both deletedAt and deletedAtFieldValue",
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
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      productName == _sentinel || productNameFieldValue == null,
      "Cannot specify both productName and productNameFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      taxName == _sentinel || taxNameFieldValue == null,
      "Cannot specify both taxName and taxNameFieldValue",
    );
    assert(
      taxPercentage == _sentinel || taxPercentageFieldValue == null,
      "Cannot specify both taxPercentage and taxPercentageFieldValue",
    );
    assert(
      itemSeq == _sentinel || itemSeqFieldValue == null,
      "Cannot specify both itemSeq and itemSeqFieldValue",
    );
    assert(
      isrccCd == _sentinel || isrccCdFieldValue == null,
      "Cannot specify both isrccCd and isrccCdFieldValue",
    );
    assert(
      isrccNm == _sentinel || isrccNmFieldValue == null,
      "Cannot specify both isrccNm and isrccNmFieldValue",
    );
    assert(
      isrcRt == _sentinel || isrcRtFieldValue == null,
      "Cannot specify both isrcRt and isrcRtFieldValue",
    );
    assert(
      isrcAmt == _sentinel || isrcAmtFieldValue == null,
      "Cannot specify both isrcAmt and isrcAmtFieldValue",
    );
    assert(
      taxTyCd == _sentinel || taxTyCdFieldValue == null,
      "Cannot specify both taxTyCd and taxTyCdFieldValue",
    );
    assert(
      bcd == _sentinel || bcdFieldValue == null,
      "Cannot specify both bcd and bcdFieldValue",
    );
    assert(
      itemClsCd == _sentinel || itemClsCdFieldValue == null,
      "Cannot specify both itemClsCd and itemClsCdFieldValue",
    );
    assert(
      itemTyCd == _sentinel || itemTyCdFieldValue == null,
      "Cannot specify both itemTyCd and itemTyCdFieldValue",
    );
    assert(
      itemStdNm == _sentinel || itemStdNmFieldValue == null,
      "Cannot specify both itemStdNm and itemStdNmFieldValue",
    );
    assert(
      orgnNatCd == _sentinel || orgnNatCdFieldValue == null,
      "Cannot specify both orgnNatCd and orgnNatCdFieldValue",
    );
    assert(
      pkg == _sentinel || pkgFieldValue == null,
      "Cannot specify both pkg and pkgFieldValue",
    );
    assert(
      itemCd == _sentinel || itemCdFieldValue == null,
      "Cannot specify both itemCd and itemCdFieldValue",
    );
    assert(
      pkgUnitCd == _sentinel || pkgUnitCdFieldValue == null,
      "Cannot specify both pkgUnitCd and pkgUnitCdFieldValue",
    );
    assert(
      qtyUnitCd == _sentinel || qtyUnitCdFieldValue == null,
      "Cannot specify both qtyUnitCd and qtyUnitCdFieldValue",
    );
    assert(
      itemNm == _sentinel || itemNmFieldValue == null,
      "Cannot specify both itemNm and itemNmFieldValue",
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
      splyAmt == _sentinel || splyAmtFieldValue == null,
      "Cannot specify both splyAmt and splyAmtFieldValue",
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
      dftPrc == _sentinel || dftPrcFieldValue == null,
      "Cannot specify both dftPrc and dftPrcFieldValue",
    );
    assert(
      addInfo == _sentinel || addInfoFieldValue == null,
      "Cannot specify both addInfo and addInfoFieldValue",
    );
    assert(
      isrcAplcbYn == _sentinel || isrcAplcbYnFieldValue == null,
      "Cannot specify both isrcAplcbYn and isrcAplcbYnFieldValue",
    );
    assert(
      useYn == _sentinel || useYnFieldValue == null,
      "Cannot specify both useYn and useYnFieldValue",
    );
    assert(
      regrId == _sentinel || regrIdFieldValue == null,
      "Cannot specify both regrId and regrIdFieldValue",
    );
    assert(
      regrNm == _sentinel || regrNmFieldValue == null,
      "Cannot specify both regrNm and regrNmFieldValue",
    );
    assert(
      modrId == _sentinel || modrIdFieldValue == null,
      "Cannot specify both modrId and modrIdFieldValue",
    );
    assert(
      modrNm == _sentinel || modrNmFieldValue == null,
      "Cannot specify both modrNm and modrNmFieldValue",
    );
    assert(
      rsdQty == _sentinel || rsdQtyFieldValue == null,
      "Cannot specify both rsdQty and rsdQtyFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
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
      spplrItemClsCd == _sentinel || spplrItemClsCdFieldValue == null,
      "Cannot specify both spplrItemClsCd and spplrItemClsCdFieldValue",
    );
    assert(
      spplrItemCd == _sentinel || spplrItemCdFieldValue == null,
      "Cannot specify both spplrItemCd and spplrItemCdFieldValue",
    );
    assert(
      spplrItemNm == _sentinel || spplrItemNmFieldValue == null,
      "Cannot specify both spplrItemNm and spplrItemNmFieldValue",
    );
    assert(
      ebmSynced == _sentinel || ebmSyncedFieldValue == null,
      "Cannot specify both ebmSynced and ebmSyncedFieldValue",
    );
    assert(
      isTaxExempted == _sentinel || isTaxExemptedFieldValue == null,
      "Cannot specify both isTaxExempted and isTaxExemptedFieldValue",
    );
    assert(
      taxType == _sentinel || taxTypeFieldValue == null,
      "Cannot specify both taxType and taxTypeFieldValue",
    );
    assert(
      branchIds == _sentinel || branchIdsFieldValue == null,
      "Cannot specify both branchIds and branchIdsFieldValue",
    );
    assert(
      stock == _sentinel || stockFieldValue == null,
      "Cannot specify both stock and stockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$VariantFieldMap['id']!: _$VariantPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (deletedAt != _sentinel)
        _$VariantFieldMap['deletedAt']!:
            _$VariantPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$VariantFieldMap['deletedAt']!: deletedAtFieldValue,
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
      if (productId != _sentinel)
        _$VariantFieldMap['productId']!:
            _$VariantPerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$VariantFieldMap['productId']!: productIdFieldValue,
      if (unit != _sentinel)
        _$VariantFieldMap['unit']!:
            _$VariantPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (productName != _sentinel)
        _$VariantFieldMap['productName']!:
            _$VariantPerFieldToJson.productName(productName as String?),
      if (productNameFieldValue != null)
        _$VariantFieldMap['productName']!: productNameFieldValue,
      if (branchId != _sentinel)
        _$VariantFieldMap['branchId']!:
            _$VariantPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$VariantFieldMap['branchId']!: branchIdFieldValue,
      if (taxName != _sentinel)
        _$VariantFieldMap['taxName']!:
            _$VariantPerFieldToJson.taxName(taxName as String?),
      if (taxNameFieldValue != null)
        _$VariantFieldMap['taxName']!: taxNameFieldValue,
      if (taxPercentage != _sentinel)
        _$VariantFieldMap['taxPercentage']!:
            _$VariantPerFieldToJson.taxPercentage(taxPercentage as double),
      if (taxPercentageFieldValue != null)
        _$VariantFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (itemSeq != _sentinel)
        _$VariantFieldMap['itemSeq']!:
            _$VariantPerFieldToJson.itemSeq(itemSeq as int?),
      if (itemSeqFieldValue != null)
        _$VariantFieldMap['itemSeq']!: itemSeqFieldValue,
      if (isrccCd != _sentinel)
        _$VariantFieldMap['isrccCd']!:
            _$VariantPerFieldToJson.isrccCd(isrccCd as String?),
      if (isrccCdFieldValue != null)
        _$VariantFieldMap['isrccCd']!: isrccCdFieldValue,
      if (isrccNm != _sentinel)
        _$VariantFieldMap['isrccNm']!:
            _$VariantPerFieldToJson.isrccNm(isrccNm as String?),
      if (isrccNmFieldValue != null)
        _$VariantFieldMap['isrccNm']!: isrccNmFieldValue,
      if (isrcRt != _sentinel)
        _$VariantFieldMap['isrcRt']!:
            _$VariantPerFieldToJson.isrcRt(isrcRt as int?),
      if (isrcRtFieldValue != null)
        _$VariantFieldMap['isrcRt']!: isrcRtFieldValue,
      if (isrcAmt != _sentinel)
        _$VariantFieldMap['isrcAmt']!:
            _$VariantPerFieldToJson.isrcAmt(isrcAmt as int?),
      if (isrcAmtFieldValue != null)
        _$VariantFieldMap['isrcAmt']!: isrcAmtFieldValue,
      if (taxTyCd != _sentinel)
        _$VariantFieldMap['taxTyCd']!:
            _$VariantPerFieldToJson.taxTyCd(taxTyCd as String?),
      if (taxTyCdFieldValue != null)
        _$VariantFieldMap['taxTyCd']!: taxTyCdFieldValue,
      if (bcd != _sentinel)
        _$VariantFieldMap['bcd']!: _$VariantPerFieldToJson.bcd(bcd as String?),
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (itemClsCd != _sentinel)
        _$VariantFieldMap['itemClsCd']!:
            _$VariantPerFieldToJson.itemClsCd(itemClsCd as String?),
      if (itemClsCdFieldValue != null)
        _$VariantFieldMap['itemClsCd']!: itemClsCdFieldValue,
      if (itemTyCd != _sentinel)
        _$VariantFieldMap['itemTyCd']!:
            _$VariantPerFieldToJson.itemTyCd(itemTyCd as String?),
      if (itemTyCdFieldValue != null)
        _$VariantFieldMap['itemTyCd']!: itemTyCdFieldValue,
      if (itemStdNm != _sentinel)
        _$VariantFieldMap['itemStdNm']!:
            _$VariantPerFieldToJson.itemStdNm(itemStdNm as String?),
      if (itemStdNmFieldValue != null)
        _$VariantFieldMap['itemStdNm']!: itemStdNmFieldValue,
      if (orgnNatCd != _sentinel)
        _$VariantFieldMap['orgnNatCd']!:
            _$VariantPerFieldToJson.orgnNatCd(orgnNatCd as String?),
      if (orgnNatCdFieldValue != null)
        _$VariantFieldMap['orgnNatCd']!: orgnNatCdFieldValue,
      if (pkg != _sentinel)
        _$VariantFieldMap['pkg']!: _$VariantPerFieldToJson.pkg(pkg as String?),
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (itemCd != _sentinel)
        _$VariantFieldMap['itemCd']!:
            _$VariantPerFieldToJson.itemCd(itemCd as String?),
      if (itemCdFieldValue != null)
        _$VariantFieldMap['itemCd']!: itemCdFieldValue,
      if (pkgUnitCd != _sentinel)
        _$VariantFieldMap['pkgUnitCd']!:
            _$VariantPerFieldToJson.pkgUnitCd(pkgUnitCd as String?),
      if (pkgUnitCdFieldValue != null)
        _$VariantFieldMap['pkgUnitCd']!: pkgUnitCdFieldValue,
      if (qtyUnitCd != _sentinel)
        _$VariantFieldMap['qtyUnitCd']!:
            _$VariantPerFieldToJson.qtyUnitCd(qtyUnitCd as String?),
      if (qtyUnitCdFieldValue != null)
        _$VariantFieldMap['qtyUnitCd']!: qtyUnitCdFieldValue,
      if (itemNm != _sentinel)
        _$VariantFieldMap['itemNm']!:
            _$VariantPerFieldToJson.itemNm(itemNm as String?),
      if (itemNmFieldValue != null)
        _$VariantFieldMap['itemNm']!: itemNmFieldValue,
      if (qty != _sentinel)
        _$VariantFieldMap['qty']!: _$VariantPerFieldToJson.qty(qty as double),
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prc != _sentinel)
        _$VariantFieldMap['prc']!: _$VariantPerFieldToJson.prc(prc as double),
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (splyAmt != _sentinel)
        _$VariantFieldMap['splyAmt']!:
            _$VariantPerFieldToJson.splyAmt(splyAmt as double),
      if (splyAmtFieldValue != null)
        _$VariantFieldMap['splyAmt']!: splyAmtFieldValue,
      if (tin != _sentinel)
        _$VariantFieldMap['tin']!: _$VariantPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhfId != _sentinel)
        _$VariantFieldMap['bhfId']!:
            _$VariantPerFieldToJson.bhfId(bhfId as String?),
      if (bhfIdFieldValue != null) _$VariantFieldMap['bhfId']!: bhfIdFieldValue,
      if (dftPrc != _sentinel)
        _$VariantFieldMap['dftPrc']!:
            _$VariantPerFieldToJson.dftPrc(dftPrc as double?),
      if (dftPrcFieldValue != null)
        _$VariantFieldMap['dftPrc']!: dftPrcFieldValue,
      if (addInfo != _sentinel)
        _$VariantFieldMap['addInfo']!:
            _$VariantPerFieldToJson.addInfo(addInfo as String?),
      if (addInfoFieldValue != null)
        _$VariantFieldMap['addInfo']!: addInfoFieldValue,
      if (isrcAplcbYn != _sentinel)
        _$VariantFieldMap['isrcAplcbYn']!:
            _$VariantPerFieldToJson.isrcAplcbYn(isrcAplcbYn as String?),
      if (isrcAplcbYnFieldValue != null)
        _$VariantFieldMap['isrcAplcbYn']!: isrcAplcbYnFieldValue,
      if (useYn != _sentinel)
        _$VariantFieldMap['useYn']!:
            _$VariantPerFieldToJson.useYn(useYn as String?),
      if (useYnFieldValue != null) _$VariantFieldMap['useYn']!: useYnFieldValue,
      if (regrId != _sentinel)
        _$VariantFieldMap['regrId']!:
            _$VariantPerFieldToJson.regrId(regrId as String?),
      if (regrIdFieldValue != null)
        _$VariantFieldMap['regrId']!: regrIdFieldValue,
      if (regrNm != _sentinel)
        _$VariantFieldMap['regrNm']!:
            _$VariantPerFieldToJson.regrNm(regrNm as String?),
      if (regrNmFieldValue != null)
        _$VariantFieldMap['regrNm']!: regrNmFieldValue,
      if (modrId != _sentinel)
        _$VariantFieldMap['modrId']!:
            _$VariantPerFieldToJson.modrId(modrId as String?),
      if (modrIdFieldValue != null)
        _$VariantFieldMap['modrId']!: modrIdFieldValue,
      if (modrNm != _sentinel)
        _$VariantFieldMap['modrNm']!:
            _$VariantPerFieldToJson.modrNm(modrNm as String?),
      if (modrNmFieldValue != null)
        _$VariantFieldMap['modrNm']!: modrNmFieldValue,
      if (rsdQty != _sentinel)
        _$VariantFieldMap['rsdQty']!:
            _$VariantPerFieldToJson.rsdQty(rsdQty as double),
      if (rsdQtyFieldValue != null)
        _$VariantFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (lastTouched != _sentinel)
        _$VariantFieldMap['lastTouched']!:
            _$VariantPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$VariantFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (supplyPrice != _sentinel)
        _$VariantFieldMap['supplyPrice']!:
            _$VariantPerFieldToJson.supplyPrice(supplyPrice as double),
      if (supplyPriceFieldValue != null)
        _$VariantFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPrice != _sentinel)
        _$VariantFieldMap['retailPrice']!:
            _$VariantPerFieldToJson.retailPrice(retailPrice as double),
      if (retailPriceFieldValue != null)
        _$VariantFieldMap['retailPrice']!: retailPriceFieldValue,
      if (spplrItemClsCd != _sentinel)
        _$VariantFieldMap['spplrItemClsCd']!:
            _$VariantPerFieldToJson.spplrItemClsCd(spplrItemClsCd as String?),
      if (spplrItemClsCdFieldValue != null)
        _$VariantFieldMap['spplrItemClsCd']!: spplrItemClsCdFieldValue,
      if (spplrItemCd != _sentinel)
        _$VariantFieldMap['spplrItemCd']!:
            _$VariantPerFieldToJson.spplrItemCd(spplrItemCd as String?),
      if (spplrItemCdFieldValue != null)
        _$VariantFieldMap['spplrItemCd']!: spplrItemCdFieldValue,
      if (spplrItemNm != _sentinel)
        _$VariantFieldMap['spplrItemNm']!:
            _$VariantPerFieldToJson.spplrItemNm(spplrItemNm as String?),
      if (spplrItemNmFieldValue != null)
        _$VariantFieldMap['spplrItemNm']!: spplrItemNmFieldValue,
      if (ebmSynced != _sentinel)
        _$VariantFieldMap['ebmSynced']!:
            _$VariantPerFieldToJson.ebmSynced(ebmSynced as bool),
      if (ebmSyncedFieldValue != null)
        _$VariantFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (isTaxExempted != _sentinel)
        _$VariantFieldMap['isTaxExempted']!:
            _$VariantPerFieldToJson.isTaxExempted(isTaxExempted as bool),
      if (isTaxExemptedFieldValue != null)
        _$VariantFieldMap['isTaxExempted']!: isTaxExemptedFieldValue,
      if (taxType != _sentinel)
        _$VariantFieldMap['taxType']!:
            _$VariantPerFieldToJson.taxType(taxType as String),
      if (taxTypeFieldValue != null)
        _$VariantFieldMap['taxType']!: taxTypeFieldValue,
      if (branchIds != _sentinel)
        _$VariantFieldMap['branchIds']!:
            _$VariantPerFieldToJson.branchIds(branchIds as List<int>),
      if (branchIdsFieldValue != null)
        _$VariantFieldMap['branchIds']!: branchIdsFieldValue,
      if (stock != _sentinel)
        _$VariantFieldMap['stock']!:
            _$VariantPerFieldToJson.stock(stock as Stock?),
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
    };

    return reference.update(json);
  }

  void transactionUpdate(
    Transaction transaction, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? sku = _sentinel,
    FieldValue? skuFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? productName = _sentinel,
    FieldValue? productNameFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? taxName = _sentinel,
    FieldValue? taxNameFieldValue,
    Object? taxPercentage = _sentinel,
    FieldValue? taxPercentageFieldValue,
    Object? itemSeq = _sentinel,
    FieldValue? itemSeqFieldValue,
    Object? isrccCd = _sentinel,
    FieldValue? isrccCdFieldValue,
    Object? isrccNm = _sentinel,
    FieldValue? isrccNmFieldValue,
    Object? isrcRt = _sentinel,
    FieldValue? isrcRtFieldValue,
    Object? isrcAmt = _sentinel,
    FieldValue? isrcAmtFieldValue,
    Object? taxTyCd = _sentinel,
    FieldValue? taxTyCdFieldValue,
    Object? bcd = _sentinel,
    FieldValue? bcdFieldValue,
    Object? itemClsCd = _sentinel,
    FieldValue? itemClsCdFieldValue,
    Object? itemTyCd = _sentinel,
    FieldValue? itemTyCdFieldValue,
    Object? itemStdNm = _sentinel,
    FieldValue? itemStdNmFieldValue,
    Object? orgnNatCd = _sentinel,
    FieldValue? orgnNatCdFieldValue,
    Object? pkg = _sentinel,
    FieldValue? pkgFieldValue,
    Object? itemCd = _sentinel,
    FieldValue? itemCdFieldValue,
    Object? pkgUnitCd = _sentinel,
    FieldValue? pkgUnitCdFieldValue,
    Object? qtyUnitCd = _sentinel,
    FieldValue? qtyUnitCdFieldValue,
    Object? itemNm = _sentinel,
    FieldValue? itemNmFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? prc = _sentinel,
    FieldValue? prcFieldValue,
    Object? splyAmt = _sentinel,
    FieldValue? splyAmtFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhfId = _sentinel,
    FieldValue? bhfIdFieldValue,
    Object? dftPrc = _sentinel,
    FieldValue? dftPrcFieldValue,
    Object? addInfo = _sentinel,
    FieldValue? addInfoFieldValue,
    Object? isrcAplcbYn = _sentinel,
    FieldValue? isrcAplcbYnFieldValue,
    Object? useYn = _sentinel,
    FieldValue? useYnFieldValue,
    Object? regrId = _sentinel,
    FieldValue? regrIdFieldValue,
    Object? regrNm = _sentinel,
    FieldValue? regrNmFieldValue,
    Object? modrId = _sentinel,
    FieldValue? modrIdFieldValue,
    Object? modrNm = _sentinel,
    FieldValue? modrNmFieldValue,
    Object? rsdQty = _sentinel,
    FieldValue? rsdQtyFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? supplyPrice = _sentinel,
    FieldValue? supplyPriceFieldValue,
    Object? retailPrice = _sentinel,
    FieldValue? retailPriceFieldValue,
    Object? spplrItemClsCd = _sentinel,
    FieldValue? spplrItemClsCdFieldValue,
    Object? spplrItemCd = _sentinel,
    FieldValue? spplrItemCdFieldValue,
    Object? spplrItemNm = _sentinel,
    FieldValue? spplrItemNmFieldValue,
    Object? ebmSynced = _sentinel,
    FieldValue? ebmSyncedFieldValue,
    Object? isTaxExempted = _sentinel,
    FieldValue? isTaxExemptedFieldValue,
    Object? taxType = _sentinel,
    FieldValue? taxTypeFieldValue,
    Object? branchIds = _sentinel,
    FieldValue? branchIdsFieldValue,
    Object? stock = _sentinel,
    FieldValue? stockFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      deletedAt == _sentinel || deletedAtFieldValue == null,
      "Cannot specify both deletedAt and deletedAtFieldValue",
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
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      productName == _sentinel || productNameFieldValue == null,
      "Cannot specify both productName and productNameFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      taxName == _sentinel || taxNameFieldValue == null,
      "Cannot specify both taxName and taxNameFieldValue",
    );
    assert(
      taxPercentage == _sentinel || taxPercentageFieldValue == null,
      "Cannot specify both taxPercentage and taxPercentageFieldValue",
    );
    assert(
      itemSeq == _sentinel || itemSeqFieldValue == null,
      "Cannot specify both itemSeq and itemSeqFieldValue",
    );
    assert(
      isrccCd == _sentinel || isrccCdFieldValue == null,
      "Cannot specify both isrccCd and isrccCdFieldValue",
    );
    assert(
      isrccNm == _sentinel || isrccNmFieldValue == null,
      "Cannot specify both isrccNm and isrccNmFieldValue",
    );
    assert(
      isrcRt == _sentinel || isrcRtFieldValue == null,
      "Cannot specify both isrcRt and isrcRtFieldValue",
    );
    assert(
      isrcAmt == _sentinel || isrcAmtFieldValue == null,
      "Cannot specify both isrcAmt and isrcAmtFieldValue",
    );
    assert(
      taxTyCd == _sentinel || taxTyCdFieldValue == null,
      "Cannot specify both taxTyCd and taxTyCdFieldValue",
    );
    assert(
      bcd == _sentinel || bcdFieldValue == null,
      "Cannot specify both bcd and bcdFieldValue",
    );
    assert(
      itemClsCd == _sentinel || itemClsCdFieldValue == null,
      "Cannot specify both itemClsCd and itemClsCdFieldValue",
    );
    assert(
      itemTyCd == _sentinel || itemTyCdFieldValue == null,
      "Cannot specify both itemTyCd and itemTyCdFieldValue",
    );
    assert(
      itemStdNm == _sentinel || itemStdNmFieldValue == null,
      "Cannot specify both itemStdNm and itemStdNmFieldValue",
    );
    assert(
      orgnNatCd == _sentinel || orgnNatCdFieldValue == null,
      "Cannot specify both orgnNatCd and orgnNatCdFieldValue",
    );
    assert(
      pkg == _sentinel || pkgFieldValue == null,
      "Cannot specify both pkg and pkgFieldValue",
    );
    assert(
      itemCd == _sentinel || itemCdFieldValue == null,
      "Cannot specify both itemCd and itemCdFieldValue",
    );
    assert(
      pkgUnitCd == _sentinel || pkgUnitCdFieldValue == null,
      "Cannot specify both pkgUnitCd and pkgUnitCdFieldValue",
    );
    assert(
      qtyUnitCd == _sentinel || qtyUnitCdFieldValue == null,
      "Cannot specify both qtyUnitCd and qtyUnitCdFieldValue",
    );
    assert(
      itemNm == _sentinel || itemNmFieldValue == null,
      "Cannot specify both itemNm and itemNmFieldValue",
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
      splyAmt == _sentinel || splyAmtFieldValue == null,
      "Cannot specify both splyAmt and splyAmtFieldValue",
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
      dftPrc == _sentinel || dftPrcFieldValue == null,
      "Cannot specify both dftPrc and dftPrcFieldValue",
    );
    assert(
      addInfo == _sentinel || addInfoFieldValue == null,
      "Cannot specify both addInfo and addInfoFieldValue",
    );
    assert(
      isrcAplcbYn == _sentinel || isrcAplcbYnFieldValue == null,
      "Cannot specify both isrcAplcbYn and isrcAplcbYnFieldValue",
    );
    assert(
      useYn == _sentinel || useYnFieldValue == null,
      "Cannot specify both useYn and useYnFieldValue",
    );
    assert(
      regrId == _sentinel || regrIdFieldValue == null,
      "Cannot specify both regrId and regrIdFieldValue",
    );
    assert(
      regrNm == _sentinel || regrNmFieldValue == null,
      "Cannot specify both regrNm and regrNmFieldValue",
    );
    assert(
      modrId == _sentinel || modrIdFieldValue == null,
      "Cannot specify both modrId and modrIdFieldValue",
    );
    assert(
      modrNm == _sentinel || modrNmFieldValue == null,
      "Cannot specify both modrNm and modrNmFieldValue",
    );
    assert(
      rsdQty == _sentinel || rsdQtyFieldValue == null,
      "Cannot specify both rsdQty and rsdQtyFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
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
      spplrItemClsCd == _sentinel || spplrItemClsCdFieldValue == null,
      "Cannot specify both spplrItemClsCd and spplrItemClsCdFieldValue",
    );
    assert(
      spplrItemCd == _sentinel || spplrItemCdFieldValue == null,
      "Cannot specify both spplrItemCd and spplrItemCdFieldValue",
    );
    assert(
      spplrItemNm == _sentinel || spplrItemNmFieldValue == null,
      "Cannot specify both spplrItemNm and spplrItemNmFieldValue",
    );
    assert(
      ebmSynced == _sentinel || ebmSyncedFieldValue == null,
      "Cannot specify both ebmSynced and ebmSyncedFieldValue",
    );
    assert(
      isTaxExempted == _sentinel || isTaxExemptedFieldValue == null,
      "Cannot specify both isTaxExempted and isTaxExemptedFieldValue",
    );
    assert(
      taxType == _sentinel || taxTypeFieldValue == null,
      "Cannot specify both taxType and taxTypeFieldValue",
    );
    assert(
      branchIds == _sentinel || branchIdsFieldValue == null,
      "Cannot specify both branchIds and branchIdsFieldValue",
    );
    assert(
      stock == _sentinel || stockFieldValue == null,
      "Cannot specify both stock and stockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$VariantFieldMap['id']!: _$VariantPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (deletedAt != _sentinel)
        _$VariantFieldMap['deletedAt']!:
            _$VariantPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$VariantFieldMap['deletedAt']!: deletedAtFieldValue,
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
      if (productId != _sentinel)
        _$VariantFieldMap['productId']!:
            _$VariantPerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$VariantFieldMap['productId']!: productIdFieldValue,
      if (unit != _sentinel)
        _$VariantFieldMap['unit']!:
            _$VariantPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (productName != _sentinel)
        _$VariantFieldMap['productName']!:
            _$VariantPerFieldToJson.productName(productName as String?),
      if (productNameFieldValue != null)
        _$VariantFieldMap['productName']!: productNameFieldValue,
      if (branchId != _sentinel)
        _$VariantFieldMap['branchId']!:
            _$VariantPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$VariantFieldMap['branchId']!: branchIdFieldValue,
      if (taxName != _sentinel)
        _$VariantFieldMap['taxName']!:
            _$VariantPerFieldToJson.taxName(taxName as String?),
      if (taxNameFieldValue != null)
        _$VariantFieldMap['taxName']!: taxNameFieldValue,
      if (taxPercentage != _sentinel)
        _$VariantFieldMap['taxPercentage']!:
            _$VariantPerFieldToJson.taxPercentage(taxPercentage as double),
      if (taxPercentageFieldValue != null)
        _$VariantFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (itemSeq != _sentinel)
        _$VariantFieldMap['itemSeq']!:
            _$VariantPerFieldToJson.itemSeq(itemSeq as int?),
      if (itemSeqFieldValue != null)
        _$VariantFieldMap['itemSeq']!: itemSeqFieldValue,
      if (isrccCd != _sentinel)
        _$VariantFieldMap['isrccCd']!:
            _$VariantPerFieldToJson.isrccCd(isrccCd as String?),
      if (isrccCdFieldValue != null)
        _$VariantFieldMap['isrccCd']!: isrccCdFieldValue,
      if (isrccNm != _sentinel)
        _$VariantFieldMap['isrccNm']!:
            _$VariantPerFieldToJson.isrccNm(isrccNm as String?),
      if (isrccNmFieldValue != null)
        _$VariantFieldMap['isrccNm']!: isrccNmFieldValue,
      if (isrcRt != _sentinel)
        _$VariantFieldMap['isrcRt']!:
            _$VariantPerFieldToJson.isrcRt(isrcRt as int?),
      if (isrcRtFieldValue != null)
        _$VariantFieldMap['isrcRt']!: isrcRtFieldValue,
      if (isrcAmt != _sentinel)
        _$VariantFieldMap['isrcAmt']!:
            _$VariantPerFieldToJson.isrcAmt(isrcAmt as int?),
      if (isrcAmtFieldValue != null)
        _$VariantFieldMap['isrcAmt']!: isrcAmtFieldValue,
      if (taxTyCd != _sentinel)
        _$VariantFieldMap['taxTyCd']!:
            _$VariantPerFieldToJson.taxTyCd(taxTyCd as String?),
      if (taxTyCdFieldValue != null)
        _$VariantFieldMap['taxTyCd']!: taxTyCdFieldValue,
      if (bcd != _sentinel)
        _$VariantFieldMap['bcd']!: _$VariantPerFieldToJson.bcd(bcd as String?),
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (itemClsCd != _sentinel)
        _$VariantFieldMap['itemClsCd']!:
            _$VariantPerFieldToJson.itemClsCd(itemClsCd as String?),
      if (itemClsCdFieldValue != null)
        _$VariantFieldMap['itemClsCd']!: itemClsCdFieldValue,
      if (itemTyCd != _sentinel)
        _$VariantFieldMap['itemTyCd']!:
            _$VariantPerFieldToJson.itemTyCd(itemTyCd as String?),
      if (itemTyCdFieldValue != null)
        _$VariantFieldMap['itemTyCd']!: itemTyCdFieldValue,
      if (itemStdNm != _sentinel)
        _$VariantFieldMap['itemStdNm']!:
            _$VariantPerFieldToJson.itemStdNm(itemStdNm as String?),
      if (itemStdNmFieldValue != null)
        _$VariantFieldMap['itemStdNm']!: itemStdNmFieldValue,
      if (orgnNatCd != _sentinel)
        _$VariantFieldMap['orgnNatCd']!:
            _$VariantPerFieldToJson.orgnNatCd(orgnNatCd as String?),
      if (orgnNatCdFieldValue != null)
        _$VariantFieldMap['orgnNatCd']!: orgnNatCdFieldValue,
      if (pkg != _sentinel)
        _$VariantFieldMap['pkg']!: _$VariantPerFieldToJson.pkg(pkg as String?),
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (itemCd != _sentinel)
        _$VariantFieldMap['itemCd']!:
            _$VariantPerFieldToJson.itemCd(itemCd as String?),
      if (itemCdFieldValue != null)
        _$VariantFieldMap['itemCd']!: itemCdFieldValue,
      if (pkgUnitCd != _sentinel)
        _$VariantFieldMap['pkgUnitCd']!:
            _$VariantPerFieldToJson.pkgUnitCd(pkgUnitCd as String?),
      if (pkgUnitCdFieldValue != null)
        _$VariantFieldMap['pkgUnitCd']!: pkgUnitCdFieldValue,
      if (qtyUnitCd != _sentinel)
        _$VariantFieldMap['qtyUnitCd']!:
            _$VariantPerFieldToJson.qtyUnitCd(qtyUnitCd as String?),
      if (qtyUnitCdFieldValue != null)
        _$VariantFieldMap['qtyUnitCd']!: qtyUnitCdFieldValue,
      if (itemNm != _sentinel)
        _$VariantFieldMap['itemNm']!:
            _$VariantPerFieldToJson.itemNm(itemNm as String?),
      if (itemNmFieldValue != null)
        _$VariantFieldMap['itemNm']!: itemNmFieldValue,
      if (qty != _sentinel)
        _$VariantFieldMap['qty']!: _$VariantPerFieldToJson.qty(qty as double),
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prc != _sentinel)
        _$VariantFieldMap['prc']!: _$VariantPerFieldToJson.prc(prc as double),
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (splyAmt != _sentinel)
        _$VariantFieldMap['splyAmt']!:
            _$VariantPerFieldToJson.splyAmt(splyAmt as double),
      if (splyAmtFieldValue != null)
        _$VariantFieldMap['splyAmt']!: splyAmtFieldValue,
      if (tin != _sentinel)
        _$VariantFieldMap['tin']!: _$VariantPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhfId != _sentinel)
        _$VariantFieldMap['bhfId']!:
            _$VariantPerFieldToJson.bhfId(bhfId as String?),
      if (bhfIdFieldValue != null) _$VariantFieldMap['bhfId']!: bhfIdFieldValue,
      if (dftPrc != _sentinel)
        _$VariantFieldMap['dftPrc']!:
            _$VariantPerFieldToJson.dftPrc(dftPrc as double?),
      if (dftPrcFieldValue != null)
        _$VariantFieldMap['dftPrc']!: dftPrcFieldValue,
      if (addInfo != _sentinel)
        _$VariantFieldMap['addInfo']!:
            _$VariantPerFieldToJson.addInfo(addInfo as String?),
      if (addInfoFieldValue != null)
        _$VariantFieldMap['addInfo']!: addInfoFieldValue,
      if (isrcAplcbYn != _sentinel)
        _$VariantFieldMap['isrcAplcbYn']!:
            _$VariantPerFieldToJson.isrcAplcbYn(isrcAplcbYn as String?),
      if (isrcAplcbYnFieldValue != null)
        _$VariantFieldMap['isrcAplcbYn']!: isrcAplcbYnFieldValue,
      if (useYn != _sentinel)
        _$VariantFieldMap['useYn']!:
            _$VariantPerFieldToJson.useYn(useYn as String?),
      if (useYnFieldValue != null) _$VariantFieldMap['useYn']!: useYnFieldValue,
      if (regrId != _sentinel)
        _$VariantFieldMap['regrId']!:
            _$VariantPerFieldToJson.regrId(regrId as String?),
      if (regrIdFieldValue != null)
        _$VariantFieldMap['regrId']!: regrIdFieldValue,
      if (regrNm != _sentinel)
        _$VariantFieldMap['regrNm']!:
            _$VariantPerFieldToJson.regrNm(regrNm as String?),
      if (regrNmFieldValue != null)
        _$VariantFieldMap['regrNm']!: regrNmFieldValue,
      if (modrId != _sentinel)
        _$VariantFieldMap['modrId']!:
            _$VariantPerFieldToJson.modrId(modrId as String?),
      if (modrIdFieldValue != null)
        _$VariantFieldMap['modrId']!: modrIdFieldValue,
      if (modrNm != _sentinel)
        _$VariantFieldMap['modrNm']!:
            _$VariantPerFieldToJson.modrNm(modrNm as String?),
      if (modrNmFieldValue != null)
        _$VariantFieldMap['modrNm']!: modrNmFieldValue,
      if (rsdQty != _sentinel)
        _$VariantFieldMap['rsdQty']!:
            _$VariantPerFieldToJson.rsdQty(rsdQty as double),
      if (rsdQtyFieldValue != null)
        _$VariantFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (lastTouched != _sentinel)
        _$VariantFieldMap['lastTouched']!:
            _$VariantPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$VariantFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (supplyPrice != _sentinel)
        _$VariantFieldMap['supplyPrice']!:
            _$VariantPerFieldToJson.supplyPrice(supplyPrice as double),
      if (supplyPriceFieldValue != null)
        _$VariantFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPrice != _sentinel)
        _$VariantFieldMap['retailPrice']!:
            _$VariantPerFieldToJson.retailPrice(retailPrice as double),
      if (retailPriceFieldValue != null)
        _$VariantFieldMap['retailPrice']!: retailPriceFieldValue,
      if (spplrItemClsCd != _sentinel)
        _$VariantFieldMap['spplrItemClsCd']!:
            _$VariantPerFieldToJson.spplrItemClsCd(spplrItemClsCd as String?),
      if (spplrItemClsCdFieldValue != null)
        _$VariantFieldMap['spplrItemClsCd']!: spplrItemClsCdFieldValue,
      if (spplrItemCd != _sentinel)
        _$VariantFieldMap['spplrItemCd']!:
            _$VariantPerFieldToJson.spplrItemCd(spplrItemCd as String?),
      if (spplrItemCdFieldValue != null)
        _$VariantFieldMap['spplrItemCd']!: spplrItemCdFieldValue,
      if (spplrItemNm != _sentinel)
        _$VariantFieldMap['spplrItemNm']!:
            _$VariantPerFieldToJson.spplrItemNm(spplrItemNm as String?),
      if (spplrItemNmFieldValue != null)
        _$VariantFieldMap['spplrItemNm']!: spplrItemNmFieldValue,
      if (ebmSynced != _sentinel)
        _$VariantFieldMap['ebmSynced']!:
            _$VariantPerFieldToJson.ebmSynced(ebmSynced as bool),
      if (ebmSyncedFieldValue != null)
        _$VariantFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (isTaxExempted != _sentinel)
        _$VariantFieldMap['isTaxExempted']!:
            _$VariantPerFieldToJson.isTaxExempted(isTaxExempted as bool),
      if (isTaxExemptedFieldValue != null)
        _$VariantFieldMap['isTaxExempted']!: isTaxExemptedFieldValue,
      if (taxType != _sentinel)
        _$VariantFieldMap['taxType']!:
            _$VariantPerFieldToJson.taxType(taxType as String),
      if (taxTypeFieldValue != null)
        _$VariantFieldMap['taxType']!: taxTypeFieldValue,
      if (branchIds != _sentinel)
        _$VariantFieldMap['branchIds']!:
            _$VariantPerFieldToJson.branchIds(branchIds as List<int>),
      if (branchIdsFieldValue != null)
        _$VariantFieldMap['branchIds']!: branchIdsFieldValue,
      if (stock != _sentinel)
        _$VariantFieldMap['stock']!:
            _$VariantPerFieldToJson.stock(stock as Stock?),
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
    };

    transaction.update(reference, json);
  }

  void batchUpdate(
    WriteBatch batch, {
    Object? id = _sentinel,
    FieldValue? idFieldValue,
    Object? deletedAt = _sentinel,
    FieldValue? deletedAtFieldValue,
    Object? name = _sentinel,
    FieldValue? nameFieldValue,
    Object? color = _sentinel,
    FieldValue? colorFieldValue,
    Object? sku = _sentinel,
    FieldValue? skuFieldValue,
    Object? productId = _sentinel,
    FieldValue? productIdFieldValue,
    Object? unit = _sentinel,
    FieldValue? unitFieldValue,
    Object? productName = _sentinel,
    FieldValue? productNameFieldValue,
    Object? branchId = _sentinel,
    FieldValue? branchIdFieldValue,
    Object? taxName = _sentinel,
    FieldValue? taxNameFieldValue,
    Object? taxPercentage = _sentinel,
    FieldValue? taxPercentageFieldValue,
    Object? itemSeq = _sentinel,
    FieldValue? itemSeqFieldValue,
    Object? isrccCd = _sentinel,
    FieldValue? isrccCdFieldValue,
    Object? isrccNm = _sentinel,
    FieldValue? isrccNmFieldValue,
    Object? isrcRt = _sentinel,
    FieldValue? isrcRtFieldValue,
    Object? isrcAmt = _sentinel,
    FieldValue? isrcAmtFieldValue,
    Object? taxTyCd = _sentinel,
    FieldValue? taxTyCdFieldValue,
    Object? bcd = _sentinel,
    FieldValue? bcdFieldValue,
    Object? itemClsCd = _sentinel,
    FieldValue? itemClsCdFieldValue,
    Object? itemTyCd = _sentinel,
    FieldValue? itemTyCdFieldValue,
    Object? itemStdNm = _sentinel,
    FieldValue? itemStdNmFieldValue,
    Object? orgnNatCd = _sentinel,
    FieldValue? orgnNatCdFieldValue,
    Object? pkg = _sentinel,
    FieldValue? pkgFieldValue,
    Object? itemCd = _sentinel,
    FieldValue? itemCdFieldValue,
    Object? pkgUnitCd = _sentinel,
    FieldValue? pkgUnitCdFieldValue,
    Object? qtyUnitCd = _sentinel,
    FieldValue? qtyUnitCdFieldValue,
    Object? itemNm = _sentinel,
    FieldValue? itemNmFieldValue,
    Object? qty = _sentinel,
    FieldValue? qtyFieldValue,
    Object? prc = _sentinel,
    FieldValue? prcFieldValue,
    Object? splyAmt = _sentinel,
    FieldValue? splyAmtFieldValue,
    Object? tin = _sentinel,
    FieldValue? tinFieldValue,
    Object? bhfId = _sentinel,
    FieldValue? bhfIdFieldValue,
    Object? dftPrc = _sentinel,
    FieldValue? dftPrcFieldValue,
    Object? addInfo = _sentinel,
    FieldValue? addInfoFieldValue,
    Object? isrcAplcbYn = _sentinel,
    FieldValue? isrcAplcbYnFieldValue,
    Object? useYn = _sentinel,
    FieldValue? useYnFieldValue,
    Object? regrId = _sentinel,
    FieldValue? regrIdFieldValue,
    Object? regrNm = _sentinel,
    FieldValue? regrNmFieldValue,
    Object? modrId = _sentinel,
    FieldValue? modrIdFieldValue,
    Object? modrNm = _sentinel,
    FieldValue? modrNmFieldValue,
    Object? rsdQty = _sentinel,
    FieldValue? rsdQtyFieldValue,
    Object? lastTouched = _sentinel,
    FieldValue? lastTouchedFieldValue,
    Object? supplyPrice = _sentinel,
    FieldValue? supplyPriceFieldValue,
    Object? retailPrice = _sentinel,
    FieldValue? retailPriceFieldValue,
    Object? spplrItemClsCd = _sentinel,
    FieldValue? spplrItemClsCdFieldValue,
    Object? spplrItemCd = _sentinel,
    FieldValue? spplrItemCdFieldValue,
    Object? spplrItemNm = _sentinel,
    FieldValue? spplrItemNmFieldValue,
    Object? ebmSynced = _sentinel,
    FieldValue? ebmSyncedFieldValue,
    Object? isTaxExempted = _sentinel,
    FieldValue? isTaxExemptedFieldValue,
    Object? taxType = _sentinel,
    FieldValue? taxTypeFieldValue,
    Object? branchIds = _sentinel,
    FieldValue? branchIdsFieldValue,
    Object? stock = _sentinel,
    FieldValue? stockFieldValue,
  }) {
    assert(
      id == _sentinel || idFieldValue == null,
      "Cannot specify both id and idFieldValue",
    );
    assert(
      deletedAt == _sentinel || deletedAtFieldValue == null,
      "Cannot specify both deletedAt and deletedAtFieldValue",
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
      productId == _sentinel || productIdFieldValue == null,
      "Cannot specify both productId and productIdFieldValue",
    );
    assert(
      unit == _sentinel || unitFieldValue == null,
      "Cannot specify both unit and unitFieldValue",
    );
    assert(
      productName == _sentinel || productNameFieldValue == null,
      "Cannot specify both productName and productNameFieldValue",
    );
    assert(
      branchId == _sentinel || branchIdFieldValue == null,
      "Cannot specify both branchId and branchIdFieldValue",
    );
    assert(
      taxName == _sentinel || taxNameFieldValue == null,
      "Cannot specify both taxName and taxNameFieldValue",
    );
    assert(
      taxPercentage == _sentinel || taxPercentageFieldValue == null,
      "Cannot specify both taxPercentage and taxPercentageFieldValue",
    );
    assert(
      itemSeq == _sentinel || itemSeqFieldValue == null,
      "Cannot specify both itemSeq and itemSeqFieldValue",
    );
    assert(
      isrccCd == _sentinel || isrccCdFieldValue == null,
      "Cannot specify both isrccCd and isrccCdFieldValue",
    );
    assert(
      isrccNm == _sentinel || isrccNmFieldValue == null,
      "Cannot specify both isrccNm and isrccNmFieldValue",
    );
    assert(
      isrcRt == _sentinel || isrcRtFieldValue == null,
      "Cannot specify both isrcRt and isrcRtFieldValue",
    );
    assert(
      isrcAmt == _sentinel || isrcAmtFieldValue == null,
      "Cannot specify both isrcAmt and isrcAmtFieldValue",
    );
    assert(
      taxTyCd == _sentinel || taxTyCdFieldValue == null,
      "Cannot specify both taxTyCd and taxTyCdFieldValue",
    );
    assert(
      bcd == _sentinel || bcdFieldValue == null,
      "Cannot specify both bcd and bcdFieldValue",
    );
    assert(
      itemClsCd == _sentinel || itemClsCdFieldValue == null,
      "Cannot specify both itemClsCd and itemClsCdFieldValue",
    );
    assert(
      itemTyCd == _sentinel || itemTyCdFieldValue == null,
      "Cannot specify both itemTyCd and itemTyCdFieldValue",
    );
    assert(
      itemStdNm == _sentinel || itemStdNmFieldValue == null,
      "Cannot specify both itemStdNm and itemStdNmFieldValue",
    );
    assert(
      orgnNatCd == _sentinel || orgnNatCdFieldValue == null,
      "Cannot specify both orgnNatCd and orgnNatCdFieldValue",
    );
    assert(
      pkg == _sentinel || pkgFieldValue == null,
      "Cannot specify both pkg and pkgFieldValue",
    );
    assert(
      itemCd == _sentinel || itemCdFieldValue == null,
      "Cannot specify both itemCd and itemCdFieldValue",
    );
    assert(
      pkgUnitCd == _sentinel || pkgUnitCdFieldValue == null,
      "Cannot specify both pkgUnitCd and pkgUnitCdFieldValue",
    );
    assert(
      qtyUnitCd == _sentinel || qtyUnitCdFieldValue == null,
      "Cannot specify both qtyUnitCd and qtyUnitCdFieldValue",
    );
    assert(
      itemNm == _sentinel || itemNmFieldValue == null,
      "Cannot specify both itemNm and itemNmFieldValue",
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
      splyAmt == _sentinel || splyAmtFieldValue == null,
      "Cannot specify both splyAmt and splyAmtFieldValue",
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
      dftPrc == _sentinel || dftPrcFieldValue == null,
      "Cannot specify both dftPrc and dftPrcFieldValue",
    );
    assert(
      addInfo == _sentinel || addInfoFieldValue == null,
      "Cannot specify both addInfo and addInfoFieldValue",
    );
    assert(
      isrcAplcbYn == _sentinel || isrcAplcbYnFieldValue == null,
      "Cannot specify both isrcAplcbYn and isrcAplcbYnFieldValue",
    );
    assert(
      useYn == _sentinel || useYnFieldValue == null,
      "Cannot specify both useYn and useYnFieldValue",
    );
    assert(
      regrId == _sentinel || regrIdFieldValue == null,
      "Cannot specify both regrId and regrIdFieldValue",
    );
    assert(
      regrNm == _sentinel || regrNmFieldValue == null,
      "Cannot specify both regrNm and regrNmFieldValue",
    );
    assert(
      modrId == _sentinel || modrIdFieldValue == null,
      "Cannot specify both modrId and modrIdFieldValue",
    );
    assert(
      modrNm == _sentinel || modrNmFieldValue == null,
      "Cannot specify both modrNm and modrNmFieldValue",
    );
    assert(
      rsdQty == _sentinel || rsdQtyFieldValue == null,
      "Cannot specify both rsdQty and rsdQtyFieldValue",
    );
    assert(
      lastTouched == _sentinel || lastTouchedFieldValue == null,
      "Cannot specify both lastTouched and lastTouchedFieldValue",
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
      spplrItemClsCd == _sentinel || spplrItemClsCdFieldValue == null,
      "Cannot specify both spplrItemClsCd and spplrItemClsCdFieldValue",
    );
    assert(
      spplrItemCd == _sentinel || spplrItemCdFieldValue == null,
      "Cannot specify both spplrItemCd and spplrItemCdFieldValue",
    );
    assert(
      spplrItemNm == _sentinel || spplrItemNmFieldValue == null,
      "Cannot specify both spplrItemNm and spplrItemNmFieldValue",
    );
    assert(
      ebmSynced == _sentinel || ebmSyncedFieldValue == null,
      "Cannot specify both ebmSynced and ebmSyncedFieldValue",
    );
    assert(
      isTaxExempted == _sentinel || isTaxExemptedFieldValue == null,
      "Cannot specify both isTaxExempted and isTaxExemptedFieldValue",
    );
    assert(
      taxType == _sentinel || taxTypeFieldValue == null,
      "Cannot specify both taxType and taxTypeFieldValue",
    );
    assert(
      branchIds == _sentinel || branchIdsFieldValue == null,
      "Cannot specify both branchIds and branchIdsFieldValue",
    );
    assert(
      stock == _sentinel || stockFieldValue == null,
      "Cannot specify both stock and stockFieldValue",
    );
    final json = {
      if (id != _sentinel)
        _$VariantFieldMap['id']!: _$VariantPerFieldToJson.id(id as int?),
      if (idFieldValue != null) _$VariantFieldMap['id']!: idFieldValue,
      if (deletedAt != _sentinel)
        _$VariantFieldMap['deletedAt']!:
            _$VariantPerFieldToJson.deletedAt(deletedAt as DateTime?),
      if (deletedAtFieldValue != null)
        _$VariantFieldMap['deletedAt']!: deletedAtFieldValue,
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
      if (productId != _sentinel)
        _$VariantFieldMap['productId']!:
            _$VariantPerFieldToJson.productId(productId as int?),
      if (productIdFieldValue != null)
        _$VariantFieldMap['productId']!: productIdFieldValue,
      if (unit != _sentinel)
        _$VariantFieldMap['unit']!:
            _$VariantPerFieldToJson.unit(unit as String?),
      if (unitFieldValue != null) _$VariantFieldMap['unit']!: unitFieldValue,
      if (productName != _sentinel)
        _$VariantFieldMap['productName']!:
            _$VariantPerFieldToJson.productName(productName as String?),
      if (productNameFieldValue != null)
        _$VariantFieldMap['productName']!: productNameFieldValue,
      if (branchId != _sentinel)
        _$VariantFieldMap['branchId']!:
            _$VariantPerFieldToJson.branchId(branchId as int?),
      if (branchIdFieldValue != null)
        _$VariantFieldMap['branchId']!: branchIdFieldValue,
      if (taxName != _sentinel)
        _$VariantFieldMap['taxName']!:
            _$VariantPerFieldToJson.taxName(taxName as String?),
      if (taxNameFieldValue != null)
        _$VariantFieldMap['taxName']!: taxNameFieldValue,
      if (taxPercentage != _sentinel)
        _$VariantFieldMap['taxPercentage']!:
            _$VariantPerFieldToJson.taxPercentage(taxPercentage as double),
      if (taxPercentageFieldValue != null)
        _$VariantFieldMap['taxPercentage']!: taxPercentageFieldValue,
      if (itemSeq != _sentinel)
        _$VariantFieldMap['itemSeq']!:
            _$VariantPerFieldToJson.itemSeq(itemSeq as int?),
      if (itemSeqFieldValue != null)
        _$VariantFieldMap['itemSeq']!: itemSeqFieldValue,
      if (isrccCd != _sentinel)
        _$VariantFieldMap['isrccCd']!:
            _$VariantPerFieldToJson.isrccCd(isrccCd as String?),
      if (isrccCdFieldValue != null)
        _$VariantFieldMap['isrccCd']!: isrccCdFieldValue,
      if (isrccNm != _sentinel)
        _$VariantFieldMap['isrccNm']!:
            _$VariantPerFieldToJson.isrccNm(isrccNm as String?),
      if (isrccNmFieldValue != null)
        _$VariantFieldMap['isrccNm']!: isrccNmFieldValue,
      if (isrcRt != _sentinel)
        _$VariantFieldMap['isrcRt']!:
            _$VariantPerFieldToJson.isrcRt(isrcRt as int?),
      if (isrcRtFieldValue != null)
        _$VariantFieldMap['isrcRt']!: isrcRtFieldValue,
      if (isrcAmt != _sentinel)
        _$VariantFieldMap['isrcAmt']!:
            _$VariantPerFieldToJson.isrcAmt(isrcAmt as int?),
      if (isrcAmtFieldValue != null)
        _$VariantFieldMap['isrcAmt']!: isrcAmtFieldValue,
      if (taxTyCd != _sentinel)
        _$VariantFieldMap['taxTyCd']!:
            _$VariantPerFieldToJson.taxTyCd(taxTyCd as String?),
      if (taxTyCdFieldValue != null)
        _$VariantFieldMap['taxTyCd']!: taxTyCdFieldValue,
      if (bcd != _sentinel)
        _$VariantFieldMap['bcd']!: _$VariantPerFieldToJson.bcd(bcd as String?),
      if (bcdFieldValue != null) _$VariantFieldMap['bcd']!: bcdFieldValue,
      if (itemClsCd != _sentinel)
        _$VariantFieldMap['itemClsCd']!:
            _$VariantPerFieldToJson.itemClsCd(itemClsCd as String?),
      if (itemClsCdFieldValue != null)
        _$VariantFieldMap['itemClsCd']!: itemClsCdFieldValue,
      if (itemTyCd != _sentinel)
        _$VariantFieldMap['itemTyCd']!:
            _$VariantPerFieldToJson.itemTyCd(itemTyCd as String?),
      if (itemTyCdFieldValue != null)
        _$VariantFieldMap['itemTyCd']!: itemTyCdFieldValue,
      if (itemStdNm != _sentinel)
        _$VariantFieldMap['itemStdNm']!:
            _$VariantPerFieldToJson.itemStdNm(itemStdNm as String?),
      if (itemStdNmFieldValue != null)
        _$VariantFieldMap['itemStdNm']!: itemStdNmFieldValue,
      if (orgnNatCd != _sentinel)
        _$VariantFieldMap['orgnNatCd']!:
            _$VariantPerFieldToJson.orgnNatCd(orgnNatCd as String?),
      if (orgnNatCdFieldValue != null)
        _$VariantFieldMap['orgnNatCd']!: orgnNatCdFieldValue,
      if (pkg != _sentinel)
        _$VariantFieldMap['pkg']!: _$VariantPerFieldToJson.pkg(pkg as String?),
      if (pkgFieldValue != null) _$VariantFieldMap['pkg']!: pkgFieldValue,
      if (itemCd != _sentinel)
        _$VariantFieldMap['itemCd']!:
            _$VariantPerFieldToJson.itemCd(itemCd as String?),
      if (itemCdFieldValue != null)
        _$VariantFieldMap['itemCd']!: itemCdFieldValue,
      if (pkgUnitCd != _sentinel)
        _$VariantFieldMap['pkgUnitCd']!:
            _$VariantPerFieldToJson.pkgUnitCd(pkgUnitCd as String?),
      if (pkgUnitCdFieldValue != null)
        _$VariantFieldMap['pkgUnitCd']!: pkgUnitCdFieldValue,
      if (qtyUnitCd != _sentinel)
        _$VariantFieldMap['qtyUnitCd']!:
            _$VariantPerFieldToJson.qtyUnitCd(qtyUnitCd as String?),
      if (qtyUnitCdFieldValue != null)
        _$VariantFieldMap['qtyUnitCd']!: qtyUnitCdFieldValue,
      if (itemNm != _sentinel)
        _$VariantFieldMap['itemNm']!:
            _$VariantPerFieldToJson.itemNm(itemNm as String?),
      if (itemNmFieldValue != null)
        _$VariantFieldMap['itemNm']!: itemNmFieldValue,
      if (qty != _sentinel)
        _$VariantFieldMap['qty']!: _$VariantPerFieldToJson.qty(qty as double),
      if (qtyFieldValue != null) _$VariantFieldMap['qty']!: qtyFieldValue,
      if (prc != _sentinel)
        _$VariantFieldMap['prc']!: _$VariantPerFieldToJson.prc(prc as double),
      if (prcFieldValue != null) _$VariantFieldMap['prc']!: prcFieldValue,
      if (splyAmt != _sentinel)
        _$VariantFieldMap['splyAmt']!:
            _$VariantPerFieldToJson.splyAmt(splyAmt as double),
      if (splyAmtFieldValue != null)
        _$VariantFieldMap['splyAmt']!: splyAmtFieldValue,
      if (tin != _sentinel)
        _$VariantFieldMap['tin']!: _$VariantPerFieldToJson.tin(tin as int?),
      if (tinFieldValue != null) _$VariantFieldMap['tin']!: tinFieldValue,
      if (bhfId != _sentinel)
        _$VariantFieldMap['bhfId']!:
            _$VariantPerFieldToJson.bhfId(bhfId as String?),
      if (bhfIdFieldValue != null) _$VariantFieldMap['bhfId']!: bhfIdFieldValue,
      if (dftPrc != _sentinel)
        _$VariantFieldMap['dftPrc']!:
            _$VariantPerFieldToJson.dftPrc(dftPrc as double?),
      if (dftPrcFieldValue != null)
        _$VariantFieldMap['dftPrc']!: dftPrcFieldValue,
      if (addInfo != _sentinel)
        _$VariantFieldMap['addInfo']!:
            _$VariantPerFieldToJson.addInfo(addInfo as String?),
      if (addInfoFieldValue != null)
        _$VariantFieldMap['addInfo']!: addInfoFieldValue,
      if (isrcAplcbYn != _sentinel)
        _$VariantFieldMap['isrcAplcbYn']!:
            _$VariantPerFieldToJson.isrcAplcbYn(isrcAplcbYn as String?),
      if (isrcAplcbYnFieldValue != null)
        _$VariantFieldMap['isrcAplcbYn']!: isrcAplcbYnFieldValue,
      if (useYn != _sentinel)
        _$VariantFieldMap['useYn']!:
            _$VariantPerFieldToJson.useYn(useYn as String?),
      if (useYnFieldValue != null) _$VariantFieldMap['useYn']!: useYnFieldValue,
      if (regrId != _sentinel)
        _$VariantFieldMap['regrId']!:
            _$VariantPerFieldToJson.regrId(regrId as String?),
      if (regrIdFieldValue != null)
        _$VariantFieldMap['regrId']!: regrIdFieldValue,
      if (regrNm != _sentinel)
        _$VariantFieldMap['regrNm']!:
            _$VariantPerFieldToJson.regrNm(regrNm as String?),
      if (regrNmFieldValue != null)
        _$VariantFieldMap['regrNm']!: regrNmFieldValue,
      if (modrId != _sentinel)
        _$VariantFieldMap['modrId']!:
            _$VariantPerFieldToJson.modrId(modrId as String?),
      if (modrIdFieldValue != null)
        _$VariantFieldMap['modrId']!: modrIdFieldValue,
      if (modrNm != _sentinel)
        _$VariantFieldMap['modrNm']!:
            _$VariantPerFieldToJson.modrNm(modrNm as String?),
      if (modrNmFieldValue != null)
        _$VariantFieldMap['modrNm']!: modrNmFieldValue,
      if (rsdQty != _sentinel)
        _$VariantFieldMap['rsdQty']!:
            _$VariantPerFieldToJson.rsdQty(rsdQty as double),
      if (rsdQtyFieldValue != null)
        _$VariantFieldMap['rsdQty']!: rsdQtyFieldValue,
      if (lastTouched != _sentinel)
        _$VariantFieldMap['lastTouched']!:
            _$VariantPerFieldToJson.lastTouched(lastTouched as DateTime?),
      if (lastTouchedFieldValue != null)
        _$VariantFieldMap['lastTouched']!: lastTouchedFieldValue,
      if (supplyPrice != _sentinel)
        _$VariantFieldMap['supplyPrice']!:
            _$VariantPerFieldToJson.supplyPrice(supplyPrice as double),
      if (supplyPriceFieldValue != null)
        _$VariantFieldMap['supplyPrice']!: supplyPriceFieldValue,
      if (retailPrice != _sentinel)
        _$VariantFieldMap['retailPrice']!:
            _$VariantPerFieldToJson.retailPrice(retailPrice as double),
      if (retailPriceFieldValue != null)
        _$VariantFieldMap['retailPrice']!: retailPriceFieldValue,
      if (spplrItemClsCd != _sentinel)
        _$VariantFieldMap['spplrItemClsCd']!:
            _$VariantPerFieldToJson.spplrItemClsCd(spplrItemClsCd as String?),
      if (spplrItemClsCdFieldValue != null)
        _$VariantFieldMap['spplrItemClsCd']!: spplrItemClsCdFieldValue,
      if (spplrItemCd != _sentinel)
        _$VariantFieldMap['spplrItemCd']!:
            _$VariantPerFieldToJson.spplrItemCd(spplrItemCd as String?),
      if (spplrItemCdFieldValue != null)
        _$VariantFieldMap['spplrItemCd']!: spplrItemCdFieldValue,
      if (spplrItemNm != _sentinel)
        _$VariantFieldMap['spplrItemNm']!:
            _$VariantPerFieldToJson.spplrItemNm(spplrItemNm as String?),
      if (spplrItemNmFieldValue != null)
        _$VariantFieldMap['spplrItemNm']!: spplrItemNmFieldValue,
      if (ebmSynced != _sentinel)
        _$VariantFieldMap['ebmSynced']!:
            _$VariantPerFieldToJson.ebmSynced(ebmSynced as bool),
      if (ebmSyncedFieldValue != null)
        _$VariantFieldMap['ebmSynced']!: ebmSyncedFieldValue,
      if (isTaxExempted != _sentinel)
        _$VariantFieldMap['isTaxExempted']!:
            _$VariantPerFieldToJson.isTaxExempted(isTaxExempted as bool),
      if (isTaxExemptedFieldValue != null)
        _$VariantFieldMap['isTaxExempted']!: isTaxExemptedFieldValue,
      if (taxType != _sentinel)
        _$VariantFieldMap['taxType']!:
            _$VariantPerFieldToJson.taxType(taxType as String),
      if (taxTypeFieldValue != null)
        _$VariantFieldMap['taxType']!: taxTypeFieldValue,
      if (branchIds != _sentinel)
        _$VariantFieldMap['branchIds']!:
            _$VariantPerFieldToJson.branchIds(branchIds as List<int>),
      if (branchIdsFieldValue != null)
        _$VariantFieldMap['branchIds']!: branchIdsFieldValue,
      if (stock != _sentinel)
        _$VariantFieldMap['stock']!:
            _$VariantPerFieldToJson.stock(stock as Stock?),
      if (stockFieldValue != null) _$VariantFieldMap['stock']!: stockFieldValue,
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

  VariantQuery whereDeletedAt({
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

  VariantQuery whereProductId({
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

  VariantQuery whereProductName({
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

  VariantQuery whereBranchId({
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

  VariantQuery whereTaxName({
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

  VariantQuery whereTaxPercentage({
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

  VariantQuery whereItemSeq({
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

  VariantQuery whereIsrccCd({
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

  VariantQuery whereIsrccNm({
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

  VariantQuery whereIsrcRt({
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

  VariantQuery whereIsrcAmt({
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

  VariantQuery whereTaxTyCd({
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

  VariantQuery whereBcd({
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

  VariantQuery whereItemClsCd({
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

  VariantQuery whereItemTyCd({
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

  VariantQuery whereItemStdNm({
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

  VariantQuery whereOrgnNatCd({
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

  VariantQuery wherePkg({
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

  VariantQuery whereItemCd({
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

  VariantQuery wherePkgUnitCd({
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

  VariantQuery whereQtyUnitCd({
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

  VariantQuery whereItemNm({
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

  VariantQuery whereSplyAmt({
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

  VariantQuery whereBhfId({
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

  VariantQuery whereDftPrc({
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

  VariantQuery whereAddInfo({
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

  VariantQuery whereIsrcAplcbYn({
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

  VariantQuery whereUseYn({
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

  VariantQuery whereRegrId({
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

  VariantQuery whereRegrNm({
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

  VariantQuery whereModrId({
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

  VariantQuery whereModrNm({
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

  VariantQuery whereRsdQty({
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

  VariantQuery whereLastTouched({
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

  VariantQuery whereSupplyPrice({
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

  VariantQuery whereRetailPrice({
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

  VariantQuery whereSpplrItemClsCd({
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

  VariantQuery whereSpplrItemCd({
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

  VariantQuery whereSpplrItemNm({
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

  VariantQuery whereEbmSynced({
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

  VariantQuery whereIsTaxExempted({
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

  VariantQuery whereTaxType({
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

  VariantQuery whereBranchIds({
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
    List<Stock?>? whereIn,
    List<Stock?>? whereNotIn,
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
    int? startAt,
    int? startAfter,
    int? endAt,
    int? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByDeletedAt({
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

  VariantQuery orderByProductId({
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

  VariantQuery orderByProductName({
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

  VariantQuery orderByBranchId({
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

  VariantQuery orderByTaxName({
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

  VariantQuery orderByTaxPercentage({
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

  VariantQuery orderByItemSeq({
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

  VariantQuery orderByIsrccCd({
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

  VariantQuery orderByIsrccNm({
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

  VariantQuery orderByIsrcRt({
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

  VariantQuery orderByIsrcAmt({
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

  VariantQuery orderByTaxTyCd({
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

  VariantQuery orderByBcd({
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

  VariantQuery orderByItemClsCd({
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

  VariantQuery orderByItemTyCd({
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

  VariantQuery orderByItemStdNm({
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

  VariantQuery orderByOrgnNatCd({
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

  VariantQuery orderByPkg({
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

  VariantQuery orderByItemCd({
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

  VariantQuery orderByPkgUnitCd({
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

  VariantQuery orderByQtyUnitCd({
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

  VariantQuery orderByItemNm({
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

  VariantQuery orderBySplyAmt({
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

  VariantQuery orderByBhfId({
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

  VariantQuery orderByDftPrc({
    bool descending = false,
    double? startAt,
    double? startAfter,
    double? endAt,
    double? endBefore,
    VariantDocumentSnapshot? startAtDocument,
    VariantDocumentSnapshot? endAtDocument,
    VariantDocumentSnapshot? endBeforeDocument,
    VariantDocumentSnapshot? startAfterDocument,
  });

  VariantQuery orderByAddInfo({
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

  VariantQuery orderByIsrcAplcbYn({
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

  VariantQuery orderByUseYn({
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

  VariantQuery orderByRegrId({
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

  VariantQuery orderByRegrNm({
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

  VariantQuery orderByModrId({
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

  VariantQuery orderByModrNm({
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

  VariantQuery orderByRsdQty({
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

  VariantQuery orderByLastTouched({
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

  VariantQuery orderBySupplyPrice({
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

  VariantQuery orderByRetailPrice({
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

  VariantQuery orderBySpplrItemClsCd({
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

  VariantQuery orderBySpplrItemCd({
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

  VariantQuery orderBySpplrItemNm({
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

  VariantQuery orderByEbmSynced({
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

  VariantQuery orderByIsTaxExempted({
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

  VariantQuery orderByTaxType({
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

  VariantQuery orderByBranchIds({
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
    Stock? startAt,
    Stock? startAfter,
    Stock? endAt,
    Stock? endBefore,
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
    List<int?>? whereIn,
    List<int?>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['id']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.id(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.id(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.id(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.id(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.id(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.id(isGreaterThanOrEqualTo as int?)
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
  VariantQuery whereDeletedAt({
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
        _$VariantFieldMap['deletedAt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.deletedAt(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.deletedAt(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.deletedAt(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .deletedAt(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.deletedAt(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .deletedAt(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.deletedAt(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.deletedAt(e)),
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
  VariantQuery whereProductId({
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
        _$VariantFieldMap['productId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.productId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.productId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.productId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.productId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.productId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.productId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.productId(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.productId(e)),
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
  VariantQuery whereProductName({
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
        _$VariantFieldMap['productName']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.productName(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.productName(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.productName(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .productName(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.productName(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .productName(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.productName(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.productName(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereBranchId({
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
        _$VariantFieldMap['branchId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branchId(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branchId(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.branchId(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.branchId(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.branchId(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.branchId(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.branchId(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.branchId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTaxName({
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
        _$VariantFieldMap['taxName']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxName(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxName(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.taxName(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.taxName(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.taxName(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.taxName(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.taxName(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.taxName(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTaxPercentage({
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
        _$VariantFieldMap['taxPercentage']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxPercentage(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxPercentage(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.taxPercentage(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .taxPercentage(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.taxPercentage(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .taxPercentage(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.taxPercentage(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.taxPercentage(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItemSeq({
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
        _$VariantFieldMap['itemSeq']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemSeq(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemSeq(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.itemSeq(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemSeq(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.itemSeq(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemSeq(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.itemSeq(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.itemSeq(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrccCd({
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
        _$VariantFieldMap['isrccCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrccCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrccCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrccCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrccCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrccCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrccCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrccCd(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrccCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrccNm({
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
        _$VariantFieldMap['isrccNm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrccNm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrccNm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrccNm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrccNm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrccNm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrccNm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrccNm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrccNm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrcRt({
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
        _$VariantFieldMap['isrcRt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcRt(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcRt(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrcRt(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcRt(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrcRt(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcRt(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrcRt(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrcRt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrcAmt({
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
        _$VariantFieldMap['isrcAmt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcAmt(isEqualTo as int?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcAmt(isNotEqualTo as int?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrcAmt(isLessThan as int?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcAmt(isLessThanOrEqualTo as int?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrcAmt(isGreaterThan as int?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isrcAmt(isGreaterThanOrEqualTo as int?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrcAmt(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.isrcAmt(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTaxTyCd({
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
        _$VariantFieldMap['taxTyCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxTyCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxTyCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.taxTyCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.taxTyCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.taxTyCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.taxTyCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.taxTyCd(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.taxTyCd(e)),
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
    List<String?>? whereIn,
    List<String?>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['bcd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bcd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bcd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.bcd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bcd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.bcd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bcd(isGreaterThanOrEqualTo as String?)
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
  VariantQuery whereItemClsCd({
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
        _$VariantFieldMap['itemClsCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemClsCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemClsCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.itemClsCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemClsCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.itemClsCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .itemClsCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.itemClsCd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.itemClsCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItemTyCd({
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
        _$VariantFieldMap['itemTyCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemTyCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemTyCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.itemTyCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemTyCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.itemTyCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .itemTyCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.itemTyCd(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.itemTyCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItemStdNm({
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
        _$VariantFieldMap['itemStdNm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemStdNm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemStdNm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.itemStdNm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemStdNm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.itemStdNm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .itemStdNm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.itemStdNm(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.itemStdNm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereOrgnNatCd({
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
        _$VariantFieldMap['orgnNatCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.orgnNatCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.orgnNatCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.orgnNatCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.orgnNatCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.orgnNatCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .orgnNatCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.orgnNatCd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.orgnNatCd(e)),
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
    List<String?>? whereIn,
    List<String?>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['pkg']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkg(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkg(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.pkg(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.pkg(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.pkg(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.pkg(isGreaterThanOrEqualTo as String?)
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
  VariantQuery whereItemCd({
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
        _$VariantFieldMap['itemCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.itemCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.itemCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.itemCd(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.itemCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery wherePkgUnitCd({
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
        _$VariantFieldMap['pkgUnitCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkgUnitCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.pkgUnitCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.pkgUnitCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.pkgUnitCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.pkgUnitCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .pkgUnitCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.pkgUnitCd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.pkgUnitCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereQtyUnitCd({
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
        _$VariantFieldMap['qtyUnitCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.qtyUnitCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.qtyUnitCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.qtyUnitCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.qtyUnitCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.qtyUnitCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .qtyUnitCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.qtyUnitCd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.qtyUnitCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereItemNm({
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
        _$VariantFieldMap['itemNm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemNm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.itemNm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.itemNm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemNm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.itemNm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.itemNm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.itemNm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.itemNm(e)),
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
  VariantQuery whereSplyAmt({
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
        _$VariantFieldMap['splyAmt']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.splyAmt(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.splyAmt(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.splyAmt(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.splyAmt(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.splyAmt(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.splyAmt(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.splyAmt(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.splyAmt(e)),
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
  VariantQuery whereBhfId({
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
        _$VariantFieldMap['bhfId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bhfId(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.bhfId(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.bhfId(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bhfId(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.bhfId(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.bhfId(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.bhfId(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.bhfId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereDftPrc({
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
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['dftPrc']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.dftPrc(isEqualTo as double?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.dftPrc(isNotEqualTo as double?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.dftPrc(isLessThan as double?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.dftPrc(isLessThanOrEqualTo as double?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.dftPrc(isGreaterThan as double?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.dftPrc(isGreaterThanOrEqualTo as double?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.dftPrc(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.dftPrc(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereAddInfo({
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
        _$VariantFieldMap['addInfo']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.addInfo(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.addInfo(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.addInfo(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.addInfo(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.addInfo(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.addInfo(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.addInfo(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.addInfo(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsrcAplcbYn({
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
        _$VariantFieldMap['isrcAplcbYn']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcAplcbYn(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isrcAplcbYn(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isrcAplcbYn(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .isrcAplcbYn(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isrcAplcbYn(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .isrcAplcbYn(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isrcAplcbYn(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.isrcAplcbYn(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereUseYn({
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
        _$VariantFieldMap['useYn']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.useYn(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.useYn(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.useYn(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.useYn(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.useYn(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.useYn(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.useYn(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.useYn(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRegrId({
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
        _$VariantFieldMap['regrId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regrId(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regrId(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.regrId(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regrId(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.regrId(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regrId(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.regrId(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.regrId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRegrNm({
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
        _$VariantFieldMap['regrNm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regrNm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.regrNm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.regrNm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regrNm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.regrNm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.regrNm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.regrNm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.regrNm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereModrId({
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
        _$VariantFieldMap['modrId']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modrId(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modrId(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.modrId(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modrId(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.modrId(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modrId(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.modrId(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.modrId(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereModrNm({
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
        _$VariantFieldMap['modrNm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modrNm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.modrNm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.modrNm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modrNm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.modrNm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.modrNm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.modrNm(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.modrNm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRsdQty({
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
        _$VariantFieldMap['rsdQty']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.rsdQty(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.rsdQty(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.rsdQty(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.rsdQty(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.rsdQty(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.rsdQty(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.rsdQty(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.rsdQty(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereLastTouched({
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
        _$VariantFieldMap['lastTouched']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.lastTouched(isEqualTo as DateTime?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.lastTouched(isNotEqualTo as DateTime?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.lastTouched(isLessThan as DateTime?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .lastTouched(isLessThanOrEqualTo as DateTime?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.lastTouched(isGreaterThan as DateTime?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .lastTouched(isGreaterThanOrEqualTo as DateTime?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.lastTouched(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.lastTouched(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSupplyPrice({
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
        _$VariantFieldMap['supplyPrice']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.supplyPrice(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.supplyPrice(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.supplyPrice(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.supplyPrice(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.supplyPrice(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .supplyPrice(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.supplyPrice(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.supplyPrice(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereRetailPrice({
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
        _$VariantFieldMap['retailPrice']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.retailPrice(isEqualTo as double)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.retailPrice(isNotEqualTo as double)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.retailPrice(isLessThan as double)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.retailPrice(isLessThanOrEqualTo as double)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.retailPrice(isGreaterThan as double)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .retailPrice(isGreaterThanOrEqualTo as double)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.retailPrice(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.retailPrice(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSpplrItemClsCd({
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
        _$VariantFieldMap['spplrItemClsCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplrItemClsCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplrItemClsCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.spplrItemClsCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplrItemClsCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.spplrItemClsCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplrItemClsCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.spplrItemClsCd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.spplrItemClsCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSpplrItemCd({
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
        _$VariantFieldMap['spplrItemCd']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplrItemCd(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplrItemCd(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.spplrItemCd(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplrItemCd(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.spplrItemCd(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplrItemCd(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.spplrItemCd(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.spplrItemCd(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereSpplrItemNm({
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
        _$VariantFieldMap['spplrItemNm']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplrItemNm(isEqualTo as String?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.spplrItemNm(isNotEqualTo as String?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.spplrItemNm(isLessThan as String?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplrItemNm(isLessThanOrEqualTo as String?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.spplrItemNm(isGreaterThan as String?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .spplrItemNm(isGreaterThanOrEqualTo as String?)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.spplrItemNm(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.spplrItemNm(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereEbmSynced({
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
        _$VariantFieldMap['ebmSynced']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.ebmSynced(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.ebmSynced(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.ebmSynced(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.ebmSynced(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.ebmSynced(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.ebmSynced(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.ebmSynced(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.ebmSynced(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereIsTaxExempted({
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
        _$VariantFieldMap['isTaxExempted']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isTaxExempted(isEqualTo as bool)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.isTaxExempted(isNotEqualTo as bool)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.isTaxExempted(isLessThan as bool)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.isTaxExempted(isLessThanOrEqualTo as bool)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.isTaxExempted(isGreaterThan as bool)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .isTaxExempted(isGreaterThanOrEqualTo as bool)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.isTaxExempted(e)),
        whereNotIn:
            whereNotIn?.map((e) => _$VariantPerFieldToJson.isTaxExempted(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereTaxType({
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
        _$VariantFieldMap['taxType']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxType(isEqualTo as String)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.taxType(isNotEqualTo as String)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.taxType(isLessThan as String)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.taxType(isLessThanOrEqualTo as String)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.taxType(isGreaterThan as String)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.taxType(isGreaterThanOrEqualTo as String)
            : null,
        whereIn: whereIn?.map((e) => _$VariantPerFieldToJson.taxType(e)),
        whereNotIn: whereNotIn?.map((e) => _$VariantPerFieldToJson.taxType(e)),
        isNull: isNull ??
            (isEqualTo == null ? false : null) ??
            (isNotEqualTo == null ? true : null),
      ),
      $queryCursor: $queryCursor,
    );
  }

  @override
  VariantQuery whereBranchIds({
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
        _$VariantFieldMap['branchIds']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branchIds(isEqualTo as List<int>)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.branchIds(isNotEqualTo as List<int>)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.branchIds(isLessThan as List<int>)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .branchIds(isLessThanOrEqualTo as List<int>)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.branchIds(isGreaterThan as List<int>)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson
                .branchIds(isGreaterThanOrEqualTo as List<int>)
            : null,
        arrayContains: arrayContains != null
            ? (_$VariantPerFieldToJson.branchIds([arrayContains as int])
                    as List?)!
                .single
            : null,
        arrayContainsAny: arrayContainsAny != null
            ? _$VariantPerFieldToJson.branchIds(arrayContainsAny)
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
    List<Stock?>? whereIn,
    List<Stock?>? whereNotIn,
    bool? isNull,
  }) {
    return _$VariantQuery(
      _collection,
      $referenceWithoutCursor: $referenceWithoutCursor.where(
        _$VariantFieldMap['stock']!,
        isEqualTo: isEqualTo != _sentinel
            ? _$VariantPerFieldToJson.stock(isEqualTo as Stock?)
            : null,
        isNotEqualTo: isNotEqualTo != _sentinel
            ? _$VariantPerFieldToJson.stock(isNotEqualTo as Stock?)
            : null,
        isLessThan: isLessThan != null
            ? _$VariantPerFieldToJson.stock(isLessThan as Stock?)
            : null,
        isLessThanOrEqualTo: isLessThanOrEqualTo != null
            ? _$VariantPerFieldToJson.stock(isLessThanOrEqualTo as Stock?)
            : null,
        isGreaterThan: isGreaterThan != null
            ? _$VariantPerFieldToJson.stock(isGreaterThan as Stock?)
            : null,
        isGreaterThanOrEqualTo: isGreaterThanOrEqualTo != null
            ? _$VariantPerFieldToJson.stock(isGreaterThanOrEqualTo as Stock?)
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
  VariantQuery orderByDeletedAt({
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
        .orderBy(_$VariantFieldMap['deletedAt']!, descending: descending);
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
  VariantQuery orderByProductId({
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
        .orderBy(_$VariantFieldMap['productId']!, descending: descending);
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
  VariantQuery orderByProductName({
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
        .orderBy(_$VariantFieldMap['productName']!, descending: descending);
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
  VariantQuery orderByBranchId({
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
        .orderBy(_$VariantFieldMap['branchId']!, descending: descending);
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
  VariantQuery orderByTaxName({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['taxName']!,
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
  VariantQuery orderByTaxPercentage({
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
        .orderBy(_$VariantFieldMap['taxPercentage']!, descending: descending);
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
  VariantQuery orderByItemSeq({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['itemSeq']!,
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
  VariantQuery orderByIsrccCd({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['isrccCd']!,
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
  VariantQuery orderByIsrccNm({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['isrccNm']!,
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
  VariantQuery orderByIsrcRt({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['isrcRt']!,
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
  VariantQuery orderByIsrcAmt({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['isrcAmt']!,
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
  VariantQuery orderByTaxTyCd({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['taxTyCd']!,
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
  VariantQuery orderByItemClsCd({
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
        .orderBy(_$VariantFieldMap['itemClsCd']!, descending: descending);
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
  VariantQuery orderByItemTyCd({
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
        .orderBy(_$VariantFieldMap['itemTyCd']!, descending: descending);
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
  VariantQuery orderByItemStdNm({
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
        .orderBy(_$VariantFieldMap['itemStdNm']!, descending: descending);
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
  VariantQuery orderByOrgnNatCd({
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
        .orderBy(_$VariantFieldMap['orgnNatCd']!, descending: descending);
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
  VariantQuery orderByItemCd({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['itemCd']!,
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
  VariantQuery orderByPkgUnitCd({
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
        .orderBy(_$VariantFieldMap['pkgUnitCd']!, descending: descending);
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
  VariantQuery orderByQtyUnitCd({
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
        .orderBy(_$VariantFieldMap['qtyUnitCd']!, descending: descending);
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
  VariantQuery orderByItemNm({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['itemNm']!,
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
  VariantQuery orderBySplyAmt({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['splyAmt']!,
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
  VariantQuery orderByBhfId({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['bhfId']!,
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
  VariantQuery orderByDftPrc({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['dftPrc']!,
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
  VariantQuery orderByAddInfo({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['addInfo']!,
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
  VariantQuery orderByIsrcAplcbYn({
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
        .orderBy(_$VariantFieldMap['isrcAplcbYn']!, descending: descending);
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
  VariantQuery orderByUseYn({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['useYn']!,
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
  VariantQuery orderByRegrId({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['regrId']!,
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
  VariantQuery orderByRegrNm({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['regrNm']!,
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
  VariantQuery orderByModrId({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['modrId']!,
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
  VariantQuery orderByModrNm({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['modrNm']!,
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
  VariantQuery orderByRsdQty({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['rsdQty']!,
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
  VariantQuery orderByLastTouched({
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
        .orderBy(_$VariantFieldMap['lastTouched']!, descending: descending);
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
  VariantQuery orderBySupplyPrice({
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
        .orderBy(_$VariantFieldMap['supplyPrice']!, descending: descending);
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
  VariantQuery orderByRetailPrice({
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
        .orderBy(_$VariantFieldMap['retailPrice']!, descending: descending);
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
  VariantQuery orderBySpplrItemClsCd({
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
        .orderBy(_$VariantFieldMap['spplrItemClsCd']!, descending: descending);
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
  VariantQuery orderBySpplrItemCd({
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
        .orderBy(_$VariantFieldMap['spplrItemCd']!, descending: descending);
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
  VariantQuery orderBySpplrItemNm({
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
        .orderBy(_$VariantFieldMap['spplrItemNm']!, descending: descending);
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
  VariantQuery orderByEbmSynced({
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
        .orderBy(_$VariantFieldMap['ebmSynced']!, descending: descending);
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
  VariantQuery orderByIsTaxExempted({
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
        .orderBy(_$VariantFieldMap['isTaxExempted']!, descending: descending);
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
  VariantQuery orderByTaxType({
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
    final query = $referenceWithoutCursor.orderBy(_$VariantFieldMap['taxType']!,
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
  VariantQuery orderByBranchIds({
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
        .orderBy(_$VariantFieldMap['branchIds']!, descending: descending);
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

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Variant _$VariantFromJson(Map<String, dynamic> json) => Variant(
      id: (json['id'] as num?)?.toInt(),
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
      name: json['name'] as String?,
      color: json['color'] as String?,
      sku: json['sku'] as String?,
      productId: (json['productId'] as num?)?.toInt(),
      unit: json['unit'] as String?,
      productName: json['productName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      taxName: json['taxName'] as String? ?? '',
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble() ?? 0.0,
      itemSeq: (json['itemSeq'] as num?)?.toInt(),
      isrccCd: json['isrccCd'] as String? ?? '',
      isrccNm: json['isrccNm'] as String? ?? '',
      isrcRt: (json['isrcRt'] as num?)?.toInt() ?? 0,
      isrcAmt: (json['isrcAmt'] as num?)?.toInt() ?? 0,
      taxTyCd: json['taxTyCd'] as String? ?? 'B',
      bcd: json['bcd'] as String? ?? '',
      itemClsCd: json['itemClsCd'] as String?,
      itemTyCd: json['itemTyCd'] as String?,
      itemStdNm: json['itemStdNm'] as String? ?? '',
      orgnNatCd: json['orgnNatCd'] as String? ?? '',
      pkg: json['pkg'] as String? ?? '1',
      itemCd: json['itemCd'] as String? ?? '',
      pkgUnitCd: json['pkgUnitCd'] as String? ?? 'CT',
      qtyUnitCd: json['qtyUnitCd'] as String? ?? 'BX',
      itemNm: json['itemNm'] as String?,
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      prc: (json['prc'] as num?)?.toDouble() ?? 0.0,
      splyAmt: (json['splyAmt'] as num?)?.toDouble() ?? 0.0,
      tin: (json['tin'] as num?)?.toInt(),
      bhfId: json['bhfId'] as String?,
      dftPrc: (json['dftPrc'] as num?)?.toDouble() ?? 0.0,
      addInfo: json['addInfo'] as String? ?? '',
      isrcAplcbYn: json['isrcAplcbYn'] as String? ?? '',
      useYn: json['useYn'] as String? ?? '',
      regrId: json['regrId'] as String?,
      regrNm: json['regrNm'] as String?,
      modrId: json['modrId'] as String?,
      modrNm: json['modrNm'] as String?,
      rsdQty: (json['rsdQty'] as num?)?.toDouble() ?? 0.0,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      supplyPrice: (json['supplyPrice'] as num?)?.toDouble() ?? 0.0,
      retailPrice: (json['retailPrice'] as num?)?.toDouble() ?? 0.0,
      spplrItemClsCd: json['spplrItemClsCd'] as String?,
      spplrItemCd: json['spplrItemCd'] as String?,
      spplrItemNm: json['spplrItemNm'] as String?,
      ebmSynced: json['ebmSynced'] as bool? ?? false,
      isTaxExempted: json['isTaxExempted'] as bool? ?? false,
      taxType: json['taxType'] as String? ?? 'B',
      branchIds: (json['branchIds'] as List<dynamic>?)
              ?.map((e) => (e as num).toInt())
              .toList() ??
          [],
      stock: json['stock'] == null
          ? null
          : Stock.fromJson(json['stock'] as Map<String, dynamic>),
    );

const _$VariantFieldMap = <String, String>{
  'id': 'id',
  'deletedAt': 'deletedAt',
  'name': 'name',
  'color': 'color',
  'sku': 'sku',
  'productId': 'productId',
  'unit': 'unit',
  'productName': 'productName',
  'branchId': 'branchId',
  'taxName': 'taxName',
  'taxPercentage': 'taxPercentage',
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
  'qty': 'qty',
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
  'rsdQty': 'rsdQty',
  'lastTouched': 'lastTouched',
  'supplyPrice': 'supplyPrice',
  'retailPrice': 'retailPrice',
  'spplrItemClsCd': 'spplrItemClsCd',
  'spplrItemCd': 'spplrItemCd',
  'spplrItemNm': 'spplrItemNm',
  'ebmSynced': 'ebmSynced',
  'isTaxExempted': 'isTaxExempted',
  'taxType': 'taxType',
  'branchIds': 'branchIds',
  'stock': 'stock',
};

// ignore: unused_element
abstract class _$VariantPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? deletedAt(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? name(String? instance) => instance;
  // ignore: unused_element
  static Object? color(String? instance) => instance;
  // ignore: unused_element
  static Object? sku(String? instance) => instance;
  // ignore: unused_element
  static Object? productId(int? instance) => instance;
  // ignore: unused_element
  static Object? unit(String? instance) => instance;
  // ignore: unused_element
  static Object? productName(String? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int? instance) => instance;
  // ignore: unused_element
  static Object? taxName(String? instance) => instance;
  // ignore: unused_element
  static Object? taxPercentage(double instance) => instance;
  // ignore: unused_element
  static Object? itemSeq(int? instance) => instance;
  // ignore: unused_element
  static Object? isrccCd(String? instance) => instance;
  // ignore: unused_element
  static Object? isrccNm(String? instance) => instance;
  // ignore: unused_element
  static Object? isrcRt(int? instance) => instance;
  // ignore: unused_element
  static Object? isrcAmt(int? instance) => instance;
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
  static Object? qty(double instance) => instance;
  // ignore: unused_element
  static Object? prc(double instance) => instance;
  // ignore: unused_element
  static Object? splyAmt(double instance) => instance;
  // ignore: unused_element
  static Object? tin(int? instance) => instance;
  // ignore: unused_element
  static Object? bhfId(String? instance) => instance;
  // ignore: unused_element
  static Object? dftPrc(double? instance) => instance;
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
  static Object? rsdQty(double instance) => instance;
  // ignore: unused_element
  static Object? lastTouched(DateTime? instance) => instance?.toIso8601String();
  // ignore: unused_element
  static Object? supplyPrice(double instance) => instance;
  // ignore: unused_element
  static Object? retailPrice(double instance) => instance;
  // ignore: unused_element
  static Object? spplrItemClsCd(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrItemCd(String? instance) => instance;
  // ignore: unused_element
  static Object? spplrItemNm(String? instance) => instance;
  // ignore: unused_element
  static Object? ebmSynced(bool instance) => instance;
  // ignore: unused_element
  static Object? isTaxExempted(bool instance) => instance;
  // ignore: unused_element
  static Object? taxType(String instance) => instance;
  // ignore: unused_element
  static Object? branchIds(List<int> instance) => instance;
  // ignore: unused_element
  static Object? stock(Stock? instance) => instance;
}

Map<String, dynamic> _$VariantToJson(Variant instance) => <String, dynamic>{
      'id': instance.id,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'name': instance.name,
      'color': instance.color,
      'sku': instance.sku,
      'productId': instance.productId,
      'unit': instance.unit,
      'productName': instance.productName,
      'branchId': instance.branchId,
      'taxName': instance.taxName,
      'taxPercentage': instance.taxPercentage,
      'itemSeq': instance.itemSeq,
      'isrccCd': instance.isrccCd,
      'isrccNm': instance.isrccNm,
      'isrcRt': instance.isrcRt,
      'isrcAmt': instance.isrcAmt,
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
      'qty': instance.qty,
      'prc': instance.prc,
      'splyAmt': instance.splyAmt,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'dftPrc': instance.dftPrc,
      'addInfo': instance.addInfo,
      'isrcAplcbYn': instance.isrcAplcbYn,
      'useYn': instance.useYn,
      'regrId': instance.regrId,
      'regrNm': instance.regrNm,
      'modrId': instance.modrId,
      'modrNm': instance.modrNm,
      'rsdQty': instance.rsdQty,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'supplyPrice': instance.supplyPrice,
      'retailPrice': instance.retailPrice,
      'spplrItemClsCd': instance.spplrItemClsCd,
      'spplrItemCd': instance.spplrItemCd,
      'spplrItemNm': instance.spplrItemNm,
      'ebmSynced': instance.ebmSynced,
      'isTaxExempted': instance.isTaxExempted,
      'taxType': instance.taxType,
      'branchIds': instance.branchIds,
      'stock': instance.stock,
    };
