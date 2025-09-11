
class User {
  final String id;
  final String? phoneNumber;
  final String? totpSecret;

  User({
    required this.id,
    this.phoneNumber,
    this.totpSecret,
  });
}
