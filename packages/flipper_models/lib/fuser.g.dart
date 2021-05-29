// GENERATED CODE - DO NOT MODIFY BY HAND

part of flipper_models;

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<FUser> _$fUserSerializer = new _$FUserSerializer();

class _$FUserSerializer implements StructuredSerializer<FUser> {
  @override
  final Iterable<Type> types = const [FUser, _$FUser];
  @override
  final String wireName = 'FUser';

  @override
  Iterable<Object?> serialize(Serializers serializers, FUser object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object?>[
      'userId',
      serializers.serialize(object.userId,
          specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.email;
    if (value != null) {
      result
        ..add('email')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.active;
    if (value != null) {
      result
        ..add('active')
        ..add(
            serializers.serialize(value, specifiedType: const FullType(bool)));
    }
    value = object.name;
    if (value != null) {
      result
        ..add('name')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('createdAt')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updatedAt')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.token;
    if (value != null) {
      result
        ..add('token')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    value = object.permissions;
    if (value != null) {
      result
        ..add('permissions')
        ..add(serializers.serialize(value,
            specifiedType: const FullType(String)));
    }
    return result;
  }

  @override
  FUser deserialize(Serializers serializers, Iterable<Object?> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new FUserBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'email':
          result.email = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'active':
          result.active = serializers.deserialize(value,
              specifiedType: const FullType(bool)) as bool;
          break;
        case 'name':
          result.name = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'userId':
          result.userId = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'createdAt':
          result.createdAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'updatedAt':
          result.updatedAt = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'token':
          result.token = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'permissions':
          result.permissions = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$FUser extends FUser {
  @override
  final String? id;
  @override
  final String? email;
  @override
  final bool? active;
  @override
  final String? name;
  @override
  final String userId;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? token;
  @override
  final String? permissions;

  factory _$FUser([void Function(FUserBuilder)? updates]) =>
      (new FUserBuilder()..update(updates)).build();

  _$FUser._(
      {this.id,
      this.email,
      this.active,
      this.name,
      required this.userId,
      this.createdAt,
      this.updatedAt,
      this.token,
      this.permissions})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(userId, 'FUser', 'userId');
  }

  @override
  FUser rebuild(void Function(FUserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FUserBuilder toBuilder() => new FUserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FUser &&
        id == other.id &&
        email == other.email &&
        active == other.active &&
        name == other.name &&
        userId == other.userId &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        token == other.token &&
        permissions == other.permissions;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc($jc($jc(0, id.hashCode), email.hashCode),
                                active.hashCode),
                            name.hashCode),
                        userId.hashCode),
                    createdAt.hashCode),
                updatedAt.hashCode),
            token.hashCode),
        permissions.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FUser')
          ..add('id', id)
          ..add('email', email)
          ..add('active', active)
          ..add('name', name)
          ..add('userId', userId)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('token', token)
          ..add('permissions', permissions))
        .toString();
  }
}

class FUserBuilder implements Builder<FUser, FUserBuilder> {
  _$FUser? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  bool? _active;
  bool? get active => _$this._active;
  set active(bool? active) => _$this._active = active;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _token;
  String? get token => _$this._token;
  set token(String? token) => _$this._token = token;

  String? _permissions;
  String? get permissions => _$this._permissions;
  set permissions(String? permissions) => _$this._permissions = permissions;

  FUserBuilder();

  FUserBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _email = $v.email;
      _active = $v.active;
      _name = $v.name;
      _userId = $v.userId;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _token = $v.token;
      _permissions = $v.permissions;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FUser other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$FUser;
  }

  @override
  void update(void Function(FUserBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  _$FUser build() {
    final _$result = _$v ??
        new _$FUser._(
            id: id,
            email: email,
            active: active,
            name: name,
            userId: BuiltValueNullFieldError.checkNotNull(
                userId, 'FUser', 'userId'),
            createdAt: createdAt,
            updatedAt: updatedAt,
            token: token,
            permissions: permissions);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
