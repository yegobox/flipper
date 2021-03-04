// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StockHistory> _$stockHistorySerializer =
    new _$StockHistorySerializer();

class _$StockHistorySerializer implements StructuredSerializer<StockHistory> {
  @override
  final Iterable<Type> types = const [StockHistory, _$StockHistory];
  @override
  final String wireName = 'StockHistory';

  @override
  Iterable<Object> serialize(Serializers serializers, StockHistory object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'orderId',
      serializers.serialize(object.orderId,
          specifiedType: const FullType(String)),
      'variantId',
      serializers.serialize(object.variantId,
          specifiedType: const FullType(String)),
      'variantName',
      serializers.serialize(object.variantName,
          specifiedType: const FullType(String)),
      'updatedAt',
      serializers.serialize(object.updatedAt,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'stockId',
      serializers.serialize(object.stockId,
          specifiedType: const FullType(String)),
      'reason',
      serializers.serialize(object.reason,
          specifiedType: const FullType(String)),
      'quantity',
      serializers.serialize(object.quantity,
          specifiedType: const FullType(double)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'table',
      serializers.serialize(object.table,
          specifiedType: const FullType(String)),
    ];
    if (object.note != null) {
      result
        ..add('note')
        ..add(serializers.serialize(object.note,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  StockHistory deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new StockHistoryBuilder();

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
        case 'orderId':
          result.orderId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'variantId':
          result.variantId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'variantName':
          result.variantName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'note':
          result.note = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'stockId':
          result.stockId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'reason':
          result.reason = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'quantity':
          result.quantity = serializers.deserialize(value,
              specifiedType: const FullType(double)) as double;
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

class _$StockHistory extends StockHistory {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final String variantId;
  @override
  final String variantName;
  @override
  final String note;
  @override
  final String updatedAt;
  @override
  final String createdAt;
  @override
  final String stockId;
  @override
  final String reason;
  @override
  final double quantity;
  @override
  final BuiltList<String> channels;
  @override
  final String table;

  factory _$StockHistory([void Function(StockHistoryBuilder) updates]) =>
      (new StockHistoryBuilder()..update(updates)).build();

  _$StockHistory._(
      {this.id,
      this.orderId,
      this.variantId,
      this.variantName,
      this.note,
      this.updatedAt,
      this.createdAt,
      this.stockId,
      this.reason,
      this.quantity,
      this.channels,
      this.table})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'id');
    }
    if (orderId == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'orderId');
    }
    if (variantId == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'variantId');
    }
    if (variantName == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'variantName');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'updatedAt');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'createdAt');
    }
    if (stockId == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'stockId');
    }
    if (reason == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'reason');
    }
    if (quantity == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'quantity');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'channels');
    }
    if (table == null) {
      throw new BuiltValueNullFieldError('StockHistory', 'table');
    }
  }

  @override
  StockHistory rebuild(void Function(StockHistoryBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StockHistoryBuilder toBuilder() => new StockHistoryBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StockHistory &&
        id == other.id &&
        orderId == other.orderId &&
        variantId == other.variantId &&
        variantName == other.variantName &&
        note == other.note &&
        updatedAt == other.updatedAt &&
        createdAt == other.createdAt &&
        stockId == other.stockId &&
        reason == other.reason &&
        quantity == other.quantity &&
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
                                            $jc($jc(0, id.hashCode),
                                                orderId.hashCode),
                                            variantId.hashCode),
                                        variantName.hashCode),
                                    note.hashCode),
                                updatedAt.hashCode),
                            createdAt.hashCode),
                        stockId.hashCode),
                    reason.hashCode),
                quantity.hashCode),
            channels.hashCode),
        table.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('StockHistory')
          ..add('id', id)
          ..add('orderId', orderId)
          ..add('variantId', variantId)
          ..add('variantName', variantName)
          ..add('note', note)
          ..add('updatedAt', updatedAt)
          ..add('createdAt', createdAt)
          ..add('stockId', stockId)
          ..add('reason', reason)
          ..add('quantity', quantity)
          ..add('channels', channels)
          ..add('table', table))
        .toString();
  }
}

class StockHistoryBuilder
    implements Builder<StockHistory, StockHistoryBuilder> {
  _$StockHistory _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _orderId;
  String get orderId => _$this._orderId;
  set orderId(String orderId) => _$this._orderId = orderId;

  String _variantId;
  String get variantId => _$this._variantId;
  set variantId(String variantId) => _$this._variantId = variantId;

  String _variantName;
  String get variantName => _$this._variantName;
  set variantName(String variantName) => _$this._variantName = variantName;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _stockId;
  String get stockId => _$this._stockId;
  set stockId(String stockId) => _$this._stockId = stockId;

  String _reason;
  String get reason => _$this._reason;
  set reason(String reason) => _$this._reason = reason;

  double _quantity;
  double get quantity => _$this._quantity;
  set quantity(double quantity) => _$this._quantity = quantity;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  String _table;
  String get table => _$this._table;
  set table(String table) => _$this._table = table;

  StockHistoryBuilder();

  StockHistoryBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _orderId = _$v.orderId;
      _variantId = _$v.variantId;
      _variantName = _$v.variantName;
      _note = _$v.note;
      _updatedAt = _$v.updatedAt;
      _createdAt = _$v.createdAt;
      _stockId = _$v.stockId;
      _reason = _$v.reason;
      _quantity = _$v.quantity;
      _channels = _$v.channels?.toBuilder();
      _table = _$v.table;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StockHistory other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$StockHistory;
  }

  @override
  void update(void Function(StockHistoryBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$StockHistory build() {
    _$StockHistory _$result;
    try {
      _$result = _$v ??
          new _$StockHistory._(
              id: id,
              orderId: orderId,
              variantId: variantId,
              variantName: variantName,
              note: note,
              updatedAt: updatedAt,
              createdAt: createdAt,
              stockId: stockId,
              reason: reason,
              quantity: quantity,
              channels: channels.build(),
              table: table);
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'StockHistory', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
