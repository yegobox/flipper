// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Printable> _$printableSerializer = new _$PrintableSerializer();

class _$PrintableSerializer implements StructuredSerializer<Printable> {
  @override
  final Iterable<Type> types = const [Printable, _$Printable];
  @override
  final String wireName = 'Printable';

  @override
  Iterable<Object> serialize(Serializers serializers, Printable object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'amount',
      serializers.serialize(object.amount,
          specifiedType: const FullType(double)),
      'unit',
      serializers.serialize(object.unit, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(double)),
      'price',
      serializers.serialize(object.price,
          specifiedType: const FullType(double)),
    ];

    return result;
  }

  @override
  Printable deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PrintableBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'amount':
          result.amount = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'unit':
          result.unit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
        case 'price':
          result.price = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
          break;
      }
    }

    return result.build();
  }
}

class _$Printable extends Printable {
  @override
  final double amount;
  @override
  final String unit;
  @override
  final String name;
  @override
  final double quantity;
  @override
  final double price;

  factory _$Printable([void Function(PrintableBuilder) updates]) =>
      (new PrintableBuilder()..update(updates)).build();

  _$Printable._({this.amount, this.unit, this.name, this.quantity, this.price})
      : super._() {
    if (amount == null) {
      throw new BuiltValueNullFieldError('Printable', 'amount');
    }
    if (unit == null) {
      throw new BuiltValueNullFieldError('Printable', 'unit');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Printable', 'name');
    }
    if (quantity == null) {
      throw new BuiltValueNullFieldError('Printable', 'quantity');
    }
    if (price == null) {
      throw new BuiltValueNullFieldError('Printable', 'price');
    }
  }

  @override
  Printable rebuild(void Function(PrintableBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PrintableBuilder toBuilder() => new PrintableBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Printable &&
        amount == other.amount &&
        unit == other.unit &&
        name == other.name &&
        quantity == other.quantity &&
        price == other.price;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc($jc($jc($jc(0, amount.hashCode), unit.hashCode), name.hashCode),
            quantity.hashCode),
        price.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Printable')
          ..add('amount', amount)
          ..add('unit', unit)
          ..add('name', name)
          ..add('quantity', quantity)
          ..add('price', price))
        .toString();
  }
}

class PrintableBuilder implements Builder<Printable, PrintableBuilder> {
  _$Printable _$v;

  double _amount;
  double get amount => _$this._amount;
  set amount(double amount) => _$this._amount = amount;

  String _unit;
  String get unit => _$this._unit;
  set unit(String unit) => _$this._unit = unit;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  double _quantity;
  double get quantity => _$this._quantity;
  set quantity(double quantity) => _$this._quantity = quantity;

  double _price;
  double get price => _$this._price;
  set price(double price) => _$this._price = price;

  PrintableBuilder();

  PrintableBuilder get _$this {
    if (_$v != null) {
      _amount = _$v.amount;
      _unit = _$v.unit;
      _name = _$v.name;
      _quantity = _$v.quantity;
      _price = _$v.price;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Printable other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Printable;
  }

  @override
  void update(void Function(PrintableBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Printable build() {
    final _$result = _$v ??
        new _$Printable._(
            amount: amount,
            unit: unit,
            name: name,
            quantity: quantity,
            price: price);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
