import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';
import '../message.dart';
import '../preview_data.dart' show PreviewData;
import '../user.dart' show User;
import 'partial_custom.dart';
import 'package:objectbox/objectbox.dart';
part 'custom_message.g.dart';

/// A class that represents custom message. Use [metadata] to store anything
/// you want.
@Entity()
@Sync()
@JsonSerializable(explicitToJson: true)
class CustomMessage extends Message {
  @Id(assignable: true)
  int id;

  final author = ToOne<User>();

  /// Creates a custom message.
  CustomMessage({
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
          type ?? MessageType.custom,
          updatedAt,
        );

  /// Creates a full custom message from a partial one.
  CustomMessage.fromPartial({
    int? createdAt,
    this.id = 0,
    required PartialCustom partialCustom,
    int? remoteId,
    int? roomId,
    Status? status,
    int? updatedAt,
  }) : super(
          createdAt,
          partialCustom.metadata,
          remoteId,
          roomId,
          status,
          MessageType.custom,
          updatedAt,
        );

  /// Creates a custom message from a map (decoded JSON).
  factory CustomMessage.fromJson(Map<String, dynamic> json) =>
      _$CustomMessageFromJson(json);

  /// Converts a custom message to the map representation,
  /// encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$CustomMessageToJson(this);

  /// Creates a copy of the custom message with an updated data.
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
    return CustomMessage(
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
