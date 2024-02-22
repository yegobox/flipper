// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetPurchaseCollection on Isar {
  IsarCollection<String, Purchase> get purchases => this.collection();
}

const PurchaseSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'Purchase',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'id',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'itemIds',
        type: IsarType.stringList,
      ),
      IsarPropertySchema(
        name: 'lastTouched',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'createdAt',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'action',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'tin',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'bhfId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'invcNo',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'orgInvcNo',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'spplrTin',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'spplrBhfId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'spplrNm',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'spplrInvcNo',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'regTyCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'pchsTyCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'rcptTyCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'pmtTyCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'pchsSttsCd',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'cfmDt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'pchsDt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'wrhsDt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'cnclReqDt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'cnclDt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'rfdDt',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'totItemCnt',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'taxblAmtA',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxblAmtB',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxblAmtC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxblAmtD',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxRtA',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxRtB',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxRtC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxRtD',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxAmtA',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxAmtB',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxAmtC',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'taxAmtD',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'totTaxblAmt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'totTaxAmt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'totAmt',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'remark',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'modrId',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'modrNm',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'regrId',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'deletedAt',
        type: IsarType.dateTime,
      ),
    ],
    indexes: [],
  ),
  converter: IsarObjectConverter<String, Purchase>(
    serialize: serializePurchase,
    deserialize: deserializePurchase,
    deserializeProperty: deserializePurchaseProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializePurchase(IsarWriter writer, Purchase object) {
  IsarCore.writeString(writer, 1, object.id);
  {
    final list = object.itemIds;
    final listWriter = IsarCore.beginList(writer, 2, list.length);
    for (var i = 0; i < list.length; i++) {
      IsarCore.writeString(listWriter, i, list[i]);
    }
    IsarCore.endList(writer, listWriter);
  }
  IsarCore.writeLong(
      writer,
      3,
      object.lastTouched?.toUtc().microsecondsSinceEpoch ??
          -9223372036854775808);
  IsarCore.writeLong(
      writer, 4, object.createdAt.toUtc().microsecondsSinceEpoch);
  IsarCore.writeString(writer, 5, object.action);
  {
    final value = object.tin;
    if (value == null) {
      IsarCore.writeNull(writer, 6);
    } else {
      IsarCore.writeString(writer, 6, value);
    }
  }
  {
    final value = object.bhfId;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  IsarCore.writeLong(writer, 8, object.invcNo ?? -9223372036854775808);
  IsarCore.writeLong(writer, 9, object.orgInvcNo ?? -9223372036854775808);
  {
    final value = object.spplrTin;
    if (value == null) {
      IsarCore.writeNull(writer, 10);
    } else {
      IsarCore.writeString(writer, 10, value);
    }
  }
  {
    final value = object.spplrBhfId;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  {
    final value = object.spplrNm;
    if (value == null) {
      IsarCore.writeNull(writer, 12);
    } else {
      IsarCore.writeString(writer, 12, value);
    }
  }
  {
    final value = object.spplrInvcNo;
    if (value == null) {
      IsarCore.writeNull(writer, 13);
    } else {
      IsarCore.writeString(writer, 13, value);
    }
  }
  {
    final value = object.regTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 14);
    } else {
      IsarCore.writeString(writer, 14, value);
    }
  }
  {
    final value = object.pchsTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 15);
    } else {
      IsarCore.writeString(writer, 15, value);
    }
  }
  {
    final value = object.rcptTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 16);
    } else {
      IsarCore.writeString(writer, 16, value);
    }
  }
  {
    final value = object.pmtTyCd;
    if (value == null) {
      IsarCore.writeNull(writer, 17);
    } else {
      IsarCore.writeString(writer, 17, value);
    }
  }
  {
    final value = object.pchsSttsCd;
    if (value == null) {
      IsarCore.writeNull(writer, 18);
    } else {
      IsarCore.writeString(writer, 18, value);
    }
  }
  {
    final value = object.cfmDt;
    if (value == null) {
      IsarCore.writeNull(writer, 19);
    } else {
      IsarCore.writeString(writer, 19, value);
    }
  }
  {
    final value = object.pchsDt;
    if (value == null) {
      IsarCore.writeNull(writer, 20);
    } else {
      IsarCore.writeString(writer, 20, value);
    }
  }
  {
    final value = object.wrhsDt;
    if (value == null) {
      IsarCore.writeNull(writer, 21);
    } else {
      IsarCore.writeString(writer, 21, value);
    }
  }
  {
    final value = object.cnclReqDt;
    if (value == null) {
      IsarCore.writeNull(writer, 22);
    } else {
      IsarCore.writeString(writer, 22, value);
    }
  }
  {
    final value = object.cnclDt;
    if (value == null) {
      IsarCore.writeNull(writer, 23);
    } else {
      IsarCore.writeString(writer, 23, value);
    }
  }
  {
    final value = object.rfdDt;
    if (value == null) {
      IsarCore.writeNull(writer, 24);
    } else {
      IsarCore.writeString(writer, 24, value);
    }
  }
  IsarCore.writeLong(writer, 25, object.totItemCnt ?? -9223372036854775808);
  IsarCore.writeDouble(writer, 26, object.taxblAmtA ?? double.nan);
  IsarCore.writeDouble(writer, 27, object.taxblAmtB ?? double.nan);
  IsarCore.writeDouble(writer, 28, object.taxblAmtC ?? double.nan);
  IsarCore.writeDouble(writer, 29, object.taxblAmtD ?? double.nan);
  IsarCore.writeDouble(writer, 30, object.taxRtA ?? double.nan);
  IsarCore.writeDouble(writer, 31, object.taxRtB ?? double.nan);
  IsarCore.writeDouble(writer, 32, object.taxRtC ?? double.nan);
  IsarCore.writeDouble(writer, 33, object.taxRtD ?? double.nan);
  IsarCore.writeDouble(writer, 34, object.taxAmtA ?? double.nan);
  IsarCore.writeDouble(writer, 35, object.taxAmtB ?? double.nan);
  IsarCore.writeDouble(writer, 36, object.taxAmtC ?? double.nan);
  IsarCore.writeDouble(writer, 37, object.taxAmtD ?? double.nan);
  IsarCore.writeDouble(writer, 38, object.totTaxblAmt ?? double.nan);
  IsarCore.writeDouble(writer, 39, object.totTaxAmt ?? double.nan);
  IsarCore.writeDouble(writer, 40, object.totAmt ?? double.nan);
  {
    final value = object.remark;
    if (value == null) {
      IsarCore.writeNull(writer, 41);
    } else {
      IsarCore.writeString(writer, 41, value);
    }
  }
  IsarCore.writeLong(writer, 42, object.modrId ?? -9223372036854775808);
  {
    final value = object.modrNm;
    if (value == null) {
      IsarCore.writeNull(writer, 43);
    } else {
      IsarCore.writeString(writer, 43, value);
    }
  }
  IsarCore.writeLong(writer, 44, object.regrId ?? -9223372036854775808);
  IsarCore.writeLong(writer, 45,
      object.deletedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808);
  return Isar.fastHash(object.id);
}

@isarProtected
Purchase deserializePurchase(IsarReader reader) {
  final String _id;
  _id = IsarCore.readString(reader, 1) ?? '';
  final List<String> _itemIds;
  {
    final length = IsarCore.readList(reader, 2, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        _itemIds = const <String>[];
      } else {
        final list = List<String>.filled(length, '', growable: true);
        for (var i = 0; i < length; i++) {
          list[i] = IsarCore.readString(reader, i) ?? '';
        }
        IsarCore.freeReader(reader);
        _itemIds = list;
      }
    }
  }
  final DateTime? _lastTouched;
  {
    final value = IsarCore.readLong(reader, 3);
    if (value == -9223372036854775808) {
      _lastTouched = null;
    } else {
      _lastTouched =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final DateTime _createdAt;
  {
    final value = IsarCore.readLong(reader, 4);
    if (value == -9223372036854775808) {
      _createdAt =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      _createdAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  final String _action;
  _action = IsarCore.readString(reader, 5) ?? '';
  final String? _tin;
  _tin = IsarCore.readString(reader, 6);
  final String? _bhfId;
  _bhfId = IsarCore.readString(reader, 7);
  final int? _invcNo;
  {
    final value = IsarCore.readLong(reader, 8);
    if (value == -9223372036854775808) {
      _invcNo = null;
    } else {
      _invcNo = value;
    }
  }
  final int? _orgInvcNo;
  {
    final value = IsarCore.readLong(reader, 9);
    if (value == -9223372036854775808) {
      _orgInvcNo = null;
    } else {
      _orgInvcNo = value;
    }
  }
  final String? _spplrTin;
  _spplrTin = IsarCore.readString(reader, 10);
  final String? _spplrBhfId;
  _spplrBhfId = IsarCore.readString(reader, 11);
  final String? _spplrNm;
  _spplrNm = IsarCore.readString(reader, 12);
  final String? _spplrInvcNo;
  _spplrInvcNo = IsarCore.readString(reader, 13);
  final String? _regTyCd;
  _regTyCd = IsarCore.readString(reader, 14);
  final String? _pchsTyCd;
  _pchsTyCd = IsarCore.readString(reader, 15);
  final String? _rcptTyCd;
  _rcptTyCd = IsarCore.readString(reader, 16);
  final String? _pmtTyCd;
  _pmtTyCd = IsarCore.readString(reader, 17);
  final String? _pchsSttsCd;
  _pchsSttsCd = IsarCore.readString(reader, 18);
  final String? _cfmDt;
  _cfmDt = IsarCore.readString(reader, 19);
  final String? _pchsDt;
  _pchsDt = IsarCore.readString(reader, 20);
  final String? _wrhsDt;
  _wrhsDt = IsarCore.readString(reader, 21);
  final String? _cnclReqDt;
  _cnclReqDt = IsarCore.readString(reader, 22);
  final String? _cnclDt;
  _cnclDt = IsarCore.readString(reader, 23);
  final String? _rfdDt;
  _rfdDt = IsarCore.readString(reader, 24);
  final int? _totItemCnt;
  {
    final value = IsarCore.readLong(reader, 25);
    if (value == -9223372036854775808) {
      _totItemCnt = null;
    } else {
      _totItemCnt = value;
    }
  }
  final double? _taxblAmtA;
  {
    final value = IsarCore.readDouble(reader, 26);
    if (value.isNaN) {
      _taxblAmtA = null;
    } else {
      _taxblAmtA = value;
    }
  }
  final double? _taxblAmtB;
  {
    final value = IsarCore.readDouble(reader, 27);
    if (value.isNaN) {
      _taxblAmtB = null;
    } else {
      _taxblAmtB = value;
    }
  }
  final double? _taxblAmtC;
  {
    final value = IsarCore.readDouble(reader, 28);
    if (value.isNaN) {
      _taxblAmtC = null;
    } else {
      _taxblAmtC = value;
    }
  }
  final double? _taxblAmtD;
  {
    final value = IsarCore.readDouble(reader, 29);
    if (value.isNaN) {
      _taxblAmtD = null;
    } else {
      _taxblAmtD = value;
    }
  }
  final double? _taxRtA;
  {
    final value = IsarCore.readDouble(reader, 30);
    if (value.isNaN) {
      _taxRtA = null;
    } else {
      _taxRtA = value;
    }
  }
  final double? _taxRtB;
  {
    final value = IsarCore.readDouble(reader, 31);
    if (value.isNaN) {
      _taxRtB = null;
    } else {
      _taxRtB = value;
    }
  }
  final double? _taxRtC;
  {
    final value = IsarCore.readDouble(reader, 32);
    if (value.isNaN) {
      _taxRtC = null;
    } else {
      _taxRtC = value;
    }
  }
  final double? _taxRtD;
  {
    final value = IsarCore.readDouble(reader, 33);
    if (value.isNaN) {
      _taxRtD = null;
    } else {
      _taxRtD = value;
    }
  }
  final double? _taxAmtA;
  {
    final value = IsarCore.readDouble(reader, 34);
    if (value.isNaN) {
      _taxAmtA = null;
    } else {
      _taxAmtA = value;
    }
  }
  final double? _taxAmtB;
  {
    final value = IsarCore.readDouble(reader, 35);
    if (value.isNaN) {
      _taxAmtB = null;
    } else {
      _taxAmtB = value;
    }
  }
  final double? _taxAmtC;
  {
    final value = IsarCore.readDouble(reader, 36);
    if (value.isNaN) {
      _taxAmtC = null;
    } else {
      _taxAmtC = value;
    }
  }
  final double? _taxAmtD;
  {
    final value = IsarCore.readDouble(reader, 37);
    if (value.isNaN) {
      _taxAmtD = null;
    } else {
      _taxAmtD = value;
    }
  }
  final double? _totTaxblAmt;
  {
    final value = IsarCore.readDouble(reader, 38);
    if (value.isNaN) {
      _totTaxblAmt = null;
    } else {
      _totTaxblAmt = value;
    }
  }
  final double? _totTaxAmt;
  {
    final value = IsarCore.readDouble(reader, 39);
    if (value.isNaN) {
      _totTaxAmt = null;
    } else {
      _totTaxAmt = value;
    }
  }
  final double? _totAmt;
  {
    final value = IsarCore.readDouble(reader, 40);
    if (value.isNaN) {
      _totAmt = null;
    } else {
      _totAmt = value;
    }
  }
  final String? _remark;
  _remark = IsarCore.readString(reader, 41);
  final int? _modrId;
  {
    final value = IsarCore.readLong(reader, 42);
    if (value == -9223372036854775808) {
      _modrId = null;
    } else {
      _modrId = value;
    }
  }
  final String? _modrNm;
  _modrNm = IsarCore.readString(reader, 43);
  final int? _regrId;
  {
    final value = IsarCore.readLong(reader, 44);
    if (value == -9223372036854775808) {
      _regrId = null;
    } else {
      _regrId = value;
    }
  }
  final object = Purchase(
    id: _id,
    itemIds: _itemIds,
    lastTouched: _lastTouched,
    createdAt: _createdAt,
    action: _action,
    tin: _tin,
    bhfId: _bhfId,
    invcNo: _invcNo,
    orgInvcNo: _orgInvcNo,
    spplrTin: _spplrTin,
    spplrBhfId: _spplrBhfId,
    spplrNm: _spplrNm,
    spplrInvcNo: _spplrInvcNo,
    regTyCd: _regTyCd,
    pchsTyCd: _pchsTyCd,
    rcptTyCd: _rcptTyCd,
    pmtTyCd: _pmtTyCd,
    pchsSttsCd: _pchsSttsCd,
    cfmDt: _cfmDt,
    pchsDt: _pchsDt,
    wrhsDt: _wrhsDt,
    cnclReqDt: _cnclReqDt,
    cnclDt: _cnclDt,
    rfdDt: _rfdDt,
    totItemCnt: _totItemCnt,
    taxblAmtA: _taxblAmtA,
    taxblAmtB: _taxblAmtB,
    taxblAmtC: _taxblAmtC,
    taxblAmtD: _taxblAmtD,
    taxRtA: _taxRtA,
    taxRtB: _taxRtB,
    taxRtC: _taxRtC,
    taxRtD: _taxRtD,
    taxAmtA: _taxAmtA,
    taxAmtB: _taxAmtB,
    taxAmtC: _taxAmtC,
    taxAmtD: _taxAmtD,
    totTaxblAmt: _totTaxblAmt,
    totTaxAmt: _totTaxAmt,
    totAmt: _totAmt,
    remark: _remark,
    modrId: _modrId,
    modrNm: _modrNm,
    regrId: _regrId,
  );
  {
    final value = IsarCore.readLong(reader, 45);
    if (value == -9223372036854775808) {
      object.deletedAt = null;
    } else {
      object.deletedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  return object;
}

@isarProtected
dynamic deserializePurchaseProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      {
        final length = IsarCore.readList(reader, 2, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const <String>[];
          } else {
            final list = List<String>.filled(length, '', growable: true);
            for (var i = 0; i < length; i++) {
              list[i] = IsarCore.readString(reader, i) ?? '';
            }
            IsarCore.freeReader(reader);
            return list;
          }
        }
      }
    case 3:
      {
        final value = IsarCore.readLong(reader, 3);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 4:
      {
        final value = IsarCore.readLong(reader, 4);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 5:
      return IsarCore.readString(reader, 5) ?? '';
    case 6:
      return IsarCore.readString(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7);
    case 8:
      {
        final value = IsarCore.readLong(reader, 8);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 9:
      {
        final value = IsarCore.readLong(reader, 9);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 10:
      return IsarCore.readString(reader, 10);
    case 11:
      return IsarCore.readString(reader, 11);
    case 12:
      return IsarCore.readString(reader, 12);
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
      return IsarCore.readString(reader, 20);
    case 21:
      return IsarCore.readString(reader, 21);
    case 22:
      return IsarCore.readString(reader, 22);
    case 23:
      return IsarCore.readString(reader, 23);
    case 24:
      return IsarCore.readString(reader, 24);
    case 25:
      {
        final value = IsarCore.readLong(reader, 25);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 26:
      {
        final value = IsarCore.readDouble(reader, 26);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 27:
      {
        final value = IsarCore.readDouble(reader, 27);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 28:
      {
        final value = IsarCore.readDouble(reader, 28);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
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
          return null;
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
        final value = IsarCore.readDouble(reader, 32);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 33:
      {
        final value = IsarCore.readDouble(reader, 33);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
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
      {
        final value = IsarCore.readDouble(reader, 35);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 36:
      {
        final value = IsarCore.readDouble(reader, 36);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
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
        final value = IsarCore.readDouble(reader, 39);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 40:
      {
        final value = IsarCore.readDouble(reader, 40);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 41:
      return IsarCore.readString(reader, 41);
    case 42:
      {
        final value = IsarCore.readLong(reader, 42);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 43:
      return IsarCore.readString(reader, 43);
    case 44:
      {
        final value = IsarCore.readLong(reader, 44);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 45:
      {
        final value = IsarCore.readLong(reader, 45);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _PurchaseUpdate {
  bool call({
    required String id,
    DateTime? lastTouched,
    DateTime? createdAt,
    String? action,
    String? tin,
    String? bhfId,
    int? invcNo,
    int? orgInvcNo,
    String? spplrTin,
    String? spplrBhfId,
    String? spplrNm,
    String? spplrInvcNo,
    String? regTyCd,
    String? pchsTyCd,
    String? rcptTyCd,
    String? pmtTyCd,
    String? pchsSttsCd,
    String? cfmDt,
    String? pchsDt,
    String? wrhsDt,
    String? cnclReqDt,
    String? cnclDt,
    String? rfdDt,
    int? totItemCnt,
    double? taxblAmtA,
    double? taxblAmtB,
    double? taxblAmtC,
    double? taxblAmtD,
    double? taxRtA,
    double? taxRtB,
    double? taxRtC,
    double? taxRtD,
    double? taxAmtA,
    double? taxAmtB,
    double? taxAmtC,
    double? taxAmtD,
    double? totTaxblAmt,
    double? totTaxAmt,
    double? totAmt,
    String? remark,
    int? modrId,
    String? modrNm,
    int? regrId,
    DateTime? deletedAt,
  });
}

class _PurchaseUpdateImpl implements _PurchaseUpdate {
  const _PurchaseUpdateImpl(this.collection);

  final IsarCollection<String, Purchase> collection;

  @override
  bool call({
    required String id,
    Object? lastTouched = ignore,
    Object? createdAt = ignore,
    Object? action = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? invcNo = ignore,
    Object? orgInvcNo = ignore,
    Object? spplrTin = ignore,
    Object? spplrBhfId = ignore,
    Object? spplrNm = ignore,
    Object? spplrInvcNo = ignore,
    Object? regTyCd = ignore,
    Object? pchsTyCd = ignore,
    Object? rcptTyCd = ignore,
    Object? pmtTyCd = ignore,
    Object? pchsSttsCd = ignore,
    Object? cfmDt = ignore,
    Object? pchsDt = ignore,
    Object? wrhsDt = ignore,
    Object? cnclReqDt = ignore,
    Object? cnclDt = ignore,
    Object? rfdDt = ignore,
    Object? totItemCnt = ignore,
    Object? taxblAmtA = ignore,
    Object? taxblAmtB = ignore,
    Object? taxblAmtC = ignore,
    Object? taxblAmtD = ignore,
    Object? taxRtA = ignore,
    Object? taxRtB = ignore,
    Object? taxRtC = ignore,
    Object? taxRtD = ignore,
    Object? taxAmtA = ignore,
    Object? taxAmtB = ignore,
    Object? taxAmtC = ignore,
    Object? taxAmtD = ignore,
    Object? totTaxblAmt = ignore,
    Object? totTaxAmt = ignore,
    Object? totAmt = ignore,
    Object? remark = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? regrId = ignore,
    Object? deletedAt = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (lastTouched != ignore) 3: lastTouched as DateTime?,
          if (createdAt != ignore) 4: createdAt as DateTime?,
          if (action != ignore) 5: action as String?,
          if (tin != ignore) 6: tin as String?,
          if (bhfId != ignore) 7: bhfId as String?,
          if (invcNo != ignore) 8: invcNo as int?,
          if (orgInvcNo != ignore) 9: orgInvcNo as int?,
          if (spplrTin != ignore) 10: spplrTin as String?,
          if (spplrBhfId != ignore) 11: spplrBhfId as String?,
          if (spplrNm != ignore) 12: spplrNm as String?,
          if (spplrInvcNo != ignore) 13: spplrInvcNo as String?,
          if (regTyCd != ignore) 14: regTyCd as String?,
          if (pchsTyCd != ignore) 15: pchsTyCd as String?,
          if (rcptTyCd != ignore) 16: rcptTyCd as String?,
          if (pmtTyCd != ignore) 17: pmtTyCd as String?,
          if (pchsSttsCd != ignore) 18: pchsSttsCd as String?,
          if (cfmDt != ignore) 19: cfmDt as String?,
          if (pchsDt != ignore) 20: pchsDt as String?,
          if (wrhsDt != ignore) 21: wrhsDt as String?,
          if (cnclReqDt != ignore) 22: cnclReqDt as String?,
          if (cnclDt != ignore) 23: cnclDt as String?,
          if (rfdDt != ignore) 24: rfdDt as String?,
          if (totItemCnt != ignore) 25: totItemCnt as int?,
          if (taxblAmtA != ignore) 26: taxblAmtA as double?,
          if (taxblAmtB != ignore) 27: taxblAmtB as double?,
          if (taxblAmtC != ignore) 28: taxblAmtC as double?,
          if (taxblAmtD != ignore) 29: taxblAmtD as double?,
          if (taxRtA != ignore) 30: taxRtA as double?,
          if (taxRtB != ignore) 31: taxRtB as double?,
          if (taxRtC != ignore) 32: taxRtC as double?,
          if (taxRtD != ignore) 33: taxRtD as double?,
          if (taxAmtA != ignore) 34: taxAmtA as double?,
          if (taxAmtB != ignore) 35: taxAmtB as double?,
          if (taxAmtC != ignore) 36: taxAmtC as double?,
          if (taxAmtD != ignore) 37: taxAmtD as double?,
          if (totTaxblAmt != ignore) 38: totTaxblAmt as double?,
          if (totTaxAmt != ignore) 39: totTaxAmt as double?,
          if (totAmt != ignore) 40: totAmt as double?,
          if (remark != ignore) 41: remark as String?,
          if (modrId != ignore) 42: modrId as int?,
          if (modrNm != ignore) 43: modrNm as String?,
          if (regrId != ignore) 44: regrId as int?,
          if (deletedAt != ignore) 45: deletedAt as DateTime?,
        }) >
        0;
  }
}

sealed class _PurchaseUpdateAll {
  int call({
    required List<String> id,
    DateTime? lastTouched,
    DateTime? createdAt,
    String? action,
    String? tin,
    String? bhfId,
    int? invcNo,
    int? orgInvcNo,
    String? spplrTin,
    String? spplrBhfId,
    String? spplrNm,
    String? spplrInvcNo,
    String? regTyCd,
    String? pchsTyCd,
    String? rcptTyCd,
    String? pmtTyCd,
    String? pchsSttsCd,
    String? cfmDt,
    String? pchsDt,
    String? wrhsDt,
    String? cnclReqDt,
    String? cnclDt,
    String? rfdDt,
    int? totItemCnt,
    double? taxblAmtA,
    double? taxblAmtB,
    double? taxblAmtC,
    double? taxblAmtD,
    double? taxRtA,
    double? taxRtB,
    double? taxRtC,
    double? taxRtD,
    double? taxAmtA,
    double? taxAmtB,
    double? taxAmtC,
    double? taxAmtD,
    double? totTaxblAmt,
    double? totTaxAmt,
    double? totAmt,
    String? remark,
    int? modrId,
    String? modrNm,
    int? regrId,
    DateTime? deletedAt,
  });
}

class _PurchaseUpdateAllImpl implements _PurchaseUpdateAll {
  const _PurchaseUpdateAllImpl(this.collection);

  final IsarCollection<String, Purchase> collection;

  @override
  int call({
    required List<String> id,
    Object? lastTouched = ignore,
    Object? createdAt = ignore,
    Object? action = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? invcNo = ignore,
    Object? orgInvcNo = ignore,
    Object? spplrTin = ignore,
    Object? spplrBhfId = ignore,
    Object? spplrNm = ignore,
    Object? spplrInvcNo = ignore,
    Object? regTyCd = ignore,
    Object? pchsTyCd = ignore,
    Object? rcptTyCd = ignore,
    Object? pmtTyCd = ignore,
    Object? pchsSttsCd = ignore,
    Object? cfmDt = ignore,
    Object? pchsDt = ignore,
    Object? wrhsDt = ignore,
    Object? cnclReqDt = ignore,
    Object? cnclDt = ignore,
    Object? rfdDt = ignore,
    Object? totItemCnt = ignore,
    Object? taxblAmtA = ignore,
    Object? taxblAmtB = ignore,
    Object? taxblAmtC = ignore,
    Object? taxblAmtD = ignore,
    Object? taxRtA = ignore,
    Object? taxRtB = ignore,
    Object? taxRtC = ignore,
    Object? taxRtD = ignore,
    Object? taxAmtA = ignore,
    Object? taxAmtB = ignore,
    Object? taxAmtC = ignore,
    Object? taxAmtD = ignore,
    Object? totTaxblAmt = ignore,
    Object? totTaxAmt = ignore,
    Object? totAmt = ignore,
    Object? remark = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? regrId = ignore,
    Object? deletedAt = ignore,
  }) {
    return collection.updateProperties(id, {
      if (lastTouched != ignore) 3: lastTouched as DateTime?,
      if (createdAt != ignore) 4: createdAt as DateTime?,
      if (action != ignore) 5: action as String?,
      if (tin != ignore) 6: tin as String?,
      if (bhfId != ignore) 7: bhfId as String?,
      if (invcNo != ignore) 8: invcNo as int?,
      if (orgInvcNo != ignore) 9: orgInvcNo as int?,
      if (spplrTin != ignore) 10: spplrTin as String?,
      if (spplrBhfId != ignore) 11: spplrBhfId as String?,
      if (spplrNm != ignore) 12: spplrNm as String?,
      if (spplrInvcNo != ignore) 13: spplrInvcNo as String?,
      if (regTyCd != ignore) 14: regTyCd as String?,
      if (pchsTyCd != ignore) 15: pchsTyCd as String?,
      if (rcptTyCd != ignore) 16: rcptTyCd as String?,
      if (pmtTyCd != ignore) 17: pmtTyCd as String?,
      if (pchsSttsCd != ignore) 18: pchsSttsCd as String?,
      if (cfmDt != ignore) 19: cfmDt as String?,
      if (pchsDt != ignore) 20: pchsDt as String?,
      if (wrhsDt != ignore) 21: wrhsDt as String?,
      if (cnclReqDt != ignore) 22: cnclReqDt as String?,
      if (cnclDt != ignore) 23: cnclDt as String?,
      if (rfdDt != ignore) 24: rfdDt as String?,
      if (totItemCnt != ignore) 25: totItemCnt as int?,
      if (taxblAmtA != ignore) 26: taxblAmtA as double?,
      if (taxblAmtB != ignore) 27: taxblAmtB as double?,
      if (taxblAmtC != ignore) 28: taxblAmtC as double?,
      if (taxblAmtD != ignore) 29: taxblAmtD as double?,
      if (taxRtA != ignore) 30: taxRtA as double?,
      if (taxRtB != ignore) 31: taxRtB as double?,
      if (taxRtC != ignore) 32: taxRtC as double?,
      if (taxRtD != ignore) 33: taxRtD as double?,
      if (taxAmtA != ignore) 34: taxAmtA as double?,
      if (taxAmtB != ignore) 35: taxAmtB as double?,
      if (taxAmtC != ignore) 36: taxAmtC as double?,
      if (taxAmtD != ignore) 37: taxAmtD as double?,
      if (totTaxblAmt != ignore) 38: totTaxblAmt as double?,
      if (totTaxAmt != ignore) 39: totTaxAmt as double?,
      if (totAmt != ignore) 40: totAmt as double?,
      if (remark != ignore) 41: remark as String?,
      if (modrId != ignore) 42: modrId as int?,
      if (modrNm != ignore) 43: modrNm as String?,
      if (regrId != ignore) 44: regrId as int?,
      if (deletedAt != ignore) 45: deletedAt as DateTime?,
    });
  }
}

extension PurchaseUpdate on IsarCollection<String, Purchase> {
  _PurchaseUpdate get update => _PurchaseUpdateImpl(this);

  _PurchaseUpdateAll get updateAll => _PurchaseUpdateAllImpl(this);
}

sealed class _PurchaseQueryUpdate {
  int call({
    DateTime? lastTouched,
    DateTime? createdAt,
    String? action,
    String? tin,
    String? bhfId,
    int? invcNo,
    int? orgInvcNo,
    String? spplrTin,
    String? spplrBhfId,
    String? spplrNm,
    String? spplrInvcNo,
    String? regTyCd,
    String? pchsTyCd,
    String? rcptTyCd,
    String? pmtTyCd,
    String? pchsSttsCd,
    String? cfmDt,
    String? pchsDt,
    String? wrhsDt,
    String? cnclReqDt,
    String? cnclDt,
    String? rfdDt,
    int? totItemCnt,
    double? taxblAmtA,
    double? taxblAmtB,
    double? taxblAmtC,
    double? taxblAmtD,
    double? taxRtA,
    double? taxRtB,
    double? taxRtC,
    double? taxRtD,
    double? taxAmtA,
    double? taxAmtB,
    double? taxAmtC,
    double? taxAmtD,
    double? totTaxblAmt,
    double? totTaxAmt,
    double? totAmt,
    String? remark,
    int? modrId,
    String? modrNm,
    int? regrId,
    DateTime? deletedAt,
  });
}

class _PurchaseQueryUpdateImpl implements _PurchaseQueryUpdate {
  const _PurchaseQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<Purchase> query;
  final int? limit;

  @override
  int call({
    Object? lastTouched = ignore,
    Object? createdAt = ignore,
    Object? action = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? invcNo = ignore,
    Object? orgInvcNo = ignore,
    Object? spplrTin = ignore,
    Object? spplrBhfId = ignore,
    Object? spplrNm = ignore,
    Object? spplrInvcNo = ignore,
    Object? regTyCd = ignore,
    Object? pchsTyCd = ignore,
    Object? rcptTyCd = ignore,
    Object? pmtTyCd = ignore,
    Object? pchsSttsCd = ignore,
    Object? cfmDt = ignore,
    Object? pchsDt = ignore,
    Object? wrhsDt = ignore,
    Object? cnclReqDt = ignore,
    Object? cnclDt = ignore,
    Object? rfdDt = ignore,
    Object? totItemCnt = ignore,
    Object? taxblAmtA = ignore,
    Object? taxblAmtB = ignore,
    Object? taxblAmtC = ignore,
    Object? taxblAmtD = ignore,
    Object? taxRtA = ignore,
    Object? taxRtB = ignore,
    Object? taxRtC = ignore,
    Object? taxRtD = ignore,
    Object? taxAmtA = ignore,
    Object? taxAmtB = ignore,
    Object? taxAmtC = ignore,
    Object? taxAmtD = ignore,
    Object? totTaxblAmt = ignore,
    Object? totTaxAmt = ignore,
    Object? totAmt = ignore,
    Object? remark = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? regrId = ignore,
    Object? deletedAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (lastTouched != ignore) 3: lastTouched as DateTime?,
      if (createdAt != ignore) 4: createdAt as DateTime?,
      if (action != ignore) 5: action as String?,
      if (tin != ignore) 6: tin as String?,
      if (bhfId != ignore) 7: bhfId as String?,
      if (invcNo != ignore) 8: invcNo as int?,
      if (orgInvcNo != ignore) 9: orgInvcNo as int?,
      if (spplrTin != ignore) 10: spplrTin as String?,
      if (spplrBhfId != ignore) 11: spplrBhfId as String?,
      if (spplrNm != ignore) 12: spplrNm as String?,
      if (spplrInvcNo != ignore) 13: spplrInvcNo as String?,
      if (regTyCd != ignore) 14: regTyCd as String?,
      if (pchsTyCd != ignore) 15: pchsTyCd as String?,
      if (rcptTyCd != ignore) 16: rcptTyCd as String?,
      if (pmtTyCd != ignore) 17: pmtTyCd as String?,
      if (pchsSttsCd != ignore) 18: pchsSttsCd as String?,
      if (cfmDt != ignore) 19: cfmDt as String?,
      if (pchsDt != ignore) 20: pchsDt as String?,
      if (wrhsDt != ignore) 21: wrhsDt as String?,
      if (cnclReqDt != ignore) 22: cnclReqDt as String?,
      if (cnclDt != ignore) 23: cnclDt as String?,
      if (rfdDt != ignore) 24: rfdDt as String?,
      if (totItemCnt != ignore) 25: totItemCnt as int?,
      if (taxblAmtA != ignore) 26: taxblAmtA as double?,
      if (taxblAmtB != ignore) 27: taxblAmtB as double?,
      if (taxblAmtC != ignore) 28: taxblAmtC as double?,
      if (taxblAmtD != ignore) 29: taxblAmtD as double?,
      if (taxRtA != ignore) 30: taxRtA as double?,
      if (taxRtB != ignore) 31: taxRtB as double?,
      if (taxRtC != ignore) 32: taxRtC as double?,
      if (taxRtD != ignore) 33: taxRtD as double?,
      if (taxAmtA != ignore) 34: taxAmtA as double?,
      if (taxAmtB != ignore) 35: taxAmtB as double?,
      if (taxAmtC != ignore) 36: taxAmtC as double?,
      if (taxAmtD != ignore) 37: taxAmtD as double?,
      if (totTaxblAmt != ignore) 38: totTaxblAmt as double?,
      if (totTaxAmt != ignore) 39: totTaxAmt as double?,
      if (totAmt != ignore) 40: totAmt as double?,
      if (remark != ignore) 41: remark as String?,
      if (modrId != ignore) 42: modrId as int?,
      if (modrNm != ignore) 43: modrNm as String?,
      if (regrId != ignore) 44: regrId as int?,
      if (deletedAt != ignore) 45: deletedAt as DateTime?,
    });
  }
}

extension PurchaseQueryUpdate on IsarQuery<Purchase> {
  _PurchaseQueryUpdate get updateFirst =>
      _PurchaseQueryUpdateImpl(this, limit: 1);

  _PurchaseQueryUpdate get updateAll => _PurchaseQueryUpdateImpl(this);
}

class _PurchaseQueryBuilderUpdateImpl implements _PurchaseQueryUpdate {
  const _PurchaseQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<Purchase, Purchase, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? lastTouched = ignore,
    Object? createdAt = ignore,
    Object? action = ignore,
    Object? tin = ignore,
    Object? bhfId = ignore,
    Object? invcNo = ignore,
    Object? orgInvcNo = ignore,
    Object? spplrTin = ignore,
    Object? spplrBhfId = ignore,
    Object? spplrNm = ignore,
    Object? spplrInvcNo = ignore,
    Object? regTyCd = ignore,
    Object? pchsTyCd = ignore,
    Object? rcptTyCd = ignore,
    Object? pmtTyCd = ignore,
    Object? pchsSttsCd = ignore,
    Object? cfmDt = ignore,
    Object? pchsDt = ignore,
    Object? wrhsDt = ignore,
    Object? cnclReqDt = ignore,
    Object? cnclDt = ignore,
    Object? rfdDt = ignore,
    Object? totItemCnt = ignore,
    Object? taxblAmtA = ignore,
    Object? taxblAmtB = ignore,
    Object? taxblAmtC = ignore,
    Object? taxblAmtD = ignore,
    Object? taxRtA = ignore,
    Object? taxRtB = ignore,
    Object? taxRtC = ignore,
    Object? taxRtD = ignore,
    Object? taxAmtA = ignore,
    Object? taxAmtB = ignore,
    Object? taxAmtC = ignore,
    Object? taxAmtD = ignore,
    Object? totTaxblAmt = ignore,
    Object? totTaxAmt = ignore,
    Object? totAmt = ignore,
    Object? remark = ignore,
    Object? modrId = ignore,
    Object? modrNm = ignore,
    Object? regrId = ignore,
    Object? deletedAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (lastTouched != ignore) 3: lastTouched as DateTime?,
        if (createdAt != ignore) 4: createdAt as DateTime?,
        if (action != ignore) 5: action as String?,
        if (tin != ignore) 6: tin as String?,
        if (bhfId != ignore) 7: bhfId as String?,
        if (invcNo != ignore) 8: invcNo as int?,
        if (orgInvcNo != ignore) 9: orgInvcNo as int?,
        if (spplrTin != ignore) 10: spplrTin as String?,
        if (spplrBhfId != ignore) 11: spplrBhfId as String?,
        if (spplrNm != ignore) 12: spplrNm as String?,
        if (spplrInvcNo != ignore) 13: spplrInvcNo as String?,
        if (regTyCd != ignore) 14: regTyCd as String?,
        if (pchsTyCd != ignore) 15: pchsTyCd as String?,
        if (rcptTyCd != ignore) 16: rcptTyCd as String?,
        if (pmtTyCd != ignore) 17: pmtTyCd as String?,
        if (pchsSttsCd != ignore) 18: pchsSttsCd as String?,
        if (cfmDt != ignore) 19: cfmDt as String?,
        if (pchsDt != ignore) 20: pchsDt as String?,
        if (wrhsDt != ignore) 21: wrhsDt as String?,
        if (cnclReqDt != ignore) 22: cnclReqDt as String?,
        if (cnclDt != ignore) 23: cnclDt as String?,
        if (rfdDt != ignore) 24: rfdDt as String?,
        if (totItemCnt != ignore) 25: totItemCnt as int?,
        if (taxblAmtA != ignore) 26: taxblAmtA as double?,
        if (taxblAmtB != ignore) 27: taxblAmtB as double?,
        if (taxblAmtC != ignore) 28: taxblAmtC as double?,
        if (taxblAmtD != ignore) 29: taxblAmtD as double?,
        if (taxRtA != ignore) 30: taxRtA as double?,
        if (taxRtB != ignore) 31: taxRtB as double?,
        if (taxRtC != ignore) 32: taxRtC as double?,
        if (taxRtD != ignore) 33: taxRtD as double?,
        if (taxAmtA != ignore) 34: taxAmtA as double?,
        if (taxAmtB != ignore) 35: taxAmtB as double?,
        if (taxAmtC != ignore) 36: taxAmtC as double?,
        if (taxAmtD != ignore) 37: taxAmtD as double?,
        if (totTaxblAmt != ignore) 38: totTaxblAmt as double?,
        if (totTaxAmt != ignore) 39: totTaxAmt as double?,
        if (totAmt != ignore) 40: totAmt as double?,
        if (remark != ignore) 41: remark as String?,
        if (modrId != ignore) 42: modrId as int?,
        if (modrNm != ignore) 43: modrNm as String?,
        if (regrId != ignore) 44: regrId as int?,
        if (deletedAt != ignore) 45: deletedAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension PurchaseQueryBuilderUpdate
    on QueryBuilder<Purchase, Purchase, QOperations> {
  _PurchaseQueryUpdate get updateFirst =>
      _PurchaseQueryBuilderUpdateImpl(this, limit: 1);

  _PurchaseQueryUpdate get updateAll => _PurchaseQueryBuilderUpdateImpl(this);
}

extension PurchaseQueryFilter
    on QueryBuilder<Purchase, Purchase, QFilterCondition> {
  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsElementEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsElementBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementContains(String value, {bool caseSensitive = true}) {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsElementMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsIsEmpty() {
    return not().itemIdsIsNotEmpty();
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 2, value: null),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      lastTouchedIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 3));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      lastTouchedGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      lastTouchedGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      lastTouchedLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      createdAtGreaterThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      createdAtLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      actionGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      actionLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinGreaterThan(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      tinGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinLessThan(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdGreaterThan(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      bhfIdGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdLessThan(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      bhfIdLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      invcNoGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      invcNoLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoEqualTo(
    int? value,
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoGreaterThan(
    int? value,
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      orgInvcNoGreaterThanOrEqualTo(
    int? value,
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoLessThan(
    int? value,
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      orgInvcNoLessThanOrEqualTo(
    int? value,
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoBetween(
    int? lower,
    int? upper,
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrTinGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrTinLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrBhfIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdGreaterThan(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrBhfIdGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdLessThan(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrBhfIdLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdContains(
      String value,
      {bool caseSensitive = true}) {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrBhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrNmGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrNmLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 12,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 12,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 12,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      regTyCdGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      regTyCdLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 14,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 14,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsTyCdGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsTyCdLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 15,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 15,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      rcptTyCdGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      rcptTyCdLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 16,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 16,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 17));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pmtTyCdGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pmtTyCdLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 17,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 17,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsSttsCdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 18));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsSttsCdGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsSttsCdLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 18,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsSttsCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 18,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cfmDtGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cfmDtLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 19,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 19,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsDtGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsDtLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 20,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 20,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 21));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 21));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      wrhsDtGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      wrhsDtLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 22));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 22));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cnclReqDtGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cnclReqDtLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 22,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cnclReqDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 22,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 23));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 23));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cnclDtGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cnclDtLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 23,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 23,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 24));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 24));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      rfdDtGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      rfdDtLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 24,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 24,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 25));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totItemCntIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 25));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 25,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 25,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totItemCntGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 25,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 25,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totItemCntLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 25,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 25,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 26));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 26));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 26,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 26,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtAGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 26,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtALessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 26,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtALessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 26,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtABetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 26,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 27));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 27));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 27,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 27,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtBGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 27,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 27,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtBLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 27,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 27,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 28));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 28));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 28,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 28,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtCGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 28,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 28,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtCLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 28,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 28,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 29));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 29));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtDGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxblAmtDLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 30));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 30));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtAGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtALessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtALessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtABetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 31));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 31));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtBGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtBLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 32));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 32));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 32,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 32,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtCGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 32,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 32,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtCLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 32,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 32,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 33));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 33));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 33,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 33,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtDGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 33,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 33,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxRtDLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 33,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 33,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 34));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 34));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtAGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtALessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtALessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtABetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 35));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 35));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 35,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 35,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtBGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 35,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 35,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtBLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 35,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 35,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 36));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 36));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 36,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 36,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtCGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 36,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 36,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtCLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 36,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 36,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 37));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 37));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtDGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      taxAmtDLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 38));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxblAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 38));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxblAmtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxblAmtGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxblAmtLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 39));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 39));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 39,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 39,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 39,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 39,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 39,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 39,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 40));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 40));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 40,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 40,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totAmtGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 40,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 40,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totAmtLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 40,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 40,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 41));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 41));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      remarkGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      remarkLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 41,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 41,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 42));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 42));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 42,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 42,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      modrIdGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 42,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 42,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      modrIdLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 42,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 42,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 43));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 43));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      modrNmGreaterThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      modrNmLessThanOrEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmContains(
      String value,
      {bool caseSensitive = true}) {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 43,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 43,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 44));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 44));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 44,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 44,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      regrIdGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 44,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 44,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      regrIdLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 44,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 44,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 45));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 45));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 45,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 45,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      deletedAtGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 45,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 45,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      deletedAtLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 45,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 45,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }
}

extension PurchaseQueryObject
    on QueryBuilder<Purchase, Purchase, QFilterCondition> {}

extension PurchaseQuerySortBy on QueryBuilder<Purchase, Purchase, QSortBy> {
  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTinDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByOrgInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByOrgInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrTinDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        12,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrInvcNo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrInvcNoDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        14,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        14,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        15,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        15,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRcptTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        16,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRcptTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        16,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPmtTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        17,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPmtTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        17,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsSttsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        18,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsSttsCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        18,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCfmDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        19,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCfmDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        19,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        20,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        20,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByWrhsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByWrhsDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclReqDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        22,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclReqDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        22,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        23,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        23,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRfdDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        24,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRfdDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        24,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotItemCnt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotItemCntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRemark(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        41,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRemarkDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        41,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        43,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        43,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45, sort: Sort.desc);
    });
  }
}

extension PurchaseQuerySortThenBy
    on QueryBuilder<Purchase, Purchase, QSortThenBy> {
  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTinDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByOrgInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByOrgInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrTinDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrBhfIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrInvcNo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrInvcNoDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRcptTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRcptTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPmtTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPmtTyCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsSttsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsSttsCdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCfmDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCfmDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByWrhsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByWrhsDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclReqDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclReqDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(22, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(23, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRfdDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(24, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRfdDtDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(24, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotItemCnt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotItemCntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(25, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(26, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(27, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(28, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(29, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(30, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(31, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(32, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(33, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(34, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(35, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(36, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(37, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(38, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(39, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(40, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRemark(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRemarkDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(41, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(42, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrNmDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(43, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(44, sort: Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(45, sort: Sort.desc);
    });
  }
}

extension PurchaseQueryWhereDistinct
    on QueryBuilder<Purchase, Purchase, QDistinct> {
  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByItemIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByOrgInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctBySpplrTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctBySpplrBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctBySpplrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctBySpplrInvcNo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByRegTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByPchsTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByRcptTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByPmtTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByPchsSttsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByCfmDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByPchsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByWrhsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(21, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByCnclReqDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(22, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByCnclDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(23, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByRfdDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(24, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTotItemCnt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(25);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxblAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(26);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxblAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(27);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxblAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(28);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxblAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(29);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxRtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(30);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxRtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(31);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxRtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(32);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxRtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(33);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(34);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(35);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(36);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTaxAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(37);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTotTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(38);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTotTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(39);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(40);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByRemark(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(41, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(42);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(43, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(44);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(45);
    });
  }
}

extension PurchaseQueryProperty1
    on QueryBuilder<Purchase, Purchase, QProperty> {
  QueryBuilder<Purchase, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Purchase, List<String>, QAfterProperty> itemIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Purchase, DateTime?, QAfterProperty> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Purchase, DateTime, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Purchase, String, QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Purchase, int?, QAfterProperty> invcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Purchase, int?, QAfterProperty> orgInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> spplrTinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> spplrBhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> spplrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> spplrInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> regTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> pchsTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> rcptTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> pmtTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> pchsSttsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> cfmDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> pchsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> wrhsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> cnclReqDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> cnclDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> rfdDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<Purchase, int?, QAfterProperty> totItemCntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxblAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxblAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxblAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxblAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxRtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxRtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxRtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxRtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> taxAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> totTaxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> totTaxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<Purchase, double?, QAfterProperty> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> remarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<Purchase, int?, QAfterProperty> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<Purchase, String?, QAfterProperty> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<Purchase, int?, QAfterProperty> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<Purchase, DateTime?, QAfterProperty> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }
}

extension PurchaseQueryProperty2<R>
    on QueryBuilder<Purchase, R, QAfterProperty> {
  QueryBuilder<Purchase, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Purchase, (R, List<String>), QAfterProperty> itemIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Purchase, (R, DateTime?), QAfterProperty> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Purchase, (R, DateTime), QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Purchase, (R, String), QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Purchase, (R, int?), QAfterProperty> invcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Purchase, (R, int?), QAfterProperty> orgInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> spplrTinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> spplrBhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> spplrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> spplrInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> regTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> pchsTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> rcptTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> pmtTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> pchsSttsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> cfmDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> pchsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> wrhsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> cnclReqDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> cnclDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> rfdDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<Purchase, (R, int?), QAfterProperty> totItemCntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxblAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxblAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxblAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxblAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxRtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxRtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxRtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxRtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> taxAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> totTaxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> totTaxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<Purchase, (R, double?), QAfterProperty> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> remarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<Purchase, (R, int?), QAfterProperty> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<Purchase, (R, String?), QAfterProperty> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<Purchase, (R, int?), QAfterProperty> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<Purchase, (R, DateTime?), QAfterProperty> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }
}

extension PurchaseQueryProperty3<R1, R2>
    on QueryBuilder<Purchase, (R1, R2), QAfterProperty> {
  QueryBuilder<Purchase, (R1, R2, String), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Purchase, (R1, R2, List<String>), QOperations>
      itemIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Purchase, (R1, R2, DateTime?), QOperations>
      lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Purchase, (R1, R2, DateTime), QOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String), QOperations> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Purchase, (R1, R2, int?), QOperations> invcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Purchase, (R1, R2, int?), QOperations> orgInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> spplrTinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> spplrBhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> spplrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> spplrInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> regTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> pchsTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> rcptTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> pmtTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> pchsSttsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> cfmDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> pchsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> wrhsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> cnclReqDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(22);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> cnclDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(23);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> rfdDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(24);
    });
  }

  QueryBuilder<Purchase, (R1, R2, int?), QOperations> totItemCntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(25);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxblAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(26);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxblAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(27);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxblAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(28);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxblAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(29);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxRtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(30);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxRtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(31);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxRtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(32);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxRtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(33);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(34);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(35);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(36);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> taxAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(37);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> totTaxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(38);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> totTaxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(39);
    });
  }

  QueryBuilder<Purchase, (R1, R2, double?), QOperations> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(40);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> remarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(41);
    });
  }

  QueryBuilder<Purchase, (R1, R2, int?), QOperations> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(42);
    });
  }

  QueryBuilder<Purchase, (R1, R2, String?), QOperations> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(43);
    });
  }

  QueryBuilder<Purchase, (R1, R2, int?), QOperations> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(44);
    });
  }

  QueryBuilder<Purchase, (R1, R2, DateTime?), QOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(45);
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      id: json['id'] as String,
      itemIds:
          (json['itemIds'] as List<dynamic>).map((e) => e as String).toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      action: json['action'] as String,
      lastTouched: json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String),
      tin: json['tin'] as String?,
      bhfId: json['bhfId'] as String?,
      invcNo: json['invcNo'] as int?,
      orgInvcNo: json['orgInvcNo'] as int?,
      spplrTin: json['spplrTin'] as String?,
      spplrBhfId: json['spplrBhfId'] as String?,
      spplrNm: json['spplrNm'] as String?,
      spplrInvcNo: json['spplrInvcNo'] as String?,
      regTyCd: json['regTyCd'] as String?,
      pchsTyCd: json['pchsTyCd'] as String?,
      rcptTyCd: json['rcptTyCd'] as String?,
      pmtTyCd: json['pmtTyCd'] as String?,
      pchsSttsCd: json['pchsSttsCd'] as String?,
      cfmDt: json['cfmDt'] as String?,
      pchsDt: json['pchsDt'] as String?,
      wrhsDt: json['wrhsDt'] as String?,
      cnclReqDt: json['cnclReqDt'] as String?,
      cnclDt: json['cnclDt'] as String?,
      rfdDt: json['rfdDt'] as String?,
      totItemCnt: json['totItemCnt'] as int?,
      taxblAmtA: (json['taxblAmtA'] as num?)?.toDouble(),
      taxblAmtB: (json['taxblAmtB'] as num?)?.toDouble(),
      taxblAmtC: (json['taxblAmtC'] as num?)?.toDouble(),
      taxblAmtD: (json['taxblAmtD'] as num?)?.toDouble(),
      taxRtA: (json['taxRtA'] as num?)?.toDouble(),
      taxRtB: (json['taxRtB'] as num?)?.toDouble(),
      taxRtC: (json['taxRtC'] as num?)?.toDouble(),
      taxRtD: (json['taxRtD'] as num?)?.toDouble(),
      taxAmtA: (json['taxAmtA'] as num?)?.toDouble(),
      taxAmtB: (json['taxAmtB'] as num?)?.toDouble(),
      taxAmtC: (json['taxAmtC'] as num?)?.toDouble(),
      taxAmtD: (json['taxAmtD'] as num?)?.toDouble(),
      totTaxblAmt: (json['totTaxblAmt'] as num?)?.toDouble(),
      totTaxAmt: (json['totTaxAmt'] as num?)?.toDouble(),
      totAmt: (json['totAmt'] as num?)?.toDouble(),
      remark: json['remark'] as String?,
      modrId: json['modrId'] as int?,
      modrNm: json['modrNm'] as String?,
      regrId: json['regrId'] as int?,
    )..deletedAt = json['deletedAt'] == null
        ? null
        : DateTime.parse(json['deletedAt'] as String);

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'id': instance.id,
      'itemIds': instance.itemIds,
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'action': instance.action,
      'tin': instance.tin,
      'bhfId': instance.bhfId,
      'invcNo': instance.invcNo,
      'orgInvcNo': instance.orgInvcNo,
      'spplrTin': instance.spplrTin,
      'spplrBhfId': instance.spplrBhfId,
      'spplrNm': instance.spplrNm,
      'spplrInvcNo': instance.spplrInvcNo,
      'regTyCd': instance.regTyCd,
      'pchsTyCd': instance.pchsTyCd,
      'rcptTyCd': instance.rcptTyCd,
      'pmtTyCd': instance.pmtTyCd,
      'pchsSttsCd': instance.pchsSttsCd,
      'cfmDt': instance.cfmDt,
      'pchsDt': instance.pchsDt,
      'wrhsDt': instance.wrhsDt,
      'cnclReqDt': instance.cnclReqDt,
      'cnclDt': instance.cnclDt,
      'rfdDt': instance.rfdDt,
      'totItemCnt': instance.totItemCnt,
      'taxblAmtA': instance.taxblAmtA,
      'taxblAmtB': instance.taxblAmtB,
      'taxblAmtC': instance.taxblAmtC,
      'taxblAmtD': instance.taxblAmtD,
      'taxRtA': instance.taxRtA,
      'taxRtB': instance.taxRtB,
      'taxRtC': instance.taxRtC,
      'taxRtD': instance.taxRtD,
      'taxAmtA': instance.taxAmtA,
      'taxAmtB': instance.taxAmtB,
      'taxAmtC': instance.taxAmtC,
      'taxAmtD': instance.taxAmtD,
      'totTaxblAmt': instance.totTaxblAmt,
      'totTaxAmt': instance.totTaxAmt,
      'totAmt': instance.totAmt,
      'remark': instance.remark,
      'modrId': instance.modrId,
      'modrNm': instance.modrNm,
      'regrId': instance.regrId,
    };
