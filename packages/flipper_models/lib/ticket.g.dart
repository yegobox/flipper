// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Ticket> _$ticketSerializer = new _$TicketSerializer();

class _$TicketSerializer implements StructuredSerializer<Ticket> {
  @override
  final Iterable<Type> types = const [Ticket, _$Ticket];
  @override
  final String wireName = 'Ticket';

  @override
  Iterable<Object> serialize(Serializers serializers, Ticket object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'ticketName',
      serializers.serialize(object.ticketName,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'resumed',
      serializers.serialize(object.resumed,
          specifiedType: const FullType(bool)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
      'orders',
      serializers.serialize(object.orders,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
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
  Ticket deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TicketBuilder();

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
        case 'ticketName':
          result.ticketName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'note':
          result.note = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'resumed':
          result.resumed = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'channels':
          result.channels.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
        case 'orders':
          result.orders.replace(serializers.deserialize(value,
                  specifiedType:
                      const FullType(BuiltList, const [const FullType(String)]))
              as BuiltList<Object>);
          break;
      }
    }

    return result.build();
  }
}

class _$Ticket extends Ticket {
  @override
  final String id;
  @override
  final String ticketName;
  @override
  final String note;
  @override
  final String createdAt;
  @override
  final bool resumed;
  @override
  final BuiltList<String> channels;
  @override
  final BuiltList<String> orders;

  factory _$Ticket([void Function(TicketBuilder) updates]) =>
      (new TicketBuilder()..update(updates)).build();

  _$Ticket._(
      {this.id,
      this.ticketName,
      this.note,
      this.createdAt,
      this.resumed,
      this.channels,
      this.orders})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Ticket', 'id');
    }
    if (ticketName == null) {
      throw new BuiltValueNullFieldError('Ticket', 'ticketName');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Ticket', 'createdAt');
    }
    if (resumed == null) {
      throw new BuiltValueNullFieldError('Ticket', 'resumed');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Ticket', 'channels');
    }
    if (orders == null) {
      throw new BuiltValueNullFieldError('Ticket', 'orders');
    }
  }

  @override
  Ticket rebuild(void Function(TicketBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TicketBuilder toBuilder() => new TicketBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Ticket &&
        id == other.id &&
        ticketName == other.ticketName &&
        note == other.note &&
        createdAt == other.createdAt &&
        resumed == other.resumed &&
        channels == other.channels &&
        orders == other.orders;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), ticketName.hashCode),
                        note.hashCode),
                    createdAt.hashCode),
                resumed.hashCode),
            channels.hashCode),
        orders.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Ticket')
          ..add('id', id)
          ..add('ticketName', ticketName)
          ..add('note', note)
          ..add('createdAt', createdAt)
          ..add('resumed', resumed)
          ..add('channels', channels)
          ..add('orders', orders))
        .toString();
  }
}

class TicketBuilder implements Builder<Ticket, TicketBuilder> {
  _$Ticket _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _ticketName;
  String get ticketName => _$this._ticketName;
  set ticketName(String ticketName) => _$this._ticketName = ticketName;

  String _note;
  String get note => _$this._note;
  set note(String note) => _$this._note = note;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  bool _resumed;
  bool get resumed => _$this._resumed;
  set resumed(bool resumed) => _$this._resumed = resumed;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  ListBuilder<String> _orders;
  ListBuilder<String> get orders =>
      _$this._orders ??= new ListBuilder<String>();
  set orders(ListBuilder<String> orders) => _$this._orders = orders;

  TicketBuilder();

  TicketBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _ticketName = _$v.ticketName;
      _note = _$v.note;
      _createdAt = _$v.createdAt;
      _resumed = _$v.resumed;
      _channels = _$v.channels?.toBuilder();
      _orders = _$v.orders?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Ticket other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Ticket;
  }

  @override
  void update(void Function(TicketBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$Ticket build() {
    _$Ticket _$result;
    try {
      _$result = _$v ??
          new _$Ticket._(
              id: id,
              ticketName: ticketName,
              note: note,
              createdAt: createdAt,
              resumed: resumed,
              channels: channels.build(),
              orders: orders.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
        _$failedField = 'orders';
        orders.build();
      } catch (e) {
        throw new BuiltValueNestedFieldError(
            'Ticket', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
