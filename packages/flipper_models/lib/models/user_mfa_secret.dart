import 'package:dart_mappable/dart_mappable.dart';

part 'user_mfa_secret.mapper.dart';

@MappableClass()
class UserMfaSecret with UserMfaSecretMappable {
  final String? id;
  final String userId;
  final String secret;
  final DateTime? createdAt;
  final String? issuer;
  final String? accountName;

  const UserMfaSecret({
    this.id,
    required this.userId,
    required this.secret,
    this.createdAt,
    this.issuer,
    this.accountName,
  });

  static const fromMap = UserMfaSecretMapper.fromMap;
  static const fromJson = UserMfaSecretMapper.fromJson;
}
