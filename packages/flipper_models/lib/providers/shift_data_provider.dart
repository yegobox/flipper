import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shift_data_provider.g.dart';

@riverpod
Future<ShiftData> shiftData(Ref ref) async {
  final userId = ProxyService.box.getUserId();
  if (userId == null) {
    return ShiftData(openingBalance: 0.0, cashSales: 0.0, expectedCash: 0.0);
  }

  final currentShift =
      await ProxyService.strategy.getCurrentShift(userId: userId);

  return ShiftData(
    openingBalance: currentShift?.openingBalance ?? 0.0,
    cashSales: currentShift?.cashSales?.toDouble() ?? 0.0,
    expectedCash: currentShift?.expectedCash?.toDouble() ?? 0.0,
  );
}

class ShiftData {
  final num openingBalance;
  final num cashSales;
  final num expectedCash;

  ShiftData({
    required this.openingBalance,
    required this.cashSales,
    required this.expectedCash,
  });
}
