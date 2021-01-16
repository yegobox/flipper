// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Switcher> _$switcherSerializer = new _$SwitcherSerializer();

class _$SwitcherSerializer implements StructuredSerializer<Switcher> {
  @override
  final Iterable<Type> types = const [Switcher, _$Switcher];
  @override
  final String wireName = 'Switcher';

  @override
  Iterable<Object> serialize(Serializers serializers, Switcher object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'isClosed',
      serializers.serialize(object.isClosed,
          specifiedType: const FullType(bool)),
    ];
    if (object.documentId != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.documentId,
            specifiedType: const FullType(String)));
    }
    if (object.cashierName != null) {
      result
        ..add('cashierName')
        ..add(serializers.serialize(object.cashierName,
            specifiedType: const FullType(String)));
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
    if (object.openingFLoat != null) {
      result
        ..add('openingFLoat')
        ..add(serializers.serialize(object.openingFLoat,
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
    return result;
  }

  @override
  Switcher deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new SwitcherBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'id':
          result.documentId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'cashierName':
          result.cashierName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isClosed':
          result.isClosed = serializers.deserialize(value,
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
        case 'openingFLoat':
          result.openingFLoat = serializers.deserialize(value,
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
      }
    }

    return result.build();
  }
}

class _$Switcher extends Switcher {
  @override
  final String documentId;
  @override
  final String cashierName;
  @override
  final bool isClosed;
  @override
  final bool isSocial;
  @override
  final String table;
  @override
  final double openingFLoat;
  @override
  final double closingFloat;
  @override
  final String displayText;
  @override
  final String businessId;
  @override
  final String userId;

  factory _$Switcher([void Function(SwitcherBuilder) updates]) =>
      (new SwitcherBuilder()..update(updates)).build();

  _$Switcher._(
      {this.documentId,
      this.cashierName,
      this.isClosed,
      this.isSocial,
      this.table,
      this.openingFLoat,
      this.closingFloat,
      this.displayText,
      this.businessId,
      this.userId})
      : super._() {
    if (isClosed == null) {
      throw new BuiltValueNullFieldError('Switcher', 'isClosed');
    }
  }

  @override
  Switcher rebuild(void Function(SwitcherBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SwitcherBuilder toBuilder() => new SwitcherBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Switcher &&
        documentId == other.documentId &&
        cashierName == other.cashierName &&
        isClosed == other.isClosed &&
        isSocial == other.isSocial &&
        table == other.table &&
        openingFLoat == other.openingFLoat &&
        closingFloat == other.closingFloat &&
        displayText == other.displayText &&
        businessId == other.businessId &&
        userId == other.userId;
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
                                    $jc($jc(0, documentId.hashCode),
                                        cashierName.hashCode),
                                    isClosed.hashCode),
                                isSocial.hashCode),
                            table.hashCode),
                        openingFLoat.hashCode),
                    closingFloat.hashCode),
                displayText.hashCode),
            businessId.hashCode),
        userId.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Switcher')
          ..add('documentId', documentId)
          ..add('cashierName', cashierName)
          ..add('isClosed', isClosed)
          ..add('isSocial', isSocial)
          ..add('table', table)
          ..add('openingFLoat', openingFLoat)
          ..add('closingFloat', closingFloat)
          ..add('displayText', displayText)
          ..add('businessId', businessId)
          ..add('userId', userId))
        .toString();
  }
}

class SwitcherBuilder implements Builder<Switcher, SwitcherBuilder> {
  _$Switcher _$v;

  String _documentId;
  String get documentId => _$this._documentId;
  set documentId(String documentId) => _$this._documentId = documentId;

  String _cashierName;
  String get cashierName => _$this._cashierName;
  set cashierName(String cashierName) => _$this._cashierName = cashierName;

  bool _isClosed;
  bool get isClosed => _$this._isClosed;
  set isClosed(bool isClosed) => _$this._isClosed = isClosed;

  bool _isSocial;
  bool get isSocial => _$this._isSocial;
  set isSocial(bool isSocial) => _$this._isSocial = isSocial;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  double _openingFLoat;
  double get openingFLoat => _$this._openingFLoat;
  set openingFLoat(double openingFLoat) => _$this._openingFLoat = openingFLoat;

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

  SwitcherBuilder();

  SwitcherBuilder get _$this {
    if (_$v != null) {
      _documentId = _$v.documentId;
      _cashierName = _$v.cashierName;
      _isClosed = _$v.isClosed;
      _isSocial = _$v.isSocial;
      _table = _$v.table;
      _openingFLoat = _$v.openingFLoat;
      _closingFloat = _$v.closingFloat;
      _displayText = _$v.displayText;
      _businessId = _$v.businessId;
      _userId = _$v.userId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Switcher other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Switcher;
  }

  @override
  void update(void Function(SwitcherBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Switcher build() {
    final _$result = _$v ??
        new _$Switcher._(
            documentId: documentId,
            cashierName: cashierName,
            isClosed: isClosed,
            isSocial: isSocial,
            table: table,
            openingFLoat: openingFLoat,
            closingFloat: closingFloat,
            displayText: displayText,
            businessId: businessId,
            userId: userId);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
