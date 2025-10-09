import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// Temporary diagnostic helper to debug Ditto sync issues
class DittoDiagnosticHelper {
  static Future<void> checkDittoSync() async {
    print('🔍 === DITTO SYNC DIAGNOSTIC ===');

    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) {
      print('❌ Ditto instance is null');
      return;
    }

    print('✅ Ditto instance exists');
    print('📱 Device name: ${ditto.deviceName}');

    final currentBranch = ProxyService.box.getBranchId();
    print('🏢 Current branchId: $currentBranch');

    // Check all counters (no filter)
    try {
      final allResult = await ditto.store.execute('SELECT * FROM counters');
      print('☁️  Total counters in LOCAL Ditto: ${allResult.items.length}');

      if (allResult.items.isNotEmpty) {
        print('   First 3 counters:');
        int count = 0;
        for (final item in allResult.items) {
          if (count >= 3) break;
          final doc = item.value as Map<dynamic, dynamic>;
          print(
              '   - ${doc['_id']}: branchId=${doc['branchId']}, curRcptNo=${doc['curRcptNo']}');
          count++;
        }
      }

      // Check counters for branch 1 specifically
      final branch1Result = await ditto.store.execute(
        'SELECT * FROM counters WHERE branchId = :branchId',
        arguments: {'branchId': 1},
      );
      print(
          '☁️  Counters for branchId=1 in LOCAL Ditto: ${branch1Result.items.length}');

      // Check if any counters exist with different branchId
      final otherBranchesResult = await ditto.store.execute(
        'SELECT * FROM counters WHERE branchId != :branchId',
        arguments: {'branchId': 1},
      );
      print(
          '☁️  Counters with OTHER branchIds: ${otherBranchesResult.items.length}');
      if (otherBranchesResult.items.isNotEmpty) {
        print('   Other branchIds found:');
        final branchIds = <dynamic>{};
        for (final item in otherBranchesResult.items) {
          final doc = item.value as Map<dynamic, dynamic>;
          branchIds.add(doc['branchId']);
        }
        print('   - $branchIds');
      }
    } catch (e) {
      print('❌ Error querying Ditto: $e');
    }

    print('🔍 === END DIAGNOSTIC ===');
  }

  static Future<void> checkDittoConnection() async {
    print('🔍 === DITTO CONNECTION STATUS ===');

    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) {
      print('❌ Ditto instance is null');
      return;
    }

    print('✅ Ditto initialized');
    print('� Device name: ${ditto.deviceName}');

    // Check sync status
    print('⚠️  Note: If data exists in Ditto Cloud but not locally,');
    print('   the device may not have synced yet. Wait a few moments');
    print('   or check network connectivity.');

    print('🔍 === END CONNECTION STATUS ===');
  }

  static Future<void> runFullDiagnostic() async {
    await checkDittoConnection();
    await checkDittoSync();
  }
}
