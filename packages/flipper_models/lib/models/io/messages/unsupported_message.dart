import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import '../message.dart';
import '../preview_data.dart' show PreviewData;
import '../user.dart' show User;
import 'package:objectbox/objectbox.dart';
part 'unsupported_message.g.dart';

/// A class that represents unsupported message. Used for backwards
/// compatibility. If chat's end user doesn't update to a new version
/// where new message types are being sent, some of them will result
/// to unsupported.
@Entity()
@Sync()
@JsonSerializable(explicitToJson: true)
class UnsupportedMessage extends Message {
  @Id(assignable: true)
  int id;

  final author = ToOne<User>();

  /// Creates an unsupported message.
  UnsupportedMessage({
    int? createdAt,
    this.id = 0,
    Map<String, dynamic>? metadata,
    int? remoteId,
    int? roomId,
    Status? status,
    MessageType? type,
    int? updatedAt,
  }) : super(
          createdAt,
          metadata,
          remoteId,
          roomId,
          status,
          type ?? MessageType.unsupported,
          updatedAt,
        );

  /// Creates an unsupported message from a map (decoded JSON).
  factory UnsupportedMessage.fromJson(Map<String, dynamic> json) =>
      _$UnsupportedMessageFromJson(json);

  /// Converts an unsupported message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$UnsupportedMessageToJson(this);

  /// Creates a copy of the unsupported message with an updated data.
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [previewData] is ignored for this message type.
  /// [remoteId] and [updatedAt] with null values will nullify existing value.
  /// [status] with null value will be overwritten by the previous status.
  /// [text] is ignored for this message type.
  /// [uri] is ignored for this message type.
  @override
  Message copyWith({
    Map<String, dynamic>? metadata,
    PreviewData? previewData,
    int? remoteId,
    Status? status,
    String? text,
    int? updatedAt,
    String? uri,
  }) {
    return UnsupportedMessage(
      createdAt: createdAt,
      id: id,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      remoteId: remoteId,
      roomId: roomId,
      status: status ?? this.status,
      updatedAt: updatedAt,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
        createdAt,
        id,
        metadata,
        remoteId,
        roomId,
        status,
        updatedAt,
      ];
}
