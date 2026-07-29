import 'dart:async';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
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
      throw Exception('Ditto not initialized:20');
    }
    final preparedWa = prepareDqlSyncSubscription(query, arguments);
    await ditto.sync.registerSubscription(
      preparedWa.dql,
      arguments: preparedWa.arguments,
    );
  }

  @override
  dynamic registerObserver(
    String query, {
    Map<String, dynamic>? arguments,
    required Function(dynamic) onChange,
  }) {
    final store = _service.store;
    if (store == null) {
      throw Exception('Ditto not initialized:21');
    }
    return store.registerObserver(
      query,
      arguments: arguments ?? {},
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

  bool _isProcessing = false; // Flag to prevent concurrent processing

  Stream<WhatsAppSyncState> get stateStream {
    _stateController ??= StreamController<WhatsAppSyncState>.broadcast();
    return _stateController!.stream;
  }

  /// Initialize the sync service with the business's phoneNumberId
  Future<void> initialize(String phoneNumberId) async {
    try {
      // Clean up any existing observer to prevent duplicate observers
      if (_observer != null) {
        await _observer.cancel();
        _observer = null;
      }

      // Ensure the state controller is initialized
      _stateController ??= StreamController<WhatsAppSyncState>.broadcast();
      _stateController?.add(WhatsAppSyncState.syncing());

      // Query for WhatsApp messages — Capella sync is unfiltered; Brick mirror
      // still scopes by phoneNumberId in the observer transform path.
      const syncQuery = 'SELECT * FROM whatsapp_messages';
      final query =
          'SELECT * FROM whatsapp_messages WHERE phoneNumberId = :phoneNumberId';
      final arguments = {'phoneNumberId': phoneNumberId};

      // Broad Capella subscription so inbound from data-connector replicates.
      await _runner.registerSubscription(syncQuery);

      // Observer stays phone-scoped for Brick upserts.
      _observer = _runner.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) async {
          // Wait if there's a current processing in progress to prevent concurrent execution
          while (_isProcessing) {
            await Future.delayed(const Duration(
                milliseconds: 50)); // Small delay to prevent tight loop
          }

          _isProcessing = true;
          try {
            await _handleWhatsAppMessages(queryResult.items.toList());
          } catch (e) {
            // Log error and surface it via the state stream
            print('Error processing WhatsApp messages: $e');
            _stateController?.add(WhatsAppSyncState.error(e.toString()));
          } finally {
            _isProcessing = false;
          }
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
    String branchId,
  ) async {
    try {
      final messageId = doc['messageId']?.toString() ??
          doc['_id']?.toString() ??
          doc['id']?.toString() ??
          '';
      final messageBody =
          doc['messageBody']?.toString() ?? doc['caption']?.toString() ?? '';
      final from = doc['from']?.toString() ?? '';
      final waId = doc['waId']?.toString() ?? from;
      final contactName = doc['contactName']?.toString();
      final phoneNumberId = doc['phoneNumberId']?.toString() ?? '';
      final messageType = doc['messageType']?.toString() ?? 'text';
      final timestampRaw = doc['createdAt']?.toString() ??
          doc['timestamp']?.toString() ??
          '';

      // Skip empty non-media stubs; allow captioned media.
      if (messageBody.isEmpty &&
          messageType != 'image' &&
          messageType != 'document' &&
          messageType != 'audio' &&
          messageType != 'video') {
        return;
      }

      final displayText = messageBody.isNotEmpty
          ? messageBody
          : '[${messageType.isEmpty ? 'attachment' : messageType}]';

      final timestamp = _parseWhatsAppTimestamp(timestampRaw);

      final conversationId = await _getOrCreateConversation(
        waId: waId.isNotEmpty ? waId : from,
        contactName: contactName ?? (from.isNotEmpty ? from : 'Customer'),
        branchId: branchId,
      );

      final repository = Repository();
      if (messageId.isNotEmpty) {
        final existingMessages = await repository.get<Message>(
          query: Query(
            where: [
              Where('whatsappMessageId').isExactly(messageId),
              Where('branchId').isExactly(branchId),
            ],
          ),
        );

        if (existingMessages.isNotEmpty) {
          return;
        }
      }

      // Inbound customer message → role `user` (shown on the left in the inbox).
      final message = Message(
        text: displayText,
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

      // Bump conversation ordering.
      final conversations = await repository.get<Conversation>(
        query: Query(where: [Where('id').isExactly(conversationId)]),
      );
      if (conversations.isNotEmpty) {
        final c = conversations.first;
        c.lastMessageAt = timestamp;
        if (contactName != null &&
            contactName.isNotEmpty &&
            (c.title.isEmpty || c.title.startsWith('WhatsApp:'))) {
          c.title = contactName;
        }
        await repository.upsert<Conversation>(c);
      }
    } catch (e) {
      print('Error transforming WhatsApp message: $e');
    }
  }

  DateTime _parseWhatsAppTimestamp(String raw) {
    if (raw.isEmpty) return DateTime.now().toUtc();
    final asInt = int.tryParse(raw);
    if (asInt != null) {
      // Meta sends seconds; data-connector createdAt is millis.
      if (asInt > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(asInt, isUtc: true);
      }
      return DateTime.fromMillisecondsSinceEpoch(asInt * 1000, isUtc: true);
    }
    try {
      return DateTime.parse(raw).toUtc();
    } catch (_) {
      return DateTime.now().toUtc();
    }
  }

  /// Get or create a conversation for a WhatsApp contact
  Future<String> _getOrCreateConversation({
    required String waId,
    required String contactName,
    required String branchId,
  }) async {
    final repository = Repository();

    final conversations = await repository.get<Conversation>(
      query: Query(
        where: [
          Where('branchId').isExactly(branchId),
          Where('whatsappWaId').isExactly(waId),
        ],
      ),
    );

    if (conversations.isNotEmpty) {
      return conversations.first.id;
    }

    final conversation = Conversation(
      title: contactName,
      branchId: branchId,
      whatsappWaId: waId,
      useCase: 'whatsapp',
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
