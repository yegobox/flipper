import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:supabase_models/brick/repository.dart';

final repository = Repository();

class IsolateHandler {
  static Future<void> handler(List<dynamic> args) async {
    final SendPort sendPort = args[0];
    final RootIsolateToken rootIsolateToken = args[1];

    DartPluginRegistrant.ensureInitialized();
    BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);

    ReceivePort port = ReceivePort();

    sendPort.send(port.sendPort);

    port.listen((message) async {
      if (message is Map<String, dynamic>) {
        if (message['task'] == 'taxService') {
          print("dealing with isolate");
          // int branchId = message['branchId'];

          // int businessId = message['businessId'];
          // String dbPath = message['dbPath'] ?? "";
          // String? URI = message['URI'];
          // String? bhfId = message['bhfId'];
        }
      }
    });
  }
}
