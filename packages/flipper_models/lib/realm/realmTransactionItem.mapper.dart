// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'realmTransactionItem.dart';

class $RealmITransactionItemMapper
    extends ClassMapperBase<$RealmITransactionItem> {
  $RealmITransactionItemMapper._();

  static $RealmITransactionItemMapper? _instance;
  static $RealmITransactionItemMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = $RealmITransactionItemMapper._());
    }
    return _instance!;
  }

  @override
  final String id = '\$RealmITransactionItem';

  static int _$id($RealmITransactionItem v) => v.id;
  static const Field<$RealmITransactionItem, int> _f$id =
      Field('id', _$id, mode: FieldMode.member);
  static ObjectId _$realmId($RealmITransactionItem v) => v.realmId;
  static const Field<$RealmITransactionItem, ObjectId> _f$realmId =
      Field('realmId', _$realmId, mode: FieldMode.member);
  static String _$name($RealmITransactionItem v) => v.name;
  static const Field<$RealmITransactionItem, String> _f$name =
      Field('name', _$name, mode: FieldMode.member);
  static int _$transactionId($RealmITransactionItem v) => v.transactionId;
  static const Field<$RealmITransactionItem, int> _f$transactionId =
      Field('transactionId', _$transactionId, mode: FieldMode.member);
  static int _$variantId($RealmITransactionItem v) => v.variantId;
  static const Field<$RealmITransactionItem, int> _f$variantId =
      Field('variantId', _$variantId, mode: FieldMode.member);
  static double _$qty($RealmITransactionItem v) => v.qty;
  static const Field<$RealmITransactionItem, double> _f$qty =
      Field('qty', _$qty, mode: FieldMode.member);
  static double _$price($RealmITransactionItem v) => v.price;
  static const Field<$RealmITransactionItem, double> _f$price =
      Field('price', _$price, mode: FieldMode.member);
  static String _$action($RealmITransactionItem v) => v.action;
  static const Field<$RealmITransactionItem, String> _f$action =
      Field('action', _$action, mode: FieldMode.member);
  static int _$branchId($RealmITransactionItem v) => v.branchId;
  static const Field<$RealmITransactionItem, int> _f$branchId =
      Field('branchId', _$branchId, mode: FieldMode.member);
  static double _$remainingStock($RealmITransactionItem v) => v.remainingStock;
  static const Field<$RealmITransactionItem, double> _f$remainingStock =
      Field('remainingStock', _$remainingStock, mode: FieldMode.member);
  static String _$createdAt($RealmITransactionItem v) => v.createdAt;
  static const Field<$RealmITransactionItem, String> _f$createdAt =
      Field('createdAt', _$createdAt, mode: FieldMode.member);
  static String _$updatedAt($RealmITransactionItem v) => v.updatedAt;
  static const Field<$RealmITransactionItem, String> _f$updatedAt =
      Field('updatedAt', _$updatedAt, mode: FieldMode.member);
  static bool _$isTaxExempted($RealmITransactionItem v) => v.isTaxExempted;
  static const Field<$RealmITransactionItem, bool> _f$isTaxExempted =
      Field('isTaxExempted', _$isTaxExempted, mode: FieldMode.member);
  static bool? _$isRefunded($RealmITransactionItem v) => v.isRefunded;
  static const Field<$RealmITransactionItem, bool> _f$isRefunded =
      Field('isRefunded', _$isRefunded, mode: FieldMode.member);
  static double? _$discount($RealmITransactionItem v) => v.discount;
  static const Field<$RealmITransactionItem, double> _f$discount =
      Field('discount', _$discount, mode: FieldMode.member);
  static String? _$type($RealmITransactionItem v) => v.type;
  static const Field<$RealmITransactionItem, String> _f$type =
      Field('type', _$type, mode: FieldMode.member);
  static bool? _$doneWithTransaction($RealmITransactionItem v) =>
      v.doneWithTransaction;
  static const Field<$RealmITransactionItem, bool> _f$doneWithTransaction =
      Field('doneWithTransaction', _$doneWithTransaction,
          mode: FieldMode.member);
  static bool? _$active($RealmITransactionItem v) => v.active;
  static const Field<$RealmITransactionItem, bool> _f$active =
      Field('active', _$active, mode: FieldMode.member);
  static double? _$dcRt($RealmITransactionItem v) => v.dcRt;
  static const Field<$RealmITransactionItem, double> _f$dcRt =
      Field('dcRt', _$dcRt, mode: FieldMode.member);
  static double? _$dcAmt($RealmITransactionItem v) => v.dcAmt;
  static const Field<$RealmITransactionItem, double> _f$dcAmt =
      Field('dcAmt', _$dcAmt, mode: FieldMode.member);
  static double? _$taxblAmt($RealmITransactionItem v) => v.taxblAmt;
  static const Field<$RealmITransactionItem, double> _f$taxblAmt =
      Field('taxblAmt', _$taxblAmt, mode: FieldMode.member);
  static double? _$taxAmt($RealmITransactionItem v) => v.taxAmt;
  static const Field<$RealmITransactionItem, double> _f$taxAmt =
      Field('taxAmt', _$taxAmt, mode: FieldMode.member);
  static double? _$totAmt($RealmITransactionItem v) => v.totAmt;
  static const Field<$RealmITransactionItem, double> _f$totAmt =
      Field('totAmt', _$totAmt, mode: FieldMode.member);
  static String? _$itemSeq($RealmITransactionItem v) => v.itemSeq;
  static const Field<$RealmITransactionItem, String> _f$itemSeq =
      Field('itemSeq', _$itemSeq, mode: FieldMode.member);
  static String? _$isrccCd($RealmITransactionItem v) => v.isrccCd;
  static const Field<$RealmITransactionItem, String> _f$isrccCd =
      Field('isrccCd', _$isrccCd, mode: FieldMode.member);
  static String? _$isrccNm($RealmITransactionItem v) => v.isrccNm;
  static const Field<$RealmITransactionItem, String> _f$isrccNm =
      Field('isrccNm', _$isrccNm, mode: FieldMode.member);
  static String? _$isrcRt($RealmITransactionItem v) => v.isrcRt;
  static const Field<$RealmITransactionItem, String> _f$isrcRt =
      Field('isrcRt', _$isrcRt, mode: FieldMode.member);
  static String? _$isrcAmt($RealmITransactionItem v) => v.isrcAmt;
  static const Field<$RealmITransactionItem, String> _f$isrcAmt =
      Field('isrcAmt', _$isrcAmt, mode: FieldMode.member);
  static String? _$taxTyCd($RealmITransactionItem v) => v.taxTyCd;
  static const Field<$RealmITransactionItem, String> _f$taxTyCd =
      Field('taxTyCd', _$taxTyCd, mode: FieldMode.member);
  static String? _$bcd($RealmITransactionItem v) => v.bcd;
  static const Field<$RealmITransactionItem, String> _f$bcd =
      Field('bcd', _$bcd, mode: FieldMode.member);
  static String? _$itemClsCd($RealmITransactionItem v) => v.itemClsCd;
  static const Field<$RealmITransactionItem, String> _f$itemClsCd =
      Field('itemClsCd', _$itemClsCd, mode: FieldMode.member);
  static String? _$itemTyCd($RealmITransactionItem v) => v.itemTyCd;
  static const Field<$RealmITransactionItem, String> _f$itemTyCd =
      Field('itemTyCd', _$itemTyCd, mode: FieldMode.member);
  static String? _$itemStdNm($RealmITransactionItem v) => v.itemStdNm;
  static const Field<$RealmITransactionItem, String> _f$itemStdNm =
      Field('itemStdNm', _$itemStdNm, mode: FieldMode.member);
  static String? _$orgnNatCd($RealmITransactionItem v) => v.orgnNatCd;
  static const Field<$RealmITransactionItem, String> _f$orgnNatCd =
      Field('orgnNatCd', _$orgnNatCd, mode: FieldMode.member);
  static String? _$pkg($RealmITransactionItem v) => v.pkg;
  static const Field<$RealmITransactionItem, String> _f$pkg =
      Field('pkg', _$pkg, mode: FieldMode.member);
  static String? _$itemCd($RealmITransactionItem v) => v.itemCd;
  static const Field<$RealmITransactionItem, String> _f$itemCd =
      Field('itemCd', _$itemCd, mode: FieldMode.member);
  static String? _$pkgUnitCd($RealmITransactionItem v) => v.pkgUnitCd;
  static const Field<$RealmITransactionItem, String> _f$pkgUnitCd =
      Field('pkgUnitCd', _$pkgUnitCd, mode: FieldMode.member);
  static String? _$qtyUnitCd($RealmITransactionItem v) => v.qtyUnitCd;
  static const Field<$RealmITransactionItem, String> _f$qtyUnitCd =
      Field('qtyUnitCd', _$qtyUnitCd, mode: FieldMode.member);
  static String? _$itemNm($RealmITransactionItem v) => v.itemNm;
  static const Field<$RealmITransactionItem, String> _f$itemNm =
      Field('itemNm', _$itemNm, mode: FieldMode.member);
  static double? _$prc($RealmITransactionItem v) => v.prc;
  static const Field<$RealmITransactionItem, double> _f$prc =
      Field('prc', _$prc, mode: FieldMode.member);
  static double? _$splyAmt($RealmITransactionItem v) => v.splyAmt;
  static const Field<$RealmITransactionItem, double> _f$splyAmt =
      Field('splyAmt', _$splyAmt, mode: FieldMode.member);
  static int? _$tin($RealmITransactionItem v) => v.tin;
  static const Field<$RealmITransactionItem, int> _f$tin =
      Field('tin', _$tin, mode: FieldMode.member);
  static String? _$bhfId($RealmITransactionItem v) => v.bhfId;
  static const Field<$RealmITransactionItem, String> _f$bhfId =
      Field('bhfId', _$bhfId, mode: FieldMode.member);
  static double? _$dftPrc($RealmITransactionItem v) => v.dftPrc;
  static const Field<$RealmITransactionItem, double> _f$dftPrc =
      Field('dftPrc', _$dftPrc, mode: FieldMode.member);
  static String? _$addInfo($RealmITransactionItem v) => v.addInfo;
  static const Field<$RealmITransactionItem, String> _f$addInfo =
      Field('addInfo', _$addInfo, mode: FieldMode.member);
  static String? _$isrcAplcbYn($RealmITransactionItem v) => v.isrcAplcbYn;
  static const Field<$RealmITransactionItem, String> _f$isrcAplcbYn =
      Field('isrcAplcbYn', _$isrcAplcbYn, mode: FieldMode.member);
  static String? _$useYn($RealmITransactionItem v) => v.useYn;
  static const Field<$RealmITransactionItem, String> _f$useYn =
      Field('useYn', _$useYn, mode: FieldMode.member);
  static String? _$regrId($RealmITransactionItem v) => v.regrId;
  static const Field<$RealmITransactionItem, String> _f$regrId =
      Field('regrId', _$regrId, mode: FieldMode.member);
  static String? _$regrNm($RealmITransactionItem v) => v.regrNm;
  static const Field<$RealmITransactionItem, String> _f$regrNm =
      Field('regrNm', _$regrNm, mode: FieldMode.member);
  static String? _$modrId($RealmITransactionItem v) => v.modrId;
  static const Field<$RealmITransactionItem, String> _f$modrId =
      Field('modrId', _$modrId, mode: FieldMode.member);
  static String? _$modrNm($RealmITransactionItem v) => v.modrNm;
  static const Field<$RealmITransactionItem, String> _f$modrNm =
      Field('modrNm', _$modrNm, mode: FieldMode.member);
  static DateTime? _$lastTouched($RealmITransactionItem v) => v.lastTouched;
  static const Field<$RealmITransactionItem, DateTime> _f$lastTouched =
      Field('lastTouched', _$lastTouched, mode: FieldMode.member);
  static DateTime? _$deletedAt($RealmITransactionItem v) => v.deletedAt;
  static const Field<$RealmITransactionItem, DateTime> _f$deletedAt =
      Field('deletedAt', _$deletedAt, mode: FieldMode.member);

  @override
  final MappableFields<$RealmITransactionItem> fields = const {
    #id: _f$id,
    #realmId: _f$realmId,
    #name: _f$name,
    #transactionId: _f$transactionId,
    #variantId: _f$variantId,
    #qty: _f$qty,
    #price: _f$price,
    #action: _f$action,
    #branchId: _f$branchId,
    #remainingStock: _f$remainingStock,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #isTaxExempted: _f$isTaxExempted,
    #isRefunded: _f$isRefunded,
    #discount: _f$discount,
    #type: _f$type,
    #doneWithTransaction: _f$doneWithTransaction,
    #active: _f$active,
    #dcRt: _f$dcRt,
    #dcAmt: _f$dcAmt,
    #taxblAmt: _f$taxblAmt,
    #taxAmt: _f$taxAmt,
    #totAmt: _f$totAmt,
    #itemSeq: _f$itemSeq,
    #isrccCd: _f$isrccCd,
    #isrccNm: _f$isrccNm,
    #isrcRt: _f$isrcRt,
    #isrcAmt: _f$isrcAmt,
    #taxTyCd: _f$taxTyCd,
    #bcd: _f$bcd,
    #itemClsCd: _f$itemClsCd,
    #itemTyCd: _f$itemTyCd,
    #itemStdNm: _f$itemStdNm,
    #orgnNatCd: _f$orgnNatCd,
    #pkg: _f$pkg,
    #itemCd: _f$itemCd,
    #pkgUnitCd: _f$pkgUnitCd,
    #qtyUnitCd: _f$qtyUnitCd,
    #itemNm: _f$itemNm,
    #prc: _f$prc,
    #splyAmt: _f$splyAmt,
    #tin: _f$tin,
    #bhfId: _f$bhfId,
    #dftPrc: _f$dftPrc,
    #addInfo: _f$addInfo,
    #isrcAplcbYn: _f$isrcAplcbYn,
    #useYn: _f$useYn,
    #regrId: _f$regrId,
    #regrNm: _f$regrNm,
    #modrId: _f$modrId,
    #modrNm: _f$modrNm,
    #lastTouched: _f$lastTouched,
    #deletedAt: _f$deletedAt,
  };

  static $RealmITransactionItem _instantiate(DecodingData data) {
    return $RealmITransactionItem();
  }

  @override
  final Function instantiate = _instantiate;

  static $RealmITransactionItem fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<$RealmITransactionItem>(map);
  }

  static $RealmITransactionItem fromJson(String json) {
    return ensureInitialized().decodeJson<$RealmITransactionItem>(json);
  }
}

mixin $RealmITransactionItemMappable {
  String toJson() {
    return $RealmITransactionItemMapper
        .ensureInitialized()
        .encodeJson<$RealmITransactionItem>(this as $RealmITransactionItem);
  }

  Map<String, dynamic> toMap() {
    return $RealmITransactionItemMapper
        .ensureInitialized()
        .encodeMap<$RealmITransactionItem>(this as $RealmITransactionItem);
  }

  $RealmITransactionItemCopyWith<$RealmITransactionItem, $RealmITransactionItem,
          $RealmITransactionItem>
      get copyWith => _$RealmITransactionItemCopyWithImpl(
          this as $RealmITransactionItem, $identity, $identity);
  @override
  String toString() {
    return $RealmITransactionItemMapper
        .ensureInitialized()
        .stringifyValue(this as $RealmITransactionItem);
  }

  @override
  bool operator ==(Object other) {
    return $RealmITransactionItemMapper
        .ensureInitialized()
        .equalsValue(this as $RealmITransactionItem, other);
  }

  @override
  int get hashCode {
    return $RealmITransactionItemMapper
        .ensureInitialized()
        .hashValue(this as $RealmITransactionItem);
  }
}

extension $RealmITransactionItemValueCopy<$R, $Out>
    on ObjectCopyWith<$R, $RealmITransactionItem, $Out> {
  $RealmITransactionItemCopyWith<$R, $RealmITransactionItem, $Out>
      get $as$RealmITransactionItem =>
          $base.as((v, t, t2) => _$RealmITransactionItemCopyWithImpl(v, t, t2));
}

abstract class $RealmITransactionItemCopyWith<
    $R,
    $In extends $RealmITransactionItem,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call();
  $RealmITransactionItemCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _$RealmITransactionItemCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, $RealmITransactionItem, $Out>
    implements
        $RealmITransactionItemCopyWith<$R, $RealmITransactionItem, $Out> {
  _$RealmITransactionItemCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<$RealmITransactionItem> $mapper =
      $RealmITransactionItemMapper.ensureInitialized();
  @override
  $R call() => $apply(FieldCopyWithData({}));
  @override
  $RealmITransactionItem $make(CopyWithData data) => $RealmITransactionItem();

  @override
  $RealmITransactionItemCopyWith<$R2, $RealmITransactionItem, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _$RealmITransactionItemCopyWithImpl($value, $cast, t);
}
