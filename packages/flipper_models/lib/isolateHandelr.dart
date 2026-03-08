import 'dart:isolate';
import 'dart:ui';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/services.dart';
// import 'package:supabase_models/brick/repository.dart'; // Unused in IsolateHandler now
// import 'package:supabase_models/brick/models/integration_config.model.dart'; // Unused
// import 'package:supabase_models/brick/models/transaction.model.dart'; // Unused
import 'package:flipper_models/umusada_service.dart';
import 'package:supabase_models/brick/repository.dart';

final repository = Repository(); // Unused

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
          print('salesSync message: $message');
          String? token = message['token'];
          List<Map<String, dynamic>>? salesData =
              (message['salesData'] as List?)?.cast<Map<String, dynamic>>();
          SendPort? replyTo = message['replyTo'];

          try {
            if (token != null && salesData != null && salesData.isNotEmpty) {
              final service =
                  UmusadaService(); // Repository is optional and not needed for syncSales
              // Wait, UmusadaService implementation of syncSales DOES NOT need repository if we only call syncSales.
              // But we construct it with Repository().
              // If the user says "isolate can't access repository", instantiating it might fail?
              // Or maybe just *using* it fails?
              // Let's check UmusadaService constructor.

              // If I can't even instantiate Repository(), I should modify UmusadaService or just use a raw HTTP call here.
              // But cleaner: use UmusadaService.

              await service.syncSales(token, salesData);

              if (replyTo != null) {
                replyTo.send(true);
              }
            } else {
              if (replyTo != null) {
                replyTo.send(false);
              }
            }
          } catch (e) {
            print('Error in salesSync: $e');
            if (replyTo != null) {
              replyTo.send(false);
            }
          }
        }
      }
    });
  }
}
