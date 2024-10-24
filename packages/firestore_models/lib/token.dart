import 'package:freezed_annotation/freezed_annotation.dart';

part 'token.freezed.dart';
part 'token.g.dart';

@freezed
class Token with _$Token {
  const factory Token({
    int? id,
    String? type,
    String? token,
    DateTime? validFrom,
    DateTime? validUntil,
    int? businessId,
    DateTime? lastTouched,
    DateTime? deletedAt,
  }) = _Token;

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);
}
