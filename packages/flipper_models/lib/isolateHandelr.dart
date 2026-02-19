import 'dart:isolate';
import 'dart:ui';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/repository.dart';

final repository = Repository();

class IsolateHandler {
  static Future<void> handler(List<dynamic> args) async {
    final SendPort sendPort = args[0];
    final RootIsolateToken rootIsolateToken = args[1];

    DartPluginRegistrant.ensureInitialized();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
    DittoService dittoService = DittoService.instance;

    ReceivePort port = ReceivePort();

    sendPort.send(port.sendPort);

    port.listen((message) async {
      if (message is Map<String, dynamic>) {
        if (message['task'] == 'taxService') {
          final ditto = dittoService.dittoInstance;
          if (ditto == null) {
            // talker.error('Ditto not initialized');
          } else {
            // talker.error('Ditto is initialized');
          }
        } else if (message['task'] == 'salesSync') {
          // TODO: Implement sales synchronization logic
          // 1. Fetch unsynced sales data
          // 2. Post to Umusada API
          // 3. Mark as synced
        }
      }
    });
  }
}
