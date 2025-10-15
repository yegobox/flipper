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
      {required int branchId,
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
      {required int branchId, bool fetchRemote = false}) async {
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
}
