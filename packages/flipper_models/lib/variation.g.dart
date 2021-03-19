// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Variation> _$variationSerializer = new _$VariationSerializer();

class _$VariationSerializer implements StructuredSerializer<Variation> {
  @override
  final Iterable<Type> types = const [Variation, _$Variation];
  @override
  final String wireName = 'Variation';

  @override
  Iterable<Object> serialize(Serializers serializers, Variation object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'productId',
      serializers.serialize(object.productId,
          specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'unit',
      serializers.serialize(object.unit, specifiedType: const FullType(String)),
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];
    if (object.sku != null) {
      result
        ..add('sku')
        ..add(serializers.serialize(object.sku,
            specifiedType: const FullType(String)));
    }
    if (object.productName != null) {
      result
        ..add('productName')
        ..add(serializers.serialize(object.productName,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  Variation deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new VariationBuilder();

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
        case 'sku':
          result.sku = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'productId':
          result.productId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'unit':
          result.unit = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'table':
          result.table = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'productName':
          result.productName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'channels':
          result.channels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

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
  @override
  final String table;
  @override
  final String productName;
  @override
  final BuiltList<String> channels;

  factory _$Variation([void Function(VariationBuilder) updates]) =>
      (new VariationBuilder()..update(updates)).build();

  _$Variation._(
      {this.id,
      this.sku,
      this.productId,
      this.name,
      this.unit,
      this.table,
      this.productName,
      this.channels})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Variation', 'id');
    }
    if (productId == null) {
      throw new BuiltValueNullFieldError('Variation', 'productId');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('Variation', 'name');
    }
    if (unit == null) {
      throw new BuiltValueNullFieldError('Variation', 'unit');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('Variation', 'table');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Variation', 'channels');
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
        unit == other.unit &&
        table == other.table &&
        productName == other.productName &&
        channels == other.channels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc($jc(0, id.hashCode), sku.hashCode),
                            productId.hashCode),
                        name.hashCode),
                    unit.hashCode),
                table.hashCode),
            productName.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Variation')
          ..add('id', id)
          ..add('sku', sku)
          ..add('productId', productId)
          ..add('name', name)
          ..add('unit', unit)
          ..add('table', table)
          ..add('productName', productName)
          ..add('channels', channels))
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

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  String _productName;
  String get productName => _$this._productName;
  set productName(String productName) => _$this._productName = productName;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  VariationBuilder();

  VariationBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _sku = _$v.sku;
      _productId = _$v.productId;
      _name = _$v.name;
      _unit = _$v.unit;
      _table = _$v.table;
      _productName = _$v.productName;
      _channels = _$v.channels?.toBuilder();
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
    _$Variation _$result;
    try {
      _$result = _$v ??
          new _$Variation._(
              id: id,
              sku: sku,
              productId: productId,
              name: name,
              unit: unit,
              table: table,
              productName: productName,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Variation', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
