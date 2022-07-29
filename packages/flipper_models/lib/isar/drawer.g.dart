// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawer.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings

extension GetDrawersCollection on Isar {
  IsarCollection<Drawers> get drawers => collection();
}

const DrawersSchema = CollectionSchema(
  name: r'Drawers',
  schema:
      r'{"name":"Drawers","idName":"id","properties":[{"name":"cashierId","type":"Long"},{"name":"closingBalance","type":"Double"},{"name":"closingDateTime","type":"String"},{"name":"csSaleCount","type":"Long"},{"name":"incompleteSale","type":"Long"},{"name":"nrSaleCount","type":"Long"},{"name":"nsSaleCount","type":"Long"},{"name":"open","type":"Bool"},{"name":"openingBalance","type":"Double"},{"name":"openingDateTime","type":"String"},{"name":"otherTransactions","type":"Long"},{"name":"paymentMode","type":"String"},{"name":"psSaleCount","type":"Long"},{"name":"totalCsSaleIncome","type":"Double"},{"name":"totalNsSaleIncome","type":"Double"},{"name":"trSaleCount","type":"Long"},{"name":"tradeName","type":"String"}],"indexes":[{"name":"cashierId","unique":false,"replace":false,"properties":[{"name":"cashierId","type":"Value","caseSensitive":false}]},{"name":"open_cashierId","unique":false,"replace":false,"properties":[{"name":"open","type":"Value","caseSensitive":false},{"name":"cashierId","type":"Value","caseSensitive":false}]}],"links":[]}',
  idName: r'id',
  propertyIds: {
    r'cashierId': 0,
    r'closingBalance': 1,
    r'closingDateTime': 2,
    r'csSaleCount': 3,
    r'incompleteSale': 4,
    r'nrSaleCount': 5,
    r'nsSaleCount': 6,
    r'open': 7,
    r'openingBalance': 8,
    r'openingDateTime': 9,
    r'otherTransactions': 10,
    r'paymentMode': 11,
    r'psSaleCount': 12,
    r'totalCsSaleIncome': 13,
    r'totalNsSaleIncome': 14,
    r'trSaleCount': 15,
    r'tradeName': 16
  },
  listProperties: {},
  indexIds: {r'cashierId': 0, r'open_cashierId': 1},
  indexValueTypes: {
    r'cashierId': [
      IndexValueType.long,
    ],
    r'open_cashierId': [
      IndexValueType.bool,
      IndexValueType.long,
    ]
  },
  linkIds: {},
  backlinkLinkNames: {},
  getId: _drawersGetId,
  setId: _drawersSetId,
  getLinks: _drawersGetLinks,
  attachLinks: _drawersAttachLinks,
  serializeNative: _drawersSerializeNative,
  deserializeNative: _drawersDeserializeNative,
  deserializePropNative: _drawersDeserializePropNative,
  serializeWeb: _drawersSerializeWeb,
  deserializeWeb: _drawersDeserializeWeb,
  deserializePropWeb: _drawersDeserializePropWeb,
  version: 4,
);

int? _drawersGetId(Drawers object) {
  if (object.id == Isar.autoIncrement) {
    return null;
  } else {
    return object.id;
  }
}

void _drawersSetId(Drawers object, int id) {
  object.id = id;
}

List<IsarLinkBase<dynamic>> _drawersGetLinks(Drawers object) {
  return [];
}

void _drawersSerializeNative(
    IsarCollection<Drawers> collection,
    IsarCObject cObj,
    Drawers object,
    int staticSize,
    List<int> offsets,
    AdapterAlloc alloc) {
  IsarUint8List? closingDateTime$Bytes;
  final closingDateTime$Value = object.closingDateTime;
  if (closingDateTime$Value != null) {
    closingDateTime$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(closingDateTime$Value);
  }
  IsarUint8List? openingDateTime$Bytes;
  final openingDateTime$Value = object.openingDateTime;
  if (openingDateTime$Value != null) {
    openingDateTime$Bytes =
        IsarBinaryWriter.utf8Encoder.convert(openingDateTime$Value);
  }
  IsarUint8List? paymentMode$Bytes;
  final paymentMode$Value = object.paymentMode;
  if (paymentMode$Value != null) {
    paymentMode$Bytes = IsarBinaryWriter.utf8Encoder.convert(paymentMode$Value);
  }
  IsarUint8List? tradeName$Bytes;
  final tradeName$Value = object.tradeName;
  if (tradeName$Value != null) {
    tradeName$Bytes = IsarBinaryWriter.utf8Encoder.convert(tradeName$Value);
  }
  final size = (staticSize +
      3 +
      (closingDateTime$Bytes?.length ?? 0) +
      3 +
      (openingDateTime$Bytes?.length ?? 0) +
      3 +
      (paymentMode$Bytes?.length ?? 0) +
      3 +
      (tradeName$Bytes?.length ?? 0)) as int;
  cObj.buffer = alloc(size);
  cObj.buffer_length = size;

  final buffer = IsarNative.bufAsBytes(cObj.buffer, size);
  final writer = IsarBinaryWriter(buffer, staticSize);
  writer.writeHeader();
  writer.writeLong(offsets[0], object.cashierId);
  writer.writeDouble(offsets[1], object.closingBalance);
  writer.writeByteList(offsets[2], closingDateTime$Bytes);
  writer.writeLong(offsets[3], object.csSaleCount);
  writer.writeLong(offsets[4], object.incompleteSale);
  writer.writeLong(offsets[5], object.nrSaleCount);
  writer.writeLong(offsets[6], object.nsSaleCount);
  writer.writeBool(offsets[7], object.open);
  writer.writeDouble(offsets[8], object.openingBalance);
  writer.writeByteList(offsets[9], openingDateTime$Bytes);
  writer.writeLong(offsets[10], object.otherTransactions);
  writer.writeByteList(offsets[11], paymentMode$Bytes);
  writer.writeLong(offsets[12], object.psSaleCount);
  writer.writeDouble(offsets[13], object.totalCsSaleIncome);
  writer.writeDouble(offsets[14], object.totalNsSaleIncome);
  writer.writeLong(offsets[15], object.trSaleCount);
  writer.writeByteList(offsets[16], tradeName$Bytes);
}

Drawers _drawersDeserializeNative(IsarCollection<Drawers> collection, int id,
    IsarBinaryReader reader, List<int> offsets) {
  final object = Drawers();
  object.cashierId = reader.readLong(offsets[0]);
  object.closingBalance = reader.readDouble(offsets[1]);
  object.closingDateTime = reader.readStringOrNull(offsets[2]);
  object.csSaleCount = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.incompleteSale = reader.readLongOrNull(offsets[4]);
  object.nrSaleCount = reader.readLongOrNull(offsets[5]);
  object.nsSaleCount = reader.readLongOrNull(offsets[6]);
  object.open = reader.readBool(offsets[7]);
  object.openingBalance = reader.readDouble(offsets[8]);
  object.openingDateTime = reader.readStringOrNull(offsets[9]);
  object.otherTransactions = reader.readLongOrNull(offsets[10]);
  object.paymentMode = reader.readStringOrNull(offsets[11]);
  object.psSaleCount = reader.readLongOrNull(offsets[12]);
  object.totalCsSaleIncome = reader.readDoubleOrNull(offsets[13]);
  object.totalNsSaleIncome = reader.readDoubleOrNull(offsets[14]);
  object.trSaleCount = reader.readLongOrNull(offsets[15]);
  object.tradeName = reader.readStringOrNull(offsets[16]);
  return object;
}

P _drawersDeserializePropNative<P>(
    int id, IsarBinaryReader reader, int propertyIndex, int offset) {
  switch (propertyIndex) {
    case -1:
      return id as P;
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readLongOrNull(offset)) as P;
    case 13:
      return (reader.readDoubleOrNull(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset)) as P;
    case 15:
      return (reader.readLongOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Illegal propertyIndex');
  }
}

Object _drawersSerializeWeb(
    IsarCollection<Drawers> collection, Drawers object) {
  final jsObj = IsarNative.newJsObject();
  IsarNative.jsObjectSet(jsObj, r'cashierId', object.cashierId);
  IsarNative.jsObjectSet(jsObj, r'closingBalance', object.closingBalance);
  IsarNative.jsObjectSet(jsObj, r'closingDateTime', object.closingDateTime);
  IsarNative.jsObjectSet(jsObj, r'csSaleCount', object.csSaleCount);
  IsarNative.jsObjectSet(jsObj, r'id', object.id);
  IsarNative.jsObjectSet(jsObj, r'incompleteSale', object.incompleteSale);
  IsarNative.jsObjectSet(jsObj, r'nrSaleCount', object.nrSaleCount);
  IsarNative.jsObjectSet(jsObj, r'nsSaleCount', object.nsSaleCount);
  IsarNative.jsObjectSet(jsObj, r'open', object.open);
  IsarNative.jsObjectSet(jsObj, r'openingBalance', object.openingBalance);
  IsarNative.jsObjectSet(jsObj, r'openingDateTime', object.openingDateTime);
  IsarNative.jsObjectSet(jsObj, r'otherTransactions', object.otherTransactions);
  IsarNative.jsObjectSet(jsObj, r'paymentMode', object.paymentMode);
  IsarNative.jsObjectSet(jsObj, r'psSaleCount', object.psSaleCount);
  IsarNative.jsObjectSet(jsObj, r'totalCsSaleIncome', object.totalCsSaleIncome);
  IsarNative.jsObjectSet(jsObj, r'totalNsSaleIncome', object.totalNsSaleIncome);
  IsarNative.jsObjectSet(jsObj, r'trSaleCount', object.trSaleCount);
  IsarNative.jsObjectSet(jsObj, r'tradeName', object.tradeName);
  return jsObj;
}

Drawers _drawersDeserializeWeb(
    IsarCollection<Drawers> collection, Object jsObj) {
  final object = Drawers();
  object.cashierId = IsarNative.jsObjectGet(jsObj, r'cashierId') ??
      (double.negativeInfinity as int);
  object.closingBalance = IsarNative.jsObjectGet(jsObj, r'closingBalance') ??
      double.negativeInfinity;
  object.closingDateTime = IsarNative.jsObjectGet(jsObj, r'closingDateTime');
  object.csSaleCount = IsarNative.jsObjectGet(jsObj, r'csSaleCount');
  object.id = IsarNative.jsObjectGet(jsObj, r'id');
  object.incompleteSale = IsarNative.jsObjectGet(jsObj, r'incompleteSale');
  object.nrSaleCount = IsarNative.jsObjectGet(jsObj, r'nrSaleCount');
  object.nsSaleCount = IsarNative.jsObjectGet(jsObj, r'nsSaleCount');
  object.open = IsarNative.jsObjectGet(jsObj, r'open') ?? false;
  object.openingBalance = IsarNative.jsObjectGet(jsObj, r'openingBalance') ??
      double.negativeInfinity;
  object.openingDateTime = IsarNative.jsObjectGet(jsObj, r'openingDateTime');
  object.otherTransactions =
      IsarNative.jsObjectGet(jsObj, r'otherTransactions');
  object.paymentMode = IsarNative.jsObjectGet(jsObj, r'paymentMode');
  object.psSaleCount = IsarNative.jsObjectGet(jsObj, r'psSaleCount');
  object.totalCsSaleIncome =
      IsarNative.jsObjectGet(jsObj, r'totalCsSaleIncome');
  object.totalNsSaleIncome =
      IsarNative.jsObjectGet(jsObj, r'totalNsSaleIncome');
  object.trSaleCount = IsarNative.jsObjectGet(jsObj, r'trSaleCount');
  object.tradeName = IsarNative.jsObjectGet(jsObj, r'tradeName');
  return object;
}

P _drawersDeserializePropWeb<P>(Object jsObj, String propertyName) {
  switch (propertyName) {
    case r'cashierId':
      return (IsarNative.jsObjectGet(jsObj, r'cashierId') ??
          (double.negativeInfinity as int)) as P;
    case r'closingBalance':
      return (IsarNative.jsObjectGet(jsObj, r'closingBalance') ??
          double.negativeInfinity) as P;
    case r'closingDateTime':
      return (IsarNative.jsObjectGet(jsObj, r'closingDateTime')) as P;
    case r'csSaleCount':
      return (IsarNative.jsObjectGet(jsObj, r'csSaleCount')) as P;
    case r'id':
      return (IsarNative.jsObjectGet(jsObj, r'id')) as P;
    case r'incompleteSale':
      return (IsarNative.jsObjectGet(jsObj, r'incompleteSale')) as P;
    case r'nrSaleCount':
      return (IsarNative.jsObjectGet(jsObj, r'nrSaleCount')) as P;
    case r'nsSaleCount':
      return (IsarNative.jsObjectGet(jsObj, r'nsSaleCount')) as P;
    case r'open':
      return (IsarNative.jsObjectGet(jsObj, r'open') ?? false) as P;
    case r'openingBalance':
      return (IsarNative.jsObjectGet(jsObj, r'openingBalance') ??
          double.negativeInfinity) as P;
    case r'openingDateTime':
      return (IsarNative.jsObjectGet(jsObj, r'openingDateTime')) as P;
    case r'otherTransactions':
      return (IsarNative.jsObjectGet(jsObj, r'otherTransactions')) as P;
    case r'paymentMode':
      return (IsarNative.jsObjectGet(jsObj, r'paymentMode')) as P;
    case r'psSaleCount':
      return (IsarNative.jsObjectGet(jsObj, r'psSaleCount')) as P;
    case r'totalCsSaleIncome':
      return (IsarNative.jsObjectGet(jsObj, r'totalCsSaleIncome')) as P;
    case r'totalNsSaleIncome':
      return (IsarNative.jsObjectGet(jsObj, r'totalNsSaleIncome')) as P;
    case r'trSaleCount':
      return (IsarNative.jsObjectGet(jsObj, r'trSaleCount')) as P;
    case r'tradeName':
      return (IsarNative.jsObjectGet(jsObj, r'tradeName')) as P;
    default:
      throw IsarError('Illegal propertyName');
  }
}

void _drawersAttachLinks(IsarCollection<dynamic> col, int id, Drawers object) {}

extension DrawersQueryWhereSort on QueryBuilder<Drawers, Drawers, QWhere> {
  QueryBuilder<Drawers, Drawers, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhere> anyCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'cashierId'),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhere> anyOpenCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'open_cashierId'),
      );
    });
  }
}

extension DrawersQueryWhere on QueryBuilder<Drawers, Drawers, QWhereClause> {
  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idEqualTo(int id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idNotEqualTo(int id) {
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

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idGreaterThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idLessThan(int id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> idBetween(
    int lowerId,
    int upperId, {
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

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdEqualTo(
      int cashierId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'cashierId',
        value: [cashierId],
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdNotEqualTo(
      int cashierId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashierId',
              lower: [],
              upper: [cashierId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashierId',
              lower: [cashierId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashierId',
              lower: [cashierId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'cashierId',
              lower: [],
              upper: [cashierId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdGreaterThan(
    int cashierId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cashierId',
        lower: [cashierId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdLessThan(
    int cashierId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cashierId',
        lower: [],
        upper: [cashierId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> cashierIdBetween(
    int lowerCashierId,
    int upperCashierId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'cashierId',
        lower: [lowerCashierId],
        includeLower: includeLower,
        upper: [upperCashierId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openEqualToAnyCashierId(
      bool open) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'open_cashierId',
        value: [open],
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openNotEqualToAnyCashierId(
      bool open) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [],
              upper: [open],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [open],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [open],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [],
              upper: [open],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openCashierIdEqualTo(
      bool open, int cashierId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'open_cashierId',
        value: [open, cashierId],
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause>
      openEqualToCashierIdNotEqualTo(bool open, int cashierId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [open],
              upper: [open, cashierId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [open, cashierId],
              includeLower: false,
              upper: [open],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [open, cashierId],
              includeLower: false,
              upper: [open],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'open_cashierId',
              lower: [open],
              upper: [open, cashierId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause>
      openEqualToCashierIdGreaterThan(
    bool open,
    int cashierId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'open_cashierId',
        lower: [open, cashierId],
        includeLower: include,
        upper: [open],
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause>
      openEqualToCashierIdLessThan(
    bool open,
    int cashierId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'open_cashierId',
        lower: [open],
        upper: [open, cashierId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterWhereClause> openEqualToCashierIdBetween(
    bool open,
    int lowerCashierId,
    int upperCashierId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'open_cashierId',
        lower: [open, lowerCashierId],
        includeLower: includeLower,
        upper: [open, upperCashierId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DrawersQueryFilter
    on QueryBuilder<Drawers, Drawers, QFilterCondition> {
  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cashierId',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cashierId',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cashierId',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cashierId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingBalanceGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'closingBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingBalanceLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'closingBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingBalanceBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'closingBalance',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'closingDateTime',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'closingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'closingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'closingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'closingDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'closingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'closingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'closingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'closingDateTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'csSaleCount',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'csSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'csSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'csSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'csSaleCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idGreaterThan(
    int value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idLessThan(
    int value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idBetween(
    int lower,
    int upper, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'incompleteSale',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'incompleteSale',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      incompleteSaleGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'incompleteSale',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'incompleteSale',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'incompleteSale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nrSaleCount',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nrSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nrSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nrSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nrSaleCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nsSaleCount',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nsSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nsSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nsSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nsSaleCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'open',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingBalanceGreaterThan(double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'openingBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingBalanceLessThan(
      double value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'openingBalance',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingBalanceBetween(
      double lower, double upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openingBalance',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'openingDateTime',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'openingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'openingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'openingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'openingDateTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'openingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'openingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'openingDateTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'openingDateTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'otherTransactions',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherTransactions',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'otherTransactions',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'otherTransactions',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'otherTransactions',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'paymentMode',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentMode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentMode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'psSaleCount',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'psSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'psSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'psSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'psSaleCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalCsSaleIncome',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeGreaterThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'totalCsSaleIncome',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeLessThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'totalCsSaleIncome',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeBetween(double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCsSaleIncome',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalNsSaleIncome',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeGreaterThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'totalNsSaleIncome',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeLessThan(double? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        property: r'totalNsSaleIncome',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeBetween(double? lower, double? upper) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalNsSaleIncome',
        lower: lower,
        includeLower: false,
        upper: upper,
        includeUpper: false,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'trSaleCount',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'trSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'trSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'trSaleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'trSaleCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tradeName',
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tradeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameGreaterThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tradeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameLessThan(
    String? value, {
    bool caseSensitive = true,
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tradeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tradeName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'tradeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'tradeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'tradeName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'tradeName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }
}

extension DrawersQueryLinks
    on QueryBuilder<Drawers, Drawers, QFilterCondition> {}

extension DrawersQueryWhereSortBy on QueryBuilder<Drawers, Drawers, QSortBy> {
  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingBalance', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingBalance', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingDateTime', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingDateTime', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'csSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'csSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIncompleteSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incompleteSale', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIncompleteSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incompleteSale', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nrSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nrSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nsSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nsSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'open', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'open', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingDateTime', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingDateTime', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOtherTransactions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherTransactions', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOtherTransactionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherTransactions', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPaymentModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'psSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'psSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalCsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCsSaleIncome', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalCsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCsSaleIncome', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalNsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNsSaleIncome', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalNsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNsSaleIncome', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTradeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tradeName', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTradeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tradeName', Sort.desc);
    });
  }
}

extension DrawersQueryWhereSortThenBy
    on QueryBuilder<Drawers, Drawers, QSortThenBy> {
  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cashierId', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingBalance', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingBalance', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingDateTime', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'closingDateTime', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'csSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'csSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIncompleteSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incompleteSale', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIncompleteSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'incompleteSale', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nrSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nrSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nsSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nsSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'open', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'open', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingBalance', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningDateTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingDateTime', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningDateTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'openingDateTime', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOtherTransactions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherTransactions', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOtherTransactionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherTransactions', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPaymentMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPaymentModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMode', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'psSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'psSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalCsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCsSaleIncome', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalCsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCsSaleIncome', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalNsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNsSaleIncome', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalNsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNsSaleIncome', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trSaleCount', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'trSaleCount', Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTradeName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tradeName', Sort.asc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTradeNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tradeName', Sort.desc);
    });
  }
}

extension DrawersQueryWhereDistinct
    on QueryBuilder<Drawers, Drawers, QDistinct> {
  QueryBuilder<Drawers, Drawers, QDistinct> distinctByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cashierId');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByClosingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closingBalance');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByClosingDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'closingDateTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByCsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'csSaleCount');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByIncompleteSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'incompleteSale');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByNrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nrSaleCount');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByNsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nsSaleCount');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'open');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingBalance');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOpeningDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'openingDateTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByOtherTransactions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'otherTransactions');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByPaymentMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByPsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'psSaleCount');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTotalCsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCsSaleIncome');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTotalNsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalNsSaleIncome');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'trSaleCount');
    });
  }

  QueryBuilder<Drawers, Drawers, QDistinct> distinctByTradeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tradeName', caseSensitive: caseSensitive);
    });
  }
}

extension DrawersQueryProperty
    on QueryBuilder<Drawers, Drawers, QQueryProperty> {
  QueryBuilder<Drawers, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Drawers, int, QQueryOperations> cashierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cashierId');
    });
  }

  QueryBuilder<Drawers, double, QQueryOperations> closingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closingBalance');
    });
  }

  QueryBuilder<Drawers, String?, QQueryOperations> closingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'closingDateTime');
    });
  }

  QueryBuilder<Drawers, int?, QQueryOperations> csSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'csSaleCount');
    });
  }

  QueryBuilder<Drawers, int?, QQueryOperations> incompleteSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'incompleteSale');
    });
  }

  QueryBuilder<Drawers, int?, QQueryOperations> nrSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nrSaleCount');
    });
  }

  QueryBuilder<Drawers, int?, QQueryOperations> nsSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nsSaleCount');
    });
  }

  QueryBuilder<Drawers, bool, QQueryOperations> openProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'open');
    });
  }

  QueryBuilder<Drawers, double, QQueryOperations> openingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingBalance');
    });
  }

  QueryBuilder<Drawers, String?, QQueryOperations> openingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'openingDateTime');
    });
  }

  QueryBuilder<Drawers, int?, QQueryOperations> otherTransactionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'otherTransactions');
    });
  }

  QueryBuilder<Drawers, String?, QQueryOperations> paymentModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMode');
    });
  }

  QueryBuilder<Drawers, int?, QQueryOperations> psSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'psSaleCount');
    });
  }

  QueryBuilder<Drawers, double?, QQueryOperations> totalCsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCsSaleIncome');
    });
  }

  QueryBuilder<Drawers, double?, QQueryOperations> totalNsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalNsSaleIncome');
    });
  }

  QueryBuilder<Drawers, int?, QQueryOperations> trSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'trSaleCount');
    });
  }

  QueryBuilder<Drawers, String?, QQueryOperations> tradeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tradeName');
    });
  }
}
