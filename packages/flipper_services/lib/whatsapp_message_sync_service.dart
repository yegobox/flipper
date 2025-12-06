import 'dart:async';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/message.model.dart';
import 'package:supabase_models/brick/models/conversation.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// abstract facade for testing
abstract class DittoObserverRunner {
  Future<void> registerSubscription(
    String query, {
    Map<String, dynamic>? arguments,
  });

  dynamic registerObserver(
    String query, {
    Map<String, dynamic>? arguments,
    required Function(dynamic) onChange,
  });
}

class RealDittoObserverRunner implements DittoObserverRunner {
  final DittoService _service;
  RealDittoObserverRunner(this._service);

  @override
  Future<void> registerSubscription(
    String query, {
    Map<String, dynamic>? arguments,
  }) async {
    final ditto = _service.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized');
    }
    await ditto.sync.registerSubscription(query, arguments: arguments ?? {});
  }

  @override
  dynamic registerObserver(
    String query, {
    Map<String, dynamic>? arguments,
    required Function(dynamic) onChange,
  }) {
    final store = _service.store;
    if (store == null) {
      throw Exception('Ditto not initialized');
    }
    return store.registerObserver(
      query,
      arguments: arguments!,
      onChange: (result) => onChange(result),
    );
  }
}

/// Service to sync WhatsApp messages from Ditto to local Message model
class WhatsAppMessageSyncService {
  final DittoObserverRunner _runner;
  dynamic _observer;
  StreamController<WhatsAppSyncState>? _stateController;

  WhatsAppMessageSyncService({
    DittoService? dittoService,
    DittoObserverRunner? runner,
  }) : _runner = runner ??
            RealDittoObserverRunner(dittoService ?? DittoService.instance);

  Stream<WhatsAppSyncState> get stateStream {
    _stateController ??= StreamController<WhatsAppSyncState>.broadcast();
    return _stateController!.stream;
  }

  /// Initialize the sync service with the business's phoneNumberId
  Future<void> initialize(String phoneNumberId) async {
    try {
      // Ensure the state controller is initialized
      _stateController ??= StreamController<WhatsAppSyncState>.broadcast();
      _stateController?.add(WhatsAppSyncState.syncing());

      // Query for WhatsApp messages matching this business's phoneNumberId
      final query =
          'SELECT * FROM whatsapp_messages WHERE phoneNumberId = :phoneNumberId';
      final arguments = {'phoneNumberId': phoneNumberId};

      // Register subscription to ensure we receive updates from other devices/cloud
      await _runner.registerSubscription(query, arguments: arguments);

      // Register observer to listen for changes
      _observer = _runner.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) {
          _handleWhatsAppMessages(queryResult.items.toList());
        },
      );

      _stateController?.add(WhatsAppSyncState.idle());
    } catch (e) {
      _stateController?.add(WhatsAppSyncState.error(e.toString()));
      rethrow;
    }
  }

  /// Handle incoming WhatsApp messages from Ditto
  Future<void> _handleWhatsAppMessages(List<dynamic> items) async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return;

      for (final item in items) {
        final doc = Map<String, dynamic>.from(item.value);
        await _transformAndSaveMessage(doc, branchId);
      }
    } catch (e) {
      _stateController?.add(WhatsAppSyncState.error(e.toString()));
    }
  }

  /// Transform Ditto WhatsApp message to Message model and save
  Future<void> _transformAndSaveMessage(
    Map<String, dynamic> doc,
    int branchId,
  ) async {
    try {
      // Extract fields from Ditto document
      final messageId = doc['messageId']?.toString() ?? '';
      final messageBody =
          doc['messageBody']?.toString() ?? doc['caption']?.toString() ?? '';
      final from = doc['from']?.toString() ?? '';
      final waId = doc['waId']?.toString() ?? '';
      final contactName = doc['contactName']?.toString();
      final phoneNumberId = doc['phoneNumberId']?.toString() ?? '';
      final messageType = doc['messageType']?.toString() ?? 'text';
      final timestampStr = doc['timestamp']?.toString() ?? '';

      // Only process text messages for now
      if (messageType != 'text' || messageBody.isEmpty) {
        return;
      }

      // Parse timestamp
      DateTime? timestamp;
      try {
        timestamp = DateTime.parse(timestampStr);
      } catch (e) {
        timestamp = DateTime.now();
      }

      // Find or create conversation for this WhatsApp contact
      final conversationId = await _getOrCreateConversation(
        waId: waId,
        contactName: contactName ?? from,
        branchId: branchId,
      );

      // Check if message already exists to avoid duplicates
      final repository = Repository();
      final existingMessages = await repository.get<Message>(
        query: Query(
          where: [Where('whatsappMessageId').isExactly(messageId)],
        ),
      );

      if (existingMessages.isNotEmpty) {
        return; // Skip duplicate
      }

      // Create and save Message with WhatsApp-specific fields
      final message = Message(
        text: messageBody,
        phoneNumber: from,
        branchId: branchId,
        delivered: true,
        role: 'user',
        conversationId: conversationId,
        timestamp: timestamp,
        messageType: messageType,
        messageSource: 'whatsapp',
        whatsappMessageId: messageId,
        whatsappPhoneNumberId: phoneNumberId,
        contactName: contactName,
        waId: waId,
      );

      await repository.upsert<Message>(message);
    } catch (e) {
      // Log error but don't stop processing other messages
      print('Error transforming WhatsApp message: $e');
    }
  }

  /// Get or create a conversation for a WhatsApp contact
  Future<String> _getOrCreateConversation({
    required String waId,
    required String contactName,
    required int branchId,
  }) async {
    final repository = Repository();

    // Try to find existing conversation for this WhatsApp contact
    // We'll use the conversation title to identify WhatsApp conversations
    final conversations = await repository.get<Conversation>(
      query: Query(
        where: [
          Where('branchId').isExactly(branchId),
          Where('title').contains('WhatsApp: $contactName'),
        ],
      ),
    );

    if (conversations.isNotEmpty) {
      return conversations.first.id;
    }

    // Create new conversation for this contact
    final conversation = Conversation(
      title: 'WhatsApp: $contactName',
      branchId: branchId,
    );

    await repository.upsert<Conversation>(conversation);
    return conversation.id;
  }

  /// Dispose and clean up resources
  Future<void> dispose() async {
    await _observer?.cancel();
    _stateController?.close();
  }
}

/// State for WhatsApp sync service
class WhatsAppSyncState {
  final WhatsAppSyncStatus status;
  final String? errorMessage;

  WhatsAppSyncState._(this.status, this.errorMessage);

  factory WhatsAppSyncState.idle() =>
      WhatsAppSyncState._(WhatsAppSyncStatus.idle, null);

  factory WhatsAppSyncState.syncing() =>
      WhatsAppSyncState._(WhatsAppSyncStatus.syncing, null);

  factory WhatsAppSyncState.error(String message) =>
      WhatsAppSyncState._(WhatsAppSyncStatus.error, message);
}

enum WhatsAppSyncStatus {
  idle,
  syncing,
  error,
}
