import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';

abstract class CounterInterface {
  Future<Counter?> getCounter({
    required int branchId,
    required String receiptType,
    required bool fetchRemote,
  });

  Future<List<Counter>> getCounters({
    required int branchId,
    bool fetchRemote = false,
  });

  Future<void> updateCounters({
    required List<Counter> counters,
    RwApiResponse? receiptSignature,
  });
}
