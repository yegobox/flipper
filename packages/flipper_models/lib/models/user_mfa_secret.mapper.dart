// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_mfa_secret.dart';

class UserMfaSecretMapper extends ClassMapperBase<UserMfaSecret> {
  UserMfaSecretMapper._();

  static UserMfaSecretMapper? _instance;
  static UserMfaSecretMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserMfaSecretMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserMfaSecret';

  static String? _$id(UserMfaSecret v) => v.id;
  static const Field<UserMfaSecret, String> _f$id =
      Field('id', _$id, opt: true);
  static int _$userId(UserMfaSecret v) => v.userId;
  static const Field<UserMfaSecret, int> _f$userId =
      Field('userId', _$userId, key: r'user_id');
  static String _$secret(UserMfaSecret v) => v.secret;
  static const Field<UserMfaSecret, String> _f$secret =
      Field('secret', _$secret);
  static DateTime? _$createdAt(UserMfaSecret v) => v.createdAt;
  static const Field<UserMfaSecret, DateTime> _f$createdAt =
      Field('createdAt', _$createdAt, key: r'created_at', opt: true);
  static String? _$issuer(UserMfaSecret v) => v.issuer;
  static const Field<UserMfaSecret, String> _f$issuer =
      Field('issuer', _$issuer, opt: true);
  static String? _$accountName(UserMfaSecret v) => v.accountName;
  static const Field<UserMfaSecret, String> _f$accountName =
      Field('accountName', _$accountName, key: r'account_name', opt: true);

  @override
  final MappableFields<UserMfaSecret> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #secret: _f$secret,
    #createdAt: _f$createdAt,
    #issuer: _f$issuer,
    #accountName: _f$accountName,
  };

  static UserMfaSecret _instantiate(DecodingData data) {
    return UserMfaSecret(
        id: data.dec(_f$id),
        userId: data.dec(_f$userId),
        secret: data.dec(_f$secret),
        createdAt: data.dec(_f$createdAt),
        issuer: data.dec(_f$issuer),
        accountName: data.dec(_f$accountName));
  }

  @override
  final Function instantiate = _instantiate;

  static UserMfaSecret fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserMfaSecret>(map);
  }

  static UserMfaSecret fromJson(String json) {
    return ensureInitialized().decodeJson<UserMfaSecret>(json);
  }
}

mixin UserMfaSecretMappable {
  String toJson() {
    return UserMfaSecretMapper.ensureInitialized()
        .encodeJson<UserMfaSecret>(this as UserMfaSecret);
  }

  Map<String, dynamic> toMap() {
    return UserMfaSecretMapper.ensureInitialized()
        .encodeMap<UserMfaSecret>(this as UserMfaSecret);
  }

  UserMfaSecretCopyWith<UserMfaSecret, UserMfaSecret, UserMfaSecret>
      get copyWith => _UserMfaSecretCopyWithImpl<UserMfaSecret, UserMfaSecret>(
          this as UserMfaSecret, $identity, $identity);
  @override
  String toString() {
    return UserMfaSecretMapper.ensureInitialized()
        .stringifyValue(this as UserMfaSecret);
  }

  @override
  bool operator ==(Object other) {
    return UserMfaSecretMapper.ensureInitialized()
        .equalsValue(this as UserMfaSecret, other);
  }

  @override
  int get hashCode {
    return UserMfaSecretMapper.ensureInitialized()
        .hashValue(this as UserMfaSecret);
  }
}

extension UserMfaSecretValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserMfaSecret, $Out> {
  UserMfaSecretCopyWith<$R, UserMfaSecret, $Out> get $asUserMfaSecret =>
      $base.as((v, t, t2) => _UserMfaSecretCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserMfaSecretCopyWith<$R, $In extends UserMfaSecret, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      int? userId,
      String? secret,
      DateTime? createdAt,
      String? issuer,
      String? accountName});
  UserMfaSecretCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserMfaSecretCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserMfaSecret, $Out>
    implements UserMfaSecretCopyWith<$R, UserMfaSecret, $Out> {
  _UserMfaSecretCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserMfaSecret> $mapper =
      UserMfaSecretMapper.ensureInitialized();
  @override
  $R call(
          {Object? id = $none,
          int? userId,
          String? secret,
          Object? createdAt = $none,
          Object? issuer = $none,
          Object? accountName = $none}) =>
      $apply(FieldCopyWithData({
        if (id != $none) #id: id,
        if (userId != null) #userId: userId,
        if (secret != null) #secret: secret,
        if (createdAt != $none) #createdAt: createdAt,
        if (issuer != $none) #issuer: issuer,
        if (accountName != $none) #accountName: accountName
      }));
  @override
  UserMfaSecret $make(CopyWithData data) => UserMfaSecret(
      id: data.get(#id, or: $value.id),
      userId: data.get(#userId, or: $value.userId),
      secret: data.get(#secret, or: $value.secret),
      createdAt: data.get(#createdAt, or: $value.createdAt),
      issuer: data.get(#issuer, or: $value.issuer),
      accountName: data.get(#accountName, or: $value.accountName));

  @override
  UserMfaSecretCopyWith<$R2, UserMfaSecret, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserMfaSecretCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
