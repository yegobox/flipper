// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FContact> _$fContactSerializer = new _$FContactSerializer();

class _$FContactSerializer implements StructuredSerializer<FContact> {
  @override
  final Iterable<Type> types = const [FContact, _$FContact];
  @override
  final String wireName = 'FContact';

  @override
  Iterable<Object> serialize(Serializers serializers, FContact object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[];
    if (object.name != null) {
      result
        ..add('name')
        ..add(serializers.serialize(object.name,
            specifiedType: const FullType(String)));
    }
    if (object.phoneNumber != null) {
      result
        ..add('phoneNumber')
        ..add(serializers.serialize(object.phoneNumber,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  FContact deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FContactBuilder();

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
        case 'phoneNumber':
          result.phoneNumber = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FContact extends FContact {
  @override
  final String name;
  @override
  final String phoneNumber;

  factory _$FContact([void Function(FContactBuilder) updates]) =>
      (new FContactBuilder()..update(updates)).build();

  _$FContact._({this.name, this.phoneNumber}) : super._();

  @override
  FContact rebuild(void Function(FContactBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FContactBuilder toBuilder() => new FContactBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FContact &&
        name == other.name &&
        phoneNumber == other.phoneNumber;
  }

  @override
  int get hashCode {
    return $jf($jc($jc(0, name.hashCode), phoneNumber.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FContact')
          ..add('name', name)
          ..add('phoneNumber', phoneNumber))
        .toString();
  }
}

class FContactBuilder implements Builder<FContact, FContactBuilder> {
  _$FContact _$v;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _phoneNumber;
  String get phoneNumber => _$this._phoneNumber;
  set phoneNumber(String phoneNumber) => _$this._phoneNumber = phoneNumber;

  FContactBuilder();

  FContactBuilder get _$this {
    if (_$v != null) {
      _name = _$v.name;
      _phoneNumber = _$v.phoneNumber;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FContact other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FContact;
  }

  @override
  void update(void Function(FContactBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FContact build() {
    final _$result =
        _$v ?? new _$FContact._(name: name, phoneNumber: phoneNumber);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
