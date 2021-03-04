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
      'orderId',
      serializers.serialize(object.orderId,
          specifiedType: const FullType(String)),
      'ticketName',
      serializers.serialize(object.ticketName,
          specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(object.createdAt,
          specifiedType: const FullType(String)),
      'channels',
      serializers.serialize(object.channels,
          specifiedType:
              const FullType(BuiltList, const [const FullType(String)])),
    ];

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
        case 'orderId':
          result.orderId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'ticketName':
          result.ticketName = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
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

class _$Ticket extends Ticket {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final String ticketName;
  @override
  final String createdAt;
  @override
  final BuiltList<String> channels;

  factory _$Ticket([void Function(TicketBuilder) updates]) =>
      (new TicketBuilder()..update(updates)).build();

  _$Ticket._(
      {this.id, this.orderId, this.ticketName, this.createdAt, this.channels})
      : super._() {
    if (id == null) {
      throw new BuiltValueNullFieldError('Ticket', 'id');
    }
    if (orderId == null) {
      throw new BuiltValueNullFieldError('Ticket', 'orderId');
    }
    if (ticketName == null) {
      throw new BuiltValueNullFieldError('Ticket', 'ticketName');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('Ticket', 'createdAt');
    }
    if (channels == null) {
      throw new BuiltValueNullFieldError('Ticket', 'channels');
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
        orderId == other.orderId &&
        ticketName == other.ticketName &&
        createdAt == other.createdAt &&
        channels == other.channels;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc($jc($jc(0, id.hashCode), orderId.hashCode),
                ticketName.hashCode),
            createdAt.hashCode),
        channels.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Ticket')
          ..add('id', id)
          ..add('orderId', orderId)
          ..add('ticketName', ticketName)
          ..add('createdAt', createdAt)
          ..add('channels', channels))
        .toString();
  }
}

class TicketBuilder implements Builder<Ticket, TicketBuilder> {
  _$Ticket _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _orderId;
  String get orderId => _$this._orderId;
  set orderId(String orderId) => _$this._orderId = orderId;

  String _ticketName;
  String get ticketName => _$this._ticketName;
  set ticketName(String ticketName) => _$this._ticketName = ticketName;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  ListBuilder<String> _channels;
  ListBuilder<String> get channels =>
      _$this._channels ??= new ListBuilder<String>();
  set channels(ListBuilder<String> channels) => _$this._channels = channels;

  TicketBuilder();

  TicketBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _orderId = _$v.orderId;
      _ticketName = _$v.ticketName;
      _createdAt = _$v.createdAt;
      _channels = _$v.channels?.toBuilder();
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
              orderId: orderId,
              ticketName: ticketName,
              createdAt: createdAt,
              channels: channels.build());
    } catch (_) {
      String _$failedField;
      try {
        _$failedField = 'channels';
        channels.build();
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
