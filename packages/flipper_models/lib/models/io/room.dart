import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';
import 'message.dart';
import 'user.dart';
import 'package:objectbox/objectbox.dart';
part 'room.g.dart';

/// All possible room types
enum RoomType { channel, direct, group }

/// A class that represents a room where 2 or more participants can chat
@Entity()
@Sync()
@JsonSerializable(explicitToJson: true)
class Room extends Equatable {
  /// Creates a [Room]
  Room({
    this.createdAt,
    this.id = 0,
    this.imageUrl,
    this.lastMessages,
    this.metadata,
    this.name,
    // required this.type,
    this.updatedAt,
  });

  /// Creates room from a map (decoded JSON).
  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => _$RoomToJson(this);

  /// Creates a copy of the room with an updated data.
  /// [imageUrl], [name] and [updatedAt] with null values will nullify existing values
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [type] and [users] with null values will be overwritten by previous values.
  Room copyWith({
    String? imageUrl,
    Map<String, dynamic>? metadata,
    String? name,
    // RoomType? type,
    int? updatedAt,
  }) {
    return Room(
      id: id,
      imageUrl: imageUrl,
      lastMessages: lastMessages,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      name: name,
      // type: type ?? this.type,
      updatedAt: updatedAt,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
        createdAt,
        id,
        imageUrl,
        lastMessages,
        metadata,
        name,
        type,
        updatedAt,
        users
      ];

  /// Created room timestamp, in ms
  int? createdAt;

  /// Room's unique ID
  @Id(assignable: true)
  int id;

  /// Room's image. In case of the [RoomType.direct] - avatar of the second person,
  /// otherwise a custom image [RoomType.group].
  String? imageUrl;

  /// List of last messages this room has received
  List<Message>? lastMessages;

  /// Additional custom metadata or attributes related to the room
  Map<String, dynamic>? metadata;

  /// Room's name. In case of the [RoomType.direct] - name of the second person,
  /// otherwise a custom name [RoomType.group].
  String? name;

  /// [RoomType]
  RoomType? type;

  static String? fromRoomType(RoomType roomType) {
    if (roomType == RoomType.channel) {
      return "channnel";
    } else if (roomType == RoomType.direct) {
      return "direct";
    } else if (roomType == RoomType.group) {
      return "group";
    }

    return "direct";
  }

  static RoomType toRoomType(String roomType) {
    if (roomType == "direct") {
      return RoomType.direct;
    } else if (roomType == "channel") {
      return RoomType.channel;
    } else if (roomType == "group") {
      return RoomType.group;
    }
    return RoomType.direct;
  }

  /*
   * Converter setters and getters used for ObjectBox because the built in converters are not implemented in Dart yet
   */
  set roleOB(String? val) {
    type = val != null ? toRoomType(val) : null;
  }

  String? get roleOB {
    return type != null ? fromRoomType(type ?? RoomType.direct) : null;
  }

  /// Updated room timestamp, in ms
  int? updatedAt;

  /// List of users which are in the room
  // List<User> users;
  final users = ToMany<User>();
}
