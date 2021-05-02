/// Information about a user who is subscribing to a presence channel.
class User {
  /// A unique user identifier for the user witin the application.
  /// Pusher uses this to uniquely identify a user. So, if multiple users are given the same [id]
  /// the second of these users will be ignored and won't be represented on the presence channel.
  final String id;

  /// Arbitrary additional information about the user.
  final Map<String, dynamic>? info;

  User(this.id, [this.info]);

  Map toMap() {
    Map map = new Map();
    map['user_id'] = this.id;
    if (this.info != null) {
      map['user_info'] = this.info;
    }
    return map;
  }
}
