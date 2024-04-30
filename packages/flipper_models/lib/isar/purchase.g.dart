// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPurchaseCollection on Isar {
  IsarCollection<Purchase> get purchases => this.collection();
}

const PurchaseSchema = CollectionSchema(
  name: r'Purchase',
  id: -2376489861051921561,
  properties: {
    r'action': PropertySchema(
      id: 0,
      name: r'action',
      type: IsarType.string,
    ),
    r'bhfId': PropertySchema(
      id: 1,
      name: r'bhfId',
      type: IsarType.string,
    ),
    r'cfmDt': PropertySchema(
      id: 2,
      name: r'cfmDt',
      type: IsarType.string,
    ),
    r'cnclDt': PropertySchema(
      id: 3,
      name: r'cnclDt',
      type: IsarType.string,
    ),
    r'cnclReqDt': PropertySchema(
      id: 4,
      name: r'cnclReqDt',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 5,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'deletedAt': PropertySchema(
      id: 6,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'invcNo': PropertySchema(
      id: 7,
      name: r'invcNo',
      type: IsarType.long,
    ),
    r'itemIds': PropertySchema(
      id: 8,
      name: r'itemIds',
      type: IsarType.stringList,
    ),
    r'lastTouched': PropertySchema(
      id: 9,
      name: r'lastTouched',
      type: IsarType.dateTime,
    ),
    r'modrId': PropertySchema(
      id: 10,
      name: r'modrId',
      type: IsarType.long,
    ),
    r'modrNm': PropertySchema(
      id: 11,
      name: r'modrNm',
      type: IsarType.string,
    ),
    r'orgInvcNo': PropertySchema(
      id: 12,
      name: r'orgInvcNo',
      type: IsarType.long,
    ),
    r'pchsDt': PropertySchema(
      id: 13,
      name: r'pchsDt',
      type: IsarType.string,
    ),
    r'pchsSttsCd': PropertySchema(
      id: 14,
      name: r'pchsSttsCd',
      type: IsarType.string,
    ),
    r'pchsTyCd': PropertySchema(
      id: 15,
      name: r'pchsTyCd',
      type: IsarType.string,
    ),
    r'pmtTyCd': PropertySchema(
      id: 16,
      name: r'pmtTyCd',
      type: IsarType.string,
    ),
    r'rcptTyCd': PropertySchema(
      id: 17,
      name: r'rcptTyCd',
      type: IsarType.string,
    ),
    r'regTyCd': PropertySchema(
      id: 18,
      name: r'regTyCd',
      type: IsarType.string,
    ),
    r'regrId': PropertySchema(
      id: 19,
      name: r'regrId',
      type: IsarType.long,
    ),
    r'remark': PropertySchema(
      id: 20,
      name: r'remark',
      type: IsarType.string,
    ),
    r'rfdDt': PropertySchema(
      id: 21,
      name: r'rfdDt',
      type: IsarType.string,
    ),
    r'spplrBhfId': PropertySchema(
      id: 22,
      name: r'spplrBhfId',
      type: IsarType.string,
    ),
    r'spplrInvcNo': PropertySchema(
      id: 23,
      name: r'spplrInvcNo',
      type: IsarType.string,
    ),
    r'spplrNm': PropertySchema(
      id: 24,
      name: r'spplrNm',
      type: IsarType.string,
    ),
    r'spplrTin': PropertySchema(
      id: 25,
      name: r'spplrTin',
      type: IsarType.string,
    ),
    r'taxAmtA': PropertySchema(
      id: 26,
      name: r'taxAmtA',
      type: IsarType.double,
    ),
    r'taxAmtB': PropertySchema(
      id: 27,
      name: r'taxAmtB',
      type: IsarType.double,
    ),
    r'taxAmtC': PropertySchema(
      id: 28,
      name: r'taxAmtC',
      type: IsarType.double,
    ),
    r'taxAmtD': PropertySchema(
      id: 29,
      name: r'taxAmtD',
      type: IsarType.double,
    ),
    r'taxRtA': PropertySchema(
      id: 30,
      name: r'taxRtA',
      type: IsarType.double,
    ),
    r'taxRtB': PropertySchema(
      id: 31,
      name: r'taxRtB',
      type: IsarType.double,
    ),
    r'taxRtC': PropertySchema(
      id: 32,
      name: r'taxRtC',
      type: IsarType.double,
    ),
    r'taxRtD': PropertySchema(
      id: 33,
      name: r'taxRtD',
      type: IsarType.double,
    ),
    r'taxblAmtA': PropertySchema(
      id: 34,
      name: r'taxblAmtA',
      type: IsarType.double,
    ),
    r'taxblAmtB': PropertySchema(
      id: 35,
      name: r'taxblAmtB',
      type: IsarType.double,
    ),
    r'taxblAmtC': PropertySchema(
      id: 36,
      name: r'taxblAmtC',
      type: IsarType.double,
    ),
    r'taxblAmtD': PropertySchema(
      id: 37,
      name: r'taxblAmtD',
      type: IsarType.double,
    ),
    r'tin': PropertySchema(
      id: 38,
      name: r'tin',
      type: IsarType.string,
    ),
    r'totAmt': PropertySchema(
      id: 39,
      name: r'totAmt',
      type: IsarType.double,
    ),
    r'totItemCnt': PropertySchema(
      id: 40,
      name: r'totItemCnt',
      type: IsarType.long,
    ),
    r'totTaxAmt': PropertySchema(
      id: 41,
      name: r'totTaxAmt',
      type: IsarType.double,
    ),
    r'totTaxblAmt': PropertySchema(
      id: 42,
      name: r'totTaxblAmt',
      type: IsarType.double,
    ),
    r'wrhsDt': PropertySchema(
      id: 43,
      name: r'wrhsDt',
      type: IsarType.string,
    )
  },
  estimateSize: _purchaseEstimateSize,
  serialize: _purchaseSerialize,
  deserialize: _purchaseDeserialize,
  deserializeProp: _purchaseDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _purchaseGetId,
  getLinks: _purchaseGetLinks,
  attach: _purchaseAttach,
  version: '3.1.0+1',
);

int _purchaseEstimateSize(
  Purchase object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.action.length * 3;
  {
    final value = object.bhfId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cfmDt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cnclDt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.cnclReqDt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.itemIds.length * 3;
  {
    for (var i = 0; i < object.itemIds.length; i++) {
      final value = object.itemIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.modrNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pchsDt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pchsSttsCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pchsTyCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pmtTyCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rcptTyCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.regTyCd;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.remark;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.rfdDt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.spplrBhfId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.spplrInvcNo;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.spplrNm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.spplrTin;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.tin;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.wrhsDt;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _purchaseSerialize(
  Purchase object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.action);
  writer.writeString(offsets[1], object.bhfId);
  writer.writeString(offsets[2], object.cfmDt);
  writer.writeString(offsets[3], object.cnclDt);
  writer.writeString(offsets[4], object.cnclReqDt);
  writer.writeDateTime(offsets[5], object.createdAt);
  writer.writeDateTime(offsets[6], object.deletedAt);
  writer.writeLong(offsets[7], object.invcNo);
  writer.writeStringList(offsets[8], object.itemIds);
  writer.writeDateTime(offsets[9], object.lastTouched);
  writer.writeLong(offsets[10], object.modrId);
  writer.writeString(offsets[11], object.modrNm);
  writer.writeLong(offsets[12], object.orgInvcNo);
  writer.writeString(offsets[13], object.pchsDt);
  writer.writeString(offsets[14], object.pchsSttsCd);
  writer.writeString(offsets[15], object.pchsTyCd);
  writer.writeString(offsets[16], object.pmtTyCd);
  writer.writeString(offsets[17], object.rcptTyCd);
  writer.writeString(offsets[18], object.regTyCd);
  writer.writeLong(offsets[19], object.regrId);
  writer.writeString(offsets[20], object.remark);
  writer.writeString(offsets[21], object.rfdDt);
  writer.writeString(offsets[22], object.spplrBhfId);
  writer.writeString(offsets[23], object.spplrInvcNo);
  writer.writeString(offsets[24], object.spplrNm);
  writer.writeString(offsets[25], object.spplrTin);
  writer.writeDouble(offsets[26], object.taxAmtA);
  writer.writeDouble(offsets[27], object.taxAmtB);
  writer.writeDouble(offsets[28], object.taxAmtC);
  writer.writeDouble(offsets[29], object.taxAmtD);
  writer.writeDouble(offsets[30], object.taxRtA);
  writer.writeDouble(offsets[31], object.taxRtB);
  writer.writeDouble(offsets[32], object.taxRtC);
  writer.writeDouble(offsets[33], object.taxRtD);
  writer.writeDouble(offsets[34], object.taxblAmtA);
  writer.writeDouble(offsets[35], object.taxblAmtB);
  writer.writeDouble(offsets[36], object.taxblAmtC);
  writer.writeDouble(offsets[37], object.taxblAmtD);
  writer.writeString(offsets[38], object.tin);
  writer.writeDouble(offsets[39], object.totAmt);
  writer.writeLong(offsets[40], object.totItemCnt);
  writer.writeDouble(offsets[41], object.totTaxAmt);
  writer.writeDouble(offsets[42], object.totTaxblAmt);
  writer.writeString(offsets[43], object.wrhsDt);
}

Purchase _purchaseDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Purchase(
    action: reader.readString(offsets[0]),
    bhfId: reader.readStringOrNull(offsets[1]),
    cfmDt: reader.readStringOrNull(offsets[2]),
    cnclDt: reader.readStringOrNull(offsets[3]),
    cnclReqDt: reader.readStringOrNull(offsets[4]),
    createdAt: reader.readDateTime(offsets[5]),
    id: id,
    invcNo: reader.readLongOrNull(offsets[7]),
    itemIds: reader.readStringList(offsets[8]) ?? [],
    lastTouched: reader.readDateTimeOrNull(offsets[9]),
    modrId: reader.readLongOrNull(offsets[10]),
    modrNm: reader.readStringOrNull(offsets[11]),
    orgInvcNo: reader.readLongOrNull(offsets[12]),
    pchsDt: reader.readStringOrNull(offsets[13]),
    pchsSttsCd: reader.readStringOrNull(offsets[14]),
    pchsTyCd: reader.readStringOrNull(offsets[15]),
    pmtTyCd: reader.readStringOrNull(offsets[16]),
    rcptTyCd: reader.readStringOrNull(offsets[17]),
    regTyCd: reader.readStringOrNull(offsets[18]),
    regrId: reader.readLongOrNull(offsets[19]),
    remark: reader.readStringOrNull(offsets[20]),
    rfdDt: reader.readStringOrNull(offsets[21]),
    spplrBhfId: reader.readStringOrNull(offsets[22]),
    spplrInvcNo: reader.readStringOrNull(offsets[23]),
    spplrNm: reader.readStringOrNull(offsets[24]),
    spplrTin: reader.readStringOrNull(offsets[25]),
    taxAmtA: reader.readDoubleOrNull(offsets[26]),
    taxAmtB: reader.readDoubleOrNull(offsets[27]),
    taxAmtC: reader.readDoubleOrNull(offsets[28]),
    taxAmtD: reader.readDoubleOrNull(offsets[29]),
    taxRtA: reader.readDoubleOrNull(offsets[30]),
    taxRtB: reader.readDoubleOrNull(offsets[31]),
    taxRtC: reader.readDoubleOrNull(offsets[32]),
    taxRtD: reader.readDoubleOrNull(offsets[33]),
    taxblAmtA: reader.readDoubleOrNull(offsets[34]),
    taxblAmtB: reader.readDoubleOrNull(offsets[35]),
    taxblAmtC: reader.readDoubleOrNull(offsets[36]),
    taxblAmtD: reader.readDoubleOrNull(offsets[37]),
    tin: reader.readStringOrNull(offsets[38]),
    totAmt: reader.readDoubleOrNull(offsets[39]),
    totItemCnt: reader.readLongOrNull(offsets[40]),
    totTaxAmt: reader.readDoubleOrNull(offsets[41]),
    totTaxblAmt: reader.readDoubleOrNull(offsets[42]),
    wrhsDt: reader.readStringOrNull(offsets[43]),
  );
  object.deletedAt = reader.readDateTimeOrNull(offsets[6]);
  return object;
}

P _purchaseDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readLongOrNull(offset)) as P;
    case 8:
      return (reader.readStringList(offset) ?? []) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
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
      return (reader.readLongOrNull(offset)) as P;
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
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readDoubleOrNull(offset)) as P;
    case 27:
      return (reader.readDoubleOrNull(offset)) as P;
    case 28:
      return (reader.readDoubleOrNull(offset)) as P;
    case 29:
      return (reader.readDoubleOrNull(offset)) as P;
    case 30:
      return (reader.readDoubleOrNull(offset)) as P;
    case 31:
      return (reader.readDoubleOrNull(offset)) as P;
    case 32:
      return (reader.readDoubleOrNull(offset)) as P;
    case 33:
      return (reader.readDoubleOrNull(offset)) as P;
    case 34:
      return (reader.readDoubleOrNull(offset)) as P;
    case 35:
      return (reader.readDoubleOrNull(offset)) as P;
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
      return (reader.readDoubleOrNull(offset)) as P;
    case 43:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _purchaseGetId(Purchase object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _purchaseGetLinks(Purchase object) {
  return [];
}

void _purchaseAttach(IsarCollection<dynamic> col, Id id, Purchase object) {
  object.id = id;
}

extension PurchaseQueryWhereSort on QueryBuilder<Purchase, Purchase, QWhere> {
  QueryBuilder<Purchase, Purchase, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PurchaseQueryWhere on QueryBuilder<Purchase, Purchase, QWhereClause> {
  QueryBuilder<Purchase, Purchase, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Purchase, Purchase, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterWhereClause> idBetween(
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
}

extension PurchaseQueryFilter
    on QueryBuilder<Purchase, Purchase, QFilterCondition> {
  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionEqualTo(
    String value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionGreaterThan(
    String value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionLessThan(
    String value, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'action',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'action',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'action',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bhfId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> bhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cfmDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cfmDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cfmDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cfmDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cfmDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cfmDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cfmDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cfmDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cfmDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cfmDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cfmDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cfmDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cfmDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cnclDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cnclDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnclDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cnclDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cnclDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cnclDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cnclDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cnclDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cnclDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cnclDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnclDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cnclDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'cnclReqDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'cnclReqDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnclReqDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cnclReqDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cnclReqDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cnclReqDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cnclReqDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cnclReqDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cnclReqDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cnclReqDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> cnclReqDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cnclReqDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      cnclReqDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cnclReqDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> deletedAtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'invcNo',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'invcNo',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'invcNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'invcNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'invcNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> invcNoBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'invcNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'itemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'itemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'itemIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'itemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'itemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'itemIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsElementMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'itemIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'itemIds',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'itemIds',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'itemIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'itemIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'itemIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'itemIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      itemIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'itemIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> itemIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'itemIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      lastTouchedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastTouched',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastTouched',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      lastTouchedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastTouched',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastTouched',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> lastTouchedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastTouched',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modrId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrId',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'modrId',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'modrId',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'modrId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'modrNm',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'modrNm',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmStartsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmEndsWith(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmContains(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmMatches(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'modrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> modrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'modrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'orgInvcNo',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'orgInvcNo',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orgInvcNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orgInvcNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orgInvcNo',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> orgInvcNoBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orgInvcNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pchsDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pchsDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pchsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pchsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pchsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pchsDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pchsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pchsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pchsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pchsDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pchsDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pchsDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pchsSttsCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsSttsCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pchsSttsCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pchsSttsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pchsSttsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pchsSttsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pchsSttsCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pchsSttsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pchsSttsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pchsSttsCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pchsSttsCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsSttsCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pchsSttsCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      pchsSttsCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pchsSttsCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pchsTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pchsTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pchsTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pchsTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pchsTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pchsTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pchsTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pchsTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pchsTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pchsTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pchsTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pchsTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pchsTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pmtTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pmtTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pmtTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pmtTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pmtTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pmtTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pmtTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pmtTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pmtTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pmtTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pmtTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> pmtTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pmtTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rcptTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rcptTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rcptTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rcptTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rcptTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rcptTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rcptTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rcptTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rcptTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rcptTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rcptTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rcptTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rcptTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regTyCd',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regTyCd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'regTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'regTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'regTyCd',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'regTyCd',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regTyCdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'regTyCd',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'regrId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'regrId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'regrId',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'regrId',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'regrId',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> regrIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'regrId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'remark',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'remark',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'remark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'remark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'remark',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'remark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'remark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'remark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'remark',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'remark',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> remarkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'remark',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'rfdDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'rfdDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rfdDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rfdDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rfdDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rfdDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rfdDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rfdDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rfdDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rfdDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rfdDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> rfdDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rfdDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'spplrBhfId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrBhfIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'spplrBhfId',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrBhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'spplrBhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'spplrBhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'spplrBhfId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'spplrBhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'spplrBhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'spplrBhfId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'spplrBhfId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrBhfIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrBhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrBhfIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'spplrBhfId',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'spplrInvcNo',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'spplrInvcNo',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrInvcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'spplrInvcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'spplrInvcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'spplrInvcNo',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'spplrInvcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'spplrInvcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'spplrInvcNo',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'spplrInvcNo',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrInvcNoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrInvcNo',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      spplrInvcNoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'spplrInvcNo',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'spplrNm',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'spplrNm',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'spplrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'spplrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'spplrNm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'spplrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'spplrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'spplrNm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'spplrNm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrNmIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'spplrNm',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'spplrTin',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'spplrTin',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrTin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'spplrTin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'spplrTin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'spplrTin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'spplrTin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'spplrTin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'spplrTin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'spplrTin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'spplrTin',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> spplrTinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'spplrTin',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxAmtA',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxAmtA',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxAmtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtAGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxAmtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtALessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxAmtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtABetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxAmtA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxAmtB',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxAmtB',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxAmtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxAmtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxAmtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtBBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxAmtB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxAmtC',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxAmtC',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxAmtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxAmtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxAmtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtCBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxAmtC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxAmtD',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxAmtD',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxAmtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxAmtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxAmtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxAmtDBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxAmtD',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxRtA',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxRtA',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxRtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtAGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxRtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtALessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxRtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtABetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxRtA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxRtB',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxRtB',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxRtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxRtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxRtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtBBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxRtB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxRtC',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxRtC',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxRtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxRtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxRtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtCBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxRtC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxRtD',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxRtD',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxRtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxRtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxRtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxRtDBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxRtD',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxblAmtA',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxblAmtA',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxblAmtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtAGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxblAmtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtALessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxblAmtA',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtABetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxblAmtA',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxblAmtB',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxblAmtB',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxblAmtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxblAmtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxblAmtB',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtBBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxblAmtB',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxblAmtC',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxblAmtC',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxblAmtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxblAmtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxblAmtC',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtCBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxblAmtC',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'taxblAmtD',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'taxblAmtD',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'taxblAmtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'taxblAmtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'taxblAmtD',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> taxblAmtDBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'taxblAmtD',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tin',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tin',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tin',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tin',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tin',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tin',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> tinIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'tin',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totAmt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totAmt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtEqualTo(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtGreaterThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtLessThan(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totAmtBetween(
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

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totItemCnt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totItemCntIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totItemCnt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totItemCnt',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totItemCnt',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totItemCnt',
        value: value,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totItemCntBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totItemCnt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totTaxAmt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totTaxAmt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totTaxAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totTaxAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totTaxAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxAmtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totTaxAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totTaxblAmt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxblAmtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totTaxblAmt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totTaxblAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition>
      totTaxblAmtGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totTaxblAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totTaxblAmt',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> totTaxblAmtBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totTaxblAmt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wrhsDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wrhsDt',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrhsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrhsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrhsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrhsDt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wrhsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wrhsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wrhsDt',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wrhsDt',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrhsDt',
        value: '',
      ));
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterFilterCondition> wrhsDtIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wrhsDt',
        value: '',
      ));
    });
  }
}

extension PurchaseQueryObject
    on QueryBuilder<Purchase, Purchase, QFilterCondition> {}

extension PurchaseQueryLinks
    on QueryBuilder<Purchase, Purchase, QFilterCondition> {}

extension PurchaseQuerySortBy on QueryBuilder<Purchase, Purchase, QSortBy> {
  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCfmDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfmDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCfmDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfmDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclReqDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclReqDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCnclReqDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclReqDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invcNo', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invcNo', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByOrgInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgInvcNo', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByOrgInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgInvcNo', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsSttsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsSttsCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsSttsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsSttsCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPchsTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPmtTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pmtTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByPmtTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pmtTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRcptTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRcptTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRemark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remark', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRemarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remark', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRfdDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rfdDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByRfdDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rfdDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrBhfId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrBhfId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrInvcNo', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrInvcNo', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrNm', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrNm', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrTin', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortBySpplrTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrTin', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtA', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtA', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtB', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtB', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtC', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtC', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtD', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtD', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtA', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtA', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtB', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtB', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtC', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtC', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtD', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxRtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtD', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtA', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtA', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtB', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtB', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtC', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtC', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtD', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTaxblAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtD', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotItemCnt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totItemCnt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotItemCntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totItemCnt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxAmt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxAmt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxblAmt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByTotTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxblAmt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByWrhsDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrhsDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> sortByWrhsDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrhsDt', Sort.desc);
    });
  }
}

extension PurchaseQuerySortThenBy
    on QueryBuilder<Purchase, Purchase, QSortThenBy> {
  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'action', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bhfId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCfmDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfmDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCfmDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cfmDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclReqDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclReqDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCnclReqDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cnclReqDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invcNo', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'invcNo', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastTouched', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByModrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'modrNm', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByOrgInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgInvcNo', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByOrgInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orgInvcNo', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsSttsCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsSttsCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsSttsCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsSttsCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPchsTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pchsTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPmtTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pmtTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByPmtTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pmtTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRcptTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRcptTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rcptTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegTyCd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regTyCd', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegTyCdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regTyCd', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRegrIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'regrId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRemark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remark', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRemarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remark', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRfdDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rfdDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByRfdDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rfdDt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrBhfId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrBhfId', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrBhfIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrBhfId', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrInvcNo', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrInvcNoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrInvcNo', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrNm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrNm', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrNmDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrNm', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrTin', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenBySpplrTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'spplrTin', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtA', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtA', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtB', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtB', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtC', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtC', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtD', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxAmtD', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtA', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtA', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtB', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtB', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtC', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtC', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtD', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxRtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxRtD', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtA', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtADesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtA', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtB', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtBDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtB', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtC', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtCDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtC', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtD', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTaxblAmtDDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'taxblAmtD', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTin() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTinDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tin', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totAmt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotItemCnt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totItemCnt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotItemCntDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totItemCnt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxAmt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxAmt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxblAmt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByTotTaxblAmtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totTaxblAmt', Sort.desc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByWrhsDt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrhsDt', Sort.asc);
    });
  }

  QueryBuilder<Purchase, Purchase, QAfterSortBy> thenByWrhsDtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrhsDt', Sort.desc);
    });
  }
}

extension PurchaseQueryWhereDistinct
    on QueryBuilder<Purchase, Purchase, QDistinct> {
  QueryBuilder<Purchase, Purchase, QDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'action', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bhfId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByCfmDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cfmDt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByCnclDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cnclDt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByCnclReqDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cnclReqDt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'invcNo');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByItemIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'itemIds');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastTouched');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByModrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrId');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByModrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'modrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByOrgInvcNo() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orgInvcNo');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByPchsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pchsDt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByPchsSttsCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pchsSttsCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByPchsTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pchsTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByPmtTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pmtTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByRcptTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rcptTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByRegTyCd(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regTyCd', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByRegrId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'regrId');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByRemark(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remark', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByRfdDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rfdDt', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctBySpplrBhfId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spplrBhfId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctBySpplrInvcNo(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spplrInvcNo', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctBySpplrNm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spplrNm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctBySpplrTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'spplrTin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxAmtA');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxAmtB');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxAmtC');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxAmtD');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxRtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxRtA');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxRtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxRtB');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxRtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxRtC');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxRtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxRtD');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxblAmtA() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxblAmtA');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxblAmtB() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxblAmtB');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxblAmtC() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxblAmtC');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTaxblAmtD() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'taxblAmtD');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTin(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tin', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTotAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totAmt');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTotItemCnt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totItemCnt');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTotTaxAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totTaxAmt');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByTotTaxblAmt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totTaxblAmt');
    });
  }

  QueryBuilder<Purchase, Purchase, QDistinct> distinctByWrhsDt(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrhsDt', caseSensitive: caseSensitive);
    });
  }
}

extension PurchaseQueryProperty
    on QueryBuilder<Purchase, Purchase, QQueryProperty> {
  QueryBuilder<Purchase, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Purchase, String, QQueryOperations> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'action');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> bhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bhfId');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> cfmDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cfmDt');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> cnclDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cnclDt');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> cnclReqDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cnclReqDt');
    });
  }

  QueryBuilder<Purchase, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Purchase, DateTime?, QQueryOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<Purchase, int?, QQueryOperations> invcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'invcNo');
    });
  }

  QueryBuilder<Purchase, List<String>, QQueryOperations> itemIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'itemIds');
    });
  }

  QueryBuilder<Purchase, DateTime?, QQueryOperations> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastTouched');
    });
  }

  QueryBuilder<Purchase, int?, QQueryOperations> modrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrId');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> modrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'modrNm');
    });
  }

  QueryBuilder<Purchase, int?, QQueryOperations> orgInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orgInvcNo');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> pchsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pchsDt');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> pchsSttsCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pchsSttsCd');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> pchsTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pchsTyCd');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> pmtTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pmtTyCd');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> rcptTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rcptTyCd');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> regTyCdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regTyCd');
    });
  }

  QueryBuilder<Purchase, int?, QQueryOperations> regrIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'regrId');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> remarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remark');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> rfdDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rfdDt');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> spplrBhfIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spplrBhfId');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> spplrInvcNoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spplrInvcNo');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> spplrNmProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spplrNm');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> spplrTinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'spplrTin');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxAmtA');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxAmtB');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxAmtC');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxAmtD');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxRtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxRtA');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxRtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxRtB');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxRtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxRtC');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxRtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxRtD');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxblAmtAProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxblAmtA');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxblAmtBProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxblAmtB');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxblAmtCProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxblAmtC');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> taxblAmtDProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'taxblAmtD');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> tinProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tin');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> totAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totAmt');
    });
  }

  QueryBuilder<Purchase, int?, QQueryOperations> totItemCntProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totItemCnt');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> totTaxAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totTaxAmt');
    });
  }

  QueryBuilder<Purchase, double?, QQueryOperations> totTaxblAmtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totTaxblAmt');
    });
  }

  QueryBuilder<Purchase, String?, QQueryOperations> wrhsDtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrhsDt');
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      id: json['id'] as int?,
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
