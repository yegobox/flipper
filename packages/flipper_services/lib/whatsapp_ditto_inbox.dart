import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// One emoji reaction on a WhatsApp message (one per reactor).
class WhatsAppReaction {
  const WhatsAppReaction({
    required this.emoji,
    required this.from,
  });

  final String emoji;
  final String from;
}

/// One row from Ditto `whatsapp_messages`.
class WhatsAppDittoMessage {
  const WhatsAppDittoMessage({
    required this.id,
    required this.phoneNumberId,
    required this.waId,
    required this.from,
    required this.body,
    required this.messageType,
    required this.timestamp,
    required this.outbound,
    this.contactName,
    this.reactions = const [],
    this.filename,
    this.mimeType,
    this.mediaUrl,
    this.mediaId,
    this.mediaBase64,
  });

  final String id;
  final String phoneNumberId;
  final String waId;
  final String from;
  final String body;
  final String messageType;
  final DateTime timestamp;
  final bool outbound;
  final String? contactName;
  final List<WhatsAppReaction> reactions;
  final String? filename;
  final String? mimeType;
  final String? mediaUrl;
  final String? mediaId;
  final String? mediaBase64;

  bool get isPdf {
    final mime = (mimeType ?? '').toLowerCase();
    if (mime.contains('pdf')) return true;
    final name = (filename ?? '').toLowerCase();
    if (name.endsWith('.pdf')) return true;
    return messageType.toLowerCase() == 'document' &&
        (mime.isEmpty || mime.contains('pdf') || name.isEmpty);
  }

  bool get isDocument =>
      messageType.toLowerCase() == 'document' || isPdf;

  bool get hasDownloadableMedia =>
      (mediaUrl != null && mediaUrl!.trim().isNotEmpty) ||
      (mediaId != null && mediaId!.trim().isNotEmpty) ||
      (mediaBase64 != null && mediaBase64!.trim().isNotEmpty) ||
      id.isNotEmpty;

  String get displayFilename {
    final name = filename?.trim();
    if (name != null && name.isNotEmpty) return name;
    if (isPdf) return 'document.pdf';
    return 'attachment';
  }

  WhatsAppDittoMessage copyWith({
    List<WhatsAppReaction>? reactions,
  }) {
    return WhatsAppDittoMessage(
      id: id,
      phoneNumberId: phoneNumberId,
      waId: waId,
      from: from,
      body: body,
      messageType: messageType,
      timestamp: timestamp,
      outbound: outbound,
      contactName: contactName,
      reactions: reactions ?? this.reactions,
      filename: filename,
      mimeType: mimeType,
      mediaUrl: mediaUrl,
      mediaId: mediaId,
      mediaBase64: mediaBase64,
    );
  }

  factory WhatsAppDittoMessage.fromDoc(Map<String, dynamic> doc) {
    final id = (doc['_id'] ?? doc['id'] ?? doc['messageId'] ?? '').toString();
    final from = (doc['from'] ?? '').toString();
    final waId = (doc['waId'] ?? from).toString();
    final direction = (doc['direction'] ?? '').toString().toLowerCase();
    final body = (doc['messageBody'] ?? doc['caption'] ?? '').toString();
    final type = (doc['messageType'] ?? 'text').toString();
    final filename = doc['filename']?.toString();
    final mimeType =
        (doc['mimeType'] ?? doc['mime_type'])?.toString();
    final display = body.isNotEmpty
        ? body
        : (filename != null && filename.isNotEmpty)
            ? filename
            : (type.isEmpty ? '[attachment]' : '[$type]');

    final metaTs = (doc['timestamp'] ?? '').toString();
    final createdAt = (doc['createdAt'] ?? '').toString();
    final tsRaw = metaTs.isNotEmpty ? metaTs : createdAt;

    return WhatsAppDittoMessage(
      id: id,
      phoneNumberId: (doc['phoneNumberId'] ?? doc['phone_number_id'] ?? '')
          .toString(),
      waId: waId,
      from: from,
      body: display,
      messageType: type,
      timestamp: _parseTs(tsRaw),
      outbound: direction == 'outbound' || direction == 'out',
      contactName: doc['contactName']?.toString(),
      reactions: _reactionsFromDoc(doc),
      filename: filename,
      mimeType: mimeType,
      mediaUrl: (doc['mediaUrl'] ?? doc['media_url'])?.toString(),
      mediaId: (doc['mediaId'] ?? doc['media_id'])?.toString(),
      mediaBase64: (doc['mediaBase64'] ?? doc['media_base64'])?.toString(),
    );
  }

  static bool isDeletedDoc(Map<String, dynamic> doc) {
    final deleted = doc['deleted'];
    if (deleted == true) return true;
    if (deleted?.toString().toLowerCase() == 'true') return true;
    final status = (doc['status'] ?? '').toString().toLowerCase();
    if (status == 'deleted' || status == 'revoked') return true;
    final type = (doc['messageType'] ?? '').toString().toLowerCase();
    return type == 'revoke';
  }

  static bool isReactionDoc(Map<String, dynamic> doc) {
    return (doc['messageType'] ?? '').toString().toLowerCase() == 'reaction';
  }
}

List<WhatsAppReaction> _reactionsFromDoc(Map<String, dynamic> doc) {
  final raw = doc['reactions'];
  if (raw is! List) return const [];
  final byFrom = <String, WhatsAppReaction>{};
  for (final item in raw) {
    if (item is! Map) continue;
    final map = Map<String, dynamic>.from(item);
    final emoji = (map['emoji'] ?? '').toString().trim();
    if (emoji.isEmpty) continue;
    final from = (map['from'] ?? '').toString();
    final key = from.isNotEmpty ? from : emoji;
    byFrom[key] = WhatsAppReaction(emoji: emoji, from: from);
  }
  return byFrom.values.toList(growable: false);
}

/// Customer thread grouped from Ditto `whatsapp_messages`.
class WhatsAppDittoThread {
  const WhatsAppDittoThread({
    required this.waId,
    required this.displayName,
    required this.messages,
  });

  final String waId;
  final String displayName;
  final List<WhatsAppDittoMessage> messages;

  DateTime get lastMessageAt => messages.isEmpty
      ? DateTime.fromMillisecondsSinceEpoch(0)
      : messages.last.timestamp;

  String? get lastPreview {
    if (messages.isEmpty) return null;
    final m = messages.last;
    if (m.isDocument) return 'PDF · ${m.displayFilename}';
    return m.body;
  }
}

DateTime _parseTs(String raw) {
  if (raw.isEmpty) return DateTime.now().toUtc();
  final asInt = int.tryParse(raw);
  if (asInt != null) {
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

/// Helpers for Flo WhatsApp inbox (HTTP poll is the live source).
class WhatsAppDittoInbox {
  WhatsAppDittoInbox({DittoService? dittoService})
      : _dittoService = dittoService ?? DittoService.instance;

  final DittoService _dittoService;

  Future<void> appendOutbound({
    required String phoneNumberId,
    required String waId,
    required String body,
    String? contactName,
    String? messageId,
  }) async {
    final store = _dittoService.store;
    if (store == null) return;
    final now = DateTime.now().toUtc();
    // Prefer Meta Graph wamid so inbound reactions can attach to this row.
    final id = (messageId != null && messageId.trim().isNotEmpty)
        ? messageId.trim()
        : 'wa-out-${now.millisecondsSinceEpoch}';
    final doc = {
      '_id': id,
      'id': id,
      'messageId': id,
      'phoneNumberId': phoneNumberId,
      'waId': waId,
      'from': 'business',
      'messageBody': body,
      'messageType': 'text',
      'direction': 'outbound',
      'messagingProduct': 'whatsapp',
      'contactName': contactName,
      'timestamp': (now.millisecondsSinceEpoch ~/ 1000).toString(),
      'createdAt': now.millisecondsSinceEpoch.toString(),
    };
    await store.execute(
      'INSERT INTO whatsapp_messages DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  static List<WhatsAppDittoThread> groupThreadsFromDocs(
    List<Map<String, dynamic>> docs,
  ) =>
      _groupThreads(docs);

  static List<WhatsAppDittoThread> _groupThreads(
    List<Map<String, dynamic>> docs,
  ) {
    // targetMessageId -> from -> emoji (latest wins; empty emoji removes).
    final reactionByTarget = <String, Map<String, String>>{};
    final orphanMeta = <String, ({String waId, String? contactName})>{};

    void applyReaction({
      required String targetId,
      required String from,
      required String emoji,
      String? waId,
      String? contactName,
    }) {
      if (targetId.isEmpty) return;
      final bucket = reactionByTarget.putIfAbsent(targetId, () => {});
      final key = from.isNotEmpty ? from : '_';
      if (emoji.trim().isEmpty) {
        bucket.remove(key);
      } else {
        bucket[key] = emoji.trim();
        orphanMeta[targetId] = (
          waId: (waId != null && waId.isNotEmpty) ? waId : from,
          contactName: contactName,
        );
      }
    }

    String docId(Map<String, dynamic> doc) =>
        (doc['_id'] ?? doc['id'] ?? doc['messageId'] ?? '').toString();

    final parentIds = <String>{};
    for (final doc in docs) {
      if (WhatsAppDittoMessage.isDeletedDoc(doc)) continue;
      if (WhatsAppDittoMessage.isReactionDoc(doc)) continue;
      final id = docId(doc);
      if (id.isNotEmpty) parentIds.add(id);
      final mid = (doc['messageId'] ?? '').toString();
      if (mid.isNotEmpty) parentIds.add(mid);
    }

    for (final doc in docs) {
      if (WhatsAppDittoMessage.isDeletedDoc(doc)) continue;

      final embedded = doc['reactions'];
      if (embedded is List) {
        final parentId = docId(doc);
        for (final item in embedded) {
          if (item is! Map) continue;
          final map = Map<String, dynamic>.from(item);
          applyReaction(
            targetId: parentId,
            from: (map['from'] ?? '').toString(),
            emoji: (map['emoji'] ?? '').toString(),
            waId: (doc['waId'] ?? doc['from'])?.toString(),
            contactName: doc['contactName']?.toString(),
          );
        }
      }

      if (WhatsAppDittoMessage.isReactionDoc(doc)) {
        applyReaction(
          targetId: (doc['reactionMessageId'] ??
                  doc['reaction_message_id'] ??
                  '')
              .toString(),
          from: (doc['from'] ?? '').toString(),
          emoji: (doc['reactionEmoji'] ??
                  doc['reaction_emoji'] ??
                  doc['messageBody'] ??
                  '')
              .toString(),
          waId: (doc['waId'] ?? doc['from'])?.toString(),
          contactName: doc['contactName']?.toString(),
        );
      }
    }

    final byWa = <String, List<WhatsAppDittoMessage>>{};
    final names = <String, String>{};
    final attachedTargets = <String>{};

    for (final doc in docs) {
      if (WhatsAppDittoMessage.isDeletedDoc(doc)) continue;
      if (WhatsAppDittoMessage.isReactionDoc(doc)) continue;

      var msg = WhatsAppDittoMessage.fromDoc(doc);
      if (msg.waId.isEmpty && msg.from.isEmpty) continue;

      final mid = (doc['messageId'] ?? '').toString();
      final fromMap =
          reactionByTarget[msg.id] ?? reactionByTarget[mid];
      if (fromMap != null && fromMap.isNotEmpty) {
        attachedTargets.add(msg.id);
        if (mid.isNotEmpty) attachedTargets.add(mid);
        msg = msg.copyWith(
          reactions: fromMap.entries
              .map((e) => WhatsAppReaction(emoji: e.value, from: e.key))
              .toList(growable: false),
        );
      }

      final key = msg.waId.isNotEmpty ? msg.waId : msg.from;
      byWa.putIfAbsent(key, () => []).add(msg);
      final name = msg.contactName?.trim();
      if (name != null && name.isNotEmpty) {
        names[key] = name;
      }
    }

    // Reactions on outbound Graph wamids we never stored as chat rows.
    for (final entry in reactionByTarget.entries) {
      if (entry.value.isEmpty) continue;
      if (attachedTargets.contains(entry.key) ||
          parentIds.contains(entry.key)) {
        continue;
      }
      final meta = orphanMeta[entry.key];
      final wa = meta?.waId ?? '';
      if (wa.isEmpty) continue;
      final stub = WhatsAppDittoMessage(
        id: entry.key,
        phoneNumberId: '',
        waId: wa,
        from: 'business',
        body: '(message)',
        messageType: 'text',
        timestamp: DateTime.now().toUtc(),
        outbound: true,
        contactName: meta?.contactName,
        reactions: entry.value.entries
            .map((e) => WhatsAppReaction(emoji: e.value, from: e.key))
            .toList(growable: false),
      );
      byWa.putIfAbsent(wa, () => []).add(stub);
      final name = meta?.contactName?.trim();
      if (name != null && name.isNotEmpty) {
        names[wa] = name;
      }
    }

    final threads = <WhatsAppDittoThread>[];
    for (final entry in byWa.entries) {
      final msgs = entry.value
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      threads.add(
        WhatsAppDittoThread(
          waId: entry.key,
          displayName: names[entry.key] ?? entry.key,
          messages: List.unmodifiable(msgs),
        ),
      );
    }

    threads.sort((a, b) => b.lastMessageAt.compareTo(a.lastMessageAt));
    return threads;
  }

  Future<void> dispose() async {
    // No live observers — HTTP poll owns the stream.
  }
}

/// Resolve the Phone Number ID for the active business (prefs fallback).
Future<String?> resolveWhatsAppPhoneNumberId() async {
  final businessId = ProxyService.box.getBusinessId();
  if (businessId != null) {
    try {
      final business =
          await ProxyService.strategy.getBusiness(businessId: businessId);
      final id = business?.getWhatsAppPhoneNumberId();
      if (id != null && id.isNotEmpty) return id;
    } catch (_) {}
  }
  final prefs = ProxyService.box.whatsAppPhoneNumberId();
  if (prefs != null && prefs.isNotEmpty) return prefs;
  return null;
}
