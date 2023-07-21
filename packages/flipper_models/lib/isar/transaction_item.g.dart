// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTransactionItemCollection on Isar {
  IsarCollection<TransactionItem> get transactionItems => this.collection();
}

const TransactionItemSchema = CollectionSchema(
  name: r'TransactionItem',
  id: 4862152759336924711,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.string,
    ),
    r'addInfo': PropertySchema(
      id: 1,
      name: r'addInfo',
      type: IsarType.string,
    ),
    r'bcd': PropertySchema(
      id: 2,
      name: r'bcd',
      type: IsarType.string,
    ),
    r'bhfId': PropertySchema(
      id: 3,
      name: r'bhfId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.string,
    ),
    r'dcAmt': PropertySchema(
      id: 5,
      name: r'dcAmt',
      type: IsarType.double,
    ),
    r'dcRt': PropertySchema(
      id: 6,
      name: r'dcRt',
      type: IsarType.double,
    ),
    r'deletedAt': PropertySchema(
      id: 7,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'dftPrc': PropertySchema(
      id: 8,
      name: r'dftPrc',
      type: IsarType.double,
    ),
    r'discount': PropertySchema(
      id: 9,
      name: r'discount',
      type: IsarType.double,
    ),
    r'doneWithTransaction': PropertySchema(
      id: 10,
      name: r'doneWithTransaction',
      type: IsarType.bool,
    ),
    r'isRefunded': PropertySchema(
      id: 11,
      name: r'isRefunded',
      type: IsarType.bool,
    ),
    r'isTaxExempted': PropertySchema(
      id: 12,
      name: r'isTaxExempted',
      type: IsarType.bool,
    ),
    r'isrcAmt': PropertySchema(
      id: 13,
      name: r'isrcAmt',
      type: IsarType.string,
    ),
    r'isrcAplcbYn': PropertySchema(
      id: 14,
      name: r'isrcAplcbYn',
      type: IsarType.string,
    ),
    r'isrcRt': PropertySchema(
      id: 15,
      name: r'isrcRt',
      type: IsarType.string,
    ),
    r'isrccCd': PropertySchema(
      id: 16,
      name: r'isrccCd',
      type: IsarType.string,
    ),
    r'isrccNm': PropertySchema(
      id: 17,
      name: r'isrccNm',
      type: IsarType.string,
    ),
    r'itemCd': PropertySchema(
      id: 18,
      name: r'itemCd',
      type: IsarType.string,
    ),
    r'itemClsCd': PropertySchema(
      id: 19,
      name: r'itemClsCd',
      type: IsarType.string,
    ),
    r'itemNm': PropertySchema(
      id: 20,
      name: r'itemNm',
      type: IsarType.string,
    ),
    r'itemSeq': PropertySchema(
      id: 21,
      name: r'itemSeq',
      type: IsarType.string,
    ),
    r'itemStdNm': PropertySchema(
      id: 22,
      name: r'itemStdNm',
      type: IsarType.string,
    ),
    r'itemTyCd': PropertySchema(
      id: 23,
      name: r'itemTyCd',
      type: IsarType.string,
    ),
    r'lastTouched': PropertySchema(
      id: 24,
      name: r'lastTouched',
      type: IsarType.string,
    ),
    r'localId': PropertySchema(
      id: 25,
      name: r'localId',
      type: IsarType.long,
    ),
    r'modrId': PropertySchema(
      id: 26,
      name: r'modrId',
      type: IsarType.string,
    ),
    r'modrNm': PropertySchema(
      id: 27,
      name: r'modrNm',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 28,
      name: r'name',
      type: IsarType.string,
    ),
    r'orgnNatCd': PropertySchema(
      id: 29,
      name: r'orgnNatCd',
      type: IsarType.string,
    ),
    r'pkg': PropertySchema(
      id: 30,
      name: r'pkg',
      type: IsarType.string,
    ),
    r'pkgUnitCd': PropertySchema(
      id: 31,
      name: r'pkgUnitCd',
      type: IsarType.string,
    ),
    r'prc': PropertySchema(
      id: 32,
      name: r'prc',
      type: IsarType.double,
    ),
    r'price': PropertySchema(
      id: 33,
      name: r'price',
      type: IsarType.double,
    ),
    r'qty': PropertySchema(
      id: 34,
      name: r'qty',
      type: IsarType.double,
    ),
    r'qtyUnitCd': PropertySchema(
      id: 35,
      name: r'qtyUnitCd',
      type: IsarType.string,
    ),
    r'regrId': PropertySchema(
      id: 36,
      name: r'regrId',
      type: IsarType.string,
    ),
    r'regrNm': PropertySchema(
      id: 37,
      name: r'regrNm',
      type: IsarType.string,
    ),
    r'remainingStock': PropertySchema(
      id: 38,
      name: r'remainingStock',
      type: IsarType.double,
    ),
    r'remoteID': PropertySchema(
      id: 39,
      name: r'remoteID',
      type: IsarType.string,
    ),
    r'reported': PropertySchema(
      id: 40,
      name: r'reported',
      type: IsarType.bool,
    ),
    r'splyAmt': PropertySchema(
      id: 41,
      name: r'splyAmt',
      type: IsarType.double,
    ),
    r'taxAmt': PropertySchema(
      id: 42,
      name: r'taxAmt',
      type: IsarType.double,
    ),
    r'taxTyCd': PropertySchema(
      id: 43,
      name: r'taxTyCd',
      type: IsarType.string,
    ),
    r'taxblAmt': PropertySchema(
      id: 44,
      name: r'taxblAmt',
      type: IsarType.double,
    ),
    r'tin': PropertySchema(
      id: 45,
      name: r'tin',
      type: IsarType.long,
    ),
    r'totAmt': PropertySchema(
      id: 46,
      name: r'totAmt',
      type: IsarType.double,
    ),
    r'transactionId': PropertySchema(
      id: 47,
      name: r'transactionId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 48,
      name: r'type',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 49,
      name: r'updatedAt',
      type: IsarType.string,
    ),
    r'useYn': PropertySchema(
      id: 50,
      name: r'useYn',
      type: IsarType.string,
    ),
    r'variantId': PropertySchema(
      id: 51,
      name: r'variantId',
      type: IsarType.long,
    )
  },
  estimateSize: _transactionItemEstimateSize,
  serialize: _transactionItemSerialize,
  deserialize: _transactionItemDeserialize,
  deserializeProp: _transactionItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'transactionId': IndexSchema(
      id: 8561542235958051982,
      name: r'transactionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'transactionId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'variantId_transactionId': IndexSchema(
      id: -2589729403191562825,
      name: r'variantId_transactionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'variantId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'transactionId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'lastTouched': IndexSchema(
      id: -1197289422054722944,
      name: r'lastTouched',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastTouched',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'deletedAt': IndexSchema(
      id: -8969437169173379604,
      name: r'deletedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'deletedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _transactionItemGetId,
  getLinks: _transactionItemGetLinks,
  attach: _transactionItemAttach,
  version: '3.1.0+1',
);

int _transactionItemEstimateSize(
  TransactionItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.action;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.addInfo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bcd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.bhfId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.createdAt.length * 3;
  {
    final value = object.isrcAmt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.isrcAplcbYn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.isrcRt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.isrccCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.isrccNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.itemCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.itemClsCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.itemNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.itemSeq;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.itemStdNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.itemTyCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastTouched;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modrId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.modrNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.orgnNatCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pkg;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pkgUnitCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.qtyUnitCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.regrId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.regrNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.remoteID;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.taxTyCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.updatedAt.length * 3;
  {
    final value = object.useYn;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _transactionItemSerialize(
  TransactionItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.action);
  writer.writeString(offsets[1], object.addInfo);
  writer.writeString(offsets[2], object.bcd);
  writer.writeString(offsets[3], object.bhfId);
  writer.writeString(offsets[4], object.createdAt);
  writer.writeDouble(offsets[5], object.dcAmt);
  writer.writeDouble(offsets[6], object.dcRt);
  writer.writeDateTime(offsets[7], object.deletedAt);
  writer.writeDouble(offsets[8], object.dftPrc);
  writer.writeDouble(offsets[9], object.discount);
  writer.writeBool(offsets[10], object.doneWithTransaction);
  writer.writeBool(offsets[11], object.isRefunded);
  writer.writeBool(offsets[12], object.isTaxExempted);
  writer.writeString(offsets[13], object.isrcAmt);
  writer.writeString(offsets[14], object.isrcAplcbYn);
  writer.writeString(offsets[15], object.isrcRt);
  writer.writeString(offsets[16], object.isrccCd);
  writer.writeString(offsets[17], object.isrccNm);
  writer.writeString(offsets[18], object.itemCd);
  writer.writeString(offsets[19], object.itemClsCd);
  writer.writeString(offsets[20], object.itemNm);
  writer.writeString(offsets[21], object.itemSeq);
  writer.writeString(offsets[22], object.itemStdNm);
  writer.writeString(offsets[23], object.itemTyCd);
  writer.writeString(offsets[24], object.lastTouched);
  writer.writeLong(offsets[25], object.localId);
  writer.writeString(offsets[26], object.modrId);
  writer.writeString(offsets[27], object.modrNm);
  writer.writeString(offsets[28], object.name);
  writer.writeString(offsets[29], object.orgnNatCd);
  writer.writeString(offsets[30], object.pkg);
  writer.writeString(offsets[31], object.pkgUnitCd);
  writer.writeDouble(offsets[32], object.prc);
  writer.writeDouble(offsets[33], object.price);
  writer.writeDouble(offsets[34], object.qty);
  writer.writeString(offsets[35], object.qtyUnitCd);
  writer.writeString(offsets[36], object.regrId);
  writer.writeString(offsets[37], object.regrNm);
  writer.writeDouble(offsets[38], object.remainingStock);
  writer.writeString(offsets[39], object.remoteID);
  writer.writeBool(offsets[40], object.reported);
  writer.writeDouble(offsets[41], object.splyAmt);
  writer.writeDouble(offsets[42], object.taxAmt);
  writer.writeString(offsets[43], object.taxTyCd);
  writer.writeDouble(offsets[44], object.taxblAmt);
  writer.writeLong(offsets[45], object.tin);
  writer.writeDouble(offsets[46], object.totAmt);
  writer.writeLong(offsets[47], object.transactionId);
  writer.writeString(offsets[48], object.type);
  writer.writeString(offsets[49], object.updatedAt);
  writer.writeString(offsets[50], object.useYn);
  writer.writeLong(offsets[51], object.variantId);
}

TransactionItem _transactionItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = TransactionItem(
    addInfo: reader.readStringOrNull(offsets[1]),
    bcd: reader.readStringOrNull(offsets[2]),
    bhfId: reader.readStringOrNull(offsets[3]),
    createdAt: reader.readString(offsets[4]),
    dcAmt: reader.readDoubleOrNull(offsets[5]),
    dcRt: reader.readDoubleOrNull(offsets[6]),
    deletedAt: reader.readDateTimeOrNull(offsets[7]),
    dftPrc: reader.readDoubleOrNull(offsets[8]),
    discount: reader.readDoubleOrNull(offsets[9]),
    doneWithTransaction: reader.readBoolOrNull(offsets[10]),
    id: id,
    isRefunded: reader.readBoolOrNull(offsets[11]),
    isTaxExempted: reader.readBool(offsets[12]),
    isrcAmt: reader.readStringOrNull(offsets[13]),
    isrcAplcbYn: reader.readStringOrNull(offsets[14]),
    isrcRt: reader.readStringOrNull(offsets[15]),
    isrccCd: reader.readStringOrNull(offsets[16]),
    isrccNm: reader.readStringOrNull(offsets[17]),
    itemCd: reader.readStringOrNull(offsets[18]),
    itemClsCd: reader.readStringOrNull(offsets[19]),
    itemNm: reader.readStringOrNull(offsets[20]),
    itemSeq: reader.readStringOrNull(offsets[21]),
    itemStdNm: reader.readStringOrNull(offsets[22]),
    itemTyCd: reader.readStringOrNull(offsets[23]),
    lastTouched: reader.readStringOrNull(offsets[24]),
    modrId: reader.readStringOrNull(offsets[26]),
    modrNm: reader.readStringOrNull(offsets[27]),
    name: reader.readString(offsets[28]),
    orgnNatCd: reader.readStringOrNull(offsets[29]),
    pkg: reader.readStringOrNull(offsets[30]),
    pkgUnitCd: reader.readStringOrNull(offsets[31]),
    prc: reader.readDoubleOrNull(offsets[32]),
    price: reader.readDouble(offsets[33]),
    qty: reader.readDouble(offsets[34]),
    qtyUnitCd: reader.readStringOrNull(offsets[35]),
    regrId: reader.readStringOrNull(offsets[36]),
    regrNm: reader.readStringOrNull(offsets[37]),
    remainingStock: reader.readDouble(offsets[38]),
    reported: reader.readBoolOrNull(offsets[40]),
    splyAmt: reader.readDoubleOrNull(offsets[41]),
    taxAmt: reader.readDoubleOrNull(offsets[42]),
    taxTyCd: reader.readStringOrNull(offsets[43]),
    taxblAmt: reader.readDoubleOrNull(offsets[44]),
    tin: reader.readLongOrNull(offsets[45]),
    totAmt: reader.readDoubleOrNull(offsets[46]),
    transactionId: reader.readLong(offsets[47]),
    type: reader.readStringOrNull(offsets[48]),
    updatedAt: reader.readString(offsets[49]),
    useYn: reader.readStringOrNull(offsets[50]),
    variantId: reader.readLong(offsets[51]),
  );
  object.action = reader.readStringOrNull(offsets[0]);
  object.localId = reader.readLongOrNull(offsets[25]);
  object.remoteID = reader.readStringOrNull(offsets[39]);
  return object;
}

P _transactionItemDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readDoubleOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readBoolOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readStringOrNull(offset)) as P;
    case 20:
      return (reader.readStringOrNull(offset)) as P;
    case 21:
      return (reader.readStringOrNull(offset)) as P;
    case 22:
      return (reader.readStringOrNull(offset)) as P;
    case 23:
      return (reader.readStringOrNull(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readLongOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readString(offset)) as P;
    case 29:
      return (reader.readStringOrNull(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readDoubleOrNull(offset)) as P;
    case 33:
      return (reader.readDouble(offset)) as P;
    case 34:
      return (reader.readDouble(offset)) as P;
    case 35:
      return (reader.readStringOrNull(offset)) as P;
    case 36:
      return (reader.readStringOrNull(offset)) as P;
    case 37:
      return (reader.readStringOrNull(offset)) as P;
    case 38:
      return (reader.readDouble(offset)) as P;
    case 39:
      return (reader.readStringOrNull(offset)) as P;
    case 40:
      return (reader.readBoolOrNull(offset)) as P;
    case 41:
      return (reader.readDoubleOrNull(offset)) as P;
    case 42:
      return (reader.readDoubleOrNull(offset)) as P;
    case 43:
      return (reader.readStringOrNull(offset)) as P;
    case 44:
      return (reader.readDoubleOrNull(offset)) as P;
    case 45:
      return (reader.readLongOrNull(offset)) as P;
    case 46:
      return (reader.readDoubleOrNull(offset)) as P;
    case 47:
      return (reader.readLong(offset)) as P;
    case 48:
      return (reader.readStringOrNull(offset)) as P;
    case 49:
      return (reader.readString(offset)) as P;
    case 50:
      return (reader.readStringOrNull(offset)) as P;
    case 51:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _transactionItemGetId(TransactionItem object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _transactionItemGetLinks(TransactionItem object) {
  return [];
}

void _transactionItemAttach(
    IsarCollection<dynamic> col, Id id, TransactionItem object) {
  object.id = id;
}

extension TransactionItemQueryWhereSort
    on QueryBuilder<TransactionItem, TransactionItem, QWhere> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhere>
      anyTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'transactionId'),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhere>
      anyVariantIdTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'variantId_transactionId'),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhere> anyDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'deletedAt'),
      );
    });
  }
}

extension TransactionItemQueryWhere
    on QueryBuilder<TransactionItem, TransactionItem, QWhereClause> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      transactionIdEqualTo(int transactionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'transactionId',
        value: [transactionId],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      transactionIdNotEqualTo(int transactionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [],
              upper: [transactionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [transactionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [transactionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'transactionId',
              lower: [],
              upper: [transactionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      transactionIdGreaterThan(
    int transactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'transactionId',
        lower: [transactionId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      transactionIdLessThan(
    int transactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'transactionId',
        lower: [],
        upper: [transactionId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      transactionIdBetween(
    int lowerTransactionId,
    int upperTransactionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'transactionId',
        lower: [lowerTransactionId],
        includeLower: includeLower,
        upper: [upperTransactionId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdEqualToAnyTransactionId(int variantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'variantId_transactionId',
        value: [variantId],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdNotEqualToAnyTransactionId(int variantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [],
              upper: [variantId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [variantId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [variantId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [],
              upper: [variantId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdGreaterThanAnyTransactionId(
    int variantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_transactionId',
        lower: [variantId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdLessThanAnyTransactionId(
    int variantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_transactionId',
        lower: [],
        upper: [variantId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdBetweenAnyTransactionId(
    int lowerVariantId,
    int upperVariantId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_transactionId',
        lower: [lowerVariantId],
        includeLower: includeLower,
        upper: [upperVariantId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdTransactionIdEqualTo(int variantId, int transactionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'variantId_transactionId',
        value: [variantId, transactionId],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdEqualToTransactionIdNotEqualTo(
          int variantId, int transactionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [variantId],
              upper: [variantId, transactionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [variantId, transactionId],
              includeLower: false,
              upper: [variantId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [variantId, transactionId],
              includeLower: false,
              upper: [variantId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_transactionId',
              lower: [variantId],
              upper: [variantId, transactionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdEqualToTransactionIdGreaterThan(
    int variantId,
    int transactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_transactionId',
        lower: [variantId, transactionId],
        includeLower: include,
        upper: [variantId],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdEqualToTransactionIdLessThan(
    int variantId,
    int transactionId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_transactionId',
        lower: [variantId],
        upper: [variantId, transactionId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      variantIdEqualToTransactionIdBetween(
    int variantId,
    int lowerTransactionId,
    int upperTransactionId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_transactionId',
        lower: [variantId, lowerTransactionId],
        includeLower: includeLower,
        upper: [variantId, upperTransactionId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastTouched',
        value: [null],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      lastTouchedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastTouched',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      lastTouchedEqualTo(String? lastTouched) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastTouched',
        value: [lastTouched],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      lastTouchedNotEqualTo(String? lastTouched) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [],
              upper: [lastTouched],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [lastTouched],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [lastTouched],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastTouched',
              lower: [],
              upper: [lastTouched],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deletedAt',
        value: [null],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedAt',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      deletedAtEqualTo(DateTime? deletedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'deletedAt',
        value: [deletedAt],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      deletedAtNotEqualTo(DateTime? deletedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedAt',
              lower: [],
              upper: [deletedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedAt',
              lower: [deletedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedAt',
              lower: [deletedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'deletedAt',
              lower: [],
              upper: [deletedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      deletedAtGreaterThan(
    DateTime? deletedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedAt',
        lower: [deletedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      deletedAtLessThan(
    DateTime? deletedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedAt',
        lower: [],
        upper: [deletedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterWhereClause>
      deletedAtBetween(
    DateTime? lowerDeletedAt,
    DateTime? upperDeletedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'deletedAt',
        lower: [lowerDeletedAt],
        includeLower: includeLower,
        upper: [upperDeletedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransactionItemQueryFilter
    on QueryBuilder<TransactionItem, TransactionItem, QFilterCondition> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'action',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'action',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'action',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'action',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'addInfo',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'addInfo',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'addInfo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'addInfo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      addInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'addInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bcd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bcd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bcd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bcd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bcd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bcdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bcd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bhfId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bhfId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      bhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      createdAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dcAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dcAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dcAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dcAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dcAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcAmtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dcAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dcRt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dcRt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dcRt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dcRt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dcRt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dcRtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dcRt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dftPrc',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dftPrc',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dftPrc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dftPrc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dftPrc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      dftPrcBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dftPrc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'discount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      discountBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'discount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      doneWithTransactionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'doneWithTransaction',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      doneWithTransactionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'doneWithTransaction',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      doneWithTransactionEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doneWithTransaction',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isRefundedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isRefunded',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isRefundedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isRefunded',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isRefundedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRefunded',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isTaxExemptedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTaxExempted',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrcAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrcAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcAmt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAmt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAmtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrcAmt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcAplcbYn',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrcAplcbYn',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrcAplcbYn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcAplcbYn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAplcbYn',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcAplcbYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrcAplcbYn',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcRt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrcRt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrcRt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcRt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcRt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrcRtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrcRt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrccCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrccCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrccCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrccCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrccCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrccNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrccNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isrccNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrccNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      isrccNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrccNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemClsCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemClsCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemClsCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemClsCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemClsCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemClsCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemClsCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemSeq',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemSeq',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemSeq',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemSeq',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemSeq',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemSeqIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemSeq',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemStdNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemStdNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemStdNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemStdNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemStdNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemStdNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemStdNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemTyCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemTyCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      itemTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTouched',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastTouched',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastTouched',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTouched',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      lastTouchedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastTouched',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      localIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      localIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'localId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      localIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      localIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      localIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      localIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modrId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modrId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modrId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modrId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modrNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modrNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modrNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      modrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orgnNatCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orgnNatCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orgnNatCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orgnNatCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgnNatCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      orgnNatCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orgnNatCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pkg',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pkg',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pkg',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pkg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkg',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pkg',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pkgUnitCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pkgUnitCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pkgUnitCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pkgUnitCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkgUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      pkgUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pkgUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'prc',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'prc',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'prc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'prc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'prc',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      prcBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'prc',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'price',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      priceBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'price',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qty',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qtyUnitCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qtyUnitCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qtyUnitCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qtyUnitCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qtyUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      qtyUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qtyUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regrId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regrId',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regrId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regrId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regrId',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regrNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regrNm',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regrNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regrNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      regrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remainingStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remainingStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remainingStock',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remainingStockBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remainingStock',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remoteID',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remoteID',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remoteID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remoteID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remoteID',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remoteID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remoteID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remoteID',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remoteID',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remoteID',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      remoteIDIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remoteID',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      reportedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reported',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      reportedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reported',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      reportedEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reported',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'splyAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'splyAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'splyAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'splyAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'splyAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      splyAmtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'splyAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxAmtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxTyCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxTyCd',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxblAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxblAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxblAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxblAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxblAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      taxblAmtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxblAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tin',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tin',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tin',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tin',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tin',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      tinBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totAmt',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      totAmtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transactionId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transactionId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transactionId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      transactionIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transactionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'updatedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'updatedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'updatedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'updatedAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      updatedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'updatedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'useYn',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'useYn',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'useYn',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'useYn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useYn',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      useYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'useYn',
        value: '',
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variantId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'variantId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'variantId',
        value: value,
      ));
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterFilterCondition>
      variantIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'variantId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension TransactionItemQueryObject
    on QueryBuilder<TransactionItem, TransactionItem, QFilterCondition> {}

extension TransactionItemQueryLinks
    on QueryBuilder<TransactionItem, TransactionItem, QFilterCondition> {}

extension TransactionItemQuerySortBy
    on QueryBuilder<TransactionItem, TransactionItem, QSortBy> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByAddInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByAddInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByBcd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByBcdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDoneWithTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneWithTransaction', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByDoneWithTransactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneWithTransaction', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsRefundedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrcAplcbYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrcAplcbYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrccCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrccCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByIsrccNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByIsrccNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemClsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemClsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByItemSeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemSeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemStdNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemStdNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByItemTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByOrgnNatCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByOrgnNatCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPkg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPkgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByPkgUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByPkgUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByQtyUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByQtyUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByRegrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRegrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRemainingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRemoteID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteID', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByRemoteIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteID', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByReported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByReportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTaxTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> sortByUseYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByUseYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      sortByVariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.desc);
    });
  }
}

extension TransactionItemQuerySortThenBy
    on QueryBuilder<TransactionItem, TransactionItem, QSortThenBy> {
  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByAddInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByAddInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByBcd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByBcdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDoneWithTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneWithTransaction', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByDoneWithTransactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doneWithTransaction', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsRefundedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrcAplcbYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrcAplcbYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrccCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrccCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByIsrccNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByIsrccNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemClsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemClsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByItemSeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemSeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemStdNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemStdNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByItemTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByLocalIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByOrgnNatCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByOrgnNatCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPkg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPkgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByPkgUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByPkgUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByQtyUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByQtyUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByRegrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRegrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRemainingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRemoteID() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteID', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByRemoteIDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remoteID', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByReported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByReportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTaxTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transactionId', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy> thenByUseYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByUseYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.desc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.asc);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QAfterSortBy>
      thenByVariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.desc);
    });
  }
}

extension TransactionItemQueryWhereDistinct
    on QueryBuilder<TransactionItem, TransactionItem, QDistinct> {
  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'action', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addInfo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bcd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bhfId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dcAmt');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dcRt');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dftPrc');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByDoneWithTransaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doneWithTransaction');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRefunded');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTaxExempted');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcAmt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByIsrcAplcbYn({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcAplcbYn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcRt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrccCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrccNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemClsCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemSeq', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemStdNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByLastTouched({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTouched', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByLocalId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localId');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgnNatCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pkg', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pkgUnitCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prc');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qty');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qtyUnitCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingStock');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByRemoteID(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remoteID', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByReported() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reported');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'splyAmt');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxAmt');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxblAmt');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tin');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totAmt');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transactionId');
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct> distinctByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useYn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<TransactionItem, TransactionItem, QDistinct>
      distinctByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'variantId');
    });
  }
}

extension TransactionItemQueryProperty
    on QueryBuilder<TransactionItem, TransactionItem, QQueryProperty> {
  QueryBuilder<TransactionItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'action');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addInfo');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bcd');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bhfId');
    });
  }

  QueryBuilder<TransactionItem, String, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> dcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dcAmt');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> dcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dcRt');
    });
  }

  QueryBuilder<TransactionItem, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dftPrc');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<TransactionItem, bool?, QQueryOperations>
      doneWithTransactionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doneWithTransaction');
    });
  }

  QueryBuilder<TransactionItem, bool?, QQueryOperations> isRefundedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRefunded');
    });
  }

  QueryBuilder<TransactionItem, bool, QQueryOperations>
      isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTaxExempted');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcAmt');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations>
      isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcAplcbYn');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcRt');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrccCd');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrccNm');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCd');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemClsCd');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemNm');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemSeq');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemStdNm');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemTyCd');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations>
      lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTouched');
    });
  }

  QueryBuilder<TransactionItem, int?, QQueryOperations> localIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localId');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrId');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrNm');
    });
  }

  QueryBuilder<TransactionItem, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgnNatCd');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pkg');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pkgUnitCd');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prc');
    });
  }

  QueryBuilder<TransactionItem, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<TransactionItem, double, QQueryOperations> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qty');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qtyUnitCd');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regrId');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regrNm');
    });
  }

  QueryBuilder<TransactionItem, double, QQueryOperations>
      remainingStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingStock');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> remoteIDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remoteID');
    });
  }

  QueryBuilder<TransactionItem, bool?, QQueryOperations> reportedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reported');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'splyAmt');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> taxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxAmt');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxTyCd');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> taxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxblAmt');
    });
  }

  QueryBuilder<TransactionItem, int?, QQueryOperations> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tin');
    });
  }

  QueryBuilder<TransactionItem, double?, QQueryOperations> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totAmt');
    });
  }

  QueryBuilder<TransactionItem, int, QQueryOperations> transactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transactionId');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<TransactionItem, String, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<TransactionItem, String?, QQueryOperations> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useYn');
    });
  }

  QueryBuilder<TransactionItem, int, QQueryOperations> variantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'variantId');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionItem _$TransactionItemFromJson(Map<String, dynamic> json) =>
    TransactionItem(
      id: json['id'] as int?,
      name: json['name'] as String,
      transactionId: json['transactionId'] as int,
      variantId: json['variantId'] as int,
      qty: (json['qty'] as num).toDouble(),
      price: (json['price'] as num).toDouble(),
      discount: (json['discount'] as num?)?.toDouble(),
      type: json['type'] as String?,
      reported: json['reported'] as bool?,
      remainingStock: (json['remainingStock'] as num).toDouble(),
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      isTaxExempted: json['isTaxExempted'] as bool,
      isRefunded: json['isRefunded'] as bool?,
      doneWithTransaction: json['doneWithTransaction'] as bool?,
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
      lastTouched: json['lastTouched'] as String?,
      deletedAt: json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String),
    )
      ..remoteID = json['remoteID'] as String?
      ..action = json['action'] as String?
      ..localId = json['localId'] as int?;

Map<String, dynamic> _$TransactionItemToJson(TransactionItem instance) =>
    <String, dynamic>{
      'remoteID': instance.remoteID,
      'id': instance.id,
      'name': instance.name,
      'transactionId': instance.transactionId,
      'variantId': instance.variantId,
      'qty': instance.qty,
      'price': instance.price,
      'discount': instance.discount,
      'type': instance.type,
      'reported': instance.reported,
      'remainingStock': instance.remainingStock,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'isTaxExempted': instance.isTaxExempted,
      'isRefunded': instance.isRefunded,
      'doneWithTransaction': instance.doneWithTransaction,
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
      'lastTouched': instance.lastTouched,
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      'localId': instance.localId,
    };
