// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BusinessHistory> _$businessHistorySerializer =
    new _$BusinessHistorySerializer();

class _$BusinessHistorySerializer
    implements StructuredSerializer<BusinessHistory> {
  @override
  final Iterable<Type> types = const [BusinessHistory, _$BusinessHistory];
  @override
  final String wireName = 'BusinessHistory';

  @override
  Iterable<Object> serialize(Serializers serializers, BusinessHistory object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    if (object.cashierName != null) {
      result
        ..add('cashierName')
        ..add(serializers.serialize(object.cashierName,
            specifiedType: const FullType(String)));
    }
    if (object.openingHour != null) {
      result
        ..add('openingHour')
        ..add(serializers.serialize(object.openingHour,
            specifiedType: const FullType(bool)));
    }
    if (object.isSocial != null) {
      result
        ..add('isSocial')
        ..add(serializers.serialize(object.isSocial,
            specifiedType: const FullType(bool)));
    }
    if (object.table != null) {
      result
        ..add('table')
        ..add(serializers.serialize(object.table,
            specifiedType: const FullType(String)));
    }
    if (object.openingFloat != null) {
      result
        ..add('openingFloat')
        ..add(serializers.serialize(object.openingFloat,
            specifiedType: const FullType(double)));
    }
    if (object.closingFloat != null) {
      result
        ..add('closingFloat')
        ..add(serializers.serialize(object.closingFloat,
            specifiedType: const FullType(double)));
    }
    if (object.displayText != null) {
      result
        ..add('displayText')
        ..add(serializers.serialize(object.displayText,
            specifiedType: const FullType(String)));
    }
    if (object.businessId != null) {
      result
        ..add('businessId')
        ..add(serializers.serialize(object.businessId,
            specifiedType: const FullType(String)));
    }
    if (object.userId != null) {
      result
        ..add('userId')
        ..add(serializers.serialize(object.userId,
            specifiedType: const FullType(String)));
    }
    if (object.createdAt != null) {
      result
        ..add('createdAt')
        ..add(serializers.serialize(object.createdAt,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  BusinessHistory deserialize(
      Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new BusinessHistoryBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'cashierName':
          result.cashierName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'openingHour':
          result.openingHour = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'isSocial':
          result.isSocial = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'openingFloat':
          result.openingFloat = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'closingFloat':
          result.closingFloat = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'displayText':
          result.displayText = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'businessId':
          result.businessId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$BusinessHistory extends BusinessHistory {
  @override
  final String id;
  @override
  final String cashierName;
  @override
  final bool openingHour;
  @override
  final bool isSocial;
  @override
  final String table;
  @override
  final double openingFloat;
  @override
  final double closingFloat;
  @override
  final String displayText;
  @override
  final String businessId;
  @override
  final String userId;
  @override
  final String createdAt;

  factory _$BusinessHistory([void Function(BusinessHistoryBuilder) updates]) =>
      (new BusinessHistoryBuilder()..update(updates)).build();

  _$BusinessHistory._(
      {this.id,
      this.cashierName,
      this.openingHour,
      this.isSocial,
      this.table,
      this.openingFloat,
      this.closingFloat,
      this.displayText,
      this.businessId,
      this.userId,
      this.createdAt})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('BusinessHistory', 'id');
    }
  }

  @override
  BusinessHistory rebuild(void Function(BusinessHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BusinessHistoryBuilder toBuilder() =>
      new BusinessHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BusinessHistory &&
        id == other.id &&
        cashierName == other.cashierName &&
        openingHour == other.openingHour &&
        isSocial == other.isSocial &&
        table == other.table &&
        openingFloat == other.openingFloat &&
        closingFloat == other.closingFloat &&
        displayText == other.displayText &&
        businessId == other.businessId &&
        userId == other.userId &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, id.hashCode),
                                            cashierName.hashCode),
                                        openingHour.hashCode),
                                    isSocial.hashCode),
                                table.hashCode),
                            openingFloat.hashCode),
                        closingFloat.hashCode),
                    displayText.hashCode),
                businessId.hashCode),
            userId.hashCode),
        createdAt.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('BusinessHistory')
          ..add('id', id)
          ..add('cashierName', cashierName)
          ..add('openingHour', openingHour)
          ..add('isSocial', isSocial)
          ..add('table', table)
          ..add('openingFloat', openingFloat)
          ..add('closingFloat', closingFloat)
          ..add('displayText', displayText)
          ..add('businessId', businessId)
          ..add('userId', userId)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class BusinessHistoryBuilder
    implements Builder<BusinessHistory, BusinessHistoryBuilder> {
  _$BusinessHistory _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _cashierName;
  String get cashierName => _$this._cashierName;
  set cashierName(String cashierName) => _$this._cashierName = cashierName;

  bool _openingHour;
  bool get openingHour => _$this._openingHour;
  set openingHour(bool openingHour) => _$this._openingHour = openingHour;

  bool _isSocial;
  bool get isSocial => _$this._isSocial;
  set isSocial(bool isSocial) => _$this._isSocial = isSocial;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  double _openingFloat;
  double get openingFloat => _$this._openingFloat;
  set openingFloat(double openingFloat) => _$this._openingFloat = openingFloat;

  double _closingFloat;
  double get closingFloat => _$this._closingFloat;
  set closingFloat(double closingFloat) => _$this._closingFloat = closingFloat;

  String _displayText;
  String get displayText => _$this._displayText;
  set displayText(String displayText) => _$this._displayText = displayText;

  String _businessId;
  String get businessId => _$this._businessId;
  set businessId(String businessId) => _$this._businessId = businessId;

  String _userId;
  String get userId => _$this._userId;
  set userId(String userId) => _$this._userId = userId;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  BusinessHistoryBuilder();

  BusinessHistoryBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _cashierName = _$v.cashierName;
      _openingHour = _$v.openingHour;
      _isSocial = _$v.isSocial;
      _table = _$v.table;
      _openingFloat = _$v.openingFloat;
      _closingFloat = _$v.closingFloat;
      _displayText = _$v.displayText;
      _businessId = _$v.businessId;
      _userId = _$v.userId;
      _createdAt = _$v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BusinessHistory other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$BusinessHistory;
  }

  @override
  void update(void Function(BusinessHistoryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$BusinessHistory build() {
    final _$result = _$v ??
        new _$BusinessHistory._(
            id: id,
            cashierName: cashierName,
            openingHour: openingHour,
            isSocial: isSocial,
            table: table,
            openingFloat: openingFloat,
            closingFloat: closingFloat,
            displayText: displayText,
            businessId: businessId,
            userId: userId,
            createdAt: createdAt);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
