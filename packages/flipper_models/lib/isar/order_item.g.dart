// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderItemCollection on Isar {
  IsarCollection<OrderItem> get orderItems => this.collection();
}

const OrderItemSchema = CollectionSchema(
  name: r'OrderItem',
  id: -5113141332666578860,
  properties: {
    r'addInfo': PropertySchema(
      id: 0,
      name: r'addInfo',
      type: IsarType.string,
    ),
    r'bcd': PropertySchema(
      id: 1,
      name: r'bcd',
      type: IsarType.string,
    ),
    r'bhfId': PropertySchema(
      id: 2,
      name: r'bhfId',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.string,
    ),
    r'dcAmt': PropertySchema(
      id: 4,
      name: r'dcAmt',
      type: IsarType.double,
    ),
    r'dcRt': PropertySchema(
      id: 5,
      name: r'dcRt',
      type: IsarType.double,
    ),
    r'dftPrc': PropertySchema(
      id: 6,
      name: r'dftPrc',
      type: IsarType.double,
    ),
    r'discount': PropertySchema(
      id: 7,
      name: r'discount',
      type: IsarType.double,
    ),
    r'isRefunded': PropertySchema(
      id: 8,
      name: r'isRefunded',
      type: IsarType.bool,
    ),
    r'isTaxExempted': PropertySchema(
      id: 9,
      name: r'isTaxExempted',
      type: IsarType.bool,
    ),
    r'isrcAmt': PropertySchema(
      id: 10,
      name: r'isrcAmt',
      type: IsarType.string,
    ),
    r'isrcAplcbYn': PropertySchema(
      id: 11,
      name: r'isrcAplcbYn',
      type: IsarType.string,
    ),
    r'isrcRt': PropertySchema(
      id: 12,
      name: r'isrcRt',
      type: IsarType.string,
    ),
    r'isrccCd': PropertySchema(
      id: 13,
      name: r'isrccCd',
      type: IsarType.string,
    ),
    r'isrccNm': PropertySchema(
      id: 14,
      name: r'isrccNm',
      type: IsarType.string,
    ),
    r'itemCd': PropertySchema(
      id: 15,
      name: r'itemCd',
      type: IsarType.string,
    ),
    r'itemClsCd': PropertySchema(
      id: 16,
      name: r'itemClsCd',
      type: IsarType.string,
    ),
    r'itemNm': PropertySchema(
      id: 17,
      name: r'itemNm',
      type: IsarType.string,
    ),
    r'itemSeq': PropertySchema(
      id: 18,
      name: r'itemSeq',
      type: IsarType.string,
    ),
    r'itemStdNm': PropertySchema(
      id: 19,
      name: r'itemStdNm',
      type: IsarType.string,
    ),
    r'itemTyCd': PropertySchema(
      id: 20,
      name: r'itemTyCd',
      type: IsarType.string,
    ),
    r'modrId': PropertySchema(
      id: 21,
      name: r'modrId',
      type: IsarType.string,
    ),
    r'modrNm': PropertySchema(
      id: 22,
      name: r'modrNm',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 23,
      name: r'name',
      type: IsarType.string,
    ),
    r'orderId': PropertySchema(
      id: 24,
      name: r'orderId',
      type: IsarType.long,
    ),
    r'orgnNatCd': PropertySchema(
      id: 25,
      name: r'orgnNatCd',
      type: IsarType.string,
    ),
    r'pkg': PropertySchema(
      id: 26,
      name: r'pkg',
      type: IsarType.string,
    ),
    r'pkgUnitCd': PropertySchema(
      id: 27,
      name: r'pkgUnitCd',
      type: IsarType.string,
    ),
    r'prc': PropertySchema(
      id: 28,
      name: r'prc',
      type: IsarType.double,
    ),
    r'price': PropertySchema(
      id: 29,
      name: r'price',
      type: IsarType.double,
    ),
    r'qty': PropertySchema(
      id: 30,
      name: r'qty',
      type: IsarType.double,
    ),
    r'qtyUnitCd': PropertySchema(
      id: 31,
      name: r'qtyUnitCd',
      type: IsarType.string,
    ),
    r'regrId': PropertySchema(
      id: 32,
      name: r'regrId',
      type: IsarType.string,
    ),
    r'regrNm': PropertySchema(
      id: 33,
      name: r'regrNm',
      type: IsarType.string,
    ),
    r'remainingStock': PropertySchema(
      id: 34,
      name: r'remainingStock',
      type: IsarType.double,
    ),
    r'reported': PropertySchema(
      id: 35,
      name: r'reported',
      type: IsarType.bool,
    ),
    r'splyAmt': PropertySchema(
      id: 36,
      name: r'splyAmt',
      type: IsarType.double,
    ),
    r'taxAmt': PropertySchema(
      id: 37,
      name: r'taxAmt',
      type: IsarType.double,
    ),
    r'taxTyCd': PropertySchema(
      id: 38,
      name: r'taxTyCd',
      type: IsarType.string,
    ),
    r'taxblAmt': PropertySchema(
      id: 39,
      name: r'taxblAmt',
      type: IsarType.double,
    ),
    r'tin': PropertySchema(
      id: 40,
      name: r'tin',
      type: IsarType.long,
    ),
    r'totAmt': PropertySchema(
      id: 41,
      name: r'totAmt',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 42,
      name: r'type',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 43,
      name: r'updatedAt',
      type: IsarType.string,
    ),
    r'useYn': PropertySchema(
      id: 44,
      name: r'useYn',
      type: IsarType.string,
    ),
    r'variantId': PropertySchema(
      id: 45,
      name: r'variantId',
      type: IsarType.long,
    )
  },
  estimateSize: _orderItemEstimateSize,
  serialize: _orderItemSerialize,
  deserialize: _orderItemDeserialize,
  deserializeProp: _orderItemDeserializeProp,
  idName: r'id',
  indexes: {
    r'orderId': IndexSchema(
      id: -6176610178429382285,
      name: r'orderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'variantId_orderId': IndexSchema(
      id: 1795974761994964438,
      name: r'variantId_orderId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'variantId',
          type: IndexType.value,
          caseSensitive: false,
        ),
        IndexPropertySchema(
          name: r'orderId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _orderItemGetId,
  getLinks: _orderItemGetLinks,
  attach: _orderItemAttach,
  version: '3.1.0+1',
);

int _orderItemEstimateSize(
  OrderItem object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
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

void _orderItemSerialize(
  OrderItem object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.addInfo);
  writer.writeString(offsets[1], object.bcd);
  writer.writeString(offsets[2], object.bhfId);
  writer.writeString(offsets[3], object.createdAt);
  writer.writeDouble(offsets[4], object.dcAmt);
  writer.writeDouble(offsets[5], object.dcRt);
  writer.writeDouble(offsets[6], object.dftPrc);
  writer.writeDouble(offsets[7], object.discount);
  writer.writeBool(offsets[8], object.isRefunded);
  writer.writeBool(offsets[9], object.isTaxExempted);
  writer.writeString(offsets[10], object.isrcAmt);
  writer.writeString(offsets[11], object.isrcAplcbYn);
  writer.writeString(offsets[12], object.isrcRt);
  writer.writeString(offsets[13], object.isrccCd);
  writer.writeString(offsets[14], object.isrccNm);
  writer.writeString(offsets[15], object.itemCd);
  writer.writeString(offsets[16], object.itemClsCd);
  writer.writeString(offsets[17], object.itemNm);
  writer.writeString(offsets[18], object.itemSeq);
  writer.writeString(offsets[19], object.itemStdNm);
  writer.writeString(offsets[20], object.itemTyCd);
  writer.writeString(offsets[21], object.modrId);
  writer.writeString(offsets[22], object.modrNm);
  writer.writeString(offsets[23], object.name);
  writer.writeLong(offsets[24], object.orderId);
  writer.writeString(offsets[25], object.orgnNatCd);
  writer.writeString(offsets[26], object.pkg);
  writer.writeString(offsets[27], object.pkgUnitCd);
  writer.writeDouble(offsets[28], object.prc);
  writer.writeDouble(offsets[29], object.price);
  writer.writeDouble(offsets[30], object.qty);
  writer.writeString(offsets[31], object.qtyUnitCd);
  writer.writeString(offsets[32], object.regrId);
  writer.writeString(offsets[33], object.regrNm);
  writer.writeDouble(offsets[34], object.remainingStock);
  writer.writeBool(offsets[35], object.reported);
  writer.writeDouble(offsets[36], object.splyAmt);
  writer.writeDouble(offsets[37], object.taxAmt);
  writer.writeString(offsets[38], object.taxTyCd);
  writer.writeDouble(offsets[39], object.taxblAmt);
  writer.writeLong(offsets[40], object.tin);
  writer.writeDouble(offsets[41], object.totAmt);
  writer.writeString(offsets[42], object.type);
  writer.writeString(offsets[43], object.updatedAt);
  writer.writeString(offsets[44], object.useYn);
  writer.writeLong(offsets[45], object.variantId);
}

OrderItem _orderItemDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderItem();
  object.addInfo = reader.readStringOrNull(offsets[0]);
  object.bcd = reader.readStringOrNull(offsets[1]);
  object.bhfId = reader.readStringOrNull(offsets[2]);
  object.createdAt = reader.readString(offsets[3]);
  object.dcAmt = reader.readDoubleOrNull(offsets[4]);
  object.dcRt = reader.readDoubleOrNull(offsets[5]);
  object.dftPrc = reader.readDoubleOrNull(offsets[6]);
  object.discount = reader.readDoubleOrNull(offsets[7]);
  object.id = id;
  object.isRefunded = reader.readBoolOrNull(offsets[8]);
  object.isTaxExempted = reader.readBool(offsets[9]);
  object.isrcAmt = reader.readStringOrNull(offsets[10]);
  object.isrcAplcbYn = reader.readStringOrNull(offsets[11]);
  object.isrcRt = reader.readStringOrNull(offsets[12]);
  object.isrccCd = reader.readStringOrNull(offsets[13]);
  object.isrccNm = reader.readStringOrNull(offsets[14]);
  object.itemCd = reader.readStringOrNull(offsets[15]);
  object.itemClsCd = reader.readStringOrNull(offsets[16]);
  object.itemNm = reader.readStringOrNull(offsets[17]);
  object.itemSeq = reader.readStringOrNull(offsets[18]);
  object.itemStdNm = reader.readStringOrNull(offsets[19]);
  object.itemTyCd = reader.readStringOrNull(offsets[20]);
  object.modrId = reader.readStringOrNull(offsets[21]);
  object.modrNm = reader.readStringOrNull(offsets[22]);
  object.name = reader.readString(offsets[23]);
  object.orderId = reader.readLong(offsets[24]);
  object.orgnNatCd = reader.readStringOrNull(offsets[25]);
  object.pkg = reader.readStringOrNull(offsets[26]);
  object.pkgUnitCd = reader.readStringOrNull(offsets[27]);
  object.prc = reader.readDoubleOrNull(offsets[28]);
  object.price = reader.readDouble(offsets[29]);
  object.qty = reader.readDouble(offsets[30]);
  object.qtyUnitCd = reader.readStringOrNull(offsets[31]);
  object.regrId = reader.readStringOrNull(offsets[32]);
  object.regrNm = reader.readStringOrNull(offsets[33]);
  object.remainingStock = reader.readDouble(offsets[34]);
  object.reported = reader.readBoolOrNull(offsets[35]);
  object.splyAmt = reader.readDoubleOrNull(offsets[36]);
  object.taxAmt = reader.readDoubleOrNull(offsets[37]);
  object.taxTyCd = reader.readStringOrNull(offsets[38]);
  object.taxblAmt = reader.readDoubleOrNull(offsets[39]);
  object.tin = reader.readLongOrNull(offsets[40]);
  object.totAmt = reader.readDoubleOrNull(offsets[41]);
  object.type = reader.readStringOrNull(offsets[42]);
  object.updatedAt = reader.readString(offsets[43]);
  object.useYn = reader.readStringOrNull(offsets[44]);
  object.variantId = reader.readLong(offsets[45]);
  return object;
}

P _orderItemDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readDoubleOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readBoolOrNull(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
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
      return (reader.readString(offset)) as P;
    case 24:
      return (reader.readLong(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readStringOrNull(offset)) as P;
    case 27:
      return (reader.readStringOrNull(offset)) as P;
    case 28:
      return (reader.readDoubleOrNull(offset)) as P;
    case 29:
      return (reader.readDouble(offset)) as P;
    case 30:
      return (reader.readDouble(offset)) as P;
    case 31:
      return (reader.readStringOrNull(offset)) as P;
    case 32:
      return (reader.readStringOrNull(offset)) as P;
    case 33:
      return (reader.readStringOrNull(offset)) as P;
    case 34:
      return (reader.readDouble(offset)) as P;
    case 35:
      return (reader.readBoolOrNull(offset)) as P;
    case 36:
      return (reader.readDoubleOrNull(offset)) as P;
    case 37:
      return (reader.readDoubleOrNull(offset)) as P;
    case 38:
      return (reader.readStringOrNull(offset)) as P;
    case 39:
      return (reader.readDoubleOrNull(offset)) as P;
    case 40:
      return (reader.readLongOrNull(offset)) as P;
    case 41:
      return (reader.readDoubleOrNull(offset)) as P;
    case 42:
      return (reader.readStringOrNull(offset)) as P;
    case 43:
      return (reader.readString(offset)) as P;
    case 44:
      return (reader.readStringOrNull(offset)) as P;
    case 45:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderItemGetId(OrderItem object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderItemGetLinks(OrderItem object) {
  return [];
}

void _orderItemAttach(IsarCollection<dynamic> col, Id id, OrderItem object) {
  object.id = id;
}

extension OrderItemQueryWhereSort
    on QueryBuilder<OrderItem, OrderItem, QWhere> {
  QueryBuilder<OrderItem, OrderItem, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhere> anyOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'orderId'),
      );
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhere> anyVariantIdOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'variantId_orderId'),
      );
    });
  }
}

extension OrderItemQueryWhere
    on QueryBuilder<OrderItem, OrderItem, QWhereClause> {
  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> idBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdEqualTo(
      int orderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderId',
        value: [orderId],
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdNotEqualTo(
      int orderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [],
              upper: [orderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [orderId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [orderId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderId',
              lower: [],
              upper: [orderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdGreaterThan(
    int orderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderId',
        lower: [orderId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdLessThan(
    int orderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderId',
        lower: [],
        upper: [orderId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> orderIdBetween(
    int lowerOrderId,
    int upperOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderId',
        lower: [lowerOrderId],
        includeLower: includeLower,
        upper: [upperOrderId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToAnyOrderId(int variantId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'variantId_orderId',
        value: [variantId],
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdNotEqualToAnyOrderId(int variantId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [],
              upper: [variantId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [variantId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [variantId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [],
              upper: [variantId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdGreaterThanAnyOrderId(
    int variantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_orderId',
        lower: [variantId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdLessThanAnyOrderId(
    int variantId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_orderId',
        lower: [],
        upper: [variantId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdBetweenAnyOrderId(
    int lowerVariantId,
    int upperVariantId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_orderId',
        lower: [lowerVariantId],
        includeLower: includeLower,
        upper: [upperVariantId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause> variantIdOrderIdEqualTo(
      int variantId, int orderId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'variantId_orderId',
        value: [variantId, orderId],
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToOrderIdNotEqualTo(int variantId, int orderId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [variantId],
              upper: [variantId, orderId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [variantId, orderId],
              includeLower: false,
              upper: [variantId],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [variantId, orderId],
              includeLower: false,
              upper: [variantId],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'variantId_orderId',
              lower: [variantId],
              upper: [variantId, orderId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToOrderIdGreaterThan(
    int variantId,
    int orderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_orderId',
        lower: [variantId, orderId],
        includeLower: include,
        upper: [variantId],
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToOrderIdLessThan(
    int variantId,
    int orderId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_orderId',
        lower: [variantId],
        upper: [variantId, orderId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterWhereClause>
      variantIdEqualToOrderIdBetween(
    int variantId,
    int lowerOrderId,
    int upperOrderId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'variantId_orderId',
        lower: [variantId, lowerOrderId],
        includeLower: includeLower,
        upper: [variantId, upperOrderId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension OrderItemQueryFilter
    on QueryBuilder<OrderItem, OrderItem, QFilterCondition> {
  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'addInfo',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'addInfo',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'addInfo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'addInfo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> addInfoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'addInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      addInfoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'addInfo',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bcd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bcd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bcd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bcd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bcd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bcdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bcd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bhfId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> bhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> createdAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      createdAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dcAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dcAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcAmtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dcRt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dcRt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dcRtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dftPrc',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dftPrc',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> dftPrcBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      discountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'discount',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> discountBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idGreaterThan(
    Id value, {
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idLessThan(
    Id value, {
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isRefundedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isRefunded',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isRefundedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isRefunded',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isRefundedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isRefunded',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isTaxExemptedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isTaxExempted',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrcAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcAmt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcAmt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAmtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAmt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAmtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrcAmt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAplcbYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcAplcbYn',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAplcbYnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrcAplcbYn',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcAplcbYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcAplcbYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcAplcbYn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAplcbYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcAplcbYn',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrcAplcbYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrcAplcbYn',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrcRt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrcRt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrcRt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrcRt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrcRt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrcRtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrcRt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrccCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrccCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrccCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrccCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrccCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrccCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'isrccNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'isrccNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'isrccNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'isrccNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> isrccNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isrccNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      isrccNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'isrccNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemClsCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemClsCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemClsCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemClsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemClsCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemClsCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemClsCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemClsCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemClsCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemSeq',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemSeq',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemSeq',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemSeq',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemSeqIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemSeq',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemSeqIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemSeq',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemStdNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemStdNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemStdNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemStdNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemStdNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemStdNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemStdNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemStdNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemStdNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'itemTyCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'itemTyCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> itemTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      itemTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrId',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modrId',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modrId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modrId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modrNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'modrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'modrNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> modrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orderIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orgnNatCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      orgnNatCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orgnNatCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orgnNatCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orgnNatCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> orgnNatCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgnNatCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      orgnNatCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orgnNatCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pkg',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pkg',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pkg',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pkg',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkg',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pkg',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pkgUnitCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      pkgUnitCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pkgUnitCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pkgUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pkgUnitCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> pkgUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pkgUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      pkgUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pkgUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'prc',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'prc',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> prcBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> priceBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qtyUnitCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      qtyUnitCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qtyUnitCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'qtyUnitCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'qtyUnitCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> qtyUnitCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qtyUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      qtyUnitCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'qtyUnitCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regrId',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regrId',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regrId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regrId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regrId',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regrNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regrNm',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regrNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> regrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> reportedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reported',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      reportedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reported',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> reportedEqualTo(
      bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reported',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'splyAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'splyAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> splyAmtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxAmtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxTyCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxTyCd',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'taxTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'taxTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      taxTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'taxTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxblAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      taxblAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxblAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> taxblAmtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tin',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tin',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tin',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> tinBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totAmt',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> totAmtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'updatedAt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'updatedAt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> updatedAtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
      updatedAtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'updatedAt',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'useYn',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'useYn',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnEqualTo(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnGreaterThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnBetween(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnStartsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnEndsWith(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'useYn',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'useYn',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useYn',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> useYnIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'useYn',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> variantIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'variantId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition>
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> variantIdLessThan(
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

  QueryBuilder<OrderItem, OrderItem, QAfterFilterCondition> variantIdBetween(
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

extension OrderItemQueryObject
    on QueryBuilder<OrderItem, OrderItem, QFilterCondition> {}

extension OrderItemQueryLinks
    on QueryBuilder<OrderItem, OrderItem, QFilterCondition> {}

extension OrderItemQuerySortBy on QueryBuilder<OrderItem, OrderItem, QSortBy> {
  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByAddInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByAddInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBcd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBcdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsRefundedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAplcbYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcAplcbYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByIsrccNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemClsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemClsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemSeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemSeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemStdNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemStdNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByItemTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrgnNatCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByOrgnNatCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkgUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPkgUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQtyUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByQtyUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRegrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByRemainingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByReported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByReportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUseYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByUseYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> sortByVariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.desc);
    });
  }
}

extension OrderItemQuerySortThenBy
    on QueryBuilder<OrderItem, OrderItem, QSortThenBy> {
  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByAddInfo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByAddInfoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'addInfo', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBcd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBcdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bcd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dcRt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDftPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dftPrc', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByDiscountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'discount', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsRefundedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isRefunded', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsTaxExemptedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isTaxExempted', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAplcbYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcAplcbYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcAplcbYn', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrcRtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrcRt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByIsrccNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isrccNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemClsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemClsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemClsCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemSeq() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemSeqDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemSeq', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemStdNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemStdNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemStdNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByItemTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'itemTyCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrgnNatCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByOrgnNatCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgnNatCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkg() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkgDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkg', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkgUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPkgUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pkgUnitCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPrcDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'prc', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'price', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qty', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQtyUnitCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByQtyUnitCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyUnitCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRegrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrNm', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByRemainingStockDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingStock', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByReported() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByReportedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reported', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenBySplyAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'splyAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxTyCd', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUseYn() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByUseYnDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useYn', Sort.desc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.asc);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QAfterSortBy> thenByVariantIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'variantId', Sort.desc);
    });
  }
}

extension OrderItemQueryWhereDistinct
    on QueryBuilder<OrderItem, OrderItem, QDistinct> {
  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByAddInfo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'addInfo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByBcd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bcd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bhfId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByCreatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDcAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dcAmt');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDcRt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dcRt');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDftPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dftPrc');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByDiscount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'discount');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsRefunded() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isRefunded');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsTaxExempted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isTaxExempted');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrcAmt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcAmt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrcAplcbYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcAplcbYn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrcRt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrcRt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrccCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrccCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByIsrccNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isrccNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemClsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemClsCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemSeq(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemSeq', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemStdNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemStdNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByItemTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByModrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByOrderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderId');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByOrgnNatCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgnNatCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPkg(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pkg', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPkgUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pkgUnitCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPrc() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'prc');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'price');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qty');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByQtyUnitCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qtyUnitCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByRegrId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regrId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByRegrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByRemainingStock() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingStock');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByReported() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reported');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctBySplyAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'splyAmt');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxAmt');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTaxTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxblAmt');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tin');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totAmt');
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByUpdatedAt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByUseYn(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useYn', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderItem, OrderItem, QDistinct> distinctByVariantId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'variantId');
    });
  }
}

extension OrderItemQueryProperty
    on QueryBuilder<OrderItem, OrderItem, QQueryProperty> {
  QueryBuilder<OrderItem, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> addInfoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'addInfo');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> bcdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bcd');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bhfId');
    });
  }

  QueryBuilder<OrderItem, String, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> dcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dcAmt');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> dcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dcRt');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> dftPrcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dftPrc');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> discountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'discount');
    });
  }

  QueryBuilder<OrderItem, bool?, QQueryOperations> isRefundedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isRefunded');
    });
  }

  QueryBuilder<OrderItem, bool, QQueryOperations> isTaxExemptedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isTaxExempted');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrcAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcAmt');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrcAplcbYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcAplcbYn');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrcRtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrcRt');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrccCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrccCd');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> isrccNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isrccNm');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemCd');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemClsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemClsCd');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemNm');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemSeqProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemSeq');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemStdNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemStdNm');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> itemTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemTyCd');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrId');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrNm');
    });
  }

  QueryBuilder<OrderItem, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<OrderItem, int, QQueryOperations> orderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderId');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> orgnNatCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgnNatCd');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> pkgProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pkg');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> pkgUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pkgUnitCd');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> prcProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'prc');
    });
  }

  QueryBuilder<OrderItem, double, QQueryOperations> priceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'price');
    });
  }

  QueryBuilder<OrderItem, double, QQueryOperations> qtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qty');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> qtyUnitCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qtyUnitCd');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regrId');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> regrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regrNm');
    });
  }

  QueryBuilder<OrderItem, double, QQueryOperations> remainingStockProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingStock');
    });
  }

  QueryBuilder<OrderItem, bool?, QQueryOperations> reportedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reported');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> splyAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'splyAmt');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> taxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxAmt');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> taxTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxTyCd');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> taxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxblAmt');
    });
  }

  QueryBuilder<OrderItem, int?, QQueryOperations> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tin');
    });
  }

  QueryBuilder<OrderItem, double?, QQueryOperations> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totAmt');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<OrderItem, String, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<OrderItem, String?, QQueryOperations> useYnProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useYn');
    });
  }

  QueryBuilder<OrderItem, int, QQueryOperations> variantIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'variantId');
    });
  }
}
