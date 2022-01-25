import 'package:objectbox/objectbox.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'messages/custom_message.dart';
import 'messages/file_message.dart';
import 'messages/image_message.dart';
import 'messages/text_message.dart';
import 'messages/unsupported_message.dart';

import 'preview_data.dart' show PreviewData;
import 'user.dart' show User;

/// All possible message types.
enum MessageType { custom, file, image, text, unsupported }

/// All possible statuses message can have.
enum Status { delivered, error, seen, sending, sent }

/// An abstract class that contains all variables and methods
/// every message will have.
@immutable
abstract class Message extends Equatable {
  Message(
    // this.author,
    this.createdAt,
    this.metadata,
    this.remoteId,
    this.roomId,
    this.status,
    this.type,
    this.updatedAt,
  );

  /// Creates a particular message from a map (decoded JSON).
  /// Type is determined by the `type` field.
  factory Message.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    switch (type) {
      case 'custom':
        return CustomMessage.fromJson(json);
      case 'file':
        return FileMessage.fromJson(json);
      case 'image':
      // return ImageMessage.fromJson(json);
      case 'text':
        return TextMessage.fromJson(json);
      default:
        return UnsupportedMessage.fromJson(json);
    }
  }

  /// Creates a copy of the message with an updated data
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [previewData] will be only set for the text message type.
  /// [status] with null value will be overwritten by the previous status.
  /// [text] will be only set for the text message type. Null value will be
  /// overwritten by the previous text (can't be empty).
  /// [remoteId] and [updatedAt] with null values will nullify existing value.
  /// [uri] will be only set for file and image message types. Null value
  /// will be overwritten by the previous value (uri can't be empty).
  Message copyWith({
    Map<String, dynamic>? metadata,
    // PreviewData? previewData,
    int? remoteId,
    Status? status,
    String? text,
    int? updatedAt,
    String? uri,
  });

  /// Converts a particular message to the map representation, encodable to JSON.
  @Transient()
  Map<String, dynamic> toJson();

  /// User who sent this message
  // User author;

  /// Created message timestamp, in ms
  int? createdAt;

  /// Unique ID of the message

  /// Additional custom metadata or attributes related to the message
  @Transient()
  Map<String, dynamic>? metadata;

  /// Unique ID of the message received from the backend
  int? remoteId;

  /// ID of the room where this message is sent
  int? roomId;

  /// Message [Status]
  Status? status;
  static String? fromStatus(Status status) {
    if (status == Status.seen) {
      return "seen";
    } else if (status == Status.delivered) {
      return "delivered";
    } else if (status == Status.error) {
      return "error";
    } else if (status == Status.sending) {
      return "sending";
    } else if (status == Status.sent) {
      return "sent";
    }

    return "sent";
  }

  static Status toStatus(String status) {
    if (status == "seen") {
      return Status.seen;
    } else if (Status == "sent") {
      return Status.sent;
    } else if (status == "sending") {
      return Status.sending;
    } else if (status == "error") {
      return Status.error;
    }
    return Status.sent;
  }

  /*
   * Converter setters and getters used for ObjectBox because the built in converters are not implemented in Dart yet
   */
  set roleOB(String? val) {
    status = val != null ? toStatus(val) : null;
  }

  String? get roleOB {
    return status != null ? fromStatus(status ?? Status.sent) : null;
  }

  /// [MessageType]
  MessageType type;

  static String? fromMessageType(MessageType status) {
    if (status == MessageType.custom) {
      return "custom";
    } else if (status == MessageType.file) {
      return "file";
    } else if (status == MessageType.image) {
      return "image";
    } else if (status == MessageType.text) {
      return "text";
    } else if (status == MessageType.unsupported) {
      return "unsupported";
    }

    return "text";
  }

  static MessageType toMessageType(String type) {
    if (type == "text") {
      return MessageType.text;
    } else if (type == "custom") {
      return MessageType.custom;
    } else if (type == "file") {
      return MessageType.file;
    } else if (type == "unsupported") {
      return MessageType.unsupported;
    }
    return MessageType.text;
  }

  /*
   * Converter setters and getters used for ObjectBox because the built in converters are not implemented in Dart yet
   */
  set typeOB(String? val) {
    type = toMessageType(val!);
  }

  String? get typeOB {
    return fromMessageType(type) ?? null;
  }

  /// Updated message timestamp, in ms
  int? updatedAt;
}
