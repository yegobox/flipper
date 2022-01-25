import 'package:objectbox/objectbox.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';
import '../message.dart';
import '../preview_data.dart' show PreviewData;
import '../user.dart' show User;
import 'partial_image.dart';

part 'image_message.g.dart';

/// A class that represents text message.
@Entity()
@Sync()
@JsonSerializable(explicitToJson: true)
class ImageMessage extends Message {
  /// Creates an image message.
  @Id(assignable: true)
  int id;

  final author = ToOne<User>();

  ImageMessage({
    int? createdAt,
    this.height,
    this.id = 0,
    Map<String, dynamic>? metadata,
    required this.name,
    int? remoteId,
    int? roomId,
    required this.size,
    Status? status,
    MessageType? type,
    int? updatedAt,
    required this.uri,
    this.width,
  }) : super(
          createdAt,
          metadata,
          remoteId,
          roomId,
          status,
          type ?? MessageType.image,
          updatedAt,
        );

  /// Creates a full image message from a partial one.
  ImageMessage.fromPartial({
    int? createdAt,
    required PartialImage partialImage,
    int? remoteId,
    int? roomId,
    Status? status,
    this.id = 0,
    int? updatedAt,
  })  : height = partialImage.height,
        name = partialImage.name,
        size = partialImage.size,
        uri = partialImage.uri,
        width = partialImage.width,
        super(
          createdAt,
          partialImage.metadata,
          remoteId,
          roomId,
          status,
          MessageType.image,
          updatedAt,
        );

  /// Creates an image message from a map (decoded JSON).
  factory ImageMessage.fromJson(Map<String, dynamic> json) =>
      _$ImageMessageFromJson(json);

  /// Converts an image message to the map representation, encodable to JSON.
  @override
  Map<String, dynamic> toJson() => _$ImageMessageToJson(this);

  /// Creates a copy of the image message with an updated data
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [previewData] is ignored for this message type.
  /// [remoteId] and [updatedAt] with null values will nullify existing value.
  /// [status] and [uri] with null values will be overwritten by previous values.
  /// [text] is ignored for this message type.
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
    return ImageMessage(
      createdAt: createdAt,
      height: height,
      id: id,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      name: name,
      remoteId: remoteId,
      roomId: roomId,
      size: size,
      status: status ?? this.status,
      updatedAt: updatedAt,
      uri: uri ?? this.uri,
      width: width,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props => [
        createdAt,
        height,
        id,
        metadata,
        name,
        remoteId,
        roomId,
        size,
        status,
        updatedAt,
        uri,
        width,
      ];

  /// Image height in pixels
  double? height;

  /// The name of the image
  String name;

  /// Size of the image in bytes
  int size; // was num before!

  /// The image source (either a remote URL or a local resource)
  String uri;

  /// Image width in pixels
  double? width;
}
