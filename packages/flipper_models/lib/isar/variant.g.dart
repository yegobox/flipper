// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variant.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetVariantCollection on Isar {
  IsarCollection<String, Variant> get variants => this.collection();
}

const VariantSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'Variant',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'deletedAt',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'id',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'name',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'color',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'sku',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'productId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'unit',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'productName',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'branchId',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'taxName',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'taxPercentage',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'isTaxExempted',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'itemSeq',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'isrccCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'isrccNm',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'isrcRt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'isrcAmt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'taxTyCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'bcd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'itemClsCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'itemTyCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'itemStdNm',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'orgnNatCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'pkg',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'itemCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'pkgUnitCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'qtyUnitCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'itemNm',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'qty',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'prc',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'splyAmt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'tin',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'bhfId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'dftPrc',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'addInfo',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'isrcAplcbYn',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'useYn',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'regrId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'regrNm',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'modrId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'modrNm',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'rsdQty',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'lastTouched',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'supplyPrice',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'retailPrice',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'action',
        type: IsarType.string,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'name',
        properties: [
          "name",
        ],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'productId',
        properties: [
          "productId",
        ],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<String, Variant>(
    serialize: serializeVariant,
    deserialize: deserializeVariant,
    deserializeProperty: deserializeVariantProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeVariant(IsarWriter writer, Variant object) {
  IsarCore.writeLong(writer, 1,
      object.deletedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808);
  IsarCore.writeString(writer, 2, object.id);
  IsarCore.writeString(writer, 3, object.name);
  IsarCore.writeString(writer, 4, object.color);
  IsarCore.writeString(writer, 5, object.sku);
  IsarCore.writeString(writer, 6, object.productId);
  IsarCore.writeString(writer, 7, object.unit);
  IsarCore.writeString(writer, 8, object.productName);
  IsarCore.writeLong(writer, 9, object.branchId);
  {
    final value = object.taxName;
    if (value == null) {
      IsarCore.writeNull(writer, 10);
    } else {
      IsarCore.writeString(writer, 10, value);
    }
  }
  IsarCore.writeDouble(writer, 11, object.taxPercentage ?? double.nan);
  IsarCore.writeBool(writer, 12, object.isTaxExempted);
  {
    final value = object.itemSeq;
    if (value == null) {
      IsarCore.writeNull(writer, 13);
    } else {
      IsarCore.writeString(writer, 13, value);
    }
  }
  {
    final value = object.isrccCd;
    if (value == null) {
      IsarCore.writeNull(writer, 14);
    } else {
      IsarCore.writeString(writer, 14, value);
    }
  }
  {
    final value = object.isrccNm;
    if (value == null) {
      IsarCore.writeNull(writer, 15);
    } else {
      IsarCore.writeString(writer, 15, value);
    }
  }
  {
    final value = object.isrcRt;
    if (value == null) {
      IsarCore.writeNull(writer, 16);
    } else {
      IsarCore.writeString(writer, 16, value);
    }
  }
  {
    final value = object.isrcAmt;
    if (value == null) {
      IsarCore.writeNull(writer, 17);
    } else {
      IsarCore.writeString(writer, 17, value);
    }
  }
  {
    final value = object.taxTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 18);
    } else {
      IsarCore.writeString(writer, 18, value);
    }
  }
  {
    final value = object.bcd;
    if (value == null) {
      IsarCore.writeNull(writer, 19);
    } else {
      IsarCore.writeString(writer, 19, value);
    }
  }
  {
    final value = object.itemClsCd;
    if (value == null) {
      IsarCore.writeNull(writer, 20);
    } else {
      IsarCore.writeString(writer, 20, value);
    }
  }
  {
    final value = object.itemTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 21);
    } else {
      IsarCore.writeString(writer, 21, value);
    }
  }
  {
    final value = object.itemStdNm;
    if (value == null) {
      IsarCore.writeNull(writer, 22);
    } else {
      IsarCore.writeString(writer, 22, value);
    }
  }
  {
    final value = object.orgnNatCd;
    if (value == null) {
      IsarCore.writeNull(writer, 23);
    } else {
      IsarCore.writeString(writer, 23, value);
    }
  }
  {
    final value = object.pkg;
    if (value == null) {
      IsarCore.writeNull(writer, 24);
    } else {
      IsarCore.writeString(writer, 24, value);
    }
  }
  {
    final value = object.itemCd;
    if (value == null) {
      IsarCore.writeNull(writer, 25);
    } else {
      IsarCore.writeString(writer, 25, value);
    }
  }
  {
    final value = object.pkgUnitCd;
    if (value == null) {
      IsarCore.writeNull(writer, 26);
    } else {
      IsarCore.writeString(writer, 26, value);
    }
  }
  {
    final value = object.qtyUnitCd;
    if (value == null) {
      IsarCore.writeNull(writer, 27);
    } else {
      IsarCore.writeString(writer, 27, value);
    }
  }
  {
    final value = object.itemNm;
    if (value == null) {
      IsarCore.writeNull(writer, 28);
    } else {
      IsarCore.writeString(writer, 28, value);
    }
  }
  IsarCore.writeDouble(writer, 29, object.qty ?? double.nan);
  IsarCore.writeDouble(writer, 30, object.prc ?? double.nan);
  IsarCore.writeDouble(writer, 31, object.splyAmt ?? double.nan);
  IsarCore.writeLong(writer, 32, object.tin ?? -9223372036854775808);
  {
    final value = object.bhfId;
    if (value == null) {
      IsarCore.writeNull(writer, 33);
    } else {
      IsarCore.writeString(writer, 33, value);
    }
  }
  IsarCore.writeDouble(writer, 34, object.dftPrc ?? double.nan);
  {
    final value = object.addInfo;
    if (value == null) {
      IsarCore.writeNull(writer, 35);
    } else {
      IsarCore.writeString(writer, 35, value);
    }
  }
  {
    final value = object.isrcAplcbYn;
    if (value == null) {
      IsarCore.writeNull(writer, 36);
    } else {
      IsarCore.writeString(writer, 36, value);
    }
  }
  {
    final value = object.useYn;
    if (value == null) {
      IsarCore.writeNull(writer, 37);
    } else {
      IsarCore.writeString(writer, 37, value);
    }
  }
  {
    final value = object.regrId;
    if (value == null) {
      IsarCore.writeNull(writer, 38);
    } else {
      IsarCore.writeString(writer, 38, value);
    }
  }
  {
    final value = object.regrNm;
    if (value == null) {
      IsarCore.writeNull(writer, 39);
    } else {
      IsarCore.writeString(writer, 39, value);
    }
  }
  {
    final value = object.modrId;
    if (value == null) {
      IsarCore.writeNull(writer, 40);
    } else {
      IsarCore.writeString(writer, 40, value);
    }
  }
  {
    final value = object.modrNm;
    if (value == null) {
      IsarCore.writeNull(writer, 41);
    } else {
      IsarCore.writeString(writer, 41, value);
    }
  }
  IsarCore.writeDouble(writer, 42, object.rsdQty ?? double.nan);
  IsarCore.writeLong(
      writer,
      43,
      object.lastTouched?.toUtc().microsecondsSinceEpoch ??
          -9223372036854775808);
  IsarCore.writeDouble(writer, 44, object.supplyPrice);
  IsarCore.writeDouble(writer, 45, object.retailPrice);
  IsarCore.writeString(writer, 46, object.action);
  return Isar.fastHash(object.id);
}

@isarProtected
Variant deserializeVariant(IsarReader reader) {
  final DateTime? _deletedAt;
  {
    final value = IsarCore.readLong(reader, 1);
    if (value == -9223372036854775808) {
      _deletedAt = null;
    } else {
      _deletedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final String _id;
  _id = IsarCore.readString(reader, 2) ?? '';
  final String _name;
  _name = IsarCore.readString(reader, 3) ?? '';
  final String _color;
  _color = IsarCore.readString(reader, 4) ?? '';
  final String _sku;
  _sku = IsarCore.readString(reader, 5) ?? '';
  final String _productId;
  _productId = IsarCore.readString(reader, 6) ?? '';
  final String _unit;
  _unit = IsarCore.readString(reader, 7) ?? '';
  final String _productName;
  _productName = IsarCore.readString(reader, 8) ?? '';
  final int _branchId;
  _branchId = IsarCore.readLong(reader, 9);
  final String? _taxName;
  _taxName = IsarCore.readString(reader, 10) ?? 'N/A';
  final double? _taxPercentage;
  {
    final value = IsarCore.readDouble(reader, 11);
    if (value.isNaN) {
      _taxPercentage = 0;
    } else {
      _taxPercentage = value;
    }
  }
  final bool _isTaxExempted;
  _isTaxExempted = IsarCore.readBool(reader, 12);
  final String? _itemSeq;
  _itemSeq = IsarCore.readString(reader, 13);
  final String? _isrccCd;
  _isrccCd = IsarCore.readString(reader, 14);
  final String? _isrccNm;
  _isrccNm = IsarCore.readString(reader, 15);
  final String? _isrcRt;
  _isrcRt = IsarCore.readString(reader, 16);
  final String? _isrcAmt;
  _isrcAmt = IsarCore.readString(reader, 17);
  final String? _taxTyCd;
  _taxTyCd = IsarCore.readString(reader, 18);
  final String? _bcd;
  _bcd = IsarCore.readString(reader, 19);
  final String? _itemClsCd;
  _itemClsCd = IsarCore.readString(reader, 20) ?? 'itemClsCd';
  final String? _itemTyCd;
  _itemTyCd = IsarCore.readString(reader, 21);
  final String? _itemStdNm;
  _itemStdNm = IsarCore.readString(reader, 22);
  final String? _orgnNatCd;
  _orgnNatCd = IsarCore.readString(reader, 23);
  final String? _pkg;
  _pkg = IsarCore.readString(reader, 24);
  final String? _itemCd;
  _itemCd = IsarCore.readString(reader, 25);
  final String? _pkgUnitCd;
  _pkgUnitCd = IsarCore.readString(reader, 26);
  final String? _qtyUnitCd;
  _qtyUnitCd = IsarCore.readString(reader, 27);
  final String? _itemNm;
  _itemNm = IsarCore.readString(reader, 28);
  final double? _qty;
  {
    final value = IsarCore.readDouble(reader, 29);
    if (value.isNaN) {
      _qty = null;
    } else {
      _qty = value;
    }
  }
  final double? _prc;
  {
    final value = IsarCore.readDouble(reader, 30);
    if (value.isNaN) {
      _prc = 0.0;
    } else {
      _prc = value;
    }
  }
  final double? _splyAmt;
  {
    final value = IsarCore.readDouble(reader, 31);
    if (value.isNaN) {
      _splyAmt = null;
    } else {
      _splyAmt = value;
    }
  }
  final int? _tin;
  {
    final value = IsarCore.readLong(reader, 32);
    if (value == -9223372036854775808) {
      _tin = null;
    } else {
      _tin = value;
    }
  }
  final String? _bhfId;
  _bhfId = IsarCore.readString(reader, 33);
  final double? _dftPrc;
  {
    final value = IsarCore.readDouble(reader, 34);
    if (value.isNaN) {
      _dftPrc = null;
    } else {
      _dftPrc = value;
    }
  }
  final String? _addInfo;
  _addInfo = IsarCore.readString(reader, 35);
  final String? _isrcAplcbYn;
  _isrcAplcbYn = IsarCore.readString(reader, 36);
  final String? _useYn;
  _useYn = IsarCore.readString(reader, 37);
  final String? _regrId;
  _regrId = IsarCore.readString(reader, 38);
  final String? _regrNm;
  _regrNm = IsarCore.readString(reader, 39);
  final String? _modrId;
  _modrId = IsarCore.readString(reader, 40);
  final String? _modrNm;
  _modrNm = IsarCore.readString(reader, 41);
  final double? _rsdQty;
  {
    final value = IsarCore.readDouble(reader, 42);
    if (value.isNaN) {
      _rsdQty = null;
    } else {
      _rsdQty = value;
    }
  }
  final DateTime? _lastTouched;
  {
    final value = IsarCore.readLong(reader, 43);
    if (value == -9223372036854775808) {
      _lastTouched = null;
    } else {
      _lastTouched =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final double _supplyPrice;
  _supplyPrice = IsarCore.readDouble(reader, 44);
  final double _retailPrice;
  _retailPrice = IsarCore.readDouble(reader, 45);
  final String _action;
  _action = IsarCore.readString(reader, 46) ?? '';
  final object = Variant(
    deletedAt: _deletedAt,
    id: _id,
    name: _name,
    color: _color,
    sku: _sku,
    productId: _productId,
    unit: _unit,
    productName: _productName,
    branchId: _branchId,
    taxName: _taxName,
    taxPercentage: _taxPercentage,
    isTaxExempted: _isTaxExempted,
    itemSeq: _itemSeq,
    isrccCd: _isrccCd,
    isrccNm: _isrccNm,
    isrcRt: _isrcRt,
    isrcAmt: _isrcAmt,
    taxTyCd: _taxTyCd,
    bcd: _bcd,
    itemClsCd: _itemClsCd,
    itemTyCd: _itemTyCd,
    itemStdNm: _itemStdNm,
    orgnNatCd: _orgnNatCd,
    pkg: _pkg,
    itemCd: _itemCd,
    pkgUnitCd: _pkgUnitCd,
    qtyUnitCd: _qtyUnitCd,
    itemNm: _itemNm,
    qty: _qty,
    prc: _prc,
    splyAmt: _splyAmt,
    tin: _tin,
    bhfId: _bhfId,
    dftPrc: _dftPrc,
    addInfo: _addInfo,
    isrcAplcbYn: _isrcAplcbYn,
    useYn: _useYn,
    regrId: _regrId,
    regrNm: _regrNm,
    modrId: _modrId,
    modrNm: _modrNm,
    rsdQty: _rsdQty,
    lastTouched: _lastTouched,
    supplyPrice: _supplyPrice,
    retailPrice: _retailPrice,
    action: _action,
  );
  return object;
}

@isarProtected
dynamic deserializeVariantProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      {
        final value = IsarCore.readLong(reader, 1);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readString(reader, 5) ?? '';
    case 6:
      return IsarCore.readString(reader, 6) ?? '';
    case 7:
      return IsarCore.readString(reader, 7) ?? '';
    case 8:
      return IsarCore.readString(reader, 8) ?? '';
    case 9:
      return IsarCore.readLong(reader, 9);
    case 10:
      return IsarCore.readString(reader, 10) ?? 'N/A';
    case 11:
      {
        final value = IsarCore.readDouble(reader, 11);
        if (value.isNaN) {
          return 0;
        } else {
          return value;
        }
      }
    case 12:
      return IsarCore.readBool(reader, 12);
    case 13:
      return IsarCore.readString(reader, 13);
    case 14:
      return IsarCore.readString(reader, 14);
    case 15:
      return IsarCore.readString(reader, 15);
    case 16:
      return IsarCore.readString(reader, 16);
    case 17:
      return IsarCore.readString(reader, 17);
    case 18:
      return IsarCore.readString(reader, 18);
    case 19:
      return IsarCore.readString(reader, 19);
    case 20:
      return IsarCore.readString(reader, 20) ?? 'itemClsCd';
    case 21:
      return IsarCore.readString(reader, 21);
    case 22:
      return IsarCore.readString(reader, 22);
    case 23:
      return IsarCore.readString(reader, 23);
    case 24:
      return IsarCore.readString(reader, 24);
    case 25:
      return IsarCore.readString(reader, 25);
    case 26:
      return IsarCore.readString(reader, 26);
    case 27:
      return IsarCore.readString(reader, 27);
    case 28:
      return IsarCore.readString(reader, 28);
    case 29:
      {
        final value = IsarCore.readDouble(reader, 29);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 30:
      {
        final value = IsarCore.readDouble(reader, 30);
        if (value.isNaN) {
          return 0.0;
        } else {
          return value;
        }
      }
    case 31:
      {
        final value = IsarCore.readDouble(reader, 31);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 32:
      {
        final value = IsarCore.readLong(reader, 32);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 33:
      return IsarCore.readString(reader, 33);
    case 34:
      {
        final value = IsarCore.readDouble(reader, 34);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 35:
      return IsarCore.readString(reader, 35);
    case 36:
      return IsarCore.readString(reader, 36);
    case 37:
      return IsarCore.readString(reader, 37);
    case 38:
      return IsarCore.readString(reader, 38);
    case 39:
      return IsarCore.readString(reader, 39);
    case 40:
      return IsarCore.readString(reader, 40);
    case 41:
      return IsarCore.readString(reader, 41);
    case 42:
      {
        final value = IsarCore.readDouble(reader, 42);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 43:
      {
        final value = IsarCore.readLong(reader, 43);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 44:
      return IsarCore.readDouble(reader, 44);
    case 45:
      return IsarCore.readDouble(reader, 45);
    case 46:
      return IsarCore.readString(reader, 46) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _VariantUpdate {
  bool call({
    required String id,
    DateTime? deletedAt,
    String? name,
    String? color,
    String? sku,
    String? productId,
    String? unit,
    String? productName,
    int? branchId,
    String? taxName,
    double? taxPercentage,
    bool? isTaxExempted,
    String? itemSeq,
    String? isrccCd,
    String? isrccNm,
    String? isrcRt,
    String? isrcAmt,
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
    double? qty,
    double? prc,
    double? splyAmt,
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
    double? rsdQty,
    DateTime? lastTouched,
    double? supplyPrice,
    double? retailPrice,
    String? action,
  });
}

class _VariantUpdateImpl implements _VariantUpdate {
  const _VariantUpdateImpl(this.collection);

  final IsarCollection<String, Variant> collection;

  @override
  bool call({
    required String id,
    Object? deletedAt = ignore,
    Object? name = ignore,
    Object? color = ignore,
    Object? sku = ignore,
    Object? productId = ignore,
    Object? unit = ignore,
    Object? productName = ignore,
    Object? branchId = ignore,
    Object? taxName = ignore,
    Object? taxPercentage = ignore,
    Object? isTaxExempted = ignore,
    Object? itemSeq = ignore,
    Object? isrccCd = ignore,
    Object? isrccNm = ignore,
    Object? isrcRt = ignore,
    Object? isrcAmt = ignore,
    Object? taxTyCd = ignore,
    Object? bcd = ignore,
    Object? itemClsCd = ignore,
    Object? itemTyCd = ignore,
    Object? itemStdNm = ignore,
    Object? orgnNatCd = ignore,
    Object? pkg = ignore,
    Object? itemCd = ignore,
    Object? pkgUnitCd = ignore,
    Object? qtyUnitCd = ignore,
    Object? itemNm = ignore,
    Object? qty = ignore,
    Object? prc = ignore,
    Object? splyAmt = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? dftPrc = ignore,
    Object? addInfo = ignore,
    Object? isrcAplcbYn = ignore,
    Object? useYn = ignore,
    Object? regrId = ignore,
    Object? regrNm = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? rsdQty = ignore,
    Object? lastTouched = ignore,
    Object? supplyPrice = ignore,
    Object? retailPrice = ignore,
    Object? action = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (deletedAt != ignore) 1: deletedAt as DateTime?,
          if (name != ignore) 3: name as String?,
          if (color != ignore) 4: color as String?,
          if (sku != ignore) 5: sku as String?,
          if (productId != ignore) 6: productId as String?,
          if (unit != ignore) 7: unit as String?,
          if (productName != ignore) 8: productName as String?,
          if (branchId != ignore) 9: branchId as int?,
          if (taxName != ignore) 10: taxName as String?,
          if (taxPercentage != ignore) 11: taxPercentage as double?,
          if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
          if (itemSeq != ignore) 13: itemSeq as String?,
          if (isrccCd != ignore) 14: isrccCd as String?,
          if (isrccNm != ignore) 15: isrccNm as String?,
          if (isrcRt != ignore) 16: isrcRt as String?,
          if (isrcAmt != ignore) 17: isrcAmt as String?,
          if (taxTyCd != ignore) 18: taxTyCd as String?,
          if (bcd != ignore) 19: bcd as String?,
          if (itemClsCd != ignore) 20: itemClsCd as String?,
          if (itemTyCd != ignore) 21: itemTyCd as String?,
          if (itemStdNm != ignore) 22: itemStdNm as String?,
          if (orgnNatCd != ignore) 23: orgnNatCd as String?,
          if (pkg != ignore) 24: pkg as String?,
          if (itemCd != ignore) 25: itemCd as String?,
          if (pkgUnitCd != ignore) 26: pkgUnitCd as String?,
          if (qtyUnitCd != ignore) 27: qtyUnitCd as String?,
          if (itemNm != ignore) 28: itemNm as String?,
          if (qty != ignore) 29: qty as double?,
          if (prc != ignore) 30: prc as double?,
          if (splyAmt != ignore) 31: splyAmt as double?,
          if (tin != ignore) 32: tin as int?,
          if (bhfId != ignore) 33: bhfId as String?,
          if (dftPrc != ignore) 34: dftPrc as double?,
          if (addInfo != ignore) 35: addInfo as String?,
          if (isrcAplcbYn != ignore) 36: isrcAplcbYn as String?,
          if (useYn != ignore) 37: useYn as String?,
          if (regrId != ignore) 38: regrId as String?,
          if (regrNm != ignore) 39: regrNm as String?,
          if (modrId != ignore) 40: modrId as String?,
          if (modrNm != ignore) 41: modrNm as String?,
          if (rsdQty != ignore) 42: rsdQty as double?,
          if (lastTouched != ignore) 43: lastTouched as DateTime?,
          if (supplyPrice != ignore) 44: supplyPrice as double?,
          if (retailPrice != ignore) 45: retailPrice as double?,
          if (action != ignore) 46: action as String?,
        }) >
        0;
  }
}

sealed class _VariantUpdateAll {
  int call({
    required List<String> id,
    DateTime? deletedAt,
    String? name,
    String? color,
    String? sku,
    String? productId,
    String? unit,
    String? productName,
    int? branchId,
    String? taxName,
    double? taxPercentage,
    bool? isTaxExempted,
    String? itemSeq,
    String? isrccCd,
    String? isrccNm,
    String? isrcRt,
    String? isrcAmt,
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
    double? qty,
    double? prc,
    double? splyAmt,
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
    double? rsdQty,
    DateTime? lastTouched,
    double? supplyPrice,
    double? retailPrice,
    String? action,
  });
}

class _VariantUpdateAllImpl implements _VariantUpdateAll {
  const _VariantUpdateAllImpl(this.collection);

  final IsarCollection<String, Variant> collection;

  @override
  int call({
    required List<String> id,
    Object? deletedAt = ignore,
    Object? name = ignore,
    Object? color = ignore,
    Object? sku = ignore,
    Object? productId = ignore,
    Object? unit = ignore,
    Object? productName = ignore,
    Object? branchId = ignore,
    Object? taxName = ignore,
    Object? taxPercentage = ignore,
    Object? isTaxExempted = ignore,
    Object? itemSeq = ignore,
    Object? isrccCd = ignore,
    Object? isrccNm = ignore,
    Object? isrcRt = ignore,
    Object? isrcAmt = ignore,
    Object? taxTyCd = ignore,
    Object? bcd = ignore,
    Object? itemClsCd = ignore,
    Object? itemTyCd = ignore,
    Object? itemStdNm = ignore,
    Object? orgnNatCd = ignore,
    Object? pkg = ignore,
    Object? itemCd = ignore,
    Object? pkgUnitCd = ignore,
    Object? qtyUnitCd = ignore,
    Object? itemNm = ignore,
    Object? qty = ignore,
    Object? prc = ignore,
    Object? splyAmt = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? dftPrc = ignore,
    Object? addInfo = ignore,
    Object? isrcAplcbYn = ignore,
    Object? useYn = ignore,
    Object? regrId = ignore,
    Object? regrNm = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? rsdQty = ignore,
    Object? lastTouched = ignore,
    Object? supplyPrice = ignore,
    Object? retailPrice = ignore,
    Object? action = ignore,
  }) {
    return collection.updateProperties(id, {
      if (deletedAt != ignore) 1: deletedAt as DateTime?,
      if (name != ignore) 3: name as String?,
      if (color != ignore) 4: color as String?,
      if (sku != ignore) 5: sku as String?,
      if (productId != ignore) 6: productId as String?,
      if (unit != ignore) 7: unit as String?,
      if (productName != ignore) 8: productName as String?,
      if (branchId != ignore) 9: branchId as int?,
      if (taxName != ignore) 10: taxName as String?,
      if (taxPercentage != ignore) 11: taxPercentage as double?,
      if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
      if (itemSeq != ignore) 13: itemSeq as String?,
      if (isrccCd != ignore) 14: isrccCd as String?,
      if (isrccNm != ignore) 15: isrccNm as String?,
      if (isrcRt != ignore) 16: isrcRt as String?,
      if (isrcAmt != ignore) 17: isrcAmt as String?,
      if (taxTyCd != ignore) 18: taxTyCd as String?,
      if (bcd != ignore) 19: bcd as String?,
      if (itemClsCd != ignore) 20: itemClsCd as String?,
      if (itemTyCd != ignore) 21: itemTyCd as String?,
      if (itemStdNm != ignore) 22: itemStdNm as String?,
      if (orgnNatCd != ignore) 23: orgnNatCd as String?,
      if (pkg != ignore) 24: pkg as String?,
      if (itemCd != ignore) 25: itemCd as String?,
      if (pkgUnitCd != ignore) 26: pkgUnitCd as String?,
      if (qtyUnitCd != ignore) 27: qtyUnitCd as String?,
      if (itemNm != ignore) 28: itemNm as String?,
      if (qty != ignore) 29: qty as double?,
      if (prc != ignore) 30: prc as double?,
      if (splyAmt != ignore) 31: splyAmt as double?,
      if (tin != ignore) 32: tin as int?,
      if (bhfId != ignore) 33: bhfId as String?,
      if (dftPrc != ignore) 34: dftPrc as double?,
      if (addInfo != ignore) 35: addInfo as String?,
      if (isrcAplcbYn != ignore) 36: isrcAplcbYn as String?,
      if (useYn != ignore) 37: useYn as String?,
      if (regrId != ignore) 38: regrId as String?,
      if (regrNm != ignore) 39: regrNm as String?,
      if (modrId != ignore) 40: modrId as String?,
      if (modrNm != ignore) 41: modrNm as String?,
      if (rsdQty != ignore) 42: rsdQty as double?,
      if (lastTouched != ignore) 43: lastTouched as DateTime?,
      if (supplyPrice != ignore) 44: supplyPrice as double?,
      if (retailPrice != ignore) 45: retailPrice as double?,
      if (action != ignore) 46: action as String?,
    });
  }
}

extension VariantUpdate on IsarCollection<String, Variant> {
  _VariantUpdate get update => _VariantUpdateImpl(this);

  _VariantUpdateAll get updateAll => _VariantUpdateAllImpl(this);
}

sealed class _VariantQueryUpdate {
  int call({
    DateTime? deletedAt,
    String? name,
    String? color,
    String? sku,
    String? productId,
    String? unit,
    String? productName,
    int? branchId,
    String? taxName,
    double? taxPercentage,
    bool? isTaxExempted,
    String? itemSeq,
    String? isrccCd,
    String? isrccNm,
    String? isrcRt,
    String? isrcAmt,
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
    double? qty,
    double? prc,
    double? splyAmt,
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
    double? rsdQty,
    DateTime? lastTouched,
    double? supplyPrice,
    double? retailPrice,
    String? action,
  });
}

class _VariantQueryUpdateImpl implements _VariantQueryUpdate {
  const _VariantQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<Variant> query;
  final int? limit;

  @override
  int call({
    Object? deletedAt = ignore,
    Object? name = ignore,
    Object? color = ignore,
    Object? sku = ignore,
    Object? productId = ignore,
    Object? unit = ignore,
    Object? productName = ignore,
    Object? branchId = ignore,
    Object? taxName = ignore,
    Object? taxPercentage = ignore,
    Object? isTaxExempted = ignore,
    Object? itemSeq = ignore,
    Object? isrccCd = ignore,
    Object? isrccNm = ignore,
    Object? isrcRt = ignore,
    Object? isrcAmt = ignore,
    Object? taxTyCd = ignore,
    Object? bcd = ignore,
    Object? itemClsCd = ignore,
    Object? itemTyCd = ignore,
    Object? itemStdNm = ignore,
    Object? orgnNatCd = ignore,
    Object? pkg = ignore,
    Object? itemCd = ignore,
    Object? pkgUnitCd = ignore,
    Object? qtyUnitCd = ignore,
    Object? itemNm = ignore,
    Object? qty = ignore,
    Object? prc = ignore,
    Object? splyAmt = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? dftPrc = ignore,
    Object? addInfo = ignore,
    Object? isrcAplcbYn = ignore,
    Object? useYn = ignore,
    Object? regrId = ignore,
    Object? regrNm = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? rsdQty = ignore,
    Object? lastTouched = ignore,
    Object? supplyPrice = ignore,
    Object? retailPrice = ignore,
    Object? action = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (deletedAt != ignore) 1: deletedAt as DateTime?,
      if (name != ignore) 3: name as String?,
      if (color != ignore) 4: color as String?,
      if (sku != ignore) 5: sku as String?,
      if (productId != ignore) 6: productId as String?,
      if (unit != ignore) 7: unit as String?,
      if (productName != ignore) 8: productName as String?,
      if (branchId != ignore) 9: branchId as int?,
      if (taxName != ignore) 10: taxName as String?,
      if (taxPercentage != ignore) 11: taxPercentage as double?,
      if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
      if (itemSeq != ignore) 13: itemSeq as String?,
      if (isrccCd != ignore) 14: isrccCd as String?,
      if (isrccNm != ignore) 15: isrccNm as String?,
      if (isrcRt != ignore) 16: isrcRt as String?,
      if (isrcAmt != ignore) 17: isrcAmt as String?,
      if (taxTyCd != ignore) 18: taxTyCd as String?,
      if (bcd != ignore) 19: bcd as String?,
      if (itemClsCd != ignore) 20: itemClsCd as String?,
      if (itemTyCd != ignore) 21: itemTyCd as String?,
      if (itemStdNm != ignore) 22: itemStdNm as String?,
      if (orgnNatCd != ignore) 23: orgnNatCd as String?,
      if (pkg != ignore) 24: pkg as String?,
      if (itemCd != ignore) 25: itemCd as String?,
      if (pkgUnitCd != ignore) 26: pkgUnitCd as String?,
      if (qtyUnitCd != ignore) 27: qtyUnitCd as String?,
      if (itemNm != ignore) 28: itemNm as String?,
      if (qty != ignore) 29: qty as double?,
      if (prc != ignore) 30: prc as double?,
      if (splyAmt != ignore) 31: splyAmt as double?,
      if (tin != ignore) 32: tin as int?,
      if (bhfId != ignore) 33: bhfId as String?,
      if (dftPrc != ignore) 34: dftPrc as double?,
      if (addInfo != ignore) 35: addInfo as String?,
      if (isrcAplcbYn != ignore) 36: isrcAplcbYn as String?,
      if (useYn != ignore) 37: useYn as String?,
      if (regrId != ignore) 38: regrId as String?,
      if (regrNm != ignore) 39: regrNm as String?,
      if (modrId != ignore) 40: modrId as String?,
      if (modrNm != ignore) 41: modrNm as String?,
      if (rsdQty != ignore) 42: rsdQty as double?,
      if (lastTouched != ignore) 43: lastTouched as DateTime?,
      if (supplyPrice != ignore) 44: supplyPrice as double?,
      if (retailPrice != ignore) 45: retailPrice as double?,
      if (action != ignore) 46: action as String?,
    });
  }
}

extension VariantQueryUpdate on IsarQuery<Variant> {
  _VariantQueryUpdate get updateFirst =>
      _VariantQueryUpdateImpl(this, limit: 1);

  _VariantQueryUpdate get updateAll => _VariantQueryUpdateImpl(this);
}

class _VariantQueryBuilderUpdateImpl implements _VariantQueryUpdate {
  const _VariantQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<Variant, Variant, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? deletedAt = ignore,
    Object? name = ignore,
    Object? color = ignore,
    Object? sku = ignore,
    Object? productId = ignore,
    Object? unit = ignore,
    Object? productName = ignore,
    Object? branchId = ignore,
    Object? taxName = ignore,
    Object? taxPercentage = ignore,
    Object? isTaxExempted = ignore,
    Object? itemSeq = ignore,
    Object? isrccCd = ignore,
    Object? isrccNm = ignore,
    Object? isrcRt = ignore,
    Object? isrcAmt = ignore,
    Object? taxTyCd = ignore,
    Object? bcd = ignore,
    Object? itemClsCd = ignore,
    Object? itemTyCd = ignore,
    Object? itemStdNm = ignore,
    Object? orgnNatCd = ignore,
    Object? pkg = ignore,
    Object? itemCd = ignore,
    Object? pkgUnitCd = ignore,
    Object? qtyUnitCd = ignore,
    Object? itemNm = ignore,
    Object? qty = ignore,
    Object? prc = ignore,
    Object? splyAmt = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? dftPrc = ignore,
    Object? addInfo = ignore,
    Object? isrcAplcbYn = ignore,
    Object? useYn = ignore,
    Object? regrId = ignore,
    Object? regrNm = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? rsdQty = ignore,
    Object? lastTouched = ignore,
    Object? supplyPrice = ignore,
    Object? retailPrice = ignore,
    Object? action = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (deletedAt != ignore) 1: deletedAt as DateTime?,
        if (name != ignore) 3: name as String?,
        if (color != ignore) 4: color as String?,
        if (sku != ignore) 5: sku as String?,
        if (productId != ignore) 6: productId as String?,
        if (unit != ignore) 7: unit as String?,
        if (productName != ignore) 8: productName as String?,
        if (branchId != ignore) 9: branchId as int?,
        if (taxName != ignore) 10: taxName as String?,
        if (taxPercentage != ignore) 11: taxPercentage as double?,
        if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
        if (itemSeq != ignore) 13: itemSeq as String?,
        if (isrccCd != ignore) 14: isrccCd as String?,
        if (isrccNm != ignore) 15: isrccNm as String?,
        if (isrcRt != ignore) 16: isrcRt as String?,
        if (isrcAmt != ignore) 17: isrcAmt as String?,
        if (taxTyCd != ignore) 18: taxTyCd as String?,
        if (bcd != ignore) 19: bcd as String?,
        if (itemClsCd != ignore) 20: itemClsCd as String?,
        if (itemTyCd != ignore) 21: itemTyCd as String?,
        if (itemStdNm != ignore) 22: itemStdNm as String?,
        if (orgnNatCd != ignore) 23: orgnNatCd as String?,
        if (pkg != ignore) 24: pkg as String?,
        if (itemCd != ignore) 25: itemCd as String?,
        if (pkgUnitCd != ignore) 26: pkgUnitCd as String?,
        if (qtyUnitCd != ignore) 27: qtyUnitCd as String?,
        if (itemNm != ignore) 28: itemNm as String?,
        if (qty != ignore) 29: qty as double?,
        if (prc != ignore) 30: prc as double?,
        if (splyAmt != ignore) 31: splyAmt as double?,
        if (tin != ignore) 32: tin as int?,
        if (bhfId != ignore) 33: bhfId as String?,
        if (dftPrc != ignore) 34: dftPrc as double?,
        if (addInfo != ignore) 35: addInfo as String?,
        if (isrcAplcbYn != ignore) 36: isrcAplcbYn as String?,
        if (useYn != ignore) 37: useYn as String?,
        if (regrId != ignore) 38: regrId as String?,
        if (regrNm != ignore) 39: regrNm as String?,
        if (modrId != ignore) 40: modrId as String?,
        if (modrNm != ignore) 41: modrNm as String?,
        if (rsdQty != ignore) 42: rsdQty as double?,
        if (lastTouched != ignore) 43: lastTouched as DateTime?,
        if (supplyPrice != ignore) 44: supplyPrice as double?,
        if (retailPrice != ignore) 45: retailPrice as double?,
        if (action != ignore) 46: action as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension VariantQueryBuilderUpdate
    on QueryBuilder<Variant, Variant, QOperations> {
  _VariantQueryUpdate get updateFirst =>
      _VariantQueryBuilderUpdateImpl(this, limit: 1);

  _VariantQueryUpdate get updateAll => _VariantQueryBuilderUpdateImpl(this);
}

extension VariantQueryFilter
    on QueryBuilder<Variant, Variant, QFilterCondition> {
  QueryBuilder<Variant, Variant, QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 1));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 1));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> deletedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      deletedAtGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> deletedAtLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      deletedAtLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      nameGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      colorGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> colorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 5,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 5,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> skuIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      productIdGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      productIdLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      unitGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> unitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      productNameGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      productNameLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 8,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> productNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      productNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      branchIdGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      branchIdLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> branchIdBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxNameGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxNameLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 10,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxPercentageIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxPercentageGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxPercentageGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 11,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxPercentageLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxPercentageBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isTaxExemptedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemSeqGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemSeqLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 13,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 13,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemSeqIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrccCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrccCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 14,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 14,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 14,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 14,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrccNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrccNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 15,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 15,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 15,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 15,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrccNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 15,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrcRtGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 16,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 16,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 16,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 16,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcRtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 16,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrcAmtGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrcAmtLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 17,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 17,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 17,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 17,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAmtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 17,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxTyCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      taxTyCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 18,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 18,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 18,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 18,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> taxTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 18,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 19,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 19,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 19,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 19,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bcdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 19,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemClsCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemClsCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 20,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 20,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 20,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemClsCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 20,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 21));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 21));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemTyCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemTyCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 21,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 21,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 21,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 22));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 22));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemStdNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemStdNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 22,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 22,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 22,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 22,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemStdNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 22,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 23));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 23));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      orgnNatCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      orgnNatCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 23,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 23,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 23,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 23,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> orgnNatCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 23,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 24));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 24));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 24,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 24,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 24,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 24,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 24,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 25));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 25));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 25,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 25,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 25,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 25,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 25,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 26));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 26));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      pkgUnitCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      pkgUnitCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 26,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 26,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 26,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 26,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> pkgUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 26,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 27));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 27));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      qtyUnitCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      qtyUnitCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 27,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 27,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 27,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 27,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 27,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 28));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 28));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      itemNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 28,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 28,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 28,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 28,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> itemNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 28,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 29));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 29));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 29,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 29,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 29,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 29,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 29,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> qtyBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 29,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 30));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 30));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 30,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 30,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 30,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 30,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 30,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> prcBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 30,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 31));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 31));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 31,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 31,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      splyAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 31,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 31,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      splyAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 31,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> splyAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 31,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 32));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 32));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 32,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 32,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 32,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 32,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 32,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> tinBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 32,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 33));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 33));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      bhfIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 33,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 33,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 33,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 33,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> bhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 33,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 34));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 34));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 34,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 34,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      dftPrcGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 34,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 34,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 34,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> dftPrcBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 34,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 35));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 35));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      addInfoGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      addInfoLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 35,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 35,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 35,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 35,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> addInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 35,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 36));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 36));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrcAplcbYnGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrcAplcbYnLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 36,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 36,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 36,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> isrcAplcbYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 36,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      isrcAplcbYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 36,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 37));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 37));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      useYnGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 37,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 37,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 37,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 37,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> useYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 37,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 38));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 38));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      regrIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 38,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 38,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 38,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 38,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 38,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 39));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 39));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      regrNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 39,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 39,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 39,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 39,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> regrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 39,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 40));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 40));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      modrIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 40,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 40,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 40,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 40,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 40,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 41));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 41));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      modrNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 41,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 41,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 41,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 41,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> modrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 41,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 42));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 42));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 42,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 42,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      rsdQtyGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 42,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 42,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 42,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> rsdQtyBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 42,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 43));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> lastTouchedIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 43));
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> lastTouchedEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 43,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> lastTouchedGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 43,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      lastTouchedGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 43,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> lastTouchedLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 43,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      lastTouchedLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 43,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> lastTouchedBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 43,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 44,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 44,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      supplyPriceGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 44,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 44,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      supplyPriceLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 44,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> supplyPriceBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 44,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 45,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 45,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      retailPriceGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 45,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 45,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      retailPriceLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 45,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> retailPriceBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 45,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition>
      actionGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 46,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 46,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 46,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 46,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterFilterCondition> actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 46,
          value: '',
        ),
      );
    });
  }
}

extension VariantQueryObject
    on QueryBuilder<Variant, Variant, QFilterCondition> {}

extension VariantQuerySortBy on QueryBuilder<Variant, Variant, QSortBy> {
  QueryBuilder<Variant, Variant, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByColorDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySku(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySkuDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUnitDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByProductNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemSeqDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        14,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        14,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        15,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrccNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        15,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        16,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcRtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        16,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        17,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAmtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        17,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        18,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTaxTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        18,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        19,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBcdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        19,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        20,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemClsCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        20,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        22,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemStdNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        22,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        23,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByOrgnNatCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        23,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        24,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        24,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        25,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        25,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        26,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPkgUnitCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        26,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        27,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyUnitCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        27,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        28,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByItemNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        28,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        33,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        33,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        35,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByAddInfoDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        35,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAplcbYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        36,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByIsrcAplcbYnDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        36,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        37,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByUseYnDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        37,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        38,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        38,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        39,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRegrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        39,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        40,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        40,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        41,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByModrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        41,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRsdQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortBySupplyPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        46,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> sortByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        46,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension VariantQuerySortThenBy
    on QueryBuilder<Variant, Variant, QSortThenBy> {
  QueryBuilder<Variant, Variant, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByColorDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySku(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySkuDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUnitDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByProductNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxPercentageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemSeqDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrccNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcRtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAmtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTaxTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBcdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemClsCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemStdNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByOrgnNatCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(24, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(24, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPkgUnitCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyUnitCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByItemNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByAddInfoDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAplcbYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByIsrcAplcbYnDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByUseYnDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRegrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByModrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRsdQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenBySupplyPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByRetailPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45, sort: Sort.desc);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(46, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterSortBy> thenByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(46, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension VariantQueryWhereDistinct
    on QueryBuilder<Variant, Variant, QDistinct> {
  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctBySku(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByProductId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByProductName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByTaxName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByTaxPercentage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(21, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(22, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(23, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(24, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(25, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(26, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(27, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(28, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(29);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(30);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(31);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(32);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(33, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(34);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(35, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByIsrcAplcbYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(36, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(37, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(38, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(39, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(40, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(41, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByRsdQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(42);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(43);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctBySupplyPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(44);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByRetailPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(45);
    });
  }

  QueryBuilder<Variant, Variant, QAfterDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(46, caseSensitive: caseSensitive);
    });
  }
}

extension VariantQueryProperty1 on QueryBuilder<Variant, Variant, QProperty> {
  QueryBuilder<Variant, DateTime?, QAfterProperty> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Variant, int, QAfterProperty> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> taxNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Variant, double?, QAfterProperty> taxPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Variant, bool, QAfterProperty> isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<Variant, double?, QAfterProperty> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<Variant, double?, QAfterProperty> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<Variant, double?, QAfterProperty> splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<Variant, int?, QAfterProperty> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<Variant, double?, QAfterProperty> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<Variant, String?, QAfterProperty> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<Variant, double?, QAfterProperty> rsdQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<Variant, DateTime?, QAfterProperty> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<Variant, double, QAfterProperty> supplyPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<Variant, double, QAfterProperty> retailPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }

  QueryBuilder<Variant, String, QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(46);
    });
  }
}

extension VariantQueryProperty2<R> on QueryBuilder<Variant, R, QAfterProperty> {
  QueryBuilder<Variant, (R, DateTime?), QAfterProperty> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Variant, (R, int), QAfterProperty> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> taxNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Variant, (R, double?), QAfterProperty> taxPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Variant, (R, bool), QAfterProperty> isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<Variant, (R, double?), QAfterProperty> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<Variant, (R, double?), QAfterProperty> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<Variant, (R, double?), QAfterProperty> splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<Variant, (R, int?), QAfterProperty> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<Variant, (R, double?), QAfterProperty> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<Variant, (R, String?), QAfterProperty> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<Variant, (R, double?), QAfterProperty> rsdQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<Variant, (R, DateTime?), QAfterProperty> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<Variant, (R, double), QAfterProperty> supplyPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<Variant, (R, double), QAfterProperty> retailPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }

  QueryBuilder<Variant, (R, String), QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(46);
    });
  }
}

extension VariantQueryProperty3<R1, R2>
    on QueryBuilder<Variant, (R1, R2), QAfterProperty> {
  QueryBuilder<Variant, (R1, R2, DateTime?), QOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> colorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> skuProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> unitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> productNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Variant, (R1, R2, int), QOperations> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> taxNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Variant, (R1, R2, double?), QOperations>
      taxPercentageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Variant, (R1, R2, bool), QOperations> isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<Variant, (R1, R2, double?), QOperations> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<Variant, (R1, R2, double?), QOperations> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<Variant, (R1, R2, double?), QOperations> splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<Variant, (R1, R2, int?), QOperations> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<Variant, (R1, R2, double?), QOperations> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<Variant, (R1, R2, String?), QOperations> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<Variant, (R1, R2, double?), QOperations> rsdQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<Variant, (R1, R2, DateTime?), QOperations>
      lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<Variant, (R1, R2, double), QOperations> supplyPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<Variant, (R1, R2, double), QOperations> retailPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }

  QueryBuilder<Variant, (R1, R2, String), QOperations> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(46);
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Variant _$VariantFromJson(Map<String, dynamic> json) => Variant(
      name: json['name'] as String,
      sku: json['sku'] as String,
      productId: json['productId'] as String,
      unit: json['unit'] as String,
      productName: json['productName'] as String,
      branchId: json['branchId'] as int,
      supplyPrice: (json['supplyPrice'] as num).toDouble(),
      retailPrice: (json['retailPrice'] as num).toDouble(),
      isTaxExempted: json['isTaxExempted'] as bool,
      action: json['action'] as String,
      color: Variant._colorFromJson(json['color']),
      id: json['id'] as String,
      taxName: json['taxName'] as String? ?? 'N/A',
      taxPercentage: (json['taxPercentage'] as num?)?.toDouble() ?? 0,
      itemSeq: json['itemSeq'] as String?,
      isrccCd: json['isrccCd'] as String?,
      isrccNm: json['isrccNm'] as String?,
      isrcRt: json['isrcRt'] as String?,
      isrcAmt: json['isrcAmt'] as String?,
      taxTyCd: json['taxTyCd'] as String?,
      bcd: json['bcd'] as String?,
      itemClsCd: json['itemClsCd'] as String? ?? 'itemClsCd',
      itemTyCd: json['itemTyCd'] as String?,
      itemStdNm: json['itemStdNm'] as String?,
      orgnNatCd: json['orgnNatCd'] as String?,
      pkg: json['pkg'] as String?,
      itemCd: json['itemCd'] as String?,
      pkgUnitCd: json['pkgUnitCd'] as String?,
      qtyUnitCd: json['qtyUnitCd'] as String?,
      itemNm: json['itemNm'] as String?,
      qty: (json['qty'] as num?)?.toDouble(),
      prc: (json['prc'] as num?)?.toDouble() ?? 0.0,
      splyAmt: (json['splyAmt'] as num?)?.toDouble(),
      tin: json['tin'] as int?,
      bhfId: json['bhfId'] as String?,
      dftPrc: (json['dftPrc'] as num?)?.toDouble(),
      addInfo: json['addInfo'] as String?,
      isrcAplcbYn: json['isrcAplcbYn'] as String?,
      useYn: json['useYn'] as String?,
      regrId: json['regrId'] as String?,
      regrNm: json['regrNm'] as String?,
      modrId: json['modrId'] as String?,
      modrNm: json['modrNm'] as String?,
      rsdQty: (json['rsdQty'] as num?)?.toDouble(),
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      deletedAt: Variant._dateTimeFromJson(json['deletedAt'] as String?),
    );

Map<String, dynamic> _$VariantToJson(Variant instance) => <String, dynamic>{
      'deletedAt': Variant._dateTimeToJson(instance.deletedAt),
      'id': instance.id,
      'name': instance.name,
      'color': instance.color,
      'sku': instance.sku,
      'productId': instance.productId,
      'unit': instance.unit,
      'productName': instance.productName,
      'branchId': instance.branchId,
      'taxName': instance.taxName,
      'taxPercentage': instance.taxPercentage,
      'isTaxExempted': instance.isTaxExempted,
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
      'action': instance.action,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
