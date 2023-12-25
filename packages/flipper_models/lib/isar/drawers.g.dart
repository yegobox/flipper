// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drawers.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetDrawersCollection on Isar {
  IsarCollection<String, Drawers> get drawers => this.collection();
}

const DrawersSchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'Drawers',
    idName: 'id',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'id',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'openingBalance',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'closingBalance',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'openingDateTime',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'closingDateTime',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'csSaleCount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'tradeName',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'totalNsSaleIncome',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'totalCsSaleIncome',
        type: IsarType.double,
      ),
      IsarPropertySchema(
        name: 'nrSaleCount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'nsSaleCount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'trSaleCount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'psSaleCount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'incompleteSale',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'otherTransactions',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'paymentMode',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'cashierId',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'open',
        type: IsarType.bool,
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
    ],
    indexes: [
      IsarIndexSchema(
        name: 'cashierId',
        properties: [
          "cashierId",
        ],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'open_cashierId',
        properties: [
          "open",
          "cashierId",
        ],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<String, Drawers>(
    serialize: serializeDrawers,
    deserialize: deserializeDrawers,
    deserializeProperty: deserializeDrawersProp,
  ),
  embeddedSchemas: [],
);

@isarProtected
int serializeDrawers(IsarWriter writer, Drawers object) {
  IsarCore.writeString(writer, 1, object.id);
  IsarCore.writeDouble(writer, 2, object.openingBalance);
  IsarCore.writeDouble(writer, 3, object.closingBalance);
  {
    final value = object.openingDateTime;
    if (value == null) {
      IsarCore.writeNull(writer, 4);
    } else {
      IsarCore.writeString(writer, 4, value);
    }
  }
  {
    final value = object.closingDateTime;
    if (value == null) {
      IsarCore.writeNull(writer, 5);
    } else {
      IsarCore.writeString(writer, 5, value);
    }
  }
  IsarCore.writeLong(writer, 6, object.csSaleCount ?? -9223372036854775808);
  {
    final value = object.tradeName;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  IsarCore.writeDouble(writer, 8, object.totalNsSaleIncome ?? double.nan);
  IsarCore.writeDouble(writer, 9, object.totalCsSaleIncome ?? double.nan);
  IsarCore.writeLong(writer, 10, object.nrSaleCount ?? -9223372036854775808);
  IsarCore.writeLong(writer, 11, object.nsSaleCount ?? -9223372036854775808);
  IsarCore.writeLong(writer, 12, object.trSaleCount ?? -9223372036854775808);
  IsarCore.writeLong(writer, 13, object.psSaleCount ?? -9223372036854775808);
  IsarCore.writeLong(writer, 14, object.incompleteSale ?? -9223372036854775808);
  IsarCore.writeLong(
      writer, 15, object.otherTransactions ?? -9223372036854775808);
  {
    final value = object.paymentMode;
    if (value == null) {
      IsarCore.writeNull(writer, 16);
    } else {
      IsarCore.writeString(writer, 16, value);
    }
  }
  IsarCore.writeLong(writer, 17, object.cashierId);
  IsarCore.writeBool(writer, 18, object.open);
  IsarCore.writeLong(
      writer,
      19,
      object.lastTouched?.toUtc().microsecondsSinceEpoch ??
          -9223372036854775808);
  IsarCore.writeLong(writer, 20,
      object.deletedAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808);
  IsarCore.writeString(writer, 21, object.action);
  return Isar.fastHash(object.id);
}

@isarProtected
Drawers deserializeDrawers(IsarReader reader) {
  final String _id;
  _id = IsarCore.readString(reader, 1) ?? '';
  final double _openingBalance;
  _openingBalance = IsarCore.readDouble(reader, 2);
  final double _closingBalance;
  _closingBalance = IsarCore.readDouble(reader, 3);
  final String? _openingDateTime;
  _openingDateTime = IsarCore.readString(reader, 4);
  final String? _closingDateTime;
  _closingDateTime = IsarCore.readString(reader, 5);
  final int? _csSaleCount;
  {
    final value = IsarCore.readLong(reader, 6);
    if (value == -9223372036854775808) {
      _csSaleCount = null;
    } else {
      _csSaleCount = value;
    }
  }
  final String? _tradeName;
  _tradeName = IsarCore.readString(reader, 7);
  final double? _totalNsSaleIncome;
  {
    final value = IsarCore.readDouble(reader, 8);
    if (value.isNaN) {
      _totalNsSaleIncome = null;
    } else {
      _totalNsSaleIncome = value;
    }
  }
  final double? _totalCsSaleIncome;
  {
    final value = IsarCore.readDouble(reader, 9);
    if (value.isNaN) {
      _totalCsSaleIncome = null;
    } else {
      _totalCsSaleIncome = value;
    }
  }
  final int? _nrSaleCount;
  {
    final value = IsarCore.readLong(reader, 10);
    if (value == -9223372036854775808) {
      _nrSaleCount = null;
    } else {
      _nrSaleCount = value;
    }
  }
  final int? _nsSaleCount;
  {
    final value = IsarCore.readLong(reader, 11);
    if (value == -9223372036854775808) {
      _nsSaleCount = null;
    } else {
      _nsSaleCount = value;
    }
  }
  final int? _trSaleCount;
  {
    final value = IsarCore.readLong(reader, 12);
    if (value == -9223372036854775808) {
      _trSaleCount = null;
    } else {
      _trSaleCount = value;
    }
  }
  final int? _psSaleCount;
  {
    final value = IsarCore.readLong(reader, 13);
    if (value == -9223372036854775808) {
      _psSaleCount = null;
    } else {
      _psSaleCount = value;
    }
  }
  final int? _incompleteSale;
  {
    final value = IsarCore.readLong(reader, 14);
    if (value == -9223372036854775808) {
      _incompleteSale = null;
    } else {
      _incompleteSale = value;
    }
  }
  final int? _otherTransactions;
  {
    final value = IsarCore.readLong(reader, 15);
    if (value == -9223372036854775808) {
      _otherTransactions = null;
    } else {
      _otherTransactions = value;
    }
  }
  final String? _paymentMode;
  _paymentMode = IsarCore.readString(reader, 16);
  final int _cashierId;
  _cashierId = IsarCore.readLong(reader, 17);
  final bool _open;
  _open = IsarCore.readBool(reader, 18);
  final object = Drawers(
    id: _id,
    openingBalance: _openingBalance,
    closingBalance: _closingBalance,
    openingDateTime: _openingDateTime,
    closingDateTime: _closingDateTime,
    csSaleCount: _csSaleCount,
    tradeName: _tradeName,
    totalNsSaleIncome: _totalNsSaleIncome,
    totalCsSaleIncome: _totalCsSaleIncome,
    nrSaleCount: _nrSaleCount,
    nsSaleCount: _nsSaleCount,
    trSaleCount: _trSaleCount,
    psSaleCount: _psSaleCount,
    incompleteSale: _incompleteSale,
    otherTransactions: _otherTransactions,
    paymentMode: _paymentMode,
    cashierId: _cashierId,
    open: _open,
  );
  {
    final value = IsarCore.readLong(reader, 19);
    if (value == -9223372036854775808) {
      object.lastTouched = null;
    } else {
      object.lastTouched =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  {
    final value = IsarCore.readLong(reader, 20);
    if (value == -9223372036854775808) {
      object.deletedAt = null;
    } else {
      object.deletedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  object.action = IsarCore.readString(reader, 21) ?? '';
  return object;
}

@isarProtected
dynamic deserializeDrawersProp(IsarReader reader, int property) {
  switch (property) {
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readDouble(reader, 2);
    case 3:
      return IsarCore.readDouble(reader, 3);
    case 4:
      return IsarCore.readString(reader, 4);
    case 5:
      return IsarCore.readString(reader, 5);
    case 6:
      {
        final value = IsarCore.readLong(reader, 6);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 7:
      return IsarCore.readString(reader, 7);
    case 8:
      {
        final value = IsarCore.readDouble(reader, 8);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 9:
      {
        final value = IsarCore.readDouble(reader, 9);
        if (value.isNaN) {
          return null;
        } else {
          return value;
        }
      }
    case 10:
      {
        final value = IsarCore.readLong(reader, 10);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 11:
      {
        final value = IsarCore.readLong(reader, 11);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 12:
      {
        final value = IsarCore.readLong(reader, 12);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 13:
      {
        final value = IsarCore.readLong(reader, 13);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 14:
      {
        final value = IsarCore.readLong(reader, 14);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 15:
      {
        final value = IsarCore.readLong(reader, 15);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return value;
        }
      }
    case 16:
      return IsarCore.readString(reader, 16);
    case 17:
      return IsarCore.readLong(reader, 17);
    case 18:
      return IsarCore.readBool(reader, 18);
    case 19:
      {
        final value = IsarCore.readLong(reader, 19);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 20:
      {
        final value = IsarCore.readLong(reader, 20);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 21:
      return IsarCore.readString(reader, 21) ?? '';
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _DrawersUpdate {
  bool call({
    required String id,
    double? openingBalance,
    double? closingBalance,
    String? openingDateTime,
    String? closingDateTime,
    int? csSaleCount,
    String? tradeName,
    double? totalNsSaleIncome,
    double? totalCsSaleIncome,
    int? nrSaleCount,
    int? nsSaleCount,
    int? trSaleCount,
    int? psSaleCount,
    int? incompleteSale,
    int? otherTransactions,
    String? paymentMode,
    int? cashierId,
    bool? open,
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
  });
}

class _DrawersUpdateImpl implements _DrawersUpdate {
  const _DrawersUpdateImpl(this.collection);

  final IsarCollection<String, Drawers> collection;

  @override
  bool call({
    required String id,
    Object? openingBalance = ignore,
    Object? closingBalance = ignore,
    Object? openingDateTime = ignore,
    Object? closingDateTime = ignore,
    Object? csSaleCount = ignore,
    Object? tradeName = ignore,
    Object? totalNsSaleIncome = ignore,
    Object? totalCsSaleIncome = ignore,
    Object? nrSaleCount = ignore,
    Object? nsSaleCount = ignore,
    Object? trSaleCount = ignore,
    Object? psSaleCount = ignore,
    Object? incompleteSale = ignore,
    Object? otherTransactions = ignore,
    Object? paymentMode = ignore,
    Object? cashierId = ignore,
    Object? open = ignore,
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
  }) {
    return collection.updateProperties([
          id
        ], {
          if (openingBalance != ignore) 2: openingBalance as double?,
          if (closingBalance != ignore) 3: closingBalance as double?,
          if (openingDateTime != ignore) 4: openingDateTime as String?,
          if (closingDateTime != ignore) 5: closingDateTime as String?,
          if (csSaleCount != ignore) 6: csSaleCount as int?,
          if (tradeName != ignore) 7: tradeName as String?,
          if (totalNsSaleIncome != ignore) 8: totalNsSaleIncome as double?,
          if (totalCsSaleIncome != ignore) 9: totalCsSaleIncome as double?,
          if (nrSaleCount != ignore) 10: nrSaleCount as int?,
          if (nsSaleCount != ignore) 11: nsSaleCount as int?,
          if (trSaleCount != ignore) 12: trSaleCount as int?,
          if (psSaleCount != ignore) 13: psSaleCount as int?,
          if (incompleteSale != ignore) 14: incompleteSale as int?,
          if (otherTransactions != ignore) 15: otherTransactions as int?,
          if (paymentMode != ignore) 16: paymentMode as String?,
          if (cashierId != ignore) 17: cashierId as int?,
          if (open != ignore) 18: open as bool?,
          if (lastTouched != ignore) 19: lastTouched as DateTime?,
          if (deletedAt != ignore) 20: deletedAt as DateTime?,
          if (action != ignore) 21: action as String?,
        }) >
        0;
  }
}

sealed class _DrawersUpdateAll {
  int call({
    required List<String> id,
    double? openingBalance,
    double? closingBalance,
    String? openingDateTime,
    String? closingDateTime,
    int? csSaleCount,
    String? tradeName,
    double? totalNsSaleIncome,
    double? totalCsSaleIncome,
    int? nrSaleCount,
    int? nsSaleCount,
    int? trSaleCount,
    int? psSaleCount,
    int? incompleteSale,
    int? otherTransactions,
    String? paymentMode,
    int? cashierId,
    bool? open,
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
  });
}

class _DrawersUpdateAllImpl implements _DrawersUpdateAll {
  const _DrawersUpdateAllImpl(this.collection);

  final IsarCollection<String, Drawers> collection;

  @override
  int call({
    required List<String> id,
    Object? openingBalance = ignore,
    Object? closingBalance = ignore,
    Object? openingDateTime = ignore,
    Object? closingDateTime = ignore,
    Object? csSaleCount = ignore,
    Object? tradeName = ignore,
    Object? totalNsSaleIncome = ignore,
    Object? totalCsSaleIncome = ignore,
    Object? nrSaleCount = ignore,
    Object? nsSaleCount = ignore,
    Object? trSaleCount = ignore,
    Object? psSaleCount = ignore,
    Object? incompleteSale = ignore,
    Object? otherTransactions = ignore,
    Object? paymentMode = ignore,
    Object? cashierId = ignore,
    Object? open = ignore,
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
  }) {
    return collection.updateProperties(id, {
      if (openingBalance != ignore) 2: openingBalance as double?,
      if (closingBalance != ignore) 3: closingBalance as double?,
      if (openingDateTime != ignore) 4: openingDateTime as String?,
      if (closingDateTime != ignore) 5: closingDateTime as String?,
      if (csSaleCount != ignore) 6: csSaleCount as int?,
      if (tradeName != ignore) 7: tradeName as String?,
      if (totalNsSaleIncome != ignore) 8: totalNsSaleIncome as double?,
      if (totalCsSaleIncome != ignore) 9: totalCsSaleIncome as double?,
      if (nrSaleCount != ignore) 10: nrSaleCount as int?,
      if (nsSaleCount != ignore) 11: nsSaleCount as int?,
      if (trSaleCount != ignore) 12: trSaleCount as int?,
      if (psSaleCount != ignore) 13: psSaleCount as int?,
      if (incompleteSale != ignore) 14: incompleteSale as int?,
      if (otherTransactions != ignore) 15: otherTransactions as int?,
      if (paymentMode != ignore) 16: paymentMode as String?,
      if (cashierId != ignore) 17: cashierId as int?,
      if (open != ignore) 18: open as bool?,
      if (lastTouched != ignore) 19: lastTouched as DateTime?,
      if (deletedAt != ignore) 20: deletedAt as DateTime?,
      if (action != ignore) 21: action as String?,
    });
  }
}

extension DrawersUpdate on IsarCollection<String, Drawers> {
  _DrawersUpdate get update => _DrawersUpdateImpl(this);

  _DrawersUpdateAll get updateAll => _DrawersUpdateAllImpl(this);
}

sealed class _DrawersQueryUpdate {
  int call({
    double? openingBalance,
    double? closingBalance,
    String? openingDateTime,
    String? closingDateTime,
    int? csSaleCount,
    String? tradeName,
    double? totalNsSaleIncome,
    double? totalCsSaleIncome,
    int? nrSaleCount,
    int? nsSaleCount,
    int? trSaleCount,
    int? psSaleCount,
    int? incompleteSale,
    int? otherTransactions,
    String? paymentMode,
    int? cashierId,
    bool? open,
    DateTime? lastTouched,
    DateTime? deletedAt,
    String? action,
  });
}

class _DrawersQueryUpdateImpl implements _DrawersQueryUpdate {
  const _DrawersQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<Drawers> query;
  final int? limit;

  @override
  int call({
    Object? openingBalance = ignore,
    Object? closingBalance = ignore,
    Object? openingDateTime = ignore,
    Object? closingDateTime = ignore,
    Object? csSaleCount = ignore,
    Object? tradeName = ignore,
    Object? totalNsSaleIncome = ignore,
    Object? totalCsSaleIncome = ignore,
    Object? nrSaleCount = ignore,
    Object? nsSaleCount = ignore,
    Object? trSaleCount = ignore,
    Object? psSaleCount = ignore,
    Object? incompleteSale = ignore,
    Object? otherTransactions = ignore,
    Object? paymentMode = ignore,
    Object? cashierId = ignore,
    Object? open = ignore,
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (openingBalance != ignore) 2: openingBalance as double?,
      if (closingBalance != ignore) 3: closingBalance as double?,
      if (openingDateTime != ignore) 4: openingDateTime as String?,
      if (closingDateTime != ignore) 5: closingDateTime as String?,
      if (csSaleCount != ignore) 6: csSaleCount as int?,
      if (tradeName != ignore) 7: tradeName as String?,
      if (totalNsSaleIncome != ignore) 8: totalNsSaleIncome as double?,
      if (totalCsSaleIncome != ignore) 9: totalCsSaleIncome as double?,
      if (nrSaleCount != ignore) 10: nrSaleCount as int?,
      if (nsSaleCount != ignore) 11: nsSaleCount as int?,
      if (trSaleCount != ignore) 12: trSaleCount as int?,
      if (psSaleCount != ignore) 13: psSaleCount as int?,
      if (incompleteSale != ignore) 14: incompleteSale as int?,
      if (otherTransactions != ignore) 15: otherTransactions as int?,
      if (paymentMode != ignore) 16: paymentMode as String?,
      if (cashierId != ignore) 17: cashierId as int?,
      if (open != ignore) 18: open as bool?,
      if (lastTouched != ignore) 19: lastTouched as DateTime?,
      if (deletedAt != ignore) 20: deletedAt as DateTime?,
      if (action != ignore) 21: action as String?,
    });
  }
}

extension DrawersQueryUpdate on IsarQuery<Drawers> {
  _DrawersQueryUpdate get updateFirst =>
      _DrawersQueryUpdateImpl(this, limit: 1);

  _DrawersQueryUpdate get updateAll => _DrawersQueryUpdateImpl(this);
}

class _DrawersQueryBuilderUpdateImpl implements _DrawersQueryUpdate {
  const _DrawersQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<Drawers, Drawers, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? openingBalance = ignore,
    Object? closingBalance = ignore,
    Object? openingDateTime = ignore,
    Object? closingDateTime = ignore,
    Object? csSaleCount = ignore,
    Object? tradeName = ignore,
    Object? totalNsSaleIncome = ignore,
    Object? totalCsSaleIncome = ignore,
    Object? nrSaleCount = ignore,
    Object? nsSaleCount = ignore,
    Object? trSaleCount = ignore,
    Object? psSaleCount = ignore,
    Object? incompleteSale = ignore,
    Object? otherTransactions = ignore,
    Object? paymentMode = ignore,
    Object? cashierId = ignore,
    Object? open = ignore,
    Object? lastTouched = ignore,
    Object? deletedAt = ignore,
    Object? action = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (openingBalance != ignore) 2: openingBalance as double?,
        if (closingBalance != ignore) 3: closingBalance as double?,
        if (openingDateTime != ignore) 4: openingDateTime as String?,
        if (closingDateTime != ignore) 5: closingDateTime as String?,
        if (csSaleCount != ignore) 6: csSaleCount as int?,
        if (tradeName != ignore) 7: tradeName as String?,
        if (totalNsSaleIncome != ignore) 8: totalNsSaleIncome as double?,
        if (totalCsSaleIncome != ignore) 9: totalCsSaleIncome as double?,
        if (nrSaleCount != ignore) 10: nrSaleCount as int?,
        if (nsSaleCount != ignore) 11: nsSaleCount as int?,
        if (trSaleCount != ignore) 12: trSaleCount as int?,
        if (psSaleCount != ignore) 13: psSaleCount as int?,
        if (incompleteSale != ignore) 14: incompleteSale as int?,
        if (otherTransactions != ignore) 15: otherTransactions as int?,
        if (paymentMode != ignore) 16: paymentMode as String?,
        if (cashierId != ignore) 17: cashierId as int?,
        if (open != ignore) 18: open as bool?,
        if (lastTouched != ignore) 19: lastTouched as DateTime?,
        if (deletedAt != ignore) 20: deletedAt as DateTime?,
        if (action != ignore) 21: action as String?,
      });
    } finally {
      q.close();
    }
  }
}

extension DrawersQueryBuilderUpdate
    on QueryBuilder<Drawers, Drawers, QOperations> {
  _DrawersQueryUpdate get updateFirst =>
      _DrawersQueryBuilderUpdateImpl(this, limit: 1);

  _DrawersQueryUpdate get updateAll => _DrawersQueryBuilderUpdateImpl(this);
}

extension DrawersQueryFilter
    on QueryBuilder<Drawers, Drawers, QFilterCondition> {
  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idGreaterThanOrEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idLessThanOrEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idContains(String value,
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idMatches(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingBalanceEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingBalanceGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingBalanceGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingBalanceLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingBalanceLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingBalanceBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingBalanceEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingBalanceGreaterThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingBalanceGreaterThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingBalanceLessThan(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingBalanceLessThanOrEqualTo(
    double value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingBalanceBetween(
    double lower,
    double upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 4));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeEqualTo(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeGreaterThan(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeLessThan(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeStartsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeEndsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeContains(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openingDateTimeMatches(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      openingDateTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 5));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeEqualTo(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeGreaterThan(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeGreaterThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeLessThan(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeLessThanOrEqualTo(
    String? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeStartsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeEndsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeContains(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> closingDateTimeMatches(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      closingDateTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 5,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      csSaleCountGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      csSaleCountLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> csSaleCountBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameGreaterThan(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      tradeNameGreaterThanOrEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameLessThan(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      tradeNameLessThanOrEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameBetween(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameStartsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameEndsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameContains(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameMatches(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> tradeNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeGreaterThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeGreaterThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeLessThan(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 8,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeLessThanOrEqualTo(
    double? value, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalNsSaleIncomeBetween(
    double? lower,
    double? upper, {
    double epsilon = Filter.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeEqualTo(
    double? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeGreaterThan(
    double? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeGreaterThanOrEqualTo(
    double? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeLessThan(
    double? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeLessThanOrEqualTo(
    double? value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      totalCsSaleIncomeBetween(
    double? lower,
    double? upper, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      nrSaleCountGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      nrSaleCountLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 10,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nrSaleCountBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      nsSaleCountGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      nsSaleCountLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> nsSaleCountBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 12));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountEqualTo(
    int? value,
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      trSaleCountGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      trSaleCountLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> trSaleCountBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountEqualTo(
    int? value,
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 13,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      psSaleCountGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 13,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 13,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      psSaleCountLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 13,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> psSaleCountBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 13,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      incompleteSaleIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleEqualTo(
    int? value,
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      incompleteSaleGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 14,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      incompleteSaleGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 14,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 14,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      incompleteSaleLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 14,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> incompleteSaleBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 14,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 15));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsEqualTo(
    int? value,
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsGreaterThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsGreaterThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsLessThan(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsLessThanOrEqualTo(
    int? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      otherTransactionsBetween(
    int? lower,
    int? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 15,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 16));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeGreaterThan(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      paymentModeGreaterThanOrEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeLessThan(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      paymentModeLessThanOrEqualTo(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeBetween(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeStartsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeEndsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeContains(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeMatches(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> paymentModeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 16,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      paymentModeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 16,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 17,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 17,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      cashierIdGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 17,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 17,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      cashierIdLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 17,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> cashierIdBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 17,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> openEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> lastTouchedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> lastTouchedIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 19));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> lastTouchedEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> lastTouchedGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      lastTouchedGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> lastTouchedLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      lastTouchedLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> lastTouchedBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 19,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 20));
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> deletedAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 20,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 20,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      deletedAtGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 20,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> deletedAtLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 20,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      deletedAtLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 20,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 20,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionEqualTo(
    String value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionGreaterThan(
    String value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition>
      actionGreaterThanOrEqualTo(
    String value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionLessThan(
    String value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionLessThanOrEqualTo(
    String value, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionBetween(
    String lower,
    String upper, {
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionStartsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionEndsWith(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionContains(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionMatches(
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

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterFilterCondition> actionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 21,
          value: '',
        ),
      );
    });
  }
}

extension DrawersQueryObject
    on QueryBuilder<Drawers, Drawers, QFilterCondition> {}

extension DrawersQuerySortBy on QueryBuilder<Drawers, Drawers, QSortBy> {
  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpeningDateTimeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByClosingDateTimeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        5,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTradeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTradeNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalNsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalNsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalCsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTotalCsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByNsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByTrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIncompleteSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByIncompleteSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOtherTransactions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOtherTransactionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPaymentMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        16,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByPaymentModeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        16,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> sortByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        21,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }
}

extension DrawersQuerySortThenBy
    on QueryBuilder<Drawers, Drawers, QSortThenBy> {
  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingBalanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpeningDateTimeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByClosingDateTimeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTradeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTradeNameDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalNsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalNsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalCsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTotalCsSaleIncomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByNsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByTrSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPsSaleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIncompleteSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByIncompleteSaleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOtherTransactions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOtherTransactionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPaymentMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByPaymentModeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByCashierIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByOpenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByLastTouchedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(20, sort: Sort.desc);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterSortBy> thenByActionDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(21, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }
}

extension DrawersQueryWhereDistinct
    on QueryBuilder<Drawers, Drawers, QDistinct> {
  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByOpeningBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByClosingBalance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByOpeningDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByClosingDateTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByCsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByTradeName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByTotalNsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByTotalCsSaleIncome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByNrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByNsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByTrSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByPsSaleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByIncompleteSale() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByOtherTransactions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByPaymentMode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByCashierId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByOpen() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByLastTouched() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20);
    });
  }

  QueryBuilder<Drawers, Drawers, QAfterDistinct> distinctByAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(21, caseSensitive: caseSensitive);
    });
  }
}

extension DrawersQueryProperty1 on QueryBuilder<Drawers, Drawers, QProperty> {
  QueryBuilder<Drawers, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Drawers, double, QAfterProperty> openingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Drawers, double, QAfterProperty> closingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Drawers, String?, QAfterProperty> openingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Drawers, String?, QAfterProperty> closingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Drawers, int?, QAfterProperty> csSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Drawers, String?, QAfterProperty> tradeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Drawers, double?, QAfterProperty> totalNsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Drawers, double?, QAfterProperty> totalCsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Drawers, int?, QAfterProperty> nrSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Drawers, int?, QAfterProperty> nsSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Drawers, int?, QAfterProperty> trSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Drawers, int?, QAfterProperty> psSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Drawers, int?, QAfterProperty> incompleteSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Drawers, int?, QAfterProperty> otherTransactionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Drawers, String?, QAfterProperty> paymentModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Drawers, int, QAfterProperty> cashierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Drawers, bool, QAfterProperty> openProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Drawers, DateTime?, QAfterProperty> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Drawers, DateTime?, QAfterProperty> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Drawers, String, QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }
}

extension DrawersQueryProperty2<R> on QueryBuilder<Drawers, R, QAfterProperty> {
  QueryBuilder<Drawers, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Drawers, (R, double), QAfterProperty> openingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Drawers, (R, double), QAfterProperty> closingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Drawers, (R, String?), QAfterProperty>
      openingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Drawers, (R, String?), QAfterProperty>
      closingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Drawers, (R, int?), QAfterProperty> csSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Drawers, (R, String?), QAfterProperty> tradeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Drawers, (R, double?), QAfterProperty>
      totalNsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Drawers, (R, double?), QAfterProperty>
      totalCsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Drawers, (R, int?), QAfterProperty> nrSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Drawers, (R, int?), QAfterProperty> nsSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Drawers, (R, int?), QAfterProperty> trSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Drawers, (R, int?), QAfterProperty> psSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Drawers, (R, int?), QAfterProperty> incompleteSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Drawers, (R, int?), QAfterProperty> otherTransactionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Drawers, (R, String?), QAfterProperty> paymentModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Drawers, (R, int), QAfterProperty> cashierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Drawers, (R, bool), QAfterProperty> openProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Drawers, (R, DateTime?), QAfterProperty> lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Drawers, (R, DateTime?), QAfterProperty> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Drawers, (R, String), QAfterProperty> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }
}

extension DrawersQueryProperty3<R1, R2>
    on QueryBuilder<Drawers, (R1, R2), QAfterProperty> {
  QueryBuilder<Drawers, (R1, R2, String), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<Drawers, (R1, R2, double), QOperations>
      openingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<Drawers, (R1, R2, double), QOperations>
      closingBalanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<Drawers, (R1, R2, String?), QOperations>
      openingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<Drawers, (R1, R2, String?), QOperations>
      closingDateTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int?), QOperations> csSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<Drawers, (R1, R2, String?), QOperations> tradeNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<Drawers, (R1, R2, double?), QOperations>
      totalNsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<Drawers, (R1, R2, double?), QOperations>
      totalCsSaleIncomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int?), QOperations> nrSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int?), QOperations> nsSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int?), QOperations> trSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int?), QOperations> psSaleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int?), QOperations> incompleteSaleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int?), QOperations>
      otherTransactionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<Drawers, (R1, R2, String?), QOperations> paymentModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<Drawers, (R1, R2, int), QOperations> cashierIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<Drawers, (R1, R2, bool), QOperations> openProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<Drawers, (R1, R2, DateTime?), QOperations>
      lastTouchedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<Drawers, (R1, R2, DateTime?), QOperations> deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }

  QueryBuilder<Drawers, (R1, R2, String), QOperations> actionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(21);
    });
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Drawers _$DrawersFromJson(Map<String, dynamic> json) => Drawers(
      id: json['id'] as String,
      openingBalance: (json['openingBalance'] as num).toDouble(),
      closingBalance: (json['closingBalance'] as num).toDouble(),
      openingDateTime: json['openingDateTime'] as String?,
      closingDateTime: json['closingDateTime'] as String?,
      csSaleCount: json['csSaleCount'] as int?,
      tradeName: json['tradeName'] as String?,
      totalNsSaleIncome: (json['totalNsSaleIncome'] as num?)?.toDouble(),
      totalCsSaleIncome: (json['totalCsSaleIncome'] as num?)?.toDouble(),
      nrSaleCount: json['nrSaleCount'] as int?,
      nsSaleCount: json['nsSaleCount'] as int?,
      trSaleCount: json['trSaleCount'] as int?,
      psSaleCount: json['psSaleCount'] as int?,
      incompleteSale: json['incompleteSale'] as int?,
      otherTransactions: json['otherTransactions'] as int?,
      paymentMode: json['paymentMode'] as String?,
      cashierId: json['cashierId'] as int,
      open: json['open'] as bool,
    )
      ..lastTouched = json['lastTouched'] == null
          ? null
          : DateTime.parse(json['lastTouched'] as String)
      ..deletedAt = json['deletedAt'] == null
          ? null
          : DateTime.parse(json['deletedAt'] as String)
      ..action = json['action'] as String;

Map<String, dynamic> _$DrawersToJson(Drawers instance) => <String, dynamic>{
      'lastTouched': instance.lastTouched?.toIso8601String(),
      'deletedAt': instance.deletedAt?.toIso8601String(),
      'action': instance.action,
      'id': instance.id,
      'openingBalance': instance.openingBalance,
      'closingBalance': instance.closingBalance,
      'openingDateTime': instance.openingDateTime,
      'closingDateTime': instance.closingDateTime,
      'csSaleCount': instance.csSaleCount,
      'tradeName': instance.tradeName,
      'totalNsSaleIncome': instance.totalNsSaleIncome,
      'totalCsSaleIncome': instance.totalCsSaleIncome,
      'nrSaleCount': instance.nrSaleCount,
      'nsSaleCount': instance.nsSaleCount,
      'trSaleCount': instance.trSaleCount,
      'psSaleCount': instance.psSaleCount,
      'incompleteSale': instance.incompleteSale,
      'otherTransactions': instance.otherTransactions,
      'paymentMode': instance.paymentMode,
      'cashierId': instance.cashierId,
      'open': instance.open,
    };

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
