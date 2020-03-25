// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'variation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Variation extends Variation {
  @override
  final String id;
  @override
  final String sku;
  @override
  final String productId;
  @override
  final String name;
  @override
  final String unit;

  factory _$Variation([void Function(VariationBuilder) updates]) =>
      (new VariationBuilder()..update(updates)).build();

  _$Variation._({this.id, this.sku, this.productId, this.name, this.unit})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Variation', 'id');
    }
    if (sku == null) {
      throw new BuiltValueNullFieldError('Variation', 'sku');
    }
    if (productId == null) {
      throw new BuiltValueNullFieldError('Variation', 'productId');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Variation', 'name');
    }
  }

  @override
  Variation rebuild(void Function(VariationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VariationBuilder toBuilder() => new VariationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Variation &&
        id == other.id &&
        sku == other.sku &&
        productId == other.productId &&
        name == other.name &&
        unit == other.unit;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, id.hashCode), sku.hashCode), productId.hashCode),
            name.hashCode),
        unit.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Variation')
          ..add('id', id)
          ..add('sku', sku)
          ..add('productId', productId)
          ..add('name', name)
          ..add('unit', unit))
        .toString();
  }
}

class VariationBuilder implements Builder<Variation, VariationBuilder> {
  _$Variation _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _sku;
  String get sku => _$this._sku;
  set sku(String sku) => _$this._sku = sku;

  String _productId;
  String get productId => _$this._productId;
  set productId(String productId) => _$this._productId = productId;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _unit;
  String get unit => _$this._unit;
  set unit(String unit) => _$this._unit = unit;

  VariationBuilder();

  VariationBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _sku = _$v.sku;
      _productId = _$v.productId;
      _name = _$v.name;
      _unit = _$v.unit;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Variation other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Variation;
  }

  @override
  void update(void Function(VariationBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Variation build() {
    final _$result = _$v ??
        new _$Variation._(
            id: id, sku: sku, productId: productId, name: name, unit: unit);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
