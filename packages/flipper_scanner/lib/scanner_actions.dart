import 'dart:async';

import 'package:flipper_services/event_service.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flipper_models/db_model_export.dart';

abstract class ScannerActions {
  void onBarcodeDetected(Barcode barcode);
  Future<void> handleLoginScan(String? result);
  Future<void> handleSellingScan(String? code);
  void pop();
  void navigateToSellRoute(dynamic product);
  void showSimpleNotification(String message);
  int getUserId();
  int getBusinessId();
  int getBranchId();
  String getUserPhone();
  String getDefaultApp();
  FutureOr<Pin?> getPinLocal(
      {required int userId, required bool alwaysHydrate});
  EventService getEventService();
  dynamic getBoxService();
  dynamic getStrategyService();
  void triggerHapticFeedback();
}
