import 'dart:async';

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/interfaces/counter_interface.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaCounterMixin implements CounterInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Counter?> getCounter(
      {required String branchId,
      required String receiptType,
      required bool fetchRemote}) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return null;

    final result = await ditto.store.execute(
      "SELECT * FROM counters WHERE branchId = :branchId AND receiptType = :receiptType LIMIT 1",
      arguments: {"branchId": branchId, "receiptType": receiptType},
    );

    if (result.items.isEmpty) return null;

    final data = Map<String, dynamic>.from(result.items.first.value);
    return Counter(
      id: data['id'],
      branchId: data['branchId'],
      curRcptNo: data['curRcptNo'],
      totRcptNo: data['totRcptNo'],
      invcNo: data['invcNo'],
      businessId: data['businessId'],
      createdAt:
          data['createdAt'] != null ? DateTime.parse(data['createdAt']) : null,
      lastTouched: data['lastTouched'] != null
          ? DateTime.parse(data['lastTouched'])
          : null,
      receiptType: data['receiptType'],
      bhfId: data['bhfId'] ?? '',
    );
  }

  @override
  Future<List<Counter>> getCounters(
      {required String branchId, bool fetchRemote = false}) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return [];

    final result = await ditto.store.execute(
      "SELECT * FROM counters WHERE branchId = :branchId",
      arguments: {"branchId": branchId},
    );

    return result.items.map((doc) {
      final data = Map<String, dynamic>.from(doc.value);
      return Counter(
        id: data['id'],
        branchId: data['branchId'],
        curRcptNo: data['curRcptNo'],
        totRcptNo: data['totRcptNo'],
        invcNo: data['invcNo'],
        businessId: data['businessId'],
        createdAt: data['createdAt'] != null
            ? DateTime.parse(data['createdAt'])
            : null,
        lastTouched: data['lastTouched'] != null
            ? DateTime.parse(data['lastTouched'])
            : null,
        receiptType: data['receiptType'],
        bhfId: data['bhfId'] ?? '',
      );
    }).toList();
  }

  @override
  Future<void> updateCounters(
      {required List<Counter> counters, RwApiResponse? receiptSignature}) {
    // TODO: implement updateCounters
    throw UnimplementedError();
  }

  Stream<List<Counter>> listenCounters({required String branchId}) {
    try {
      final ditto = DittoService.instance.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return Stream.value([]);
      }

      final controller = StreamController<List<Counter>>.broadcast();
      dynamic observer;

      ditto.sync.registerSubscription(
        "SELECT * FROM counters WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM counters WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );

      observer = ditto.store.registerObserver(
        'SELECT * FROM counters WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          final counters = queryResult.items.map((doc) {
            final data = Map<String, dynamic>.from(doc.value);
            return Counter(
              id: data['id'],
              branchId: data['branchId'],
              curRcptNo: data['curRcptNo'],
              totRcptNo: data['totRcptNo'],
              invcNo: data['invcNo'],
              businessId: data['businessId'],
              createdAt: data['createdAt'] != null
                  ? DateTime.parse(data['createdAt'])
                  : null,
              lastTouched: data['lastTouched'] != null
                  ? DateTime.parse(data['lastTouched'])
                  : null,
              receiptType: data['receiptType'],
              bhfId: data['bhfId'] ?? '',
            );
          }).toList();

          controller.add(counters);
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error watching counters: $e');
      return Stream.value([]);
    }
  }
}
