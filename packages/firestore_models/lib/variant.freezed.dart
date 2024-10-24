// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'variant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Variant _$VariantFromJson(Map<String, dynamic> json) {
  return _Variant.fromJson(json);
}

/// @nodoc
mixin _$Variant {
  int? get id => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get color => throw _privateConstructorUsedError;
  String? get sku => throw _privateConstructorUsedError;
  int? get productId => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  String? get taxName => throw _privateConstructorUsedError;
  double get taxPercentage =>
      throw _privateConstructorUsedError; // RRA fields with comments preserved
  int? get itemSeq => throw _privateConstructorUsedError;
  String? get isrccCd => throw _privateConstructorUsedError; // insurance code
  String? get isrccNm => throw _privateConstructorUsedError; // insurance name
  int? get isrcRt => throw _privateConstructorUsedError; // premium rate
  int? get isrcAmt => throw _privateConstructorUsedError; // insurance amount
  String? get taxTyCd =>
      throw _privateConstructorUsedError; // taxation type code
  String? get bcd => throw _privateConstructorUsedError; // bar code
  String? get itemClsCd => throw _privateConstructorUsedError; // Item code
  String? get itemTyCd => throw _privateConstructorUsedError; // Item type code
  String? get itemStdNm =>
      throw _privateConstructorUsedError; // Item standard name
  String? get orgnNatCd => throw _privateConstructorUsedError; // Item origin
  String? get pkg => throw _privateConstructorUsedError; // packaging unit code
  String? get itemCd => throw _privateConstructorUsedError; // item code
  String? get pkgUnitCd => throw _privateConstructorUsedError;
  String? get qtyUnitCd => throw _privateConstructorUsedError;
  String? get itemNm =>
      throw _privateConstructorUsedError; // same as name but for rra happiness
  double get qty => throw _privateConstructorUsedError;
  double get prc => throw _privateConstructorUsedError; // unit price
  double get splyAmt => throw _privateConstructorUsedError; // supply amount
  int? get tin => throw _privateConstructorUsedError;
  String? get bhfId => throw _privateConstructorUsedError;
  double? get dftPrc => throw _privateConstructorUsedError;
  String? get addInfo => throw _privateConstructorUsedError;
  String? get isrcAplcbYn => throw _privateConstructorUsedError;
  String? get useYn => throw _privateConstructorUsedError;
  String? get regrId => throw _privateConstructorUsedError;
  String? get regrNm => throw _privateConstructorUsedError;
  String? get modrId => throw _privateConstructorUsedError;
  String? get modrNm =>
      throw _privateConstructorUsedError; // Stock-related properties
  double get rsdQty => throw _privateConstructorUsedError;

  /// property for stock but presented here for easy
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  double get supplyPrice => throw _privateConstructorUsedError;
  double get retailPrice =>
      throw _privateConstructorUsedError; // Supplier-related fields
  String? get spplrItemClsCd => throw _privateConstructorUsedError;

  /// fields for supplier-owned items
  String? get spplrItemCd => throw _privateConstructorUsedError;
  String? get spplrItemNm =>
      throw _privateConstructorUsedError; // EBM sync status
  bool get ebmSynced =>
      throw _privateConstructorUsedError; // Deprecated fields marked with @deprecated annotation
  @deprecated
  bool get isTaxExempted => throw _privateConstructorUsedError;

  /// use taxTyCd='A' instead
  @deprecated
  String get taxType => throw _privateConstructorUsedError;

  /// use taxTyCd instead
// Branch and stock relationships
  List<int> get branchIds => throw _privateConstructorUsedError;
  Stock? get stock => throw _privateConstructorUsedError;

  /// Serializes this Variant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VariantCopyWith<Variant> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VariantCopyWith<$Res> {
  factory $VariantCopyWith(Variant value, $Res Function(Variant) then) =
      _$VariantCopyWithImpl<$Res, Variant>;
  @useResult
  $Res call(
      {int? id,
      DateTime? deletedAt,
      String? name,
      String? color,
      String? sku,
      int? productId,
      String? unit,
      String? productName,
      int? branchId,
      String? taxName,
      double taxPercentage,
      int? itemSeq,
      String? isrccCd,
      String? isrccNm,
      int? isrcRt,
      int? isrcAmt,
      String? taxTyCd,
      String? bcd,
      String? itemClsCd,
      String? itemTyCd,
      String? itemStdNm,
      String? orgnNatCd,
      String? pkg,
      String? itemCd,
      String? pkgUnitCd,
      String? qtyUnitCd,
      String? itemNm,
      double qty,
      double prc,
      double splyAmt,
      int? tin,
      String? bhfId,
      double? dftPrc,
      String? addInfo,
      String? isrcAplcbYn,
      String? useYn,
      String? regrId,
      String? regrNm,
      String? modrId,
      String? modrNm,
      double rsdQty,
      DateTime? lastTouched,
      double supplyPrice,
      double retailPrice,
      String? spplrItemClsCd,
      String? spplrItemCd,
      String? spplrItemNm,
      bool ebmSynced,
      @deprecated bool isTaxExempted,
      @deprecated String taxType,
      List<int> branchIds,
      Stock? stock});

  $StockCopyWith<$Res>? get stock;
}

/// @nodoc
class _$VariantCopyWithImpl<$Res, $Val extends Variant>
    implements $VariantCopyWith<$Res> {
  _$VariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? deletedAt = freezed,
    Object? name = freezed,
    Object? color = freezed,
    Object? sku = freezed,
    Object? productId = freezed,
    Object? unit = freezed,
    Object? productName = freezed,
    Object? branchId = freezed,
    Object? taxName = freezed,
    Object? taxPercentage = null,
    Object? itemSeq = freezed,
    Object? isrccCd = freezed,
    Object? isrccNm = freezed,
    Object? isrcRt = freezed,
    Object? isrcAmt = freezed,
    Object? taxTyCd = freezed,
    Object? bcd = freezed,
    Object? itemClsCd = freezed,
    Object? itemTyCd = freezed,
    Object? itemStdNm = freezed,
    Object? orgnNatCd = freezed,
    Object? pkg = freezed,
    Object? itemCd = freezed,
    Object? pkgUnitCd = freezed,
    Object? qtyUnitCd = freezed,
    Object? itemNm = freezed,
    Object? qty = null,
    Object? prc = null,
    Object? splyAmt = null,
    Object? tin = freezed,
    Object? bhfId = freezed,
    Object? dftPrc = freezed,
    Object? addInfo = freezed,
    Object? isrcAplcbYn = freezed,
    Object? useYn = freezed,
    Object? regrId = freezed,
    Object? regrNm = freezed,
    Object? modrId = freezed,
    Object? modrNm = freezed,
    Object? rsdQty = null,
    Object? lastTouched = freezed,
    Object? supplyPrice = null,
    Object? retailPrice = null,
    Object? spplrItemClsCd = freezed,
    Object? spplrItemCd = freezed,
    Object? spplrItemNm = freezed,
    Object? ebmSynced = null,
    Object? isTaxExempted = null,
    Object? taxType = null,
    Object? branchIds = null,
    Object? stock = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      taxName: freezed == taxName
          ? _value.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      taxPercentage: null == taxPercentage
          ? _value.taxPercentage
          : taxPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      itemSeq: freezed == itemSeq
          ? _value.itemSeq
          : itemSeq // ignore: cast_nullable_to_non_nullable
              as int?,
      isrccCd: freezed == isrccCd
          ? _value.isrccCd
          : isrccCd // ignore: cast_nullable_to_non_nullable
              as String?,
      isrccNm: freezed == isrccNm
          ? _value.isrccNm
          : isrccNm // ignore: cast_nullable_to_non_nullable
              as String?,
      isrcRt: freezed == isrcRt
          ? _value.isrcRt
          : isrcRt // ignore: cast_nullable_to_non_nullable
              as int?,
      isrcAmt: freezed == isrcAmt
          ? _value.isrcAmt
          : isrcAmt // ignore: cast_nullable_to_non_nullable
              as int?,
      taxTyCd: freezed == taxTyCd
          ? _value.taxTyCd
          : taxTyCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bcd: freezed == bcd
          ? _value.bcd
          : bcd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemClsCd: freezed == itemClsCd
          ? _value.itemClsCd
          : itemClsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTyCd: freezed == itemTyCd
          ? _value.itemTyCd
          : itemTyCd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemStdNm: freezed == itemStdNm
          ? _value.itemStdNm
          : itemStdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      orgnNatCd: freezed == orgnNatCd
          ? _value.orgnNatCd
          : orgnNatCd // ignore: cast_nullable_to_non_nullable
              as String?,
      pkg: freezed == pkg
          ? _value.pkg
          : pkg // ignore: cast_nullable_to_non_nullable
              as String?,
      itemCd: freezed == itemCd
          ? _value.itemCd
          : itemCd // ignore: cast_nullable_to_non_nullable
              as String?,
      pkgUnitCd: freezed == pkgUnitCd
          ? _value.pkgUnitCd
          : pkgUnitCd // ignore: cast_nullable_to_non_nullable
              as String?,
      qtyUnitCd: freezed == qtyUnitCd
          ? _value.qtyUnitCd
          : qtyUnitCd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemNm: freezed == itemNm
          ? _value.itemNm
          : itemNm // ignore: cast_nullable_to_non_nullable
              as String?,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double,
      prc: null == prc
          ? _value.prc
          : prc // ignore: cast_nullable_to_non_nullable
              as double,
      splyAmt: null == splyAmt
          ? _value.splyAmt
          : splyAmt // ignore: cast_nullable_to_non_nullable
              as double,
      tin: freezed == tin
          ? _value.tin
          : tin // ignore: cast_nullable_to_non_nullable
              as int?,
      bhfId: freezed == bhfId
          ? _value.bhfId
          : bhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      dftPrc: freezed == dftPrc
          ? _value.dftPrc
          : dftPrc // ignore: cast_nullable_to_non_nullable
              as double?,
      addInfo: freezed == addInfo
          ? _value.addInfo
          : addInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      isrcAplcbYn: freezed == isrcAplcbYn
          ? _value.isrcAplcbYn
          : isrcAplcbYn // ignore: cast_nullable_to_non_nullable
              as String?,
      useYn: freezed == useYn
          ? _value.useYn
          : useYn // ignore: cast_nullable_to_non_nullable
              as String?,
      regrId: freezed == regrId
          ? _value.regrId
          : regrId // ignore: cast_nullable_to_non_nullable
              as String?,
      regrNm: freezed == regrNm
          ? _value.regrNm
          : regrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      modrId: freezed == modrId
          ? _value.modrId
          : modrId // ignore: cast_nullable_to_non_nullable
              as String?,
      modrNm: freezed == modrNm
          ? _value.modrNm
          : modrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      rsdQty: null == rsdQty
          ? _value.rsdQty
          : rsdQty // ignore: cast_nullable_to_non_nullable
              as double,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplyPrice: null == supplyPrice
          ? _value.supplyPrice
          : supplyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      retailPrice: null == retailPrice
          ? _value.retailPrice
          : retailPrice // ignore: cast_nullable_to_non_nullable
              as double,
      spplrItemClsCd: freezed == spplrItemClsCd
          ? _value.spplrItemClsCd
          : spplrItemClsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      spplrItemCd: freezed == spplrItemCd
          ? _value.spplrItemCd
          : spplrItemCd // ignore: cast_nullable_to_non_nullable
              as String?,
      spplrItemNm: freezed == spplrItemNm
          ? _value.spplrItemNm
          : spplrItemNm // ignore: cast_nullable_to_non_nullable
              as String?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isTaxExempted: null == isTaxExempted
          ? _value.isTaxExempted
          : isTaxExempted // ignore: cast_nullable_to_non_nullable
              as bool,
      taxType: null == taxType
          ? _value.taxType
          : taxType // ignore: cast_nullable_to_non_nullable
              as String,
      branchIds: null == branchIds
          ? _value.branchIds
          : branchIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as Stock?,
    ) as $Val);
  }

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StockCopyWith<$Res>? get stock {
    if (_value.stock == null) {
      return null;
    }

    return $StockCopyWith<$Res>(_value.stock!, (value) {
      return _then(_value.copyWith(stock: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VariantImplCopyWith<$Res> implements $VariantCopyWith<$Res> {
  factory _$$VariantImplCopyWith(
          _$VariantImpl value, $Res Function(_$VariantImpl) then) =
      __$$VariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      DateTime? deletedAt,
      String? name,
      String? color,
      String? sku,
      int? productId,
      String? unit,
      String? productName,
      int? branchId,
      String? taxName,
      double taxPercentage,
      int? itemSeq,
      String? isrccCd,
      String? isrccNm,
      int? isrcRt,
      int? isrcAmt,
      String? taxTyCd,
      String? bcd,
      String? itemClsCd,
      String? itemTyCd,
      String? itemStdNm,
      String? orgnNatCd,
      String? pkg,
      String? itemCd,
      String? pkgUnitCd,
      String? qtyUnitCd,
      String? itemNm,
      double qty,
      double prc,
      double splyAmt,
      int? tin,
      String? bhfId,
      double? dftPrc,
      String? addInfo,
      String? isrcAplcbYn,
      String? useYn,
      String? regrId,
      String? regrNm,
      String? modrId,
      String? modrNm,
      double rsdQty,
      DateTime? lastTouched,
      double supplyPrice,
      double retailPrice,
      String? spplrItemClsCd,
      String? spplrItemCd,
      String? spplrItemNm,
      bool ebmSynced,
      @deprecated bool isTaxExempted,
      @deprecated String taxType,
      List<int> branchIds,
      Stock? stock});

  @override
  $StockCopyWith<$Res>? get stock;
}

/// @nodoc
class __$$VariantImplCopyWithImpl<$Res>
    extends _$VariantCopyWithImpl<$Res, _$VariantImpl>
    implements _$$VariantImplCopyWith<$Res> {
  __$$VariantImplCopyWithImpl(
      _$VariantImpl _value, $Res Function(_$VariantImpl) _then)
      : super(_value, _then);

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? deletedAt = freezed,
    Object? name = freezed,
    Object? color = freezed,
    Object? sku = freezed,
    Object? productId = freezed,
    Object? unit = freezed,
    Object? productName = freezed,
    Object? branchId = freezed,
    Object? taxName = freezed,
    Object? taxPercentage = null,
    Object? itemSeq = freezed,
    Object? isrccCd = freezed,
    Object? isrccNm = freezed,
    Object? isrcRt = freezed,
    Object? isrcAmt = freezed,
    Object? taxTyCd = freezed,
    Object? bcd = freezed,
    Object? itemClsCd = freezed,
    Object? itemTyCd = freezed,
    Object? itemStdNm = freezed,
    Object? orgnNatCd = freezed,
    Object? pkg = freezed,
    Object? itemCd = freezed,
    Object? pkgUnitCd = freezed,
    Object? qtyUnitCd = freezed,
    Object? itemNm = freezed,
    Object? qty = null,
    Object? prc = null,
    Object? splyAmt = null,
    Object? tin = freezed,
    Object? bhfId = freezed,
    Object? dftPrc = freezed,
    Object? addInfo = freezed,
    Object? isrcAplcbYn = freezed,
    Object? useYn = freezed,
    Object? regrId = freezed,
    Object? regrNm = freezed,
    Object? modrId = freezed,
    Object? modrNm = freezed,
    Object? rsdQty = null,
    Object? lastTouched = freezed,
    Object? supplyPrice = null,
    Object? retailPrice = null,
    Object? spplrItemClsCd = freezed,
    Object? spplrItemCd = freezed,
    Object? spplrItemNm = freezed,
    Object? ebmSynced = null,
    Object? isTaxExempted = null,
    Object? taxType = null,
    Object? branchIds = null,
    Object? stock = freezed,
  }) {
    return _then(_$VariantImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      color: freezed == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String?,
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      productId: freezed == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as int?,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      taxName: freezed == taxName
          ? _value.taxName
          : taxName // ignore: cast_nullable_to_non_nullable
              as String?,
      taxPercentage: null == taxPercentage
          ? _value.taxPercentage
          : taxPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      itemSeq: freezed == itemSeq
          ? _value.itemSeq
          : itemSeq // ignore: cast_nullable_to_non_nullable
              as int?,
      isrccCd: freezed == isrccCd
          ? _value.isrccCd
          : isrccCd // ignore: cast_nullable_to_non_nullable
              as String?,
      isrccNm: freezed == isrccNm
          ? _value.isrccNm
          : isrccNm // ignore: cast_nullable_to_non_nullable
              as String?,
      isrcRt: freezed == isrcRt
          ? _value.isrcRt
          : isrcRt // ignore: cast_nullable_to_non_nullable
              as int?,
      isrcAmt: freezed == isrcAmt
          ? _value.isrcAmt
          : isrcAmt // ignore: cast_nullable_to_non_nullable
              as int?,
      taxTyCd: freezed == taxTyCd
          ? _value.taxTyCd
          : taxTyCd // ignore: cast_nullable_to_non_nullable
              as String?,
      bcd: freezed == bcd
          ? _value.bcd
          : bcd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemClsCd: freezed == itemClsCd
          ? _value.itemClsCd
          : itemClsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemTyCd: freezed == itemTyCd
          ? _value.itemTyCd
          : itemTyCd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemStdNm: freezed == itemStdNm
          ? _value.itemStdNm
          : itemStdNm // ignore: cast_nullable_to_non_nullable
              as String?,
      orgnNatCd: freezed == orgnNatCd
          ? _value.orgnNatCd
          : orgnNatCd // ignore: cast_nullable_to_non_nullable
              as String?,
      pkg: freezed == pkg
          ? _value.pkg
          : pkg // ignore: cast_nullable_to_non_nullable
              as String?,
      itemCd: freezed == itemCd
          ? _value.itemCd
          : itemCd // ignore: cast_nullable_to_non_nullable
              as String?,
      pkgUnitCd: freezed == pkgUnitCd
          ? _value.pkgUnitCd
          : pkgUnitCd // ignore: cast_nullable_to_non_nullable
              as String?,
      qtyUnitCd: freezed == qtyUnitCd
          ? _value.qtyUnitCd
          : qtyUnitCd // ignore: cast_nullable_to_non_nullable
              as String?,
      itemNm: freezed == itemNm
          ? _value.itemNm
          : itemNm // ignore: cast_nullable_to_non_nullable
              as String?,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double,
      prc: null == prc
          ? _value.prc
          : prc // ignore: cast_nullable_to_non_nullable
              as double,
      splyAmt: null == splyAmt
          ? _value.splyAmt
          : splyAmt // ignore: cast_nullable_to_non_nullable
              as double,
      tin: freezed == tin
          ? _value.tin
          : tin // ignore: cast_nullable_to_non_nullable
              as int?,
      bhfId: freezed == bhfId
          ? _value.bhfId
          : bhfId // ignore: cast_nullable_to_non_nullable
              as String?,
      dftPrc: freezed == dftPrc
          ? _value.dftPrc
          : dftPrc // ignore: cast_nullable_to_non_nullable
              as double?,
      addInfo: freezed == addInfo
          ? _value.addInfo
          : addInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      isrcAplcbYn: freezed == isrcAplcbYn
          ? _value.isrcAplcbYn
          : isrcAplcbYn // ignore: cast_nullable_to_non_nullable
              as String?,
      useYn: freezed == useYn
          ? _value.useYn
          : useYn // ignore: cast_nullable_to_non_nullable
              as String?,
      regrId: freezed == regrId
          ? _value.regrId
          : regrId // ignore: cast_nullable_to_non_nullable
              as String?,
      regrNm: freezed == regrNm
          ? _value.regrNm
          : regrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      modrId: freezed == modrId
          ? _value.modrId
          : modrId // ignore: cast_nullable_to_non_nullable
              as String?,
      modrNm: freezed == modrNm
          ? _value.modrNm
          : modrNm // ignore: cast_nullable_to_non_nullable
              as String?,
      rsdQty: null == rsdQty
          ? _value.rsdQty
          : rsdQty // ignore: cast_nullable_to_non_nullable
              as double,
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      supplyPrice: null == supplyPrice
          ? _value.supplyPrice
          : supplyPrice // ignore: cast_nullable_to_non_nullable
              as double,
      retailPrice: null == retailPrice
          ? _value.retailPrice
          : retailPrice // ignore: cast_nullable_to_non_nullable
              as double,
      spplrItemClsCd: freezed == spplrItemClsCd
          ? _value.spplrItemClsCd
          : spplrItemClsCd // ignore: cast_nullable_to_non_nullable
              as String?,
      spplrItemCd: freezed == spplrItemCd
          ? _value.spplrItemCd
          : spplrItemCd // ignore: cast_nullable_to_non_nullable
              as String?,
      spplrItemNm: freezed == spplrItemNm
          ? _value.spplrItemNm
          : spplrItemNm // ignore: cast_nullable_to_non_nullable
              as String?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      isTaxExempted: null == isTaxExempted
          ? _value.isTaxExempted
          : isTaxExempted // ignore: cast_nullable_to_non_nullable
              as bool,
      taxType: null == taxType
          ? _value.taxType
          : taxType // ignore: cast_nullable_to_non_nullable
              as String,
      branchIds: null == branchIds
          ? _value._branchIds
          : branchIds // ignore: cast_nullable_to_non_nullable
              as List<int>,
      stock: freezed == stock
          ? _value.stock
          : stock // ignore: cast_nullable_to_non_nullable
              as Stock?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VariantImpl implements _Variant {
  const _$VariantImpl(
      {this.id,
      this.deletedAt,
      this.name,
      this.color,
      this.sku,
      this.productId,
      this.unit,
      this.productName,
      this.branchId,
      this.taxName = "",
      this.taxPercentage = 0.0,
      this.itemSeq,
      this.isrccCd = "",
      this.isrccNm = "",
      this.isrcRt = 0,
      this.isrcAmt = 0,
      this.taxTyCd = "B",
      this.bcd = "",
      this.itemClsCd,
      this.itemTyCd,
      this.itemStdNm = "",
      this.orgnNatCd = "",
      this.pkg = "1",
      this.itemCd = "",
      this.pkgUnitCd = "CT",
      this.qtyUnitCd = "BX",
      this.itemNm,
      this.qty = 0.0,
      this.prc = 0.0,
      this.splyAmt = 0.0,
      this.tin,
      this.bhfId,
      this.dftPrc = 0.0,
      this.addInfo = "",
      this.isrcAplcbYn = "",
      this.useYn = "",
      this.regrId,
      this.regrNm,
      this.modrId,
      this.modrNm,
      this.rsdQty = 0.0,
      this.lastTouched,
      this.supplyPrice = 0.0,
      this.retailPrice = 0.0,
      this.spplrItemClsCd,
      this.spplrItemCd,
      this.spplrItemNm,
      this.ebmSynced = false,
      @deprecated this.isTaxExempted = false,
      @deprecated this.taxType = "B",
      final List<int> branchIds = const [],
      this.stock})
      : _branchIds = branchIds;

  factory _$VariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$VariantImplFromJson(json);

  @override
  final int? id;
  @override
  final DateTime? deletedAt;
  @override
  final String? name;
  @override
  final String? color;
  @override
  final String? sku;
  @override
  final int? productId;
  @override
  final String? unit;
  @override
  final String? productName;
  @override
  final int? branchId;
  @override
  @JsonKey()
  final String? taxName;
  @override
  @JsonKey()
  final double taxPercentage;
// RRA fields with comments preserved
  @override
  final int? itemSeq;
  @override
  @JsonKey()
  final String? isrccCd;
// insurance code
  @override
  @JsonKey()
  final String? isrccNm;
// insurance name
  @override
  @JsonKey()
  final int? isrcRt;
// premium rate
  @override
  @JsonKey()
  final int? isrcAmt;
// insurance amount
  @override
  @JsonKey()
  final String? taxTyCd;
// taxation type code
  @override
  @JsonKey()
  final String? bcd;
// bar code
  @override
  final String? itemClsCd;
// Item code
  @override
  final String? itemTyCd;
// Item type code
  @override
  @JsonKey()
  final String? itemStdNm;
// Item standard name
  @override
  @JsonKey()
  final String? orgnNatCd;
// Item origin
  @override
  @JsonKey()
  final String? pkg;
// packaging unit code
  @override
  @JsonKey()
  final String? itemCd;
// item code
  @override
  @JsonKey()
  final String? pkgUnitCd;
  @override
  @JsonKey()
  final String? qtyUnitCd;
  @override
  final String? itemNm;
// same as name but for rra happiness
  @override
  @JsonKey()
  final double qty;
  @override
  @JsonKey()
  final double prc;
// unit price
  @override
  @JsonKey()
  final double splyAmt;
// supply amount
  @override
  final int? tin;
  @override
  final String? bhfId;
  @override
  @JsonKey()
  final double? dftPrc;
  @override
  @JsonKey()
  final String? addInfo;
  @override
  @JsonKey()
  final String? isrcAplcbYn;
  @override
  @JsonKey()
  final String? useYn;
  @override
  final String? regrId;
  @override
  final String? regrNm;
  @override
  final String? modrId;
  @override
  final String? modrNm;
// Stock-related properties
  @override
  @JsonKey()
  final double rsdQty;

  /// property for stock but presented here for easy
  @override
  final DateTime? lastTouched;
  @override
  @JsonKey()
  final double supplyPrice;
  @override
  @JsonKey()
  final double retailPrice;
// Supplier-related fields
  @override
  final String? spplrItemClsCd;

  /// fields for supplier-owned items
  @override
  final String? spplrItemCd;
  @override
  final String? spplrItemNm;
// EBM sync status
  @override
  @JsonKey()
  final bool ebmSynced;
// Deprecated fields marked with @deprecated annotation
  @override
  @JsonKey()
  @deprecated
  final bool isTaxExempted;

  /// use taxTyCd='A' instead
  @override
  @JsonKey()
  @deprecated
  final String taxType;

  /// use taxTyCd instead
// Branch and stock relationships
  final List<int> _branchIds;

  /// use taxTyCd instead
// Branch and stock relationships
  @override
  @JsonKey()
  List<int> get branchIds {
    if (_branchIds is EqualUnmodifiableListView) return _branchIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_branchIds);
  }

  @override
  final Stock? stock;

  @override
  String toString() {
    return 'Variant(id: $id, deletedAt: $deletedAt, name: $name, color: $color, sku: $sku, productId: $productId, unit: $unit, productName: $productName, branchId: $branchId, taxName: $taxName, taxPercentage: $taxPercentage, itemSeq: $itemSeq, isrccCd: $isrccCd, isrccNm: $isrccNm, isrcRt: $isrcRt, isrcAmt: $isrcAmt, taxTyCd: $taxTyCd, bcd: $bcd, itemClsCd: $itemClsCd, itemTyCd: $itemTyCd, itemStdNm: $itemStdNm, orgnNatCd: $orgnNatCd, pkg: $pkg, itemCd: $itemCd, pkgUnitCd: $pkgUnitCd, qtyUnitCd: $qtyUnitCd, itemNm: $itemNm, qty: $qty, prc: $prc, splyAmt: $splyAmt, tin: $tin, bhfId: $bhfId, dftPrc: $dftPrc, addInfo: $addInfo, isrcAplcbYn: $isrcAplcbYn, useYn: $useYn, regrId: $regrId, regrNm: $regrNm, modrId: $modrId, modrNm: $modrNm, rsdQty: $rsdQty, lastTouched: $lastTouched, supplyPrice: $supplyPrice, retailPrice: $retailPrice, spplrItemClsCd: $spplrItemClsCd, spplrItemCd: $spplrItemCd, spplrItemNm: $spplrItemNm, ebmSynced: $ebmSynced, isTaxExempted: $isTaxExempted, taxType: $taxType, branchIds: $branchIds, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.taxName, taxName) || other.taxName == taxName) &&
            (identical(other.taxPercentage, taxPercentage) ||
                other.taxPercentage == taxPercentage) &&
            (identical(other.itemSeq, itemSeq) || other.itemSeq == itemSeq) &&
            (identical(other.isrccCd, isrccCd) || other.isrccCd == isrccCd) &&
            (identical(other.isrccNm, isrccNm) || other.isrccNm == isrccNm) &&
            (identical(other.isrcRt, isrcRt) || other.isrcRt == isrcRt) &&
            (identical(other.isrcAmt, isrcAmt) || other.isrcAmt == isrcAmt) &&
            (identical(other.taxTyCd, taxTyCd) || other.taxTyCd == taxTyCd) &&
            (identical(other.bcd, bcd) || other.bcd == bcd) &&
            (identical(other.itemClsCd, itemClsCd) ||
                other.itemClsCd == itemClsCd) &&
            (identical(other.itemTyCd, itemTyCd) ||
                other.itemTyCd == itemTyCd) &&
            (identical(other.itemStdNm, itemStdNm) ||
                other.itemStdNm == itemStdNm) &&
            (identical(other.orgnNatCd, orgnNatCd) ||
                other.orgnNatCd == orgnNatCd) &&
            (identical(other.pkg, pkg) || other.pkg == pkg) &&
            (identical(other.itemCd, itemCd) || other.itemCd == itemCd) &&
            (identical(other.pkgUnitCd, pkgUnitCd) ||
                other.pkgUnitCd == pkgUnitCd) &&
            (identical(other.qtyUnitCd, qtyUnitCd) ||
                other.qtyUnitCd == qtyUnitCd) &&
            (identical(other.itemNm, itemNm) || other.itemNm == itemNm) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.prc, prc) || other.prc == prc) &&
            (identical(other.splyAmt, splyAmt) || other.splyAmt == splyAmt) &&
            (identical(other.tin, tin) || other.tin == tin) &&
            (identical(other.bhfId, bhfId) || other.bhfId == bhfId) &&
            (identical(other.dftPrc, dftPrc) || other.dftPrc == dftPrc) &&
            (identical(other.addInfo, addInfo) || other.addInfo == addInfo) &&
            (identical(other.isrcAplcbYn, isrcAplcbYn) ||
                other.isrcAplcbYn == isrcAplcbYn) &&
            (identical(other.useYn, useYn) || other.useYn == useYn) &&
            (identical(other.regrId, regrId) || other.regrId == regrId) &&
            (identical(other.regrNm, regrNm) || other.regrNm == regrNm) &&
            (identical(other.modrId, modrId) || other.modrId == modrId) &&
            (identical(other.modrNm, modrNm) || other.modrNm == modrNm) &&
            (identical(other.rsdQty, rsdQty) || other.rsdQty == rsdQty) &&
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.supplyPrice, supplyPrice) ||
                other.supplyPrice == supplyPrice) &&
            (identical(other.retailPrice, retailPrice) ||
                other.retailPrice == retailPrice) &&
            (identical(other.spplrItemClsCd, spplrItemClsCd) ||
                other.spplrItemClsCd == spplrItemClsCd) &&
            (identical(other.spplrItemCd, spplrItemCd) ||
                other.spplrItemCd == spplrItemCd) &&
            (identical(other.spplrItemNm, spplrItemNm) ||
                other.spplrItemNm == spplrItemNm) &&
            (identical(other.ebmSynced, ebmSynced) ||
                other.ebmSynced == ebmSynced) &&
            (identical(other.isTaxExempted, isTaxExempted) ||
                other.isTaxExempted == isTaxExempted) &&
            (identical(other.taxType, taxType) || other.taxType == taxType) &&
            const DeepCollectionEquality()
                .equals(other._branchIds, _branchIds) &&
            (identical(other.stock, stock) || other.stock == stock));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        deletedAt,
        name,
        color,
        sku,
        productId,
        unit,
        productName,
        branchId,
        taxName,
        taxPercentage,
        itemSeq,
        isrccCd,
        isrccNm,
        isrcRt,
        isrcAmt,
        taxTyCd,
        bcd,
        itemClsCd,
        itemTyCd,
        itemStdNm,
        orgnNatCd,
        pkg,
        itemCd,
        pkgUnitCd,
        qtyUnitCd,
        itemNm,
        qty,
        prc,
        splyAmt,
        tin,
        bhfId,
        dftPrc,
        addInfo,
        isrcAplcbYn,
        useYn,
        regrId,
        regrNm,
        modrId,
        modrNm,
        rsdQty,
        lastTouched,
        supplyPrice,
        retailPrice,
        spplrItemClsCd,
        spplrItemCd,
        spplrItemNm,
        ebmSynced,
        isTaxExempted,
        taxType,
        const DeepCollectionEquality().hash(_branchIds),
        stock
      ]);

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VariantImplCopyWith<_$VariantImpl> get copyWith =>
      __$$VariantImplCopyWithImpl<_$VariantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VariantImplToJson(
      this,
    );
  }
}

abstract class _Variant implements Variant {
  const factory _Variant(
      {final int? id,
      final DateTime? deletedAt,
      final String? name,
      final String? color,
      final String? sku,
      final int? productId,
      final String? unit,
      final String? productName,
      final int? branchId,
      final String? taxName,
      final double taxPercentage,
      final int? itemSeq,
      final String? isrccCd,
      final String? isrccNm,
      final int? isrcRt,
      final int? isrcAmt,
      final String? taxTyCd,
      final String? bcd,
      final String? itemClsCd,
      final String? itemTyCd,
      final String? itemStdNm,
      final String? orgnNatCd,
      final String? pkg,
      final String? itemCd,
      final String? pkgUnitCd,
      final String? qtyUnitCd,
      final String? itemNm,
      final double qty,
      final double prc,
      final double splyAmt,
      final int? tin,
      final String? bhfId,
      final double? dftPrc,
      final String? addInfo,
      final String? isrcAplcbYn,
      final String? useYn,
      final String? regrId,
      final String? regrNm,
      final String? modrId,
      final String? modrNm,
      final double rsdQty,
      final DateTime? lastTouched,
      final double supplyPrice,
      final double retailPrice,
      final String? spplrItemClsCd,
      final String? spplrItemCd,
      final String? spplrItemNm,
      final bool ebmSynced,
      @deprecated final bool isTaxExempted,
      @deprecated final String taxType,
      final List<int> branchIds,
      final Stock? stock}) = _$VariantImpl;

  factory _Variant.fromJson(Map<String, dynamic> json) = _$VariantImpl.fromJson;

  @override
  int? get id;
  @override
  DateTime? get deletedAt;
  @override
  String? get name;
  @override
  String? get color;
  @override
  String? get sku;
  @override
  int? get productId;
  @override
  String? get unit;
  @override
  String? get productName;
  @override
  int? get branchId;
  @override
  String? get taxName;
  @override
  double get taxPercentage; // RRA fields with comments preserved
  @override
  int? get itemSeq;
  @override
  String? get isrccCd; // insurance code
  @override
  String? get isrccNm; // insurance name
  @override
  int? get isrcRt; // premium rate
  @override
  int? get isrcAmt; // insurance amount
  @override
  String? get taxTyCd; // taxation type code
  @override
  String? get bcd; // bar code
  @override
  String? get itemClsCd; // Item code
  @override
  String? get itemTyCd; // Item type code
  @override
  String? get itemStdNm; // Item standard name
  @override
  String? get orgnNatCd; // Item origin
  @override
  String? get pkg; // packaging unit code
  @override
  String? get itemCd; // item code
  @override
  String? get pkgUnitCd;
  @override
  String? get qtyUnitCd;
  @override
  String? get itemNm; // same as name but for rra happiness
  @override
  double get qty;
  @override
  double get prc; // unit price
  @override
  double get splyAmt; // supply amount
  @override
  int? get tin;
  @override
  String? get bhfId;
  @override
  double? get dftPrc;
  @override
  String? get addInfo;
  @override
  String? get isrcAplcbYn;
  @override
  String? get useYn;
  @override
  String? get regrId;
  @override
  String? get regrNm;
  @override
  String? get modrId;
  @override
  String? get modrNm; // Stock-related properties
  @override
  double get rsdQty;

  /// property for stock but presented here for easy
  @override
  DateTime? get lastTouched;
  @override
  double get supplyPrice;
  @override
  double get retailPrice; // Supplier-related fields
  @override
  String? get spplrItemClsCd;

  /// fields for supplier-owned items
  @override
  String? get spplrItemCd;
  @override
  String? get spplrItemNm; // EBM sync status
  @override
  bool get ebmSynced; // Deprecated fields marked with @deprecated annotation
  @override
  @deprecated
  bool get isTaxExempted;

  /// use taxTyCd='A' instead
  @override
  @deprecated
  String get taxType;

  /// use taxTyCd instead
// Branch and stock relationships
  @override
  List<int> get branchIds;
  @override
  Stock? get stock;

  /// Create a copy of Variant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VariantImplCopyWith<_$VariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
