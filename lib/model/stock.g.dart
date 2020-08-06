// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Stock extends Stock {
  @override
  final String value;
  @override
  final int id;
  @override
  final int branchId;
  @override
  final int variantId;
  @override
  final int lowStock;
  @override
  final int currentStock;
  @override
  final int supplyPrice;
  @override
  final int retailPrice;
  @override
  final bool canTrackingStock;
  @override
  final bool showLowStockAlert;

  factory _$Stock([void Function(StockBuilder) updates]) =>
      (new StockBuilder()..update(updates)).build();

  _$Stock._(
      {this.value,
      this.id,
      this.branchId,
      this.variantId,
      this.lowStock,
      this.currentStock,
      this.supplyPrice,
      this.retailPrice,
      this.canTrackingStock,
      this.showLowStockAlert})
      : super._() {
    if (value == null) {
      throw new BuiltValueNullFieldError('Stock', 'value');
    }
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
    if (showLowStockAlert == null) {
      throw new BuiltValueNullFieldError('Stock', 'showLowStockAlert');
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
        lowStock == other.lowStock &&
        currentStock == other.currentStock &&
        supplyPrice == other.supplyPrice &&
        retailPrice == other.retailPrice &&
        canTrackingStock == other.canTrackingStock &&
        showLowStockAlert == other.showLowStockAlert;
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
                                $jc($jc($jc(0, value.hashCode), id.hashCode),
                                    branchId.hashCode),
                                variantId.hashCode),
                            lowStock.hashCode),
                        currentStock.hashCode),
                    supplyPrice.hashCode),
                retailPrice.hashCode),
            canTrackingStock.hashCode),
        showLowStockAlert.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Stock')
          ..add('value', value)
          ..add('id', id)
          ..add('branchId', branchId)
          ..add('variantId', variantId)
          ..add('lowStock', lowStock)
          ..add('currentStock', currentStock)
          ..add('supplyPrice', supplyPrice)
          ..add('retailPrice', retailPrice)
          ..add('canTrackingStock', canTrackingStock)
          ..add('showLowStockAlert', showLowStockAlert))
        .toString();
  }
}

class StockBuilder implements Builder<Stock, StockBuilder> {
  _$Stock _$v;

  String _value;
  String get value => _$this._value;
  set value(String value) => _$this._value = value;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  int _branchId;
  int get branchId => _$this._branchId;
  set branchId(int branchId) => _$this._branchId = branchId;

  int _variantId;
  int get variantId => _$this._variantId;
  set variantId(int variantId) => _$this._variantId = variantId;

  int _lowStock;
  int get lowStock => _$this._lowStock;
  set lowStock(int lowStock) => _$this._lowStock = lowStock;

  int _currentStock;
  int get currentStock => _$this._currentStock;
  set currentStock(int currentStock) => _$this._currentStock = currentStock;

  int _supplyPrice;
  int get supplyPrice => _$this._supplyPrice;
  set supplyPrice(int supplyPrice) => _$this._supplyPrice = supplyPrice;

  int _retailPrice;
  int get retailPrice => _$this._retailPrice;
  set retailPrice(int retailPrice) => _$this._retailPrice = retailPrice;

  bool _canTrackingStock;
  bool get canTrackingStock => _$this._canTrackingStock;
  set canTrackingStock(bool canTrackingStock) =>
      _$this._canTrackingStock = canTrackingStock;

  bool _showLowStockAlert;
  bool get showLowStockAlert => _$this._showLowStockAlert;
  set showLowStockAlert(bool showLowStockAlert) =>
      _$this._showLowStockAlert = showLowStockAlert;

  StockBuilder();

  StockBuilder get _$this {
    if (_$v != null) {
      _value = _$v.value;
      _id = _$v.id;
      _branchId = _$v.branchId;
      _variantId = _$v.variantId;
      _lowStock = _$v.lowStock;
      _currentStock = _$v.currentStock;
      _supplyPrice = _$v.supplyPrice;
      _retailPrice = _$v.retailPrice;
      _canTrackingStock = _$v.canTrackingStock;
      _showLowStockAlert = _$v.showLowStockAlert;
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
    final _$result = _$v ??
        new _$Stock._(
            value: value,
            id: id,
            branchId: branchId,
            variantId: variantId,
            lowStock: lowStock,
            currentStock: currentStock,
            supplyPrice: supplyPrice,
            retailPrice: retailPrice,
            canTrackingStock: canTrackingStock,
            showLowStockAlert: showLowStockAlert);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
