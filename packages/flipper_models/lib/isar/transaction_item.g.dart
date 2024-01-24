// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetTransactionItemCollection on Isar {
  IsarCollection<String, TransactionItem> get transactionItems =>
      this.collection();
}

const TransactionItemSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'TransactionItem',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'id',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'name',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'transactionId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'variantId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'qty',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'price',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'discount',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'type',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'remainingStock',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'createdAt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'updatedAt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'isTaxExempted',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'isRefunded',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'doneWithTransaction',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'active',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'dcRt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'dcAmt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxblAmt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxAmt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'totAmt',
        type: IsarType.double,
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
        name: 'lastTouched',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'deletedAt',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'action',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'branchId',
        type: IsarType.long,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'transactionId',
        properties: [
          "transactionId",
        ],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<String, TransactionItem>(
    serialize: serializeTransactionItem,
    deserialize: deserializeTransactionItem,
    deserializeProperty: deserializeTransactionItemProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeTransactionItem(IsarWriter writer, TransactionItem object) {
  IsarCore.writeString(writer, 1, object.id);
  IsarCore.writeString(writer, 2, object.name);
  IsarCore.writeString(writer, 3, object.transactionId);
  IsarCore.writeString(writer, 4, object.variantId);
  IsarCore.writeDouble(writer, 5, object.qty);
  IsarCore.writeDouble(writer, 6, object.price);
  IsarCore.writeDouble(writer, 7, object.discount ?? double.nan);
  {
    final value = object.type;
    if (value == null) {
      IsarCore.writeNull(writer, 8);
    } else {
      IsarCore.writeString(writer, 8, value);
    }
  }
  IsarCore.writeDouble(writer, 9, object.remainingStock);
  IsarCore.writeString(writer, 10, object.createdAt);
  IsarCore.writeString(writer, 11, object.updatedAt);
  IsarCore.writeBool(writer, 12, object.isTaxExempted);
  {
    final value = object.isRefunded;
    if (value == null) {
      IsarCore.writeNull(writer, 13);
    } else {
      IsarCore.writeBool(writer, 13, value);
    }
  }
  {
    final value = object.doneWithTransaction;
    if (value == null) {
      IsarCore.writeNull(writer, 14);
    } else {
      IsarCore.writeBool(writer, 14, value);
    }
  }
  {
    final value = object.active;
    if (value == null) {
      IsarCore.writeNull(writer, 15);
    } else {
      IsarCore.writeBool(writer, 15, value);
    }
  }
  IsarCore.writeDouble(writer, 16, object.dcRt ?? double.nan);
  IsarCore.writeDouble(writer, 17, object.dcAmt ?? double.nan);
  IsarCore.writeDouble(writer, 18, object.taxblAmt ?? double.nan);
  IsarCore.writeDouble(writer, 19, object.taxAmt ?? double.nan);
  IsarCore.writeDouble(writer, 20, object.totAmt ?? double.nan);
  {
    final value = object.itemSeq;
    if (value == null) {
      IsarCore.writeNull(writer, 21);
    } else {
      IsarCore.writeString(writer, 21, value);
    }
  }
  {
    final value = object.isrccCd;
    if (value == null) {
      IsarCore.writeNull(writer, 22);
    } else {
      IsarCore.writeString(writer, 22, value);
    }
  }
  {
    final value = object.isrccNm;
    if (value == null) {
      IsarCore.writeNull(writer, 23);
    } else {
      IsarCore.writeString(writer, 23, value);
    }
  }
  {
    final value = object.isrcRt;
    if (value == null) {
      IsarCore.writeNull(writer, 24);
    } else {
      IsarCore.writeString(writer, 24, value);
    }
  }
  {
    final value = object.isrcAmt;
    if (value == null) {
      IsarCore.writeNull(writer, 25);
    } else {
      IsarCore.writeString(writer, 25, value);
    }
  }
  {
    final value = object.taxTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 26);
    } else {
      IsarCore.writeString(writer, 26, value);
    }
  }
  {
    final value = object.bcd;
    if (value == null) {
      IsarCore.writeNull(writer, 27);
    } else {
      IsarCore.writeString(writer, 27, value);
    }
  }
  {
    final value = object.itemClsCd;
    if (value == null) {
      IsarCore.writeNull(writer, 28);
    } else {
      IsarCore.writeString(writer, 28, value);
    }
  }
  {
    final value = object.itemTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 29);
    } else {
      IsarCore.writeString(writer, 29, value);
    }
  }
  {
    final value = object.itemStdNm;
    if (value == null) {
      IsarCore.writeNull(writer, 30);
    } else {
      IsarCore.writeString(writer, 30, value);
    }
  }
  {
    final value = object.orgnNatCd;
    if (value == null) {
      IsarCore.writeNull(writer, 31);
    } else {
      IsarCore.writeString(writer, 31, value);
    }
  }
  {
    final value = object.pkg;
    if (value == null) {
      IsarCore.writeNull(writer, 32);
    } else {
      IsarCore.writeString(writer, 32, value);
    }
  }
  {
    final value = object.itemCd;
    if (value == null) {
      IsarCore.writeNull(writer, 33);
    } else {
      IsarCore.writeString(writer, 33, value);
    }
  }
  {
    final value = object.pkgUnitCd;
    if (value == null) {
      IsarCore.writeNull(writer, 34);
    } else {
      IsarCore.writeString(writer, 34, value);
    }
  }
  {
    final value = object.qtyUnitCd;
    if (value == null) {
      IsarCore.writeNull(writer, 35);
    } else {
      IsarCore.writeString(writer, 35, value);
    }
  }
  {
    final value = object.itemNm;
    if (value == null) {
      IsarCore.writeNull(writer, 36);
    } else {
      IsarCore.writeString(writer, 36, value);
    }
  }
  IsarCore.writeDouble(writer, 37, object.prc ?? double.nan);
  IsarCore.writeDouble(writer, 38, object.splyAmt ?? double.nan);
  IsarCore.writeLong(writer, 39, object.tin ?? -9223372036854775808);
  {
    final value = object.bhfId;
    if (value == null) {
      IsarCore.writeNull(writer, 40);
    } else {
      IsarCore.writeString(writer, 40, value);
    }
  }
  IsarCore.writeDouble(writer, 41, object.dftPrc ?? double.nan);
  {
    final value = object.addInfo;
    if (value == null) {
      IsarCore.writeNull(writer, 42);
    } else {
      IsarCore.writeString(writer, 42, value);
    }
  }
  {
    final value = object.isrcAplcbYn;
    if (value == null) {
      IsarCore.writeNull(writer, 43);
    } else {
      IsarCore.writeString(writer, 43, value);
    }
  }
  {
    final value = object.useYn;
    if (value == null) {
      IsarCore.writeNull(writer, 44);
    } else {
      IsarCore.writeString(writer, 44, value);
    }
  }
  {
    final value = object.regrId;
    if (value == null) {
      IsarCore.writeNull(writer, 45);
    } else {
      IsarCore.writeString(writer, 45, value);
    }
  }
  {
    final value = object.regrNm;
    if (value == null) {
      IsarCore.writeNull(writer, 46);
    } else {
      IsarCore.writeString(writer, 46, value);
    }
  }
  {
    final value = object.modrId;
    if (value == null) {
      IsarCore.writeNull(writer, 47);
    } else {
      IsarCore.writeString(writer, 47, value);
    }
  }
  {
    final value = object.modrNm;
    if (value == null) {
      IsarCore.writeNull(writer, 48);
    } else {
      IsarCore.writeString(writer, 48, value);
    }
  }
  IsarCore.writeLong(
      writer,
      49,
      object.lastTouched?.toUtc().microsecondsSinceEpoch ??
          -9223372036854775808);
  IsarCore.writeLong(writer, 50,
      object.deletedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808);
  IsarCore.writeString(writer, 51, object.action);
  IsarCore.writeLong(writer, 52, object.branchId);
  return Isar.fastHash(object.id);
}

@isarProtected
TransactionItem deserializeTransactionItem(IsarReader reader) {
  final String _id;
  _id = IsarCore.readString(reader, 1) ?? '';
  final String _name;
  _name = IsarCore.readString(reader, 2) ?? '';
  final String _transactionId;
  _transactionId = IsarCore.readString(reader, 3) ?? '';
  final String _variantId;
  _variantId = IsarCore.readString(reader, 4) ?? '';
  final double _qty;
  _qty = IsarCore.readDouble(reader, 5);
  final double _price;
  _price = IsarCore.readDouble(reader, 6);
  final double? _discount;
  {
    final value = IsarCore.readDouble(reader, 7);
    if (value.isNaN) {
      _discount = null;
    } else {
      _discount = value;
    }
  }
  final String? _type;
  _type = IsarCore.readString(reader, 8);
  final double _remainingStock;
  _remainingStock = IsarCore.readDouble(reader, 9);
  final String _createdAt;
  _createdAt = IsarCore.readString(reader, 10) ?? '';
  final String _updatedAt;
  _updatedAt = IsarCore.readString(reader, 11) ?? '';
  final bool _isTaxExempted;
  _isTaxExempted = IsarCore.readBool(reader, 12);
  final bool? _isRefunded;
  {
    if (IsarCore.readNull(reader, 13)) {
      _isRefunded = null;
    } else {
      _isRefunded = IsarCore.readBool(reader, 13);
    }
  }
  final bool? _doneWithTransaction;
  {
    if (IsarCore.readNull(reader, 14)) {
      _doneWithTransaction = null;
    } else {
      _doneWithTransaction = IsarCore.readBool(reader, 14);
    }
  }
  final bool? _active;
  {
    if (IsarCore.readNull(reader, 15)) {
      _active = null;
    } else {
      _active = IsarCore.readBool(reader, 15);
    }
  }
  final double? _dcRt;
  {
    final value = IsarCore.readDouble(reader, 16);
    if (value.isNaN) {
      _dcRt = null;
    } else {
      _dcRt = value;
    }
  }
  final double? _dcAmt;
  {
    final value = IsarCore.readDouble(reader, 17);
    if (value.isNaN) {
      _dcAmt = null;
    } else {
      _dcAmt = value;
    }
  }
  final double? _taxblAmt;
  {
    final value = IsarCore.readDouble(reader, 18);
    if (value.isNaN) {
      _taxblAmt = null;
    } else {
      _taxblAmt = value;
    }
  }
  final double? _taxAmt;
  {
    final value = IsarCore.readDouble(reader, 19);
    if (value.isNaN) {
      _taxAmt = null;
    } else {
      _taxAmt = value;
    }
  }
  final double? _totAmt;
  {
    final value = IsarCore.readDouble(reader, 20);
    if (value.isNaN) {
      _totAmt = null;
    } else {
      _totAmt = value;
    }
  }
  final String? _itemSeq;
  _itemSeq = IsarCore.readString(reader, 21);
  final String? _isrccCd;
  _isrccCd = IsarCore.readString(reader, 22);
  final String? _isrccNm;
  _isrccNm = IsarCore.readString(reader, 23);
  final String? _isrcRt;
  _isrcRt = IsarCore.readString(reader, 24);
  final String? _isrcAmt;
  _isrcAmt = IsarCore.readString(reader, 25);
  final String? _taxTyCd;
  _taxTyCd = IsarCore.readString(reader, 26);
  final String? _bcd;
  _bcd = IsarCore.readString(reader, 27);
  final String? _itemClsCd;
  _itemClsCd = IsarCore.readString(reader, 28);
  final String? _itemTyCd;
  _itemTyCd = IsarCore.readString(reader, 29);
  final String? _itemStdNm;
  _itemStdNm = IsarCore.readString(reader, 30);
  final String? _orgnNatCd;
  _orgnNatCd = IsarCore.readString(reader, 31);
  final String? _pkg;
  _pkg = IsarCore.readString(reader, 32);
  final String? _itemCd;
  _itemCd = IsarCore.readString(reader, 33);
  final String? _pkgUnitCd;
  _pkgUnitCd = IsarCore.readString(reader, 34);
  final String? _qtyUnitCd;
  _qtyUnitCd = IsarCore.readString(reader, 35);
  final String? _itemNm;
  _itemNm = IsarCore.readString(reader, 36);
  final double? _prc;
  {
    final value = IsarCore.readDouble(reader, 37);
    if (value.isNaN) {
      _prc = null;
    } else {
      _prc = value;
    }
  }
  final double? _splyAmt;
  {
    final value = IsarCore.readDouble(reader, 38);
    if (value.isNaN) {
      _splyAmt = null;
    } else {
      _splyAmt = value;
    }
  }
  final int? _tin;
  {
    final value = IsarCore.readLong(reader, 39);
    if (value == -9223372036854775808) {
      _tin = null;
    } else {
      _tin = value;
    }
  }
  final String? _bhfId;
  _bhfId = IsarCore.readString(reader, 40);
  final double? _dftPrc;
  {
    final value = IsarCore.readDouble(reader, 41);
    if (value.isNaN) {
      _dftPrc = null;
    } else {
      _dftPrc = value;
    }
  }
  final String? _addInfo;
  _addInfo = IsarCore.readString(reader, 42);
  final String? _isrcAplcbYn;
  _isrcAplcbYn = IsarCore.readString(reader, 43);
  final String? _useYn;
  _useYn = IsarCore.readString(reader, 44);
  final String? _regrId;
  _regrId = IsarCore.readString(reader, 45);
  final String? _regrNm;
  _regrNm = IsarCore.readString(reader, 46);
  final String? _modrId;
  _modrId = IsarCore.readString(reader, 47);
  final String? _modrNm;
  _modrNm = IsarCore.readString(reader, 48);
  final DateTime? _lastTouched;
  {
    final value = IsarCore.readLong(reader, 49);
    if (value == -9223372036854775808) {
      _lastTouched = null;
    } else {
      _lastTouched =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final DateTime? _deletedAt;
  {
    final value = IsarCore.readLong(reader, 50);
    if (value == -9223372036854775808) {
      _deletedAt = null;
    } else {
      _deletedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final String _action;
  _action = IsarCore.readString(reader, 51) ?? '';
  final int _branchId;
  _branchId = IsarCore.readLong(reader, 52);
  final object = TransactionItem(
    id: _id,
    name: _name,
    transactionId: _transactionId,
    variantId: _variantId,
    qty: _qty,
    price: _price,
    discount: _discount,
    type: _type,
    remainingStock: _remainingStock,
    createdAt: _createdAt,
    updatedAt: _updatedAt,
    isTaxExempted: _isTaxExempted,
    isRefunded: _isRefunded,
    doneWithTransaction: _doneWithTransaction,
    active: _active,
    dcRt: _dcRt,
    dcAmt: _dcAmt,
    taxblAmt: _taxblAmt,
    taxAmt: _taxAmt,
    totAmt: _totAmt,
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
    lastTouched: _lastTouched,
    deletedAt: _deletedAt,
    action: _action,
    branchId: _branchId,
  );
  return object;
}

@isarProtected
dynamic deserializeTransactionItemProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2) ?? '';
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readDouble(reader, 5);
    case 6:
      return IsarCore.readDouble(reader, 6);
    case 7:
      {
        final value = IsarCore.readDouble(reader, 7);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 8:
      return IsarCore.readString(reader, 8);
    case 9:
      return IsarCore.readDouble(reader, 9);
    case 10:
      return IsarCore.readString(reader, 10) ?? '';
    case 11:
      return IsarCore.readString(reader, 11) ?? '';
    case 12:
      return IsarCore.readBool(reader, 12);
    case 13:
      {
        if (IsarCore.readNull(reader, 13)) {
          return null;
        } else {
          return IsarCore.readBool(reader, 13);
        }
      }
    case 14:
      {
        if (IsarCore.readNull(reader, 14)) {
          return null;
        } else {
          return IsarCore.readBool(reader, 14);
        }
      }
    case 15:
      {
        if (IsarCore.readNull(reader, 15)) {
          return null;
        } else {
          return IsarCore.readBool(reader, 15);
        }
      }
    case 16:
      {
        final value = IsarCore.readDouble(reader, 16);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 17:
      {
        final value = IsarCore.readDouble(reader, 17);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 18:
      {
        final value = IsarCore.readDouble(reader, 18);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 19:
      {
        final value = IsarCore.readDouble(reader, 19);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 20:
      {
        final value = IsarCore.readDouble(reader, 20);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
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
      return IsarCore.readString(reader, 29);
    case 30:
      return IsarCore.readString(reader, 30);
    case 31:
      return IsarCore.readString(reader, 31);
    case 32:
      return IsarCore.readString(reader, 32);
    case 33:
      return IsarCore.readString(reader, 33);
    case 34:
      return IsarCore.readString(reader, 34);
    case 35:
      return IsarCore.readString(reader, 35);
    case 36:
      return IsarCore.readString(reader, 36);
    case 37:
      {
        final value = IsarCore.readDouble(reader, 37);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 38:
      {
        final value = IsarCore.readDouble(reader, 38);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 39:
      {
        final value = IsarCore.readLong(reader, 39);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 40:
      return IsarCore.readString(reader, 40);
    case 41:
      {
        final value = IsarCore.readDouble(reader, 41);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 42:
      return IsarCore.readString(reader, 42);
    case 43:
      return IsarCore.readString(reader, 43);
    case 44:
      return IsarCore.readString(reader, 44);
    case 45:
      return IsarCore.readString(reader, 45);
    case 46:
      return IsarCore.readString(reader, 46);
    case 47:
      return IsarCore.readString(reader, 47);
    case 48:
      return IsarCore.readString(reader, 48);
    case 49:
      {
        final value = IsarCore.readLong(reader, 49);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 50:
      {
        final value = IsarCore.readLong(reader, 50);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 51:
      return IsarCore.readString(reader, 51) ?? '';
    case 52:
      return IsarCore.readLong(reader, 52);
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _TransactionItemUpdate {
  bool call({
    required String id,
    String? name,
    String? transactionId,
    String? variantId,
    double? qty,
    double? price,
    double? discount,
    String? type,
    double? remainingStock,
    String? createdAt,
    String? updatedAt,
    bool? isTaxExempted,
    bool? isRefunded,
    bool? doneWithTransaction,
    bool? active,
    double? dcRt,
    double? dcAmt,
    double? taxblAmt,
    double? taxAmt,
    double? totAmt,
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
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
    int? branchId,
  });
}

class _TransactionItemUpdateImpl implements _TransactionItemUpdate {
  const _TransactionItemUpdateImpl(this.collection);

  final IsarCollection<String, TransactionItem> collection;

  @override
  bool call({
    required String id,
    Object? name = ignore,
    Object? transactionId = ignore,
    Object? variantId = ignore,
    Object? qty = ignore,
    Object? price = ignore,
    Object? discount = ignore,
    Object? type = ignore,
    Object? remainingStock = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
    Object? isTaxExempted = ignore,
    Object? isRefunded = ignore,
    Object? doneWithTransaction = ignore,
    Object? active = ignore,
    Object? dcRt = ignore,
    Object? dcAmt = ignore,
    Object? taxblAmt = ignore,
    Object? taxAmt = ignore,
    Object? totAmt = ignore,
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
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
    Object? branchId = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (name != ignore) 2: name as String?,
          if (transactionId != ignore) 3: transactionId as String?,
          if (variantId != ignore) 4: variantId as String?,
          if (qty != ignore) 5: qty as double?,
          if (price != ignore) 6: price as double?,
          if (discount != ignore) 7: discount as double?,
          if (type != ignore) 8: type as String?,
          if (remainingStock != ignore) 9: remainingStock as double?,
          if (createdAt != ignore) 10: createdAt as String?,
          if (updatedAt != ignore) 11: updatedAt as String?,
          if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
          if (isRefunded != ignore) 13: isRefunded as bool?,
          if (doneWithTransaction != ignore) 14: doneWithTransaction as bool?,
          if (active != ignore) 15: active as bool?,
          if (dcRt != ignore) 16: dcRt as double?,
          if (dcAmt != ignore) 17: dcAmt as double?,
          if (taxblAmt != ignore) 18: taxblAmt as double?,
          if (taxAmt != ignore) 19: taxAmt as double?,
          if (totAmt != ignore) 20: totAmt as double?,
          if (itemSeq != ignore) 21: itemSeq as String?,
          if (isrccCd != ignore) 22: isrccCd as String?,
          if (isrccNm != ignore) 23: isrccNm as String?,
          if (isrcRt != ignore) 24: isrcRt as String?,
          if (isrcAmt != ignore) 25: isrcAmt as String?,
          if (taxTyCd != ignore) 26: taxTyCd as String?,
          if (bcd != ignore) 27: bcd as String?,
          if (itemClsCd != ignore) 28: itemClsCd as String?,
          if (itemTyCd != ignore) 29: itemTyCd as String?,
          if (itemStdNm != ignore) 30: itemStdNm as String?,
          if (orgnNatCd != ignore) 31: orgnNatCd as String?,
          if (pkg != ignore) 32: pkg as String?,
          if (itemCd != ignore) 33: itemCd as String?,
          if (pkgUnitCd != ignore) 34: pkgUnitCd as String?,
          if (qtyUnitCd != ignore) 35: qtyUnitCd as String?,
          if (itemNm != ignore) 36: itemNm as String?,
          if (prc != ignore) 37: prc as double?,
          if (splyAmt != ignore) 38: splyAmt as double?,
          if (tin != ignore) 39: tin as int?,
          if (bhfId != ignore) 40: bhfId as String?,
          if (dftPrc != ignore) 41: dftPrc as double?,
          if (addInfo != ignore) 42: addInfo as String?,
          if (isrcAplcbYn != ignore) 43: isrcAplcbYn as String?,
          if (useYn != ignore) 44: useYn as String?,
          if (regrId != ignore) 45: regrId as String?,
          if (regrNm != ignore) 46: regrNm as String?,
          if (modrId != ignore) 47: modrId as String?,
          if (modrNm != ignore) 48: modrNm as String?,
          if (lastTouched != ignore) 49: lastTouched as DateTime?,
          if (deletedAt != ignore) 50: deletedAt as DateTime?,
          if (action != ignore) 51: action as String?,
          if (branchId != ignore) 52: branchId as int?,
        }) >
        0;
  }
}

sealed class _TransactionItemUpdateAll {
  int call({
    required List<String> id,
    String? name,
    String? transactionId,
    String? variantId,
    double? qty,
    double? price,
    double? discount,
    String? type,
    double? remainingStock,
    String? createdAt,
    String? updatedAt,
    bool? isTaxExempted,
    bool? isRefunded,
    bool? doneWithTransaction,
    bool? active,
    double? dcRt,
    double? dcAmt,
    double? taxblAmt,
    double? taxAmt,
    double? totAmt,
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
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
    int? branchId,
  });
}

class _TransactionItemUpdateAllImpl implements _TransactionItemUpdateAll {
  const _TransactionItemUpdateAllImpl(this.collection);

  final IsarCollection<String, TransactionItem> collection;

  @override
  int call({
    required List<String> id,
    Object? name = ignore,
    Object? transactionId = ignore,
    Object? variantId = ignore,
    Object? qty = ignore,
    Object? price = ignore,
    Object? discount = ignore,
    Object? type = ignore,
    Object? remainingStock = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
    Object? isTaxExempted = ignore,
    Object? isRefunded = ignore,
    Object? doneWithTransaction = ignore,
    Object? active = ignore,
    Object? dcRt = ignore,
    Object? dcAmt = ignore,
    Object? taxblAmt = ignore,
    Object? taxAmt = ignore,
    Object? totAmt = ignore,
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
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
    Object? branchId = ignore,
  }) {
    return collection.updateProperties(id, {
      if (name != ignore) 2: name as String?,
      if (transactionId != ignore) 3: transactionId as String?,
      if (variantId != ignore) 4: variantId as String?,
      if (qty != ignore) 5: qty as double?,
      if (price != ignore) 6: price as double?,
      if (discount != ignore) 7: discount as double?,
      if (type != ignore) 8: type as String?,
      if (remainingStock != ignore) 9: remainingStock as double?,
      if (createdAt != ignore) 10: createdAt as String?,
      if (updatedAt != ignore) 11: updatedAt as String?,
      if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
      if (isRefunded != ignore) 13: isRefunded as bool?,
      if (doneWithTransaction != ignore) 14: doneWithTransaction as bool?,
      if (active != ignore) 15: active as bool?,
      if (dcRt != ignore) 16: dcRt as double?,
      if (dcAmt != ignore) 17: dcAmt as double?,
      if (taxblAmt != ignore) 18: taxblAmt as double?,
      if (taxAmt != ignore) 19: taxAmt as double?,
      if (totAmt != ignore) 20: totAmt as double?,
      if (itemSeq != ignore) 21: itemSeq as String?,
      if (isrccCd != ignore) 22: isrccCd as String?,
      if (isrccNm != ignore) 23: isrccNm as String?,
      if (isrcRt != ignore) 24: isrcRt as String?,
      if (isrcAmt != ignore) 25: isrcAmt as String?,
      if (taxTyCd != ignore) 26: taxTyCd as String?,
      if (bcd != ignore) 27: bcd as String?,
      if (itemClsCd != ignore) 28: itemClsCd as String?,
      if (itemTyCd != ignore) 29: itemTyCd as String?,
      if (itemStdNm != ignore) 30: itemStdNm as String?,
      if (orgnNatCd != ignore) 31: orgnNatCd as String?,
      if (pkg != ignore) 32: pkg as String?,
      if (itemCd != ignore) 33: itemCd as String?,
      if (pkgUnitCd != ignore) 34: pkgUnitCd as String?,
      if (qtyUnitCd != ignore) 35: qtyUnitCd as String?,
      if (itemNm != ignore) 36: itemNm as String?,
      if (prc != ignore) 37: prc as double?,
      if (splyAmt != ignore) 38: splyAmt as double?,
      if (tin != ignore) 39: tin as int?,
      if (bhfId != ignore) 40: bhfId as String?,
      if (dftPrc != ignore) 41: dftPrc as double?,
      if (addInfo != ignore) 42: addInfo as String?,
      if (isrcAplcbYn != ignore) 43: isrcAplcbYn as String?,
      if (useYn != ignore) 44: useYn as String?,
      if (regrId != ignore) 45: regrId as String?,
      if (regrNm != ignore) 46: regrNm as String?,
      if (modrId != ignore) 47: modrId as String?,
      if (modrNm != ignore) 48: modrNm as String?,
      if (lastTouched != ignore) 49: lastTouched as DateTime?,
      if (deletedAt != ignore) 50: deletedAt as DateTime?,
      if (action != ignore) 51: action as String?,
      if (branchId != ignore) 52: branchId as int?,
    });
  }
}

extension TransactionItemUpdate on IsarCollection<String, TransactionItem> {
  _TransactionItemUpdate get update => _TransactionItemUpdateImpl(this);

  _TransactionItemUpdateAll get updateAll =>
      _TransactionItemUpdateAllImpl(this);
}

sealed class _TransactionItemQueryUpdate {
  int call({
    String? name,
    String? transactionId,
    String? variantId,
    double? qty,
    double? price,
    double? discount,
    String? type,
    double? remainingStock,
    String? createdAt,
    String? updatedAt,
    bool? isTaxExempted,
    bool? isRefunded,
    bool? doneWithTransaction,
    bool? active,
    double? dcRt,
    double? dcAmt,
    double? taxblAmt,
    double? taxAmt,
    double? totAmt,
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
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
    int? branchId,
  });
}

class _TransactionItemQueryUpdateImpl implements _TransactionItemQueryUpdate {
  const _TransactionItemQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<TransactionItem> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? transactionId = ignore,
    Object? variantId = ignore,
    Object? qty = ignore,
    Object? price = ignore,
    Object? discount = ignore,
    Object? type = ignore,
    Object? remainingStock = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
    Object? isTaxExempted = ignore,
    Object? isRefunded = ignore,
    Object? doneWithTransaction = ignore,
    Object? active = ignore,
    Object? dcRt = ignore,
    Object? dcAmt = ignore,
    Object? taxblAmt = ignore,
    Object? taxAmt = ignore,
    Object? totAmt = ignore,
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
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
    Object? branchId = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (name != ignore) 2: name as String?,
      if (transactionId != ignore) 3: transactionId as String?,
      if (variantId != ignore) 4: variantId as String?,
      if (qty != ignore) 5: qty as double?,
      if (price != ignore) 6: price as double?,
      if (discount != ignore) 7: discount as double?,
      if (type != ignore) 8: type as String?,
      if (remainingStock != ignore) 9: remainingStock as double?,
      if (createdAt != ignore) 10: createdAt as String?,
      if (updatedAt != ignore) 11: updatedAt as String?,
      if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
      if (isRefunded != ignore) 13: isRefunded as bool?,
      if (doneWithTransaction != ignore) 14: doneWithTransaction as bool?,
      if (active != ignore) 15: active as bool?,
      if (dcRt != ignore) 16: dcRt as double?,
      if (dcAmt != ignore) 17: dcAmt as double?,
      if (taxblAmt != ignore) 18: taxblAmt as double?,
      if (taxAmt != ignore) 19: taxAmt as double?,
      if (totAmt != ignore) 20: totAmt as double?,
      if (itemSeq != ignore) 21: itemSeq as String?,
      if (isrccCd != ignore) 22: isrccCd as String?,
      if (isrccNm != ignore) 23: isrccNm as String?,
      if (isrcRt != ignore) 24: isrcRt as String?,
      if (isrcAmt != ignore) 25: isrcAmt as String?,
      if (taxTyCd != ignore) 26: taxTyCd as String?,
      if (bcd != ignore) 27: bcd as String?,
      if (itemClsCd != ignore) 28: itemClsCd as String?,
      if (itemTyCd != ignore) 29: itemTyCd as String?,
      if (itemStdNm != ignore) 30: itemStdNm as String?,
      if (orgnNatCd != ignore) 31: orgnNatCd as String?,
      if (pkg != ignore) 32: pkg as String?,
      if (itemCd != ignore) 33: itemCd as String?,
      if (pkgUnitCd != ignore) 34: pkgUnitCd as String?,
      if (qtyUnitCd != ignore) 35: qtyUnitCd as String?,
      if (itemNm != ignore) 36: itemNm as String?,
      if (prc != ignore) 37: prc as double?,
      if (splyAmt != ignore) 38: splyAmt as double?,
      if (tin != ignore) 39: tin as int?,
      if (bhfId != ignore) 40: bhfId as String?,
      if (dftPrc != ignore) 41: dftPrc as double?,
      if (addInfo != ignore) 42: addInfo as String?,
      if (isrcAplcbYn != ignore) 43: isrcAplcbYn as String?,
      if (useYn != ignore) 44: useYn as String?,
      if (regrId != ignore) 45: regrId as String?,
      if (regrNm != ignore) 46: regrNm as String?,
      if (modrId != ignore) 47: modrId as String?,
      if (modrNm != ignore) 48: modrNm as String?,
      if (lastTouched != ignore) 49: lastTouched as DateTime?,
      if (deletedAt != ignore) 50: deletedAt as DateTime?,
      if (action != ignore) 51: action as String?,
      if (branchId != ignore) 52: branchId as int?,
    });
  }
}

extension TransactionItemQueryUpdate on IsarQuery<TransactionItem> {
  _TransactionItemQueryUpdate get updateFirst =>
      _TransactionItemQueryUpdateImpl(this, limit: 1);

  _TransactionItemQueryUpdate get updateAll =>
      _TransactionItemQueryUpdateImpl(this);
}

class _TransactionItemQueryBuilderUpdateImpl
    implements _TransactionItemQueryUpdate {
  const _TransactionItemQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<TransactionItem, TransactionItem, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? name = ignore,
    Object? transactionId = ignore,
    Object? variantId = ignore,
    Object? qty = ignore,
    Object? price = ignore,
    Object? discount = ignore,
    Object? type = ignore,
    Object? remainingStock = ignore,
    Object? createdAt = ignore,
    Object? updatedAt = ignore,
    Object? isTaxExempted = ignore,
    Object? isRefunded = ignore,
    Object? doneWithTransaction = ignore,
    Object? active = ignore,
    Object? dcRt = ignore,
    Object? dcAmt = ignore,
    Object? taxblAmt = ignore,
    Object? taxAmt = ignore,
    Object? totAmt = ignore,
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
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
    Object? branchId = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (name != ignore) 2: name as String?,
        if (transactionId != ignore) 3: transactionId as String?,
        if (variantId != ignore) 4: variantId as String?,
        if (qty != ignore) 5: qty as double?,
        if (price != ignore) 6: price as double?,
        if (discount != ignore) 7: discount as double?,
        if (type != ignore) 8: type as String?,
        if (remainingStock != ignore) 9: remainingStock as double?,
        if (createdAt != ignore) 10: createdAt as String?,
        if (updatedAt != ignore) 11: updatedAt as String?,
        if (isTaxExempted != ignore) 12: isTaxExempted as bool?,
        if (isRefunded != ignore) 13: isRefunded as bool?,
        if (doneWithTransaction != ignore) 14: doneWithTransaction as bool?,
        if (active != ignore) 15: active as bool?,
        if (dcRt != ignore) 16: dcRt as double?,
        if (dcAmt != ignore) 17: dcAmt as double?,
        if (taxblAmt != ignore) 18: taxblAmt as double?,
        if (taxAmt != ignore) 19: taxAmt as double?,
        if (totAmt != ignore) 20: totAmt as double?,
        if (itemSeq != ignore) 21: itemSeq as String?,
        if (isrccCd != ignore) 22: isrccCd as String?,
        if (isrccNm != ignore) 23: isrccNm as String?,
        if (isrcRt != ignore) 24: isrcRt as String?,
        if (isrcAmt != ignore) 25: isrcAmt as String?,
        if (taxTyCd != ignore) 26: taxTyCd as String?,
        if (bcd != ignore) 27: bcd as String?,
        if (itemClsCd != ignore) 28: itemClsCd as String?,
        if (itemTyCd != ignore) 29: itemTyCd as String?,
        if (itemStdNm != ignore) 30: itemStdNm as String?,
        if (orgnNatCd != ignore) 31: orgnNatCd as String?,
        if (pkg != ignore) 32: pkg as String?,
        if (itemCd != ignore) 33: itemCd as String?,
        if (pkgUnitCd != ignore) 34: pkgUnitCd as String?,
        if (qtyUnitCd != ignore) 35: qtyUnitCd as String?,
        if (itemNm != ignore) 36: itemNm as String?,
        if (prc != ignore) 37: prc as double?,
        if (splyAmt != ignore) 38: splyAmt as double?,
        if (tin != ignore) 39: tin as int?,
        if (bhfId != ignore) 40: bhfId as String?,
        if (dftPrc != ignore) 41: dftPrc as double?,
        if (addInfo != ignore) 42: addInfo as String?,
        if (isrcAplcbYn != ignore) 43: isrcAplcbYn as String?,
        if (useYn != ignore) 44: useYn as String?,
        if (regrId != ignore) 45: regrId as String?,
        if (regrNm != ignore) 46: regrNm as String?,
        if (modrId != ignore) 47: modrId as String?,
        if (modrNm != ignore) 48: modrNm as String?,
        if (lastTouched != ignore) 49: lastTouched as DateTime?,
        if (deletedAt != ignore) 50: deletedAt as DateTime?,
        if (action != ignore) 51: action as String?,
        if (branchId != ignore) 52: branchId as int?,
      });
    } finally {
      q.close();
    }
  }
}

extension TransactionItemQueryBuilderUpdate
    on QueryBuilder<TransactionItem, TransactionItem, QOperations> {
  _TransactionItemQueryUpdate get updateFirst =>
      _TransactionItemQueryBuilderUpdateImpl(this, limit: 1);

  _TransactionItemQueryUpdate get updateAll =>
      _TransactionItemQueryBuilderUpdateImpl(this);
}

extension TransactionItemQueryFilter
    on QueryBuilder<TransactionItem, TransactionItem, QFilterCondition> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 7,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeEqualTo(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeLessThan(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 9,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 9,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtEqualTo(
    String value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtGreaterThan(
    String value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtGreaterThanOrEqualTo(
    String value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtLessThan(
    String value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtLessThanOrEqualTo(
    String value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtBetween(
    String lower,
    String upper, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 11,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isTaxExemptedEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isRefundedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isRefundedIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isRefundedEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 13,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      doneWithTransactionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      doneWithTransactionIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      doneWithTransactionEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 14,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      activeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      activeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      activeEqualTo(
    bool? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 16,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 16,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 17,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 17,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 18,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 18,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 18,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 18,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 18,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 18,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 19,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 19,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 19,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 19,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 19,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 19,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 20,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 20,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 20,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 20,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 20,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 20,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 21));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 21));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 22));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 22));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 22,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 22,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 23));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 23));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 23,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 23,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 24));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 24));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 24,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 24,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 25));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 25));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 25,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 25,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 26));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 26));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 26,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 26,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 27));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 27));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 27,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 27,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 28));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 28));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 28,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 28,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 29));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 29));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 29,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 29,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 29,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 29,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 29,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 30));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 30));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 30,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 30,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 30,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 30,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 30,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 31));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 31));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 31,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 31,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 31,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 31,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 31,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 32));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 32));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 32,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 32,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 32,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 32,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 32,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 33));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 33));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 33,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 33,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 34));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 34));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 34,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 34,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 34,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 34,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 34,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 35));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 35));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 35,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 35,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 36));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 36));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 36,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 36,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 37));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 37));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 37,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 37,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 37,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 37,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 37,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 37,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 38));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 38));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 38,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 38,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 38,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 38,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 38,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 38,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 39));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 39));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 39,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 39,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 39,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 39,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 39,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 39,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 40));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 40));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdGreaterThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdGreaterThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdLessThan(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdLessThanOrEqualTo(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdBetween(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 40,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 40,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 41));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 41));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 41,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 41,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 41,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 41,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 41,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 41,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 42));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 42));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 42,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 42,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 42,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 42,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 42,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 43));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 43));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 43,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 43,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 43,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 43,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 43,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 44));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 44));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 44,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 44,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 44,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 44,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 44,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 45));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 45));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 45,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 45,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 45,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 45,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 45,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 46));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 46));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmEqualTo(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmGreaterThan(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmLessThan(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmStartsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmEndsWith(
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmMatches(String pattern, {bool caseSensitive = true}) {
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

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 46,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 46,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 47));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 47));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 47,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 47,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 47,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 47,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 47,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 48));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 48));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 48,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 48,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 48,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 48,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 48,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 49));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 49));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 49,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 49,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 49,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 49,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 49,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 49,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 50));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 50));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 50,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 50,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 50,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 50,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 50,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 50,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 51,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 51,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 51,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 51,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 51,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      branchIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 52,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      branchIdGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 52,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      branchIdGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 52,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      branchIdLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 52,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      branchIdLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 52,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      branchIdBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 52,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension TransactionItemQueryObject
    on QueryBuilder<TransactionItem, TransactionItem, QFilterCondition> {}

extension TransactionItemQuerySortBy
    on QueryBuilder<TransactionItem, TransactionItem, QSortBy> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTransactionIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByVariantId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByVariantIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTypeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRemainingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByCreatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByCreatedAtDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByUpdatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByUpdatedAtDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsRefundedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDoneWithTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDoneWithTransactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemSeqDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        22,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrccCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        22,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        23,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrccNmDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        23,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        24,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrcRtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        24,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        25,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrcAmtDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        25,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        26,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxTyCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        26,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        27,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByBcdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        27,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        28,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemClsCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        28,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        29,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemTyCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        29,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        30,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemStdNmDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        30,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        31,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByOrgnNatCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        31,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        32,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPkgDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        32,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        33,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        33,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        34,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByPkgUnitCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        34,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        35,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByQtyUnitCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        35,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        36,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        36,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        40,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        40,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        42,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByAddInfoDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        42,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrcAplcbYn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        43,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrcAplcbYnDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        43,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        44,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByUseYnDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        44,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        45,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByRegrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        45,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        46,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByRegrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        46,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        47,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByModrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        47,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        48,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByModrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        48,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(49);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(49, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(50);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(50, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        51,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        51,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(52);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(52, sort: Sort.desc);
    });
  }
}

extension TransactionItemQuerySortThenBy
    on QueryBuilder<TransactionItem, TransactionItem, QSortThenBy> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTransactionIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByVariantId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByVariantIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTypeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRemainingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByCreatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByCreatedAtDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByUpdatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByUpdatedAtDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsRefundedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDoneWithTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDoneWithTransactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemSeqDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrccCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrccNmDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(24, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrcRtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(24, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrcAmtDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxTyCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByBcdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemClsCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemTyCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemStdNmDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByOrgnNatCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPkgDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByPkgUnitCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByQtyUnitCdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByAddInfoDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrcAplcbYn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrcAplcbYnDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByUseYnDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByRegrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(46, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByRegrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(46, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(47, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByModrIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(47, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(48, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByModrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(48, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(49);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(49, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(50);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(50, sort: Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(51, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(51, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(52);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByBranchIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(52, sort: Sort.desc);
    });
  }
}

extension TransactionItemQueryWhereDistinct
    on QueryBuilder<TransactionItem, TransactionItem, QDistinct> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByVariantId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByCreatedAt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByUpdatedAt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByDoneWithTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByItemSeq({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(21, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByIsrccCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(22, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByIsrccNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(23, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByIsrcRt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(24, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByIsrcAmt({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(25, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByTaxTyCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(26, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct> distinctByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(27, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByItemClsCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(28, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByItemTyCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(29, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByItemStdNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(30, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByOrgnNatCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(31, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct> distinctByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(32, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByItemCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(33, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByPkgUnitCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(34, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByQtyUnitCd({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(35, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByItemNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(36, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(37);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(38);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(39);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByBhfId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(40, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(41);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByAddInfo({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(42, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByIsrcAplcbYn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(43, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByUseYn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(44, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByRegrId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(45, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByRegrNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(46, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByModrId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(47, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByModrNm({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(48, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(49);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(50);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByAction({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(51, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterDistinct>
      distinctByBranchId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(52);
    });
  }
}

extension TransactionItemQueryProperty1
    on QueryBuilder<TransactionItem, TransactionItem, QProperty> {
  QueryBuilder<TransactionItem, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TransactionItem, String, QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TransactionItem, String, QAfterProperty>
      transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TransactionItem, String, QAfterProperty> variantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TransactionItem, double, QAfterProperty> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<TransactionItem, double, QAfterProperty> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<TransactionItem, double, QAfterProperty>
      remainingStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<TransactionItem, String, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<TransactionItem, String, QAfterProperty> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<TransactionItem, bool, QAfterProperty> isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<TransactionItem, bool?, QAfterProperty> isRefundedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<TransactionItem, bool?, QAfterProperty>
      doneWithTransactionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<TransactionItem, bool?, QAfterProperty> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> dcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> dcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> taxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> taxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<TransactionItem, int?, QAfterProperty> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<TransactionItem, double?, QAfterProperty> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(46);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(47);
    });
  }

  QueryBuilder<TransactionItem, String?, QAfterProperty> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(48);
    });
  }

  QueryBuilder<TransactionItem, DateTime?, QAfterProperty>
      lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(49);
    });
  }

  QueryBuilder<TransactionItem, DateTime?, QAfterProperty> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(50);
    });
  }

  QueryBuilder<TransactionItem, String, QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(51);
    });
  }

  QueryBuilder<TransactionItem, int, QAfterProperty> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(52);
    });
  }
}

extension TransactionItemQueryProperty2<R>
    on QueryBuilder<TransactionItem, R, QAfterProperty> {
  QueryBuilder<TransactionItem, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TransactionItem, (R, String), QAfterProperty> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TransactionItem, (R, String), QAfterProperty>
      transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TransactionItem, (R, String), QAfterProperty>
      variantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TransactionItem, (R, double), QAfterProperty> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<TransactionItem, (R, double), QAfterProperty> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty>
      discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<TransactionItem, (R, double), QAfterProperty>
      remainingStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<TransactionItem, (R, String), QAfterProperty>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<TransactionItem, (R, String), QAfterProperty>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<TransactionItem, (R, bool), QAfterProperty>
      isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<TransactionItem, (R, bool?), QAfterProperty>
      isRefundedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<TransactionItem, (R, bool?), QAfterProperty>
      doneWithTransactionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<TransactionItem, (R, bool?), QAfterProperty> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty> dcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty> dcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty>
      taxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty> taxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty>
      splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<TransactionItem, (R, int?), QAfterProperty> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<TransactionItem, (R, double?), QAfterProperty> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty>
      isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(46);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(47);
    });
  }

  QueryBuilder<TransactionItem, (R, String?), QAfterProperty> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(48);
    });
  }

  QueryBuilder<TransactionItem, (R, DateTime?), QAfterProperty>
      lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(49);
    });
  }

  QueryBuilder<TransactionItem, (R, DateTime?), QAfterProperty>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(50);
    });
  }

  QueryBuilder<TransactionItem, (R, String), QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(51);
    });
  }

  QueryBuilder<TransactionItem, (R, int), QAfterProperty> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(52);
    });
  }
}

extension TransactionItemQueryProperty3<R1, R2>
    on QueryBuilder<TransactionItem, (R1, R2), QAfterProperty> {
  QueryBuilder<TransactionItem, (R1, R2, String), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String), QOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String), QOperations>
      transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String), QOperations>
      variantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double), QOperations> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double), QOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations>
      discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double), QOperations>
      remainingStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String), QOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String), QOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, bool), QOperations>
      isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, bool?), QOperations>
      isRefundedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, bool?), QOperations>
      doneWithTransactionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, bool?), QOperations> activeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations> dcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations>
      dcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations>
      taxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations>
      taxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations>
      totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations>
      splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, int?), QOperations> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, double?), QOperations>
      dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(46);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(47);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String?), QOperations>
      modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(48);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, DateTime?), QOperations>
      lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(49);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, DateTime?), QOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(50);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, String), QOperations>
      actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(51);
    });
  }

  QueryBuilder<TransactionItem, (R1, R2, int), QOperations> branchIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(52);
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      id: json['id'] as String,
      action: json['action'] as String,
      name: json['name'] as String,
      transactionId: json['transactionId'] as String,
      variantId: json['variantId'] as String,
      qty: (json['qty'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      branchId: json['branchId'] as int,
      discount: (json['discount'] as num?)?.toDouble(),
      type: json['type'] as String?,
      remainingStock: (json['remainingStock'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isTaxExempted: json['isTaxExempted'] as bool,
      isRefunded: json['isRefunded'] as bool?,
      doneWithTransaction: json['doneWithTransaction'] as bool?,
      active: json['active'] as bool?,
      dcRt: (json['dcRt'] as num?)?.toDouble(),
      dcAmt: (json['dcAmt'] as num?)?.toDouble(),
      taxblAmt: (json['taxblAmt'] as num?)?.toDouble(),
      taxAmt: (json['taxAmt'] as num?)?.toDouble(),
      totAmt: (json['totAmt'] as num?)?.toDouble(),
      itemSeq: json['itemSeq'] as String?,
      isrccCd: json['isrccCd'] as String?,
      isrccNm: json['isrccNm'] as String?,
      isrcRt: json['isrcRt'] as String?,
      isrcAmt: json['isrcAmt'] as String?,
      taxTyCd: json['taxTyCd'] as String?,
      bcd: json['bcd'] as String?,
      itemClsCd: json['itemClsCd'] as String?,
      itemTyCd: json['itemTyCd'] as String?,
      itemStdNm: json['itemStdNm'] as String?,
      orgnNatCd: json['orgnNatCd'] as String?,
      pkg: json['pkg'] as String?,
      itemCd: json['itemCd'] as String?,
      pkgUnitCd: json['pkgUnitCd'] as String?,
      qtyUnitCd: json['qtyUnitCd'] as String?,
      itemNm: json['itemNm'] as String?,
      prc: (json['prc'] as num?)?.toDouble(),
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
      lastTouched:
          TransactionItem._dateTimeFromJson(json['lastTouched'] as String?),
      deletedAt:
          TransactionItem._dateTimeFromJson(json['deletedAt'] as String?),
    );

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'transactionId': instance.transactionId,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'price': instance.price,
      'discount': instance.discount,
      'type': instance.type,
      'remainingStock': instance.remainingStock,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isTaxExempted': instance.isTaxExempted,
      'isRefunded': instance.isRefunded,
      'doneWithTransaction': instance.doneWithTransaction,
      'active': instance.active,
      'dcRt': instance.dcRt,
      'dcAmt': instance.dcAmt,
      'taxblAmt': instance.taxblAmt,
      'taxAmt': instance.taxAmt,
      'totAmt': instance.totAmt,
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
      'lastTouched': TransactionItem._dateTimeToJson(instance.lastTouched),
      'deletedAt': TransactionItem._dateTimeToJson(instance.deletedAt),
      'action': instance.action,
      'branchId': instance.branchId,
    };
