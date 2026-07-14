import 'package:flipper_dashboard/stockApprovalMixin.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/notifications/notification_handler.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:flutter/material.dart';

/// Creates an outgoing branch transfer from the POS sale cart and auto-approves
/// so source stock decrements and destination stock increases.
///
/// Missing destination variants are created via [StockRequestApprovalLogic]
/// (`VariantBranch` + new [Variant] + [Stock]).
class BranchTransferService with StockRequestApprovalLogic {
  /// Clamps each line to `1…on-hand`, creates [InventoryRequest]
  /// (`main` = source, `sub` = destination), then auto-approves.
  ///
  /// Returns the request id. Throws [StateError] / [Exception] on validation
  /// or stock failures.
  Future<String> confirmBranchTransfer({
    required BuildContext context,
    required List<TransactionItem> items,
    required String sourceBranchId,
    required String destinationBranchId,
    String? destinationBranchName,
  }) async {
    if (items.isEmpty) {
      throw StateError('Add items before transferring');
    }
    if (destinationBranchId.isEmpty ||
        destinationBranchId == sourceBranchId) {
      throw StateError('Select a different destination branch');
    }

    final clamped = <TransactionItem>[];
    for (final item in items) {
      if (item.variantId == null || item.variantId!.isEmpty) {
        throw Exception('Item ${item.name} is missing a product variant');
      }
      final variant = await ProxyService.strategy.getVariant(
        id: item.variantId!,
      );
      final onHand = variant?.stock?.currentStock ?? 0;
      final requested = item.qty.round();
      if (requested < 1) {
        throw Exception('${item.name}: quantity must be at least 1');
      }
      if (onHand < 1) {
        throw Exception('${item.name}: no stock available to transfer');
      }
      final qty = requested > onHand.toInt() ? onHand.toInt() : requested;
      if (qty < 1) {
        throw Exception('${item.name}: no stock available to transfer');
      }
      clamped.add(
        item.copyWith(
          qty: qty.toDouble(),
          quantityRequested: qty,
          quantityApproved: 0,
        ),
      );
    }

    final requestId =
        await ProxyService.getStrategy(Strategy.capella).createStockRequest(
          clamped,
          mainBranchId: sourceBranchId,
          subBranchId: destinationBranchId,
        );

    final requests = await ProxyService.getStrategy(Strategy.capella).requests(
      requestId: requestId,
    );
    if (requests.isEmpty) {
      throw Exception('Transfer was created but could not be loaded');
    }

    final request = requests.first;
    // Prefer embedded items from create; otherwise load by request id.
    var requestItems = request.transactionItems;
    if (requestItems == null || requestItems.isEmpty) {
      requestItems = await ProxyService.getStrategy(
        Strategy.capella,
      ).transactionItems(requestId: requestId);
    }

    // Ensure quantityRequested is set for approval checks.
    request.transactionItems = requestItems
        .map(
          (i) => i.copyWith(
            quantityRequested:
                i.quantityRequested ?? i.qty.round().clamp(1, 1 << 30),
          ),
        )
        .toList();

    // Approval path expects [request.branch] (= destination / requester).
    if (request.branch == null && request.subBranchId != null) {
      request.branch = await ProxyService.strategy.branch(
        serverId: request.subBranchId,
      );
    }

    await approveRequest(request: request, context: context);

    await _notifyTransferCompleted(
      requestId: requestId,
      itemCount: clamped.length,
      sourceBranchId: sourceBranchId,
      destinationBranchId: destinationBranchId,
      destinationBranchName: destinationBranchName ?? request.branch?.name,
    );

    talker.info(
      'Branch transfer $requestId: ${clamped.length} item(s) '
      '$sourceBranchId → $destinationBranchId',
    );
    return requestId;
  }

  Future<void> _notifyTransferCompleted({
    required String requestId,
    required int itemCount,
    required String sourceBranchId,
    required String destinationBranchId,
    String? destinationBranchName,
  }) async {
    final destLabel = (destinationBranchName != null &&
            destinationBranchName.isNotEmpty)
        ? destinationBranchName
        : 'destination branch';
    final itemLabel = '$itemCount item${itemCount == 1 ? '' : 's'}';

    // Source device: OS + in-app banner (desktop & mobile).
    try {
      await NotificationHandler().showStockTransferNotification(
        requestId: requestId,
        title: 'Stock transferred',
        body: 'Transferred $itemLabel to $destLabel',
      );
    } catch (e, s) {
      talker.error('Source transfer notification failed', e, s);
    }

    // Destination branch: SMS when enabled (Order notification channel).
    try {
      final sourceConfig =
          await SmsNotificationService.getBranchSmsConfig(sourceBranchId);
      final sourcePhone = sourceConfig?.smsPhoneNumber ?? '';
      await SmsNotificationService.sendOrderRequestNotification(
        receiverBranchId: destinationBranchId,
        orderDetails:
            'Stock transfer: $itemLabel received from another branch '
            '(#$requestId).',
        requesterPhone: sourcePhone,
      );
    } catch (e, s) {
      talker.error('Destination transfer SMS failed', e, s);
    }
  }

  /// Marks the sale cart transaction as ordering/completed so a fresh pending
  /// sale cart is created (mirrors warehouse [placeFinalOrder] cleanup).
  Future<void> finalizeCartAfterTransfer({
    required ITransaction transaction,
    required List<TransactionItem> items,
  }) async {
    await ProxyService.getStrategy(Strategy.capella).markItemAsDoneWithTransaction(
      isDoneWithTransaction: true,
      inactiveItems: items,
      ignoreForReport: false,
      pendingTransaction: transaction,
    );
    await ProxyService.getStrategy(Strategy.capella).updateTransaction(
      transaction: transaction,
      status: ORDERING,
    );
  }
}
