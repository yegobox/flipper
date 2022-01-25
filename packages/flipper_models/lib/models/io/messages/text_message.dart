import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';
import '../message.dart';
import '../preview_data.dart' show PreviewData;
import '../user.dart' show User;
import 'partial_text.dart';

part 'text_message.g.dart';

/// A class that represents text message.
@Entity()
@Sync()
@JsonSerializable(explicitToJson: true)
class TextMessage extends Message {
  /// Creates a text message.
  TextMessage({
    int? createdAt,
    this.id = 0,
    Map<String, dynamic>? metadata,
    this.previewData,
    int? remoteId,
    int? roomId,
    Status? status,
    required this.text,
    MessageType? type,
    int? updatedAt,
  }) : super(
          createdAt,
          metadata,
          remoteId,
          roomId,
          status,
          type ?? MessageType.text,
          updatedAt,
        );

  /// Creates a full text message from a partial one.
  TextMessage.fromPartial({
    int? createdAt,
    this.id = 0,
    required PartialText partialText,
    int? remoteId,
    int? roomId,
    Status? status,
    int? updatedAt,
  })  : previewData = partialText.previewData,
        text = partialText.text,
        super(
          createdAt,
          partialText.metadata,
          remoteId,
          roomId,
          status,
          MessageType.text,
          updatedAt,
        );

  /// Creates a text message from a map (decoded JSON).
  factory TextMessage.fromJson(Map<String, dynamic> json) =>
      _$TextMessageFromJson(json);

  /// Converts a text message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$TextMessageToJson(this);

  /// Creates a copy of the text message with an updated data
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [remoteId] and [updatedAt] with null values will nullify existing value.
  /// [status] and [text] with null values will be overwritten by previous values.
  /// [uri] is ignored for this message type.
  @override
  Message copyWith({
    Map<String, dynamic>? metadata,
    // PreviewData? previewData,
    int? remoteId,
    Status? status,
    String? text,
    int? updatedAt,
    String? uri,
  }) {
    return TextMessage(
      createdAt: createdAt,
      id: id,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      // previewData: previewData,
      remoteId: remoteId,
      roomId: roomId,
      status: status ?? this.status,
      text: text ?? this.text,
      updatedAt: updatedAt,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
        createdAt,
        id,
        metadata,
        previewData,
        remoteId,
        roomId,
        status,
        text,
        updatedAt,
      ];

  /// See [PreviewData]
  PreviewData? previewData;
  @Id(assignable: true)
  int id;

  final author = ToOne<User>();

  /// User's message
  String text;
}
