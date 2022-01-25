import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';

import 'package:objectbox/objectbox.dart';

part 'user.g.dart';

/// All possible roles user can have.
enum Role { admin, agent, moderator, user }

/// A class that represents text message.
@Entity()
@Sync()
@JsonSerializable(explicitToJson: true)
class User extends Equatable {
  /// Creates a user.
  User({
    this.createdAt,
    this.firstName,
    required this.id,
    this.imageUrl,
    this.lastName,
    this.lastSeen,
    this.metadata,
    this.role,
    this.updatedAt,
  });

  /// Creates user from a map (decoded JSON).
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Converts user to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$UserToJson(this);

  /// Creates a copy of the user with an updated data.
  /// [firstName], [imageUrl], [lastName], [lastSeen], [role] and [updatedAt]
  /// with null values will nullify existing values.
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  User copyWith({
    String? firstName,
    String? imageUrl,
    String? lastName,
    int? lastSeen,
    Map<String, dynamic>? metadata,
    Role? role,
    int? updatedAt,
  }) {
    return User(
      firstName: firstName,
      id: id,
      imageUrl: imageUrl,
      lastName: lastName,
      lastSeen: lastSeen,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      role: role,
      updatedAt: updatedAt,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
        createdAt,
        firstName,
        id,
        imageUrl,
        lastName,
        lastSeen,
        metadata,
        role,
        updatedAt
      ];

  /// Created user timestamp, in ms
  int? createdAt;

  /// First name of the user
  String? firstName;

  /// Unique ID of the user
  @Id(assignable: true)
  int id;

  /// Remote image URL representing user's avatar
  String? imageUrl;

  /// Last name of the user
  String? lastName;

  /// Timestamp when user was last visible, in ms
  int? lastSeen;

  /// Additional custom metadata or attributes related to the user
  /// will add custom converter later https://docs.objectbox.io/advanced/custom-types
  @Transient()
  Map<String, dynamic>? metadata;

  /// User [Role]
  Role? role;
  static String? fromRole(Role role) {
    if (role == Role.admin) {
      return "admin";
    } else if (role == Role.agent) {
      return "agent";
    } else if (role == Role.moderator) {
      return "moderator";
    } else if (role == Role.user) {
      return "user";
    }
    return "user";
  }

  static Role toRole(String role) {
    if (role == "admin") {
      return Role.admin;
    } else if (Role == "moderator") {
      return Role.moderator;
    } else if (Role == "user") {
      return Role.user;
    } else if (Role == "agent") {
      return Role.agent;
    }
    return Role.user;
  }

  /*
   * Converter setters and getters used for ObjectBox because the built in converters are not implemented in Dart yet
   */
  set roleOB(String? val) {
    role = val != null ? toRole(val) : null;
  }

  String? get roleOB {
    return role != null ? fromRole(role ?? Role.user) : null;
  }

  /// Updated user timestamp, in ms
  int? updatedAt;
}
