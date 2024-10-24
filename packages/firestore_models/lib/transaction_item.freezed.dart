// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) {
  return _TransactionItem.fromJson(json);
}

/// @nodoc
mixin _$TransactionItem {
  int? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  int? get quantityRequested => throw _privateConstructorUsedError;
  int? get quantityApproved => throw _privateConstructorUsedError;
  int? get quantityShipped => throw _privateConstructorUsedError;
  int? get transactionId => throw _privateConstructorUsedError;
  int? get variantId => throw _privateConstructorUsedError;
  double get qty => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  double get discount => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  double get remainingStock => throw _privateConstructorUsedError;
  String? get createdAt => throw _privateConstructorUsedError;
  String? get updatedAt => throw _privateConstructorUsedError;
  bool get isTaxExempted => throw _privateConstructorUsedError;
  bool get isRefunded => throw _privateConstructorUsedError;
  bool? get doneWithTransaction => throw _privateConstructorUsedError;
  bool? get active => throw _privateConstructorUsedError; // RRA fields
  double get dcRt => throw _privateConstructorUsedError;
  double get dcAmt => throw _privateConstructorUsedError;
  double get taxblAmt => throw _privateConstructorUsedError;
  double get taxAmt => throw _privateConstructorUsedError;
  double get totAmt => throw _privateConstructorUsedError; // Variant properties
  int? get itemSeq => throw _privateConstructorUsedError;
  String? get isrccCd => throw _privateConstructorUsedError;
  String? get isrccNm => throw _privateConstructorUsedError;
  int? get isrcRt => throw _privateConstructorUsedError;
  int? get isrcAmt => throw _privateConstructorUsedError;
  String? get taxTyCd => throw _privateConstructorUsedError;
  String? get bcd => throw _privateConstructorUsedError;
  String? get itemClsCd => throw _privateConstructorUsedError;
  String? get itemTyCd => throw _privateConstructorUsedError;
  String? get itemStdNm => throw _privateConstructorUsedError;
  String? get orgnNatCd => throw _privateConstructorUsedError;
  String? get pkg => throw _privateConstructorUsedError;
  String? get itemCd => throw _privateConstructorUsedError;
  String? get pkgUnitCd => throw _privateConstructorUsedError;
  String? get qtyUnitCd => throw _privateConstructorUsedError;
  String? get itemNm => throw _privateConstructorUsedError;
  double get prc => throw _privateConstructorUsedError;
  double get splyAmt => throw _privateConstructorUsedError;
  int? get tin => throw _privateConstructorUsedError;
  String? get bhfId => throw _privateConstructorUsedError;
  double? get dftPrc => throw _privateConstructorUsedError;
  String? get addInfo => throw _privateConstructorUsedError;
  String? get isrcAplcbYn => throw _privateConstructorUsedError;
  String? get useYn => throw _privateConstructorUsedError;
  String? get regrId => throw _privateConstructorUsedError;
  String? get regrNm => throw _privateConstructorUsedError;
  String? get modrId => throw _privateConstructorUsedError;
  String? get modrNm => throw _privateConstructorUsedError;
  DateTime? get lastTouched => throw _privateConstructorUsedError;
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  int? get branchId => throw _privateConstructorUsedError;
  bool get ebmSynced => throw _privateConstructorUsedError;
  bool get partOfComposite => throw _privateConstructorUsedError;
  double get compositePrice => throw _privateConstructorUsedError;

  /// Serializes this TransactionItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TransactionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransactionItemCopyWith<TransactionItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransactionItemCopyWith<$Res> {
  factory $TransactionItemCopyWith(
          TransactionItem value, $Res Function(TransactionItem) then) =
      _$TransactionItemCopyWithImpl<$Res, TransactionItem>;
  @useResult
  $Res call(
      {int? id,
      String? name,
      int? quantityRequested,
      int? quantityApproved,
      int? quantityShipped,
      int? transactionId,
      int? variantId,
      double qty,
      double price,
      double discount,
      String? type,
      double remainingStock,
      String? createdAt,
      String? updatedAt,
      bool isTaxExempted,
      bool isRefunded,
      bool? doneWithTransaction,
      bool? active,
      double dcRt,
      double dcAmt,
      double taxblAmt,
      double taxAmt,
      double totAmt,
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
      DateTime? lastTouched,
      DateTime? deletedAt,
      int? branchId,
      bool ebmSynced,
      bool partOfComposite,
      double compositePrice});
}

/// @nodoc
class _$TransactionItemCopyWithImpl<$Res, $Val extends TransactionItem>
    implements $TransactionItemCopyWith<$Res> {
  _$TransactionItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransactionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? quantityRequested = freezed,
    Object? quantityApproved = freezed,
    Object? quantityShipped = freezed,
    Object? transactionId = freezed,
    Object? variantId = freezed,
    Object? qty = null,
    Object? price = null,
    Object? discount = null,
    Object? type = freezed,
    Object? remainingStock = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isTaxExempted = null,
    Object? isRefunded = null,
    Object? doneWithTransaction = freezed,
    Object? active = freezed,
    Object? dcRt = null,
    Object? dcAmt = null,
    Object? taxblAmt = null,
    Object? taxAmt = null,
    Object? totAmt = null,
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
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? branchId = freezed,
    Object? ebmSynced = null,
    Object? partOfComposite = null,
    Object? compositePrice = null,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityRequested: freezed == quantityRequested
          ? _value.quantityRequested
          : quantityRequested // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityApproved: freezed == quantityApproved
          ? _value.quantityApproved
          : quantityApproved // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityShipped: freezed == quantityShipped
          ? _value.quantityShipped
          : quantityShipped // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingStock: null == remainingStock
          ? _value.remainingStock
          : remainingStock // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isTaxExempted: null == isTaxExempted
          ? _value.isTaxExempted
          : isTaxExempted // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefunded: null == isRefunded
          ? _value.isRefunded
          : isRefunded // ignore: cast_nullable_to_non_nullable
              as bool,
      doneWithTransaction: freezed == doneWithTransaction
          ? _value.doneWithTransaction
          : doneWithTransaction // ignore: cast_nullable_to_non_nullable
              as bool?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      dcRt: null == dcRt
          ? _value.dcRt
          : dcRt // ignore: cast_nullable_to_non_nullable
              as double,
      dcAmt: null == dcAmt
          ? _value.dcAmt
          : dcAmt // ignore: cast_nullable_to_non_nullable
              as double,
      taxblAmt: null == taxblAmt
          ? _value.taxblAmt
          : taxblAmt // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmt: null == taxAmt
          ? _value.taxAmt
          : taxAmt // ignore: cast_nullable_to_non_nullable
              as double,
      totAmt: null == totAmt
          ? _value.totAmt
          : totAmt // ignore: cast_nullable_to_non_nullable
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
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      partOfComposite: null == partOfComposite
          ? _value.partOfComposite
          : partOfComposite // ignore: cast_nullable_to_non_nullable
              as bool,
      compositePrice: null == compositePrice
          ? _value.compositePrice
          : compositePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransactionItemImplCopyWith<$Res>
    implements $TransactionItemCopyWith<$Res> {
  factory _$$TransactionItemImplCopyWith(_$TransactionItemImpl value,
          $Res Function(_$TransactionItemImpl) then) =
      __$$TransactionItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      String? name,
      int? quantityRequested,
      int? quantityApproved,
      int? quantityShipped,
      int? transactionId,
      int? variantId,
      double qty,
      double price,
      double discount,
      String? type,
      double remainingStock,
      String? createdAt,
      String? updatedAt,
      bool isTaxExempted,
      bool isRefunded,
      bool? doneWithTransaction,
      bool? active,
      double dcRt,
      double dcAmt,
      double taxblAmt,
      double taxAmt,
      double totAmt,
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
      DateTime? lastTouched,
      DateTime? deletedAt,
      int? branchId,
      bool ebmSynced,
      bool partOfComposite,
      double compositePrice});
}

/// @nodoc
class __$$TransactionItemImplCopyWithImpl<$Res>
    extends _$TransactionItemCopyWithImpl<$Res, _$TransactionItemImpl>
    implements _$$TransactionItemImplCopyWith<$Res> {
  __$$TransactionItemImplCopyWithImpl(
      _$TransactionItemImpl _value, $Res Function(_$TransactionItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransactionItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? quantityRequested = freezed,
    Object? quantityApproved = freezed,
    Object? quantityShipped = freezed,
    Object? transactionId = freezed,
    Object? variantId = freezed,
    Object? qty = null,
    Object? price = null,
    Object? discount = null,
    Object? type = freezed,
    Object? remainingStock = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? isTaxExempted = null,
    Object? isRefunded = null,
    Object? doneWithTransaction = freezed,
    Object? active = freezed,
    Object? dcRt = null,
    Object? dcAmt = null,
    Object? taxblAmt = null,
    Object? taxAmt = null,
    Object? totAmt = null,
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
    Object? lastTouched = freezed,
    Object? deletedAt = freezed,
    Object? branchId = freezed,
    Object? ebmSynced = null,
    Object? partOfComposite = null,
    Object? compositePrice = null,
  }) {
    return _then(_$TransactionItemImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      quantityRequested: freezed == quantityRequested
          ? _value.quantityRequested
          : quantityRequested // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityApproved: freezed == quantityApproved
          ? _value.quantityApproved
          : quantityApproved // ignore: cast_nullable_to_non_nullable
              as int?,
      quantityShipped: freezed == quantityShipped
          ? _value.quantityShipped
          : quantityShipped // ignore: cast_nullable_to_non_nullable
              as int?,
      transactionId: freezed == transactionId
          ? _value.transactionId
          : transactionId // ignore: cast_nullable_to_non_nullable
              as int?,
      variantId: freezed == variantId
          ? _value.variantId
          : variantId // ignore: cast_nullable_to_non_nullable
              as int?,
      qty: null == qty
          ? _value.qty
          : qty // ignore: cast_nullable_to_non_nullable
              as double,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discount: null == discount
          ? _value.discount
          : discount // ignore: cast_nullable_to_non_nullable
              as double,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      remainingStock: null == remainingStock
          ? _value.remainingStock
          : remainingStock // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      isTaxExempted: null == isTaxExempted
          ? _value.isTaxExempted
          : isTaxExempted // ignore: cast_nullable_to_non_nullable
              as bool,
      isRefunded: null == isRefunded
          ? _value.isRefunded
          : isRefunded // ignore: cast_nullable_to_non_nullable
              as bool,
      doneWithTransaction: freezed == doneWithTransaction
          ? _value.doneWithTransaction
          : doneWithTransaction // ignore: cast_nullable_to_non_nullable
              as bool?,
      active: freezed == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool?,
      dcRt: null == dcRt
          ? _value.dcRt
          : dcRt // ignore: cast_nullable_to_non_nullable
              as double,
      dcAmt: null == dcAmt
          ? _value.dcAmt
          : dcAmt // ignore: cast_nullable_to_non_nullable
              as double,
      taxblAmt: null == taxblAmt
          ? _value.taxblAmt
          : taxblAmt // ignore: cast_nullable_to_non_nullable
              as double,
      taxAmt: null == taxAmt
          ? _value.taxAmt
          : taxAmt // ignore: cast_nullable_to_non_nullable
              as double,
      totAmt: null == totAmt
          ? _value.totAmt
          : totAmt // ignore: cast_nullable_to_non_nullable
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
      lastTouched: freezed == lastTouched
          ? _value.lastTouched
          : lastTouched // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      branchId: freezed == branchId
          ? _value.branchId
          : branchId // ignore: cast_nullable_to_non_nullable
              as int?,
      ebmSynced: null == ebmSynced
          ? _value.ebmSynced
          : ebmSynced // ignore: cast_nullable_to_non_nullable
              as bool,
      partOfComposite: null == partOfComposite
          ? _value.partOfComposite
          : partOfComposite // ignore: cast_nullable_to_non_nullable
              as bool,
      compositePrice: null == compositePrice
          ? _value.compositePrice
          : compositePrice // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransactionItemImpl implements _TransactionItem {
  const _$TransactionItemImpl(
      {this.id,
      this.name,
      this.quantityRequested,
      this.quantityApproved,
      this.quantityShipped,
      this.transactionId,
      this.variantId,
      this.qty = 0.0,
      this.price = 0.0,
      this.discount = 0.0,
      this.type,
      this.remainingStock = 0.0,
      this.createdAt,
      this.updatedAt,
      this.isTaxExempted = false,
      this.isRefunded = false,
      this.doneWithTransaction,
      this.active,
      this.dcRt = 0.0,
      this.dcAmt = 0.0,
      this.taxblAmt = 0.0,
      this.taxAmt = 0.0,
      this.totAmt = 0.0,
      this.itemSeq,
      this.isrccCd,
      this.isrccNm = "",
      this.isrcRt = 0,
      this.isrcAmt = 0,
      this.taxTyCd,
      this.bcd,
      this.itemClsCd,
      this.itemTyCd,
      this.itemStdNm,
      this.orgnNatCd,
      this.pkg,
      this.itemCd,
      this.pkgUnitCd = "CT",
      this.qtyUnitCd = "BX",
      this.itemNm,
      this.prc = 0.0,
      this.splyAmt = 0.0,
      this.tin,
      this.bhfId,
      this.dftPrc,
      this.addInfo,
      this.isrcAplcbYn,
      this.useYn,
      this.regrId,
      this.regrNm,
      this.modrId,
      this.modrNm,
      this.lastTouched,
      this.deletedAt,
      this.branchId,
      this.ebmSynced = false,
      this.partOfComposite = false,
      this.compositePrice = 0.0});

  factory _$TransactionItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransactionItemImplFromJson(json);

  @override
  final int? id;
  @override
  final String? name;
  @override
  final int? quantityRequested;
  @override
  final int? quantityApproved;
  @override
  final int? quantityShipped;
  @override
  final int? transactionId;
  @override
  final int? variantId;
  @override
  @JsonKey()
  final double qty;
  @override
  @JsonKey()
  final double price;
  @override
  @JsonKey()
  final double discount;
  @override
  final String? type;
  @override
  @JsonKey()
  final double remainingStock;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  @JsonKey()
  final bool isTaxExempted;
  @override
  @JsonKey()
  final bool isRefunded;
  @override
  final bool? doneWithTransaction;
  @override
  final bool? active;
// RRA fields
  @override
  @JsonKey()
  final double dcRt;
  @override
  @JsonKey()
  final double dcAmt;
  @override
  @JsonKey()
  final double taxblAmt;
  @override
  @JsonKey()
  final double taxAmt;
  @override
  @JsonKey()
  final double totAmt;
// Variant properties
  @override
  final int? itemSeq;
  @override
  final String? isrccCd;
  @override
  @JsonKey()
  final String? isrccNm;
  @override
  @JsonKey()
  final int? isrcRt;
  @override
  @JsonKey()
  final int? isrcAmt;
  @override
  final String? taxTyCd;
  @override
  final String? bcd;
  @override
  final String? itemClsCd;
  @override
  final String? itemTyCd;
  @override
  final String? itemStdNm;
  @override
  final String? orgnNatCd;
  @override
  final String? pkg;
  @override
  final String? itemCd;
  @override
  @JsonKey()
  final String? pkgUnitCd;
  @override
  @JsonKey()
  final String? qtyUnitCd;
  @override
  final String? itemNm;
  @override
  @JsonKey()
  final double prc;
  @override
  @JsonKey()
  final double splyAmt;
  @override
  final int? tin;
  @override
  final String? bhfId;
  @override
  final double? dftPrc;
  @override
  final String? addInfo;
  @override
  final String? isrcAplcbYn;
  @override
  final String? useYn;
  @override
  final String? regrId;
  @override
  final String? regrNm;
  @override
  final String? modrId;
  @override
  final String? modrNm;
  @override
  final DateTime? lastTouched;
  @override
  final DateTime? deletedAt;
  @override
  final int? branchId;
  @override
  @JsonKey()
  final bool ebmSynced;
  @override
  @JsonKey()
  final bool partOfComposite;
  @override
  @JsonKey()
  final double compositePrice;

  @override
  String toString() {
    return 'TransactionItem(id: $id, name: $name, quantityRequested: $quantityRequested, quantityApproved: $quantityApproved, quantityShipped: $quantityShipped, transactionId: $transactionId, variantId: $variantId, qty: $qty, price: $price, discount: $discount, type: $type, remainingStock: $remainingStock, createdAt: $createdAt, updatedAt: $updatedAt, isTaxExempted: $isTaxExempted, isRefunded: $isRefunded, doneWithTransaction: $doneWithTransaction, active: $active, dcRt: $dcRt, dcAmt: $dcAmt, taxblAmt: $taxblAmt, taxAmt: $taxAmt, totAmt: $totAmt, itemSeq: $itemSeq, isrccCd: $isrccCd, isrccNm: $isrccNm, isrcRt: $isrcRt, isrcAmt: $isrcAmt, taxTyCd: $taxTyCd, bcd: $bcd, itemClsCd: $itemClsCd, itemTyCd: $itemTyCd, itemStdNm: $itemStdNm, orgnNatCd: $orgnNatCd, pkg: $pkg, itemCd: $itemCd, pkgUnitCd: $pkgUnitCd, qtyUnitCd: $qtyUnitCd, itemNm: $itemNm, prc: $prc, splyAmt: $splyAmt, tin: $tin, bhfId: $bhfId, dftPrc: $dftPrc, addInfo: $addInfo, isrcAplcbYn: $isrcAplcbYn, useYn: $useYn, regrId: $regrId, regrNm: $regrNm, modrId: $modrId, modrNm: $modrNm, lastTouched: $lastTouched, deletedAt: $deletedAt, branchId: $branchId, ebmSynced: $ebmSynced, partOfComposite: $partOfComposite, compositePrice: $compositePrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransactionItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantityRequested, quantityRequested) ||
                other.quantityRequested == quantityRequested) &&
            (identical(other.quantityApproved, quantityApproved) ||
                other.quantityApproved == quantityApproved) &&
            (identical(other.quantityShipped, quantityShipped) ||
                other.quantityShipped == quantityShipped) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.variantId, variantId) ||
                other.variantId == variantId) &&
            (identical(other.qty, qty) || other.qty == qty) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.remainingStock, remainingStock) ||
                other.remainingStock == remainingStock) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isTaxExempted, isTaxExempted) ||
                other.isTaxExempted == isTaxExempted) &&
            (identical(other.isRefunded, isRefunded) ||
                other.isRefunded == isRefunded) &&
            (identical(other.doneWithTransaction, doneWithTransaction) ||
                other.doneWithTransaction == doneWithTransaction) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.dcRt, dcRt) || other.dcRt == dcRt) &&
            (identical(other.dcAmt, dcAmt) || other.dcAmt == dcAmt) &&
            (identical(other.taxblAmt, taxblAmt) ||
                other.taxblAmt == taxblAmt) &&
            (identical(other.taxAmt, taxAmt) || other.taxAmt == taxAmt) &&
            (identical(other.totAmt, totAmt) || other.totAmt == totAmt) &&
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
            (identical(other.lastTouched, lastTouched) ||
                other.lastTouched == lastTouched) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.branchId, branchId) ||
                other.branchId == branchId) &&
            (identical(other.ebmSynced, ebmSynced) ||
                other.ebmSynced == ebmSynced) &&
            (identical(other.partOfComposite, partOfComposite) ||
                other.partOfComposite == partOfComposite) &&
            (identical(other.compositePrice, compositePrice) ||
                other.compositePrice == compositePrice));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        quantityRequested,
        quantityApproved,
        quantityShipped,
        transactionId,
        variantId,
        qty,
        price,
        discount,
        type,
        remainingStock,
        createdAt,
        updatedAt,
        isTaxExempted,
        isRefunded,
        doneWithTransaction,
        active,
        dcRt,
        dcAmt,
        taxblAmt,
        taxAmt,
        totAmt,
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
        lastTouched,
        deletedAt,
        branchId,
        ebmSynced,
        partOfComposite,
        compositePrice
      ]);

  /// Create a copy of TransactionItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransactionItemImplCopyWith<_$TransactionItemImpl> get copyWith =>
      __$$TransactionItemImplCopyWithImpl<_$TransactionItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransactionItemImplToJson(
      this,
    );
  }
}

abstract class _TransactionItem implements TransactionItem {
  const factory _TransactionItem(
      {final int? id,
      final String? name,
      final int? quantityRequested,
      final int? quantityApproved,
      final int? quantityShipped,
      final int? transactionId,
      final int? variantId,
      final double qty,
      final double price,
      final double discount,
      final String? type,
      final double remainingStock,
      final String? createdAt,
      final String? updatedAt,
      final bool isTaxExempted,
      final bool isRefunded,
      final bool? doneWithTransaction,
      final bool? active,
      final double dcRt,
      final double dcAmt,
      final double taxblAmt,
      final double taxAmt,
      final double totAmt,
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
      final DateTime? lastTouched,
      final DateTime? deletedAt,
      final int? branchId,
      final bool ebmSynced,
      final bool partOfComposite,
      final double compositePrice}) = _$TransactionItemImpl;

  factory _TransactionItem.fromJson(Map<String, dynamic> json) =
      _$TransactionItemImpl.fromJson;

  @override
  int? get id;
  @override
  String? get name;
  @override
  int? get quantityRequested;
  @override
  int? get quantityApproved;
  @override
  int? get quantityShipped;
  @override
  int? get transactionId;
  @override
  int? get variantId;
  @override
  double get qty;
  @override
  double get price;
  @override
  double get discount;
  @override
  String? get type;
  @override
  double get remainingStock;
  @override
  String? get createdAt;
  @override
  String? get updatedAt;
  @override
  bool get isTaxExempted;
  @override
  bool get isRefunded;
  @override
  bool? get doneWithTransaction;
  @override
  bool? get active; // RRA fields
  @override
  double get dcRt;
  @override
  double get dcAmt;
  @override
  double get taxblAmt;
  @override
  double get taxAmt;
  @override
  double get totAmt; // Variant properties
  @override
  int? get itemSeq;
  @override
  String? get isrccCd;
  @override
  String? get isrccNm;
  @override
  int? get isrcRt;
  @override
  int? get isrcAmt;
  @override
  String? get taxTyCd;
  @override
  String? get bcd;
  @override
  String? get itemClsCd;
  @override
  String? get itemTyCd;
  @override
  String? get itemStdNm;
  @override
  String? get orgnNatCd;
  @override
  String? get pkg;
  @override
  String? get itemCd;
  @override
  String? get pkgUnitCd;
  @override
  String? get qtyUnitCd;
  @override
  String? get itemNm;
  @override
  double get prc;
  @override
  double get splyAmt;
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
  String? get modrNm;
  @override
  DateTime? get lastTouched;
  @override
  DateTime? get deletedAt;
  @override
  int? get branchId;
  @override
  bool get ebmSynced;
  @override
  bool get partOfComposite;
  @override
  double get compositePrice;

  /// Create a copy of TransactionItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransactionItemImplCopyWith<_$TransactionItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
