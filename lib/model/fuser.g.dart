// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fuser.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$FUser extends FUser {
  @override
  final String id;
  @override
  final String email;
  @override
  final bool active;
  @override
  final String name;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String token;

  factory _$FUser([void Function(FUserBuilder) updates]) =>
      (new FUserBuilder()..update(updates)).build();

  _$FUser._(
      {this.id,
      this.email,
      this.active,
      this.name,
      this.createdAt,
      this.updatedAt,
      this.token})
      : super._() {
    if (active == null) {
      throw new BuiltValueNullFieldError('FUser', 'active');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('FUser', 'name');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('FUser', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('FUser', 'updatedAt');
    }
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
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        token == other.token;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc($jc($jc(0, id.hashCode), email.hashCode),
                        active.hashCode),
                    name.hashCode),
                createdAt.hashCode),
            updatedAt.hashCode),
        token.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('FUser')
          ..add('id', id)
          ..add('email', email)
          ..add('active', active)
          ..add('name', name)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('token', token))
        .toString();
  }
}

class FUserBuilder implements Builder<FUser, FUserBuilder> {
  _$FUser _$v;

  String _id;
  String get id => _$this._id;
  set id(String id) => _$this._id = id;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  bool _active;
  bool get active => _$this._active;
  set active(bool active) => _$this._active = active;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  String _token;
  String get token => _$this._token;
  set token(String token) => _$this._token = token;

  FUserBuilder();

  FUserBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _email = _$v.email;
      _active = _$v.active;
      _name = _$v.name;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _token = _$v.token;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FUser other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$FUser;
  }

  @override
  void update(void Function(FUserBuilder) updates) {
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
            createdAt: createdAt,
            updatedAt: updatedAt,
            token: token);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
