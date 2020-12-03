// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Stock> _$stockSerializer = new _$StockSerializer();

class _$StockSerializer implements StructuredSerializer<Stock> {
  @override
  final Iterable<Type> types = const [Stock, _$Stock];
  @override
  final String wireName = 'Stock';

  @override
  Iterable<Object> serialize(Serializers serializers, Stock object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'branchId',
      serializers.serialize(object.branchId,
          specifiedType: const FullType(String)),
      'variantId',
      serializers.serialize(object.variantId,
          specifiedType: const FullType(String)),
      'lowStock',
      serializers.serialize(object.lowStock,
          specifiedType: const FullType(String)),
      'currentStock',
      serializers.serialize(object.currentStock,
          specifiedType: const FullType(String)),
      'supplyPrice',
      serializers.serialize(object.supplyPrice,
          specifiedType: const FullType(double)),
      'retailPrice',
      serializers.serialize(object.retailPrice,
          specifiedType: const FullType(double)),
      'canTrackingStock',
      serializers.serialize(object.canTrackingStock,
          specifiedType: const FullType(bool)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
    ];
    if (object.value != null) {
      result
        ..add('value')
        ..add(serializers.serialize(object.value,
            specifiedType: const FullType(String)));
    }
    if (object.isActive != null) {
      result
        ..add('isActive')
        ..add(serializers.serialize(object.isActive,
            specifiedType: const FullType(bool)));
    }
    if (object.showLowStockAlert != null) {
      result
        ..add('showLowStockAlert')
        ..add(serializers.serialize(object.showLowStockAlert,
            specifiedType: const FullType(bool)));
    }
    return result;
  }

  @override
  Stock deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StockBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'value':
          result.value = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'branchId':
          result.branchId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'variantId':
          result.variantId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'isActive':
          result.isActive = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'lowStock':
          result.lowStock = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'currentStock':
          result.currentStock = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'supplyPrice':
          result.supplyPrice = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'retailPrice':
          result.retailPrice = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'canTrackingStock':
          result.canTrackingStock = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'showLowStockAlert':
          result.showLowStockAlert = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'channels':
          result.channels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Stock extends Stock {
  @override
  final String value;
  @override
  final String id;
  @override
  final String branchId;
  @override
  final String variantId;
  @override
  final bool isActive;
  @override
  final String lowStock;
  @override
  final String currentStock;
  @override
  final double supplyPrice;
  @override
  final double retailPrice;
  @override
  final bool canTrackingStock;
  @override
  final bool showLowStockAlert;
  @override
  final BuiltList<String> channels;
  @override
  final String table;

  factory _$Stock([void Function(StockBuilder) updates]) =>
      (new StockBuilder()..update(updates)).build();

  _$Stock._(
      {this.value,
      this.id,
      this.branchId,
      this.variantId,
      this.isActive,
      this.lowStock,
      this.currentStock,
      this.supplyPrice,
      this.retailPrice,
      this.canTrackingStock,
      this.showLowStockAlert,
      this.channels,
      this.table})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Stock', 'id');
    }
    if (branchId == null) {
      throw new BuiltValueNullFieldError('Stock', 'branchId');
    }
    if (variantId == null) {
      throw new BuiltValueNullFieldError('Stock', 'variantId');
    }
    if (lowStock == null) {
      throw new BuiltValueNullFieldError('Stock', 'lowStock');
    }
    if (currentStock == null) {
      throw new BuiltValueNullFieldError('Stock', 'currentStock');
    }
    if (supplyPrice == null) {
      throw new BuiltValueNullFieldError('Stock', 'supplyPrice');
    }
    if (retailPrice == null) {
      throw new BuiltValueNullFieldError('Stock', 'retailPrice');
    }
    if (canTrackingStock == null) {
      throw new BuiltValueNullFieldError('Stock', 'canTrackingStock');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Stock', 'channels');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('Stock', 'table');
    }
  }

  @override
  Stock rebuild(void Function(StockBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StockBuilder toBuilder() => new StockBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Stock &&
        value == other.value &&
        id == other.id &&
        branchId == other.branchId &&
        variantId == other.variantId &&
        isActive == other.isActive &&
        lowStock == other.lowStock &&
        currentStock == other.currentStock &&
        supplyPrice == other.supplyPrice &&
        retailPrice == other.retailPrice &&
        canTrackingStock == other.canTrackingStock &&
        showLowStockAlert == other.showLowStockAlert &&
        channels == other.channels &&
        table == other.table;
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
                                        $jc(
                                            $jc(
                                                $jc($jc(0, value.hashCode),
                                                    id.hashCode),
                                                branchId.hashCode),
                                            variantId.hashCode),
                                        isActive.hashCode),
                                    lowStock.hashCode),
                                currentStock.hashCode),
                            supplyPrice.hashCode),
                        retailPrice.hashCode),
                    canTrackingStock.hashCode),
                showLowStockAlert.hashCode),
            channels.hashCode),
        table.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Stock')
          ..add('value', value)
          ..add('id', id)
          ..add('branchId', branchId)
          ..add('variantId', variantId)
          ..add('isActive', isActive)
          ..add('lowStock', lowStock)
          ..add('currentStock', currentStock)
          ..add('supplyPrice', supplyPrice)
          ..add('retailPrice', retailPrice)
          ..add('canTrackingStock', canTrackingStock)
          ..add('showLowStockAlert', showLowStockAlert)
          ..add('channels', channels)
          ..add('table', table))
        .toString();
  }
}

class StockBuilder implements Builder<Stock, StockBuilder> {
  _$Stock _$v;

  String _value;
  String get value => _$this._value;
  set value(String value) => _$this._value = value;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _branchId;
  String get branchId => _$this._branchId;
  set branchId(String branchId) => _$this._branchId = branchId;

  String _variantId;
  String get variantId => _$this._variantId;
  set variantId(String variantId) => _$this._variantId = variantId;

  bool _isActive;
  bool get isActive => _$this._isActive;
  set isActive(bool isActive) => _$this._isActive = isActive;

  String _lowStock;
  String get lowStock => _$this._lowStock;
  set lowStock(String lowStock) => _$this._lowStock = lowStock;

  String _currentStock;
  String get currentStock => _$this._currentStock;
  set currentStock(String currentStock) => _$this._currentStock = currentStock;

  double _supplyPrice;
  double get supplyPrice => _$this._supplyPrice;
  set supplyPrice(double supplyPrice) => _$this._supplyPrice = supplyPrice;

  double _retailPrice;
  double get retailPrice => _$this._retailPrice;
  set retailPrice(double retailPrice) => _$this._retailPrice = retailPrice;

  bool _canTrackingStock;
  bool get canTrackingStock => _$this._canTrackingStock;
  set canTrackingStock(bool canTrackingStock) =>
      _$this._canTrackingStock = canTrackingStock;

  bool _showLowStockAlert;
  bool get showLowStockAlert => _$this._showLowStockAlert;
  set showLowStockAlert(bool showLowStockAlert) =>
      _$this._showLowStockAlert = showLowStockAlert;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  StockBuilder();

  StockBuilder get _$this {
    if (_$v != null) {
      _value = _$v.value;
      _id = _$v.id;
      _branchId = _$v.branchId;
      _variantId = _$v.variantId;
      _isActive = _$v.isActive;
      _lowStock = _$v.lowStock;
      _currentStock = _$v.currentStock;
      _supplyPrice = _$v.supplyPrice;
      _retailPrice = _$v.retailPrice;
      _canTrackingStock = _$v.canTrackingStock;
      _showLowStockAlert = _$v.showLowStockAlert;
      _channels = _$v.channels?.toBuilder();
      _table = _$v.table;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Stock other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Stock;
  }

  @override
  void update(void Function(StockBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Stock build() {
    _$Stock _$result;
    try {
      _$result = _$v ??
          new _$Stock._(
              value: value,
              id: id,
              branchId: branchId,
              variantId: variantId,
              isActive: isActive,
              lowStock: lowStock,
              currentStock: currentStock,
              supplyPrice: supplyPrice,
              retailPrice: retailPrice,
              canTrackingStock: canTrackingStock,
              showLowStockAlert: showLowStockAlert,
              channels: channels.build(),
              table: table);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Stock', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
