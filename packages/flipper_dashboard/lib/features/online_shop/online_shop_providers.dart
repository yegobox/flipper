import 'dart:async';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/account_mode/account_mode_providers.dart';
import 'package:flipper_models/bulk_rra_client.dart'
    show resolveDataConnectorBaseUrl;
import 'package:flipper_models/online_shop/online_order.dart';
import 'package:flipper_models/online_shop/online_order_ticket.dart';
import 'package:flipper_models/online_shop/online_orders_provider.dart';
import 'package:flipper_models/online_shop/online_shop_client.dart';
import 'package:flipper_models/providers/kitchen_orders_provider.dart'
    show kitchenCapellaProvider;
import 'package:flipper_models/sms_review/sms_review_providers.dart'
    show usableDittoProvider;
import 'package:flipper_services/data_connector_url.dart';
import 'package:flipper_services/notifications/notification_handler.dart';
import 'package:flipper_services/storage/seen_requests_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// The connector client for the online-shop routes. Tests override it.
final onlineShopClientProvider = Provider<OnlineShopClient>(
  (ref) => OnlineShopClient(
    baseUrl: () async => resolveDataConnectorBaseUrl(
      dataConnectorUrl: await resolveEbmDataConnectorUrl(),
    ),
  ),
);

/// The session branch, re-read when Ditto (re)starts, i.e. after a branch
/// switch. Empty when signed out.
final onlineShopBranchIdProvider = Provider.autoDispose<String>((ref) {
  ref.watch(usableDittoProvider);
  try {
    return ref.watch(branchServicesProvider).box.getBranchId() ?? '';
  } catch (_) {
    return '';
  }
});

/// Whether to offer the Online Shop at all. A personal-mode business has no
/// shop (`docs/personal_mode.md`); the connector refuses it with 403 too.
final onlineShopAvailableProvider = Provider.autoDispose<bool>((ref) {
  final reading = ref.watch(accountModeProvider('')).value;
  return !(reading?.mode.isPersonal ?? false);
});

/// The branch's shop settings, hidden items and public link.
final onlineShopStateProvider = FutureProvider.autoDispose<OnlineShopState>((
  ref,
) {
  final branchId = ref.watch(onlineShopBranchIdProvider);
  if (branchId.isEmpty) return const OnlineShopState();
  return ref.watch(onlineShopClientProvider).load(branchId);
});

/// Parks accepted orders as POS tickets. Null until Ditto is up.
final onlineOrderTicketWriterProvider =
    Provider.autoDispose<OnlineOrderTicketWriter?>((ref) {
      final ditto = ref.watch(usableDittoProvider).value;
      if (ditto == null) return null;
      final services = ref.watch(branchServicesProvider);
      return OnlineOrderTicketWriter(
        db: ref.watch(kitchenCapellaProvider),
        createTransaction: dittoTicketTransactionFactory(
          ditto: ditto,
          agentId: services.box.getUserId() ?? 'unknown',
        ),
      );
    });

/// Shows the "New online order" banner and OS notification once per order.
typedef OnlineOrderAlert = Future<void> Function(OnlineOrder order);

final onlineOrderAlertProvider = Provider<OnlineOrderAlert>((ref) {
  // Claimed before the first await: two Ditto emissions close together would
  // otherwise both read the seen set before either marks the order.
  final claimed = <String>{};
  return (order) async {
    if (!claimed.add(order.id)) return;
    final seen = await SeenRequestsStorage.getSeenRequests();
    if (seen.contains(order.id)) return;
    await SeenRequestsStorage.markAsSeen(order.id);
    final l10n = FlipperL10n.current;
    await NotificationHandler().showStockTransferNotification(
      requestId: order.id,
      title: l10n.onlineOrderNewTitle,
      body: l10n.onlineOrderNewBody(
        '${order.orderNumber}',
        order.customerName,
        formatOnlineMoney(order.total, order.currency),
      ),
    );
  };
});

/// Orders still waiting to be accepted at this branch. Watching it also
/// raises the new-order alert, so the ribbon badge doubles as the notifier.
final newOnlineOrdersCountProvider = Provider.autoDispose<int>((ref) {
  final branchId = ref.watch(onlineShopBranchIdProvider);
  final orders = ref.watch(onlineOrdersProvider(branchId)).value ?? const [];
  final fresh = orders
      .where((o) => o.status == OnlineOrderStatus.newOrder)
      .toList();
  if (fresh.isNotEmpty) {
    final alert = ref.read(onlineOrderAlertProvider);
    for (final order in fresh) {
      unawaited(alert(order).catchError((_) {}));
    }
  }
  return fresh.length;
});

/// `4,997 RWF`.
String formatOnlineMoney(double amount, String currency) {
  final digits = amount == amount.roundToDouble() ? 0 : 2;
  final text = NumberFormat.decimalPatternDigits(
    decimalDigits: digits,
  ).format(amount);
  return '$text $currency';
}
