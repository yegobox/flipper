// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<CurrentSale> _$currentSaleSerializer = new _$CurrentSaleSerializer();

class _$CurrentSaleSerializer implements StructuredSerializer<CurrentSale> {
  @override
  final Iterable<Type> types = const [CurrentSale, _$CurrentSale];
  @override
  final String wireName = 'CurrentSale';

  @override
  Iterable<Object> serialize(Serializers serializers, CurrentSale object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'variantName',
      serializers.serialize(object.variantName,
          specifiedType: const FullType(String)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  CurrentSale deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new CurrentSaleBuilder();

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
        case 'variantName':
          result.variantName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$CurrentSale extends CurrentSale {
  @override
  final String id;
  @override
  final String variantName;
  @override
  final double quantity;

  factory _$CurrentSale([void Function(CurrentSaleBuilder) updates]) =>
      (new CurrentSaleBuilder()..update(updates)).build();

  _$CurrentSale._({this.id, this.variantName, this.quantity}) : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('CurrentSale', 'id');
    }
    if (variantName == null) {
      throw new BuiltValueNullFieldError('CurrentSale', 'variantName');
    }
    if (quantity == null) {
      throw new BuiltValueNullFieldError('CurrentSale', 'quantity');
    }
  }

  @override
  CurrentSale rebuild(void Function(CurrentSaleBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CurrentSaleBuilder toBuilder() => new CurrentSaleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CurrentSale &&
        id == other.id &&
        variantName == other.variantName &&
        quantity == other.quantity;
  }

  @override
  int get hashCode {
    return $jf(
        $jc($jc($jc(0, id.hashCode), variantName.hashCode), quantity.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('CurrentSale')
          ..add('id', id)
          ..add('variantName', variantName)
          ..add('quantity', quantity))
        .toString();
  }
}

class CurrentSaleBuilder implements Builder<CurrentSale, CurrentSaleBuilder> {
  _$CurrentSale _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _variantName;
  String get variantName => _$this._variantName;
  set variantName(String variantName) => _$this._variantName = variantName;

  double _quantity;
  double get quantity => _$this._quantity;
  set quantity(double quantity) => _$this._quantity = quantity;

  CurrentSaleBuilder();

  CurrentSaleBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _variantName = _$v.variantName;
      _quantity = _$v.quantity;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CurrentSale other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$CurrentSale;
  }

  @override
  void update(void Function(CurrentSaleBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$CurrentSale build() {
    final _$result = _$v ??
        new _$CurrentSale._(
            id: id, variantName: variantName, quantity: quantity);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
