// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<VariantStock> _$variantStockSerializer =
    new _$VariantStockSerializer();

class _$VariantStockSerializer implements StructuredSerializer<VariantStock> {
  @override
  final Iterable<Type> types = const [VariantStock, _$VariantStock];
  @override
  final String wireName = 'VariantStock';

  @override
  Iterable<Object> serialize(Serializers serializers, VariantStock object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    if (object.lowStock != null) {
      result
        ..add('lowStock')
        ..add(serializers.serialize(object.lowStock,
            specifiedType: const FullType(double)));
    }
    if (object.currentStock != null) {
      result
        ..add('currentStock')
        ..add(serializers.serialize(object.currentStock,
            specifiedType: const FullType(double)));
    }
    if (object.supplyPrice != null) {
      result
        ..add('supplyPrice')
        ..add(serializers.serialize(object.supplyPrice,
            specifiedType: const FullType(double)));
    }
    if (object.retailPrice != null) {
      result
        ..add('retailPrice')
        ..add(serializers.serialize(object.retailPrice,
            specifiedType: const FullType(double)));
    }
    if (object.sku != null) {
      result
        ..add('sku')
        ..add(serializers.serialize(object.sku,
            specifiedType: const FullType(String)));
    }
    if (object.productId != null) {
      result
        ..add('productId')
        ..add(serializers.serialize(object.productId,
            specifiedType: const FullType(String)));
    }
    if (object.unit != null) {
      result
        ..add('unit')
        ..add(serializers.serialize(object.unit,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  VariantStock deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VariantStockBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'lowStock':
          result.lowStock = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'currentStock':
          result.currentStock = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'supplyPrice':
          result.supplyPrice = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'retailPrice':
          result.retailPrice = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'sku':
          result.sku = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'productId':
          result.productId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'unit':
          result.unit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$VariantStock extends VariantStock {
  @override
  final String name;
  @override
  final String id;
  @override
  final double lowStock;
  @override
  final double currentStock;
  @override
  final double supplyPrice;
  @override
  final double retailPrice;
  @override
  final String sku;
  @override
  final String productId;
  @override
  final String unit;

  factory _$VariantStock([void Function(VariantStockBuilder) updates]) =>
      (new VariantStockBuilder()..update(updates)).build();

  _$VariantStock._(
      {this.name,
      this.id,
      this.lowStock,
      this.currentStock,
      this.supplyPrice,
      this.retailPrice,
      this.sku,
      this.productId,
      this.unit})
      : super._() {
    if (name == null) {
      throw new BuiltValueNullFieldError('VariantStock', 'name');
    }
    if (id == null) {
      throw new BuiltValueNullFieldError('VariantStock', 'id');
    }
  }

  @override
  VariantStock rebuild(void Function(VariantStockBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VariantStockBuilder toBuilder() => new VariantStockBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VariantStock &&
        name == other.name &&
        id == other.id &&
        lowStock == other.lowStock &&
        currentStock == other.currentStock &&
        supplyPrice == other.supplyPrice &&
        retailPrice == other.retailPrice &&
        sku == other.sku &&
        productId == other.productId &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, name.hashCode), id.hashCode),
                                lowStock.hashCode),
                            currentStock.hashCode),
                        supplyPrice.hashCode),
                    retailPrice.hashCode),
                sku.hashCode),
            productId.hashCode),
        unit.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('VariantStock')
          ..add('name', name)
          ..add('id', id)
          ..add('lowStock', lowStock)
          ..add('currentStock', currentStock)
          ..add('supplyPrice', supplyPrice)
          ..add('retailPrice', retailPrice)
          ..add('sku', sku)
          ..add('productId', productId)
          ..add('unit', unit))
        .toString();
  }
}

class VariantStockBuilder
    implements Builder<VariantStock, VariantStockBuilder> {
  _$VariantStock _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  double _lowStock;
  double get lowStock => _$this._lowStock;
  set lowStock(double lowStock) => _$this._lowStock = lowStock;

  double _currentStock;
  double get currentStock => _$this._currentStock;
  set currentStock(double currentStock) => _$this._currentStock = currentStock;

  double _supplyPrice;
  double get supplyPrice => _$this._supplyPrice;
  set supplyPrice(double supplyPrice) => _$this._supplyPrice = supplyPrice;

  double _retailPrice;
  double get retailPrice => _$this._retailPrice;
  set retailPrice(double retailPrice) => _$this._retailPrice = retailPrice;

  String _sku;
  String get sku => _$this._sku;
  set sku(String sku) => _$this._sku = sku;

  String _productId;
  String get productId => _$this._productId;
  set productId(String productId) => _$this._productId = productId;

  String _unit;
  String get unit => _$this._unit;
  set unit(String unit) => _$this._unit = unit;

  VariantStockBuilder();

  VariantStockBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _id = _$v.id;
      _lowStock = _$v.lowStock;
      _currentStock = _$v.currentStock;
      _supplyPrice = _$v.supplyPrice;
      _retailPrice = _$v.retailPrice;
      _sku = _$v.sku;
      _productId = _$v.productId;
      _unit = _$v.unit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VariantStock other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$VariantStock;
  }

  @override
  void update(void Function(VariantStockBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$VariantStock build() {
    final _$result = _$v ??
        new _$VariantStock._(
            name: name,
            id: id,
            lowStock: lowStock,
            currentStock: currentStock,
            supplyPrice: supplyPrice,
            retailPrice: retailPrice,
            sku: sku,
            productId: productId,
            unit: unit);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
