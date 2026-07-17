import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/utils/branch_transfer_rra.dart';
import 'package:flipper_services/sms/sms_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import 'package:flipper_ui/snack_bar_utils.dart';

mixin StockRequestApprovalLogic {
  /// Returns true when approval is finalized; false when left pending/unapproved.
  /// Unexpected failures are surfaced via snackbar then rethrown.
  Future<bool> approveRequest({
    required InventoryRequest request,
    required BuildContext context,
  }) async {
    var loadingVisible = false;
    try {
      _showLoadingDialog(context);
      loadingVisible = true;

      // Prefer embedded stock_request items (source of truth for approval qty).
      // Table rows may lag or omit quantityRequested until linked fully.
      List<TransactionItem> items = _resolveRequestItemsForApproval(request);

      if (items.isEmpty) {
        final fromTable = await ProxyService.getStrategy(
          Strategy.capella,
        ).transactionItems(requestId: request.id);
        items = fromTable
            .map(
              (i) => i.copyWith(
                quantityRequested:
                    i.quantityRequested ?? i.qty.round().clamp(1, 1 << 30),
              ),
            )
            .toList();
      }

      if (items.isEmpty) {
        loadingVisible = _dismissLoadingIfShown(context, loadingVisible);
        _showSnackBar(message: 'No items found in request', context: context);
        return false;
      }

      final itemApprovalResults = await Future.wait(
        items.map(
          (item) => _processItemApproval(
            item: item,
            request: request,
            subBranchId: request.subBranchId!,
            sourceBranchId: request.mainBranchId ?? request.subBranchId!,
          ),
        ),
      );

      final List<TransactionItem> itemsNeedingApproval = [];
      final List<BranchTransferApprovedLine> rraLines = [];
      bool isFullyApproved = true;

      for (var i = 0; i < items.length; i++) {
        final result = itemApprovalResults[i];
        if (result.line != null) {
          rraLines.add(result.line!);
        }
        if (!result.ok) {
          isFullyApproved = false;
          itemsNeedingApproval.add(items[i]);
        }
      }

      loadingVisible = _dismissLoadingIfShown(context, loadingVisible);

      if (!isFullyApproved) {
        final partial = await _handlePartialApproval(
          items: itemsNeedingApproval,
          request: request,
          context: context,
        );

        if (!partial.ok) return false;
        rraLines.addAll(partial.lines);
      }

      // Same source as approveSingleItem: Capella embedded items after writes.
      final refreshed = (await ProxyService.getStrategy(
        Strategy.capella,
      ).requests(requestId: request.id)).firstOrNull;
      final List<TransactionItem> approvedItems =
          refreshed?.transactionItems ??
          await ProxyService.getStrategy(
            Strategy.capella,
          ).transactionItems(requestId: request.id);

      final anyProcessed =
          itemApprovalResults.any((r) => r.ok) || rraLines.isNotEmpty;
      if (!anyProcessed &&
          !_atLeastOneItemApproved(approvedItems) &&
          !_atLeastOneItemApproved(items)) {
        _showSnackBar(
          message: 'At least one item must be approved',
          context: context,
          isError: true,
        );
        return false;
      }

      final bool fullyFromEmbedded =
          approvedItems.isNotEmpty &&
          approvedItems.every(
            (item) =>
                (item.quantityApproved ?? 0) >= (item.quantityRequested ?? 0) &&
                (item.quantityRequested ?? 0) > 0,
          );

      await _finalizeApproval(
        request: refreshed ?? request,
        isFullyApproved: isFullyApproved || fullyFromEmbedded,
        context: context,
        rraLines: rraLines,
      );
      return true;
    } catch (e, s) {
      talker.error('Error in approveRequest', e, s);
      _dismissLoadingIfShown(context, loadingVisible);
      if (context.mounted) {
        _showSnackBar(
          message: 'An error occurred while processing the request',
          context: context,
          isError: true,
        );
      }
      rethrow;
    }
  }

  Future<void> updateRequestedQuantity({
    required InventoryRequest request,
    required TransactionItem item,
    required int newQuantity,
    required BuildContext context,
  }) async {
    try {
      _showLoadingDialog(context);

      await ProxyService.strategy.updateStockRequestItem(
        requestId: request.id,
        transactionItemId: item.id,
        quantityRequested: newQuantity,
        // We don't change approval status here
      );

      if (context.mounted) {
        Navigator.of(context).pop();
        _showSnackBar(
          message: 'Quantity updated successfully',
          context: context,
        );
      }
    } catch (e, s) {
      talker.error('Error in updateRequestedQuantity', e, s);
      if (context.mounted) {
        Navigator.of(context).pop();
        _showSnackBar(
          message: 'Failed to update quantity',
          context: context,
          isError: true,
        );
      }
    }
  }

  Future<void> approveSingleItem({
    required InventoryRequest request,
    required TransactionItem item,
    required BuildContext context,
    double? quantity,
  }) async {
    var loadingVisible = false;
    try {
      _showLoadingDialog(context);
      loadingVisible = true;

      final canApprove = await _canApproveItem(item: item);
      if (!canApprove) {
        loadingVisible = _dismissLoadingIfShown(context, loadingVisible);
        if (context.mounted) {
          _showSnackBar(
            message: 'Insufficient stock for ${item.name}',
            context: context,
            isError: true,
          );
        }
        return;
      }

      final Variant? variant = await ProxyService.strategy.getVariant(
        id: item.variantId!,
      );
      if (variant == null) {
        loadingVisible = _dismissLoadingIfShown(context, loadingVisible);
        if (context.mounted) {
          _showSnackBar(
            message: 'Variant not found for ${item.name}',
            context: context,
            isError: true,
          );
        }
        return;
      }

      final double availableStock = variant.stock?.currentStock ?? 0;
      final int requestedQuantity = _requestedQty(item);

      int approvedQuantity;
      if (quantity != null) {
        approvedQuantity = quantity.toInt();
        if (approvedQuantity > availableStock) {
          approvedQuantity = availableStock.toInt();
          if (context.mounted) {
            toast('Quantity adjusted to available stock: $approvedQuantity');
          }
        }
      } else {
        approvedQuantity = availableStock >= requestedQuantity
            ? requestedQuantity
            : availableStock.toInt();
      }

      final rraLine = await _processPartialApprovalItem(
        item: item,
        approvedQuantity: approvedQuantity,
        request: request,
      );

      // Re-fetch the request to get updated embedded items
      final updatedRequest = (await ProxyService.getStrategy(
        Strategy.capella,
      ).requests(requestId: request.id)).firstOrNull;

      if (updatedRequest != null && updatedRequest.transactionItems != null) {
        final bool isFullyApproved = updatedRequest.transactionItems!.every(
          (line) => (line.quantityApproved ?? 0) >= (_requestedQty(line)),
        );

        await _finalizeApproval(
          request: updatedRequest,
          isFullyApproved: isFullyApproved,
          context: context,
          rraLines: rraLine != null ? [rraLine] : const [],
        );
      }

      loadingVisible = _dismissLoadingIfShown(context, loadingVisible);
      if (context.mounted) {
        _showSnackBar(
          message: '${item.name} has been approved',
          context: context,
        );
      }
    } catch (e, s) {
      talker.error('Error in approveSingleItem', e, s);
      _dismissLoadingIfShown(context, loadingVisible);
      if (context.mounted) {
        _showSnackBar(
          message: 'An error occurred while approving the item',
          context: context,
          isError: true,
        );
      }
    }
  }

  int _requestedQty(TransactionItem item) {
    final requested = item.quantityRequested ?? item.qty.round();
    return requested < 1 ? 0 : requested;
  }

  Future<bool> _canApproveItem({required TransactionItem item}) async {
    final Variant? variant = await ProxyService.strategy.getVariant(
      id: item.variantId!,
    );

    if (variant == null || variant.stock?.currentStock == null) {
      return false;
    }

    final double availableStock = variant.stock!.currentStock!;
    final int quantityRequested = _requestedQty(item);
    final int quantityApproved = item.quantityApproved ?? 0;
    final int remainingQuantityToApprove = quantityRequested - quantityApproved;

    return remainingQuantityToApprove > 0 &&
        availableStock >= remainingQuantityToApprove;
  }

  Future<_ItemApprovalResult> _processItemApproval({
    required TransactionItem item,
    required String subBranchId,
    required String sourceBranchId,
    required InventoryRequest request,
  }) async {
    try {
      final requested = _requestedQty(item);
      if (requested < 1) {
        return const _ItemApprovalResult(ok: false);
      }

      // If the item is already fully approved, we don't need to do anything
      if ((item.quantityApproved ?? 0) >= requested) {
        // Heal DB
        await ProxyService.strategy.updateStockRequestItem(
          requestId: request.id,
          transactionItemId: item.id,
          quantityApproved: item.quantityApproved ?? requested,
        );
        return const _ItemApprovalResult(ok: true);
      }

      if (await _canApproveItem(item: item)) {
        final line = await _approveItem(
          item: item,
          subBranchId: subBranchId,
          request: request,
          sourceBranchId: sourceBranchId,
        );
        return _ItemApprovalResult(ok: true, line: line);
      }
      return const _ItemApprovalResult(ok: false);
    } catch (e, s) {
      talker.error('Error processing item approval', e, s);
      return const _ItemApprovalResult(ok: false);
    }
  }

  Future<BranchTransferApprovedLine?> _approveItem({
    required TransactionItem item,
    required String subBranchId,
    required String sourceBranchId,
    required InventoryRequest request,
  }) async {
    try {
      final Variant? variant = await ProxyService.strategy.getVariant(
        id: item.variantId!,
      );
      if (variant == null) {
        throw Exception('Variant not found');
      }

      final double availableStock = variant.stock?.currentStock ?? 0;
      final int requestedQuantity = _requestedQty(item);
      final int approvedQuantity = availableStock >= requestedQuantity
          ? requestedQuantity
          : availableStock.toInt();
      if (approvedQuantity <= 0) return null;

      final line = await _processPartialApprovalItem(
        item: item,
        approvedQuantity: approvedQuantity,
        request: request,
      );
      item.quantityApproved = approvedQuantity;
      item.quantityRequested ??= requestedQuantity;
      return line;
    } catch (e, s) {
      talker.error('Error in _approveItem', e, s);
      throw Exception('Failed to approve item');
    }
  }

  Future<Stock> _createNewStockForSharedVariant({
    required TransactionItem item,
    required Variant variant,
    required String destinationBranchId,
  }) async {
    try {
      return await ProxyService.strategy.saveStock(
        rsdQty: item.quantityRequested!.toDouble(),
        currentStock: item.quantityRequested!.toDouble(),
        value: (item.quantityRequested! * variant.retailPrice!).toDouble(),
        productId: variant.productId!,
        variantId: variant.id, // use the new variant's ID
        branchId: destinationBranchId, // Use the destination branch ID
      );
    } catch (e, s) {
      talker.error('Error creating new stock for shared variant', e, s);
      throw Exception('Failed to create new stock for shared variant');
    }
  }

  Future<_PartialApprovalResult> _handlePartialApproval({
    required List<TransactionItem> items,
    required InventoryRequest request,
    required BuildContext context,
  }) async {
    final lines = <BranchTransferApprovedLine>[];
    final partialApprovalResult = await _showPartialApprovalDialog(
      items: items,
      request: request,
      context: context,
      outLines: lines,
    );

    if (!partialApprovalResult) {
      _showSnackBar(
        message: 'Approval cancelled',
        context: context,
        isError: true,
      );
      return const _PartialApprovalResult(ok: false);
    }
    return _PartialApprovalResult(ok: true, lines: lines);
  }

  /// Prefer embedded [InventoryRequest.transactionItems] (approval qty source of
  /// truth). Fall back to empty so callers can load from `transaction_items`.
  List<TransactionItem> _resolveRequestItemsForApproval(
    InventoryRequest request,
  ) {
    final embedded = request.transactionItems;
    if (embedded == null || embedded.isEmpty) return const [];
    return embedded
        .map(
          (i) => i.copyWith(
            quantityRequested:
                i.quantityRequested ?? i.qty.round().clamp(1, 1 << 30),
          ),
        )
        .toList();
  }

  //Fix: Use the List<TransactionItem> that you get after approval to validate it.
  bool _atLeastOneItemApproved(List<TransactionItem> items) {
    return items.any((item) => (item.quantityApproved ?? 0) > 0);
  }

  Future<void> _finalizeApproval({
    required InventoryRequest request,
    required bool isFullyApproved,
    required BuildContext context,
    List<BranchTransferApprovedLine> rraLines = const [],
  }) async {
    try {
      await ProxyService.strategy.updateStockRequest(
        stockRequestId: request.id,
        updatedAt: DateTime.now().toUtc(),
        status: isFullyApproved
            ? RequestStatus.approved
            : RequestStatus.partiallyApproved,
        approvedBy: ProxyService.box
            .getUserId()
            .toString(), // Assuming userId for now, will refine
        approvedAt: DateTime.now().toUtc(),
      );

      // Send SMS notification to requester (never pop navigator here).
      try {
        final requesterBranchId = request.branch?.id ?? request.subBranchId;
        if (requesterBranchId != null && requesterBranchId.isNotEmpty) {
          final requesterConfig =
              await SmsNotificationService.getBranchSmsConfig(
                requesterBranchId,
              );
          final phone = requesterConfig?.smsPhoneNumber;
          if (phone != null && phone.isNotEmpty) {
            await SmsNotificationService.sendOrderRequestNotification(
              receiverBranchId: requesterBranchId,
              orderDetails:
                  'Your stock request #${request.id.substring(0, 5)} has been ${isFullyApproved ? 'approved' : 'partially approved'}.',
              requesterPhone: phone,
            );
          }
        }
      } catch (smsError) {
        talker.error('Failed to send SMS notification: $smsError');
        // Don't show error to user as the main operation succeeded
      }

      if (rraLines.isNotEmpty) {
        final rra = await reportBranchTransferToRra(
          request: request,
          lines: rraLines,
        );
        if (!rra.succeeded && context.mounted) {
          _showSnackBar(
            message:
                'Approved locally; EBM sync failed${rra.message != null ? ': ${rra.message}' : ''}',
            context: context,
            isError: true,
          );
        }
      }

      if (context.mounted) {
        _showSnackBar(
          message:
              'Request ${isFullyApproved ? 'approved' : 'partially approved'} successfully',
          context: context,
        );
      }
    } catch (e, s) {
      talker.error('Error in finalizeApproval', e, s);
      if (context.mounted) {
        _showSnackBar(
          message: 'Failed to finalize approval',
          context: context,
          isError: true,
        );
      }
    }
  }

  /// Dismisses the loading dialog only when we know it is still open.
  /// Extra pops were leaving Incoming Orders and looking like an app restart.
  bool _dismissLoadingIfShown(BuildContext context, bool loadingVisible) {
    if (!loadingVisible || !context.mounted) return false;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
    return false;
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      useRootNavigator: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                'Processing Request...',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _showPartialApprovalDialog({
    required List<TransactionItem> items,
    required InventoryRequest request,
    required BuildContext context,
    required List<BranchTransferApprovedLine> outLines,
  }) async {
    final List<int?> approvedQuantities = List.filled(items.length, null);

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'Partial Approval',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: _buildDialogContent(
          items: items,
          approvedQuantities: approvedQuantities,
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () => _handleApproveButtonPress(
              items: items,
              approvedQuantities: approvedQuantities,
              request: request,
              context: context,
              outLines: outLines,
            ),
            child: Text(
              'Approve',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );

    // Handle the case where the dialog is dismissed (e.g., by tapping outside)
    return result ?? false; // Return false if result is null
  }

  Widget _buildDialogContent({
    required List<TransactionItem> items,
    required List<int?> approvedQuantities,
  }) {
    return Container(
      width: double.maxFinite,
      constraints: BoxConstraints(maxHeight: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Some items have insufficient stock. Please adjust the approved quantities:',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final TransactionItem item = items[index];
                return FutureBuilder<Variant?>(
                  future: ProxyService.strategy.getVariant(id: item.variantId!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator(); // Or some loading indicator
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}'); // Handle error
                    } else if (!snapshot.hasData || snapshot.data == null) {
                      return Text(
                        'Variant not found',
                      ); // Handle variant not found
                    } else {
                      final Variant variant = snapshot.data!;
                      return _buildItemCard(
                        variant: variant,
                        item: item,
                        approvedQuantities: approvedQuantities,
                        index: index,
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard({
    required TransactionItem item,
    required List<int?> approvedQuantities,
    required Variant variant,
    required int index,
  }) {
    // Initialize the quantity when building the card
    if (approvedQuantities[index] == null) {
      approvedQuantities[index] = _calculateInitialValueAsInt(
        requested: item.quantityRequested ?? 0,
        available: variant.stock!.currentStock!,
      );
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              requested: item.quantityRequested ?? 0,
              approved: item.quantityApproved ?? 0,
              available: variant.stock!.currentStock!,
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: approvedQuantities[index].toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Approve Quantity',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onChanged: (value) => _updateApprovedQuantity(
                value: value,
                availableStock: variant.stock!.currentStock!,
                approvedQuantities: approvedQuantities,
                index: index,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required num requested,
    required num approved,
    required double available,
  }) {
    return Row(
      children: [
        _buildInfoChip(
          label: 'Requested',
          value: requested.toString(),
          color: Colors.blue.shade100,
        ),
        SizedBox(width: 8),
        _buildInfoChip(
          label: 'Approved',
          value: approved.toString(),
          color: Colors.green.shade100,
        ),
        SizedBox(width: 8),
        _buildInfoChip(
          label: 'Available',
          value: available.toString(),
          color: Colors.orange.shade100,
        ),
      ],
    );
  }

  Widget _buildInfoChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text('$label: $value', style: TextStyle(fontSize: 12)),
    );
  }

  int _calculateInitialValueAsInt({
    required num requested,
    required double available,
  }) {
    return (available < requested ? available.toInt() : requested.toInt());
  }

  void _updateApprovedQuantity({
    required String value,
    required double availableStock,
    required List<int?> approvedQuantities,
    required int index,
  }) {
    final int? approvedQty = int.tryParse(value);
    if (approvedQty != null && approvedQty <= availableStock) {
      approvedQuantities[index] = approvedQty;
    }
  }

  Future<void> _handleApproveButtonPress({
    required List<TransactionItem> items,
    required List<int?> approvedQuantities,
    required InventoryRequest request,
    required BuildContext context,
    required List<BranchTransferApprovedLine> outLines,
  }) async {
    try {
      if (!approvedQuantities.any((qty) => qty != null && qty > 0)) {
        toast('Please approve at least one item');
        return;
      }

      _showLoadingDialog(context);

      // Process each item individually
      for (int i = 0; i < items.length; i++) {
        if (approvedQuantities[i] != null) {
          final TransactionItem item = items[i];
          final int approvedQuantity =
              approvedQuantities[i]!; // Correctly use the approved quantity from the dialog

          final line = await _processPartialApprovalItem(
            item: item,
            approvedQuantity: approvedQuantity,
            request: request,
          );
          if (line != null) outLines.add(line);
        }
      }

      if (context.mounted) {
        Navigator.of(context).pop(true); // Close approval dialog with success
      }
    } catch (e, s) {
      talker.error('Error in handleApproveButtonPress', e, s);
      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading dialog
        _showSnackBar(
          message: 'Failed to process approval',
          context: context,
          isError: true,
        );
      }
    }
  }

  /// Applies local Capella stock move for [approvedQuantity] and returns an RRA line
  /// with post-move source/dest variants when both can be resolved.
  Future<BranchTransferApprovedLine?> _processPartialApprovalItem({
    required TransactionItem item,
    required int approvedQuantity,
    required InventoryRequest request,
  }) async {
    try {
      final Variant? requestedVariant = await ProxyService.strategy.getVariant(
        id: item.variantId!,
      );

      if (requestedVariant == null) {
        talker.error('Variant not found for ID: ${item.variantId!}');
        throw Exception('Variant not found');
      }

      // First handle the variant and stock creation/update
      final destVariant = await _handleVariantAndStockInternal(
        item: item,
        request: request,
        variant: requestedVariant,
        approvedQuantity: approvedQuantity,
      );

      // Then update the main branch stock
      await _updateMainBranchStock(
        variantId: requestedVariant.id,
        approvedQuantity: approvedQuantity,
        isDeducting: true,
      );

      // Finally update the embedded transaction item in the request
      await ProxyService.strategy.updateStockRequestItem(
        requestId: request.id,
        transactionItemId: item.id,
        ignoreForReport: false,
        quantityApproved: approvedQuantity,
      );

      if (approvedQuantity <= 0) return null;

      final sourceVariant = await ProxyService.strategy.getVariant(
        id: requestedVariant.id,
      );
      final destFresh = await ProxyService.strategy.getVariant(
        id: destVariant.id,
      );
      if (sourceVariant == null || destFresh == null) return null;

      return BranchTransferApprovedLine(
        sourceVariant: sourceVariant,
        destVariant: destFresh,
        approvedQty: approvedQuantity,
        itemName: item.name,
      );
    } catch (e, s) {
      talker.error('Error in _processPartialApprovalItem', e, s);
      throw Exception('Failed to process partial approval item');
    }
  }

  // this function is created and will create variant and stock and update transactionitem and return
  // new variant so that it could be updated.
  Future<Variant> _handleVariantAndStockInternal({
    required TransactionItem item,
    required InventoryRequest request,
    required Variant variant,
    required int approvedQuantity,
  }) async {
    variant.isShared = true;
    await ProxyService.strategy.updateVariant(updatables: [variant]);

    // Check if this variant has already been ordered by this branch
    VariantBranch? existingVariantBranch = await ProxyService.strategy
        .variantBranch(
          variantId: variant.id,
          destinationBranchId: request.subBranchId!,
        );

    if (existingVariantBranch != null) {
      // Variant already exists for this branch, use the existing one
      final existingVariant = await ProxyService.strategy.getVariant(
        id: existingVariantBranch.newVariantId,
      );
      if (existingVariant != null) {
        // Update the existing variant's stock if it exists
        if (existingVariant.stock != null) {
          await ProxyService.strategy.updateStock(
            stockId: existingVariant.stock!.id,
            currentStock:
                existingVariant.stock!.currentStock! + approvedQuantity,
            value:
                (existingVariant.stock!.currentStock! + approvedQuantity) *
                existingVariant.retailPrice!,
            rsdQty: existingVariant.stock!.currentStock! + approvedQuantity,
            lastTouched: DateTime.now().toUtc(),
            ebmSynced: false,
          );
        } else {
          // Create new stock for the existing variant if it doesn't have one
          final stock = await _createNewStockForSharedVariant(
            item: item,
            variant: existingVariant,
            destinationBranchId: request.subBranchId!,
          );
          existingVariant.stock = stock;
          existingVariant.stockId = stock.id;
          await ProxyService.strategy.updateVariant(
            updatables: [existingVariant],
          );
        }
        return existingVariant;
      }
    }

    // Create a new variant for this branch
    final String newVariantId = const Uuid().v4();
    final String newModrId = const Uuid().v4().substring(0, 5);

    final newVariant = variant.copyWith(
      id: newVariantId,
      modrId: newModrId,
      isShared: true,
      branchId: request.subBranchId!,
    );

    final createdVariant = await ProxyService.strategy.create<Variant>(
      data: newVariant,
    );
    if (createdVariant == null) {
      throw Exception('Failed to create new variant');
    }

    // Create stock for the new variant
    final stock = await _createNewStockForSharedVariant(
      item: item,
      variant: newVariant,
      destinationBranchId: request.branch!.id,
    );

    // Update the variant with the new stock
    createdVariant.stock = stock;
    createdVariant.stockId = stock.id;
    await ProxyService.strategy.updateVariant(updatables: [createdVariant]);

    // Create the variant branch mapping
    Branch? sourceBranch = await ProxyService.strategy.branch(
      serverId: request.mainBranchId!,
    );
    if (sourceBranch == null) {
      throw Exception('Source branch not found');
    }

    final variantBranch = VariantBranch(
      variantId: variant.id,
      newVariantId: newVariantId,
      sourceBranchId: sourceBranch.id,
      destinationBranchId: request.branch!.id,
    );

    await ProxyService.strategy.create<VariantBranch>(data: variantBranch);

    return createdVariant;
  }

  Future<void> _updateMainBranchStock({
    required String variantId,
    required int approvedQuantity,
    required bool isDeducting,
  }) async {
    try {
      final Variant? variant = await ProxyService.strategy.getVariant(
        id: variantId,
      );

      if (variant?.stock == null) {
        talker.error('Stock not found for variant: $variantId');
        throw Exception('Stock not found');
      }

      final double currentStock = variant!.stock!.currentStock!;
      final double updatedStock = isDeducting
          ? (currentStock - approvedQuantity.toDouble())
          : (currentStock + approvedQuantity.toDouble());

      await ProxyService.strategy.updateStock(
        stockId: variant.stock!.id,
        currentStock: updatedStock,
        value: updatedStock * variant.retailPrice!,
        rsdQty: updatedStock,
        lastTouched: DateTime.now().toUtc(),
        ebmSynced: false,
      );
    } catch (e, s) {
      talker.error('Error updating main branch stock', e, s);
      throw Exception('Failed to update main branch stock');
    }
  }

  void _showSnackBar({
    required String message,
    required BuildContext context,
    bool isError = false,
  }) {
    if (context.mounted) {
      if (isError) {
        showErrorNotification(context, message);
      } else {
        showSuccessNotification(context, message);
      }
    }
  }
}

class _ItemApprovalResult {
  const _ItemApprovalResult({required this.ok, this.line});

  final bool ok;
  final BranchTransferApprovedLine? line;
}

class _PartialApprovalResult {
  const _PartialApprovalResult({required this.ok, this.lines = const []});

  final bool ok;
  final List<BranchTransferApprovedLine> lines;
}
