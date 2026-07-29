import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_services/whatsapp_ditto_inbox.dart';
import 'package:flipper_services/whatsapp_message_sync_service.dart';
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;

import 'whatsapp_connection_provider.dart';

String _normalizeBase(String url) {
  var u = url.trim();
  if (!u.endsWith('/')) u = '$u/';
  // Treat localhost and 127.0.0.1 as the same host so we don't try both.
  u = u.replaceFirst('://localhost:', '://127.0.0.1:');
  return u;
}

bool _isLoopbackBase(String base) {
  final host = Uri.tryParse(base)?.host;
  return host == '127.0.0.1' || host == 'localhost';
}

/// Sticky base after the first successful poll — avoids re-trying dead URLs.
String? _workingBase;

/// Prefer EBM / cached URL (e.g. https://prod.api.yegobox.com/), then local, then alias.
Future<List<String>> _candidateBases() async {
  final out = <String>[];
  void add(String? raw) {
    if (raw == null || raw.trim().isEmpty) return;
    final n = _normalizeBase(raw);
    if (!out.contains(n)) out.add(n);
  }

  add(await resolveEbmDataConnectorUrl());
  if (kDebugMode && !out.any(_isLoopbackBase)) {
    add('http://127.0.0.1:8084/');
  }
  add('https://data-connector.yegobox.com/');
  add('https://prod.api.yegobox.com/');
  return out;
}

Future<List<Map<String, dynamic>>> _fetchLocalDocs() async {
  final store = DittoService.instance.store;
  if (store == null) return const [];
  try {
    final result = await store.execute('SELECT * FROM whatsapp_messages');
    final out = <Map<String, dynamic>>[];
    for (final item in result.items) {
      try {
        out.add(Map<String, dynamic>.from(item.value as Map));
      } catch (_) {}
    }
    return out;
  } catch (e) {
    debugPrint('local whatsapp_messages read failed: $e');
    return const [];
  }
}

Future<List<Map<String, dynamic>>> _fetchRemoteDocs({
  required http.Client client,
  required String phoneNumberId,
}) async {
  final bases = await _candidateBases();
  final ordered = <String>[
    if (_workingBase != null && bases.contains(_workingBase)) _workingBase!,
    ...bases.where((b) => b != _workingBase),
  ];

  // Skip known-dead loopback quickly when nothing is listening.
  final tryBases = ordered.where((b) {
    if (!_isLoopbackBase(b)) return true;
    // Still try loopback, but with a short timeout below.
    return true;
  }).toList();

  Future<List<Map<String, dynamic>>?> attempt(String base) async {
    final uri = Uri.parse('${base}api/whatsapp/messages').replace(
      queryParameters: {
        'phone_number_id': phoneNumberId,
        'limit': '1000',
      },
    );
    final timeout = _isLoopbackBase(base)
        ? const Duration(seconds: 2)
        : const Duration(seconds: 15);
    try {
      final response = await client.get(uri).timeout(timeout);
      if (response.statusCode != 200) {
        debugPrint(
          'WhatsApp inbox HTTP ${response.statusCode} @ $base',
        );
        return null;
      }
      final root = jsonDecode(response.body) as Map<String, dynamic>;
      final msgs = (root['messages'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
      debugPrint(
        'WhatsApp inbox HTTP ok: base=$base count=${msgs.length}',
      );
      return msgs;
    } catch (e) {
      debugPrint('WhatsApp inbox HTTP failed @ $base: $e');
      return null;
    }
  }

  // Prefer sticky base first (sequential), then race the rest.
  if (_workingBase != null && tryBases.contains(_workingBase)) {
    final hit = await attempt(_workingBase!);
    if (hit != null) return hit;
    _workingBase = null;
  }

  final rest = tryBases.where((b) => b != _workingBase).toList();
  if (rest.isEmpty) {
    throw StateError('whatsapp/messages unreachable: no candidates');
  }

  final completer = Completer<List<Map<String, dynamic>>>();
  var pending = rest.length;

  for (final base in rest) {
    unawaited(() async {
      final hit = await attempt(base);
      if (hit != null) {
        if (!completer.isCompleted) {
          _workingBase = base;
          completer.complete(hit);
        }
        return;
      }
      pending -= 1;
      if (pending == 0 && !completer.isCompleted) {
        completer.completeError(
          StateError('whatsapp/messages unreachable on all candidates'),
        );
      }
    }());
  }

  return completer.future;
}

List<Map<String, dynamic>> _mergeDocs(
  List<Map<String, dynamic>> remote,
  List<Map<String, dynamic>> local,
  String phoneNumberId,
) {
  final byId = <String, Map<String, dynamic>>{};

  void put(Map<String, dynamic> doc) {
    final id = (doc['_id'] ?? doc['id'] ?? doc['messageId'] ?? '').toString();
    if (id.isEmpty) return;
    final pid =
        (doc['phoneNumberId'] ?? doc['phone_number_id'] ?? '').toString();
    if (pid.isNotEmpty && pid != phoneNumberId) return;

    final prev = byId[id];
    if (prev == null) {
      byId[id] = Map<String, dynamic>.from(doc);
      return;
    }

    final deleted = WhatsAppDittoMessage.isDeletedDoc(prev) ||
        WhatsAppDittoMessage.isDeletedDoc(doc);
    final merged = Map<String, dynamic>.from(doc);
    if (deleted) {
      merged['deleted'] = true;
      merged['status'] = 'deleted';
    }
    byId[id] = merged;
  }

  // Local first, remote last — webhook store wins when reachable.
  for (final d in local) {
    put(d);
  }
  for (final d in remote) {
    put(d);
  }

  return byId.values
      .where((d) => !WhatsAppDittoMessage.isDeletedDoc(d))
      .toList();
}

/// Inbox: data-connector HTTP when reachable; always merges local Ditto so a
/// timeout never blanks the UI.
final whatsappDittoThreadsProvider =
    StreamProvider<List<WhatsAppDittoThread>>((ref) async* {
  ref.keepAlive();
  ref.watch(whatsAppConnectionStateProvider);

  final phoneNumberId = await resolveWhatsAppPhoneNumberId();
  if (phoneNumberId == null || phoneNumberId.isEmpty) {
    yield const [];
    return;
  }

  final client = http.Client();
  ref.onDispose(client.close);

  List<WhatsAppDittoThread>? lastOk;

  while (true) {
    final local = await _fetchLocalDocs();
    List<Map<String, dynamic>> remote = const [];
    try {
      remote = await _fetchRemoteDocs(
        client: client,
        phoneNumberId: phoneNumberId,
      );
    } catch (e, st) {
      debugPrint(
        'whatsappDittoThreadsProvider HTTP failed (using local Ditto): $e\n$st',
      );
    }

    final merged = _mergeDocs(remote, local, phoneNumberId);
    final threads = WhatsAppDittoInbox.groupThreadsFromDocs(merged);
    if (threads.isNotEmpty || remote.isNotEmpty || local.isNotEmpty) {
      lastOk = threads;
    }
    debugPrint(
      'WhatsApp inbox: remote=${remote.length} local=${local.length} '
      'merged=${merged.length} threads=${threads.length}',
    );
    // Prefer fresh merge; if both sources empty but we had data, keep last.
    if (threads.isNotEmpty || lastOk == null) {
      yield threads;
    } else {
      yield lastOk;
    }

    await Future<void>.delayed(const Duration(seconds: 2));
  }
});

final whatsappDittoInboxProvider = Provider<WhatsAppDittoInbox>((ref) {
  final inbox = WhatsAppDittoInbox();
  ref.onDispose(() {
    unawaited(inbox.dispose());
  });
  return inbox;
});

final whatsappMessageSyncProvider = StateNotifierProvider<
    WhatsAppMessageSyncNotifier, AsyncValue<WhatsAppSyncState>>((ref) {
  ref.keepAlive();
  return WhatsAppMessageSyncNotifier();
});

class WhatsAppMessageSyncNotifier
    extends StateNotifier<AsyncValue<WhatsAppSyncState>> {
  WhatsAppMessageSyncService? _service;
  StreamSubscription<WhatsAppSyncState>? _stateSubscription;

  WhatsAppMessageSyncNotifier() : super(AsyncValue.loading()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _stateSubscription?.cancel();
      _stateSubscription = null;

      final phoneNumberId = await resolveWhatsAppPhoneNumberId();
      if (phoneNumberId == null || phoneNumberId.isEmpty) {
        state = AsyncValue.data(WhatsAppSyncState.idle());
        return;
      }

      _service = WhatsAppMessageSyncService();
      await _service!.initialize(phoneNumberId);

      _stateSubscription = _service!.stateStream.listen((syncState) {
        state = AsyncValue.data(syncState);
      });
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> refresh() async {
    await _initialize();
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _service?.dispose();
    super.dispose();
  }
}
