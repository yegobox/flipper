import 'package:flipper_models/isar_models.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ConversationAdapter implements types.Message {
  final Conversation conversation;

  ConversationAdapter(this.conversation);

  static types.Message fromConversation(Conversation conversation) {
    return types.TextMessage(
        id: conversation.id.toString(),
        author: types.User(
            id: conversation.fromNumber ?? "", imageUrl: conversation.avatar),
        text: conversation.body,
        createdAt:
            DateTime.parse(conversation.createdAt!).millisecondsSinceEpoch,
        roomId: conversation.fromNumber);
  }

  @override
  types.User get author => types.User(id: conversation.fromNumber ?? "");

  @override
  int? get createdAt {
    if (conversation.createdAt != null) {
      final dateTime = DateTime.parse(conversation.createdAt!);
      return dateTime.millisecondsSinceEpoch;
    }
    return null;
  }

  @override
  String get id => conversation.messageId?.toString() ?? '';

  @override
  Map<String, dynamic>? get metadata => null; // Adapt as needed

  @override
  String? get remoteId => null; // Adapt as needed

  @override
  types.Message? get repliedMessage => null; // Adapt as needed

  @override
  String? get roomId => null; // Adapt as needed

  @override
  bool? get showStatus => null; // Adapt as needed

  @override
  types.Status? get status => null; // Adapt as needed

  @override
  types.MessageType get type {
    // Adapt the conversation's messageType to MessageType
    switch (conversation.messageType) {
      case 'audio':
        return types.MessageType.audio;
      case 'custom':
        return types.MessageType.custom;
      case 'file':
        return types.MessageType.file;
      case 'image':
        return types.MessageType.image;
      case 'system':
        return types.MessageType.system;
      case 'text':
        return types.MessageType.text;
      case 'unsupported':
        return types.MessageType.unsupported;
      case 'video':
        return types.MessageType.video;
      default:
        return types.MessageType.unsupported;
    }
  }

  @override
  int? get updatedAt => null; // Adapt as needed

  @override
  types.Message copyWith({
    types.User? author,
    int? createdAt,
    String? id,
    Map<String, dynamic>? metadata,
    String? remoteId,
    types.Message? repliedMessage,
    String? roomId,
    bool? showStatus,
    types.Status? status,
    int? updatedAt,
  }) {
    // Implement if needed
    return this;
  }

  @override
  Map<String, dynamic> toJson() {
    // Implement if needed
    return {};
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();

  @override
  // TODO: implement stringify
  bool? get stringify => throw UnimplementedError();
}
