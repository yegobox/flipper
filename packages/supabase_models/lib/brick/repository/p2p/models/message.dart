// lib/src/models/message.dart
import 'dart:convert';

/// Types of messages that can be sent
enum MessageType {
  text,
  binary,
  syncData,
  control,
}

/// Represents a message sent between peers
class P2PMessage {
  /// Unique identifier for this message
  final String id;

  /// ID of the sender
  final String senderId;

  /// ID of the receiver (can be null for broadcast)
  final String? receiverId;

  /// Content of the message
  final String content;

  /// When the message was sent
  final DateTime timestamp;

  /// Type of message
  final MessageType type;

  /// Optional metadata
  final Map<String, dynamic>? metadata;

  P2PMessage({
    required this.id,
    required this.senderId,
    this.receiverId,
    required this.content,
    required this.timestamp,
    this.type = MessageType.text,
    this.metadata,
  });

  /// Create a message from JSON
  factory P2PMessage.fromJson(Map<String, dynamic> json) {
    return P2PMessage(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      type: MessageType.values[json['type'] ?? 0],
      metadata: json['metadata'],
    );
  }

  /// Convert message to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'type': type.index,
      'metadata': metadata,
    };
  }

  /// Serialize the message to a string
  String serialize() {
    return json.encode(toJson());
  }

  /// Deserialize a message from a string
  static P2PMessage deserialize(String data) {
    return P2PMessage.fromJson(json.decode(data));
  }
}
