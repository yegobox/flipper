// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$User extends User {
  @override
  final int id;
  @override
  final String email;
  @override
  final bool active;
  @override
  final String name;
  @override
  final String status;
  @override
  final String role;
  @override
  final String permissions;
  @override
  final String createdAt;
  @override
  final String updatedAt;
  @override
  final String token;
  @override
  final String avatar;

  factory _$User([void Function(UserBuilder) updates]) =>
      (new UserBuilder()..update(updates)).build();

  _$User._(
      {this.id,
      this.email,
      this.active,
      this.name,
      this.status,
      this.role,
      this.permissions,
      this.createdAt,
      this.updatedAt,
      this.token,
      this.avatar})
      : super._() {
    if (active == null) {
      throw new BuiltValueNullFieldError('User', 'active');
    }
    if (name == null) {
      throw new BuiltValueNullFieldError('User', 'name');
    }
    if (role == null) {
      throw new BuiltValueNullFieldError('User', 'role');
    }
    if (permissions == null) {
      throw new BuiltValueNullFieldError('User', 'permissions');
    }
    if (createdAt == null) {
      throw new BuiltValueNullFieldError('User', 'createdAt');
    }
    if (updatedAt == null) {
      throw new BuiltValueNullFieldError('User', 'updatedAt');
    }
  }

  @override
  User rebuild(void Function(UserBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserBuilder toBuilder() => new UserBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
        id == other.id &&
        email == other.email &&
        active == other.active &&
        name == other.name &&
        status == other.status &&
        role == other.role &&
        permissions == other.permissions &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        token == other.token &&
        avatar == other.avatar;
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
                                        $jc($jc(0, id.hashCode),
                                            email.hashCode),
                                        active.hashCode),
                                    name.hashCode),
                                status.hashCode),
                            role.hashCode),
                        permissions.hashCode),
                    createdAt.hashCode),
                updatedAt.hashCode),
            token.hashCode),
        avatar.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('User')
          ..add('id', id)
          ..add('email', email)
          ..add('active', active)
          ..add('name', name)
          ..add('status', status)
          ..add('role', role)
          ..add('permissions', permissions)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('token', token)
          ..add('avatar', avatar))
        .toString();
  }
}

class UserBuilder implements Builder<User, UserBuilder> {
  _$User _$v;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _email;
  String get email => _$this._email;
  set email(String email) => _$this._email = email;

  bool _active;
  bool get active => _$this._active;
  set active(bool active) => _$this._active = active;

  String _name;
  String get name => _$this._name;
  set name(String name) => _$this._name = name;

  String _status;
  String get status => _$this._status;
  set status(String status) => _$this._status = status;

  String _role;
  String get role => _$this._role;
  set role(String role) => _$this._role = role;

  String _permissions;
  String get permissions => _$this._permissions;
  set permissions(String permissions) => _$this._permissions = permissions;

  String _createdAt;
  String get createdAt => _$this._createdAt;
  set createdAt(String createdAt) => _$this._createdAt = createdAt;

  String _updatedAt;
  String get updatedAt => _$this._updatedAt;
  set updatedAt(String updatedAt) => _$this._updatedAt = updatedAt;

  String _token;
  String get token => _$this._token;
  set token(String token) => _$this._token = token;

  String _avatar;
  String get avatar => _$this._avatar;
  set avatar(String avatar) => _$this._avatar = avatar;

  UserBuilder();

  UserBuilder get _$this {
    if (_$v != null) {
      _id = _$v.id;
      _email = _$v.email;
      _active = _$v.active;
      _name = _$v.name;
      _status = _$v.status;
      _role = _$v.role;
      _permissions = _$v.permissions;
      _createdAt = _$v.createdAt;
      _updatedAt = _$v.updatedAt;
      _token = _$v.token;
      _avatar = _$v.avatar;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(User other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$User;
  }

  @override
  void update(void Function(UserBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$User build() {
    final _$result = _$v ??
        new _$User._(
            id: id,
            email: email,
            active: active,
            name: name,
            status: status,
            role: role,
            permissions: permissions,
            createdAt: createdAt,
            updatedAt: updatedAt,
            token: token,
            avatar: avatar);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
