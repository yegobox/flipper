import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';

mixin StockRequestApprovalLogic {
  Future<void> approveRequest({
    required InventoryRequest request,
    required BuildContext context,
  }) async {
    try {
      _showLoadingDialog(context);

      final List<TransactionItem> items =
          await ProxyService.strategy.transactionItems(
        requestId: request.id,
      );

      if (items.isEmpty) {
        Navigator.of(context).pop();
        _showSnackBar(message: 'No items found in request', context: context);
        return;
      }

      final itemApprovalResults = await Future.wait(
        items.map((item) => _processItemApproval(
            item: item,
            request: request,
            subBranchId: request.subBranchId!,
            sourceBranchId: request.branchId!)),
      );

      final List<TransactionItem> itemsNeedingApproval = [];
      bool isFullyApproved = true;

      for (var i = 0; i < items.length; i++) {
        if (!itemApprovalResults[i]) {
          isFullyApproved = false;
          itemsNeedingApproval.add(items[i]);
        }
      }

      Navigator.of(context).pop(); // Dismiss loading

      if (!isFullyApproved) {
        final bool partialApprovalResult = await _handlePartialApproval(
          items: itemsNeedingApproval,
          request: request,
          context: context,
        );

        if (!partialApprovalResult) return;
      }

      final List<TransactionItem> approvedItems =
          await ProxyService.strategy.transactionItems(
        requestId: request.id,
      );

      if (!_atLeastOneItemApproved(approvedItems)) {
        _showSnackBar(
          message: 'At least one item must be approved',
          context: context,
          isError: true,
        );
        return;
      }

      await _finalizeApproval(
        request: request,
        isFullyApproved: isFullyApproved,
        context: context,
      );
    } catch (e, s) {
      talker.error('Error in approveRequest', e, s);
      if (context.mounted) {
        Navigator.of(context).pop(); // Ensure loading dialog is dismissed
        _showSnackBar(
          message: 'An error occurred while processing the request',
          context: context,
          isError: true,
        );
      }
    }
  }

  Future<bool> _canApproveItem({required TransactionItem item}) async {
    final Variant? variant = await ProxyService.strategy.getVariant(
      id: item.variantId!,
    );

    if (variant == null || variant.stock?.currentStock == null) {
      return false;
    }

    final double availableStock = variant.stock!.currentStock!;
    final int quantityRequested = item.quantityRequested ?? 0;
    final int quantityApproved = item.quantityApproved ?? 0;
    final int remainingQuantityToApprove = quantityRequested - quantityApproved;

    return remainingQuantityToApprove > 0 &&
        availableStock >= remainingQuantityToApprove;
  }

  Future<bool> _processItemApproval(
      {required TransactionItem item,
      required int subBranchId,
      required String sourceBranchId,
      required InventoryRequest request}) async {
    try {
      if (await _canApproveItem(item: item)) {
        await _approveItem(
          item: item,
          subBranchId: subBranchId,
          request: request,
          sourceBranchId: sourceBranchId,
        );
        return true;
      }
      return false;
    } catch (e, s) {
      talker.error('Error processing item approval', e, s);
      return false;
    }
  }

  Future<void> _approveItem({
    required TransactionItem item,
    required int subBranchId,
    required String sourceBranchId,
    required InventoryRequest request,
  }) async {
    try {
      await _processPartialApprovalItem(
        item: item,
        approvedQuantity: item.quantityRequested!,
        request: request,
      );
    } catch (e, s) {
      talker.error('Error in _approveItem', e, s);
      throw Exception('Failed to approve item');
    }
  }

  Future<Stock> _createNewStockForSharedVariant({
    required TransactionItem item,
    required Variant variant,
    required int destinationBranchId,
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

  Future<bool> _handlePartialApproval({
    required List<TransactionItem> items,
    required InventoryRequest request,
    required BuildContext context,
  }) async {
    final partialApprovalResult = await _showPartialApprovalDialog(
      items: items,
      request: request,
      context: context,
    );

    if (!partialApprovalResult) {
      _showSnackBar(
        message: 'Approval cancelled',
        context: context,
        isError: true,
      );
      return false;
    }
    return partialApprovalResult;
  }

  //Fix: Use the List<TransactionItem> that you get after approval to validate it.
  bool _atLeastOneItemApproved(List<TransactionItem> items) {
    return items.any((item) => (item.quantityApproved ?? 0) > 0);
  }

  Future<void> _finalizeApproval({
    required InventoryRequest request,
    required bool isFullyApproved,
    required BuildContext context,
  }) async {
    try {
      await ProxyService.strategy.updateStockRequest(
        stockRequestId: request.id,
        updatedAt: DateTime.now(),
        status: isFullyApproved
            ? RequestStatus.approved
            : RequestStatus.partiallyApproved,
      );

      if (context.mounted) {
        _showSnackBar(
          message:
              'Request #${request.id} has been ${isFullyApproved ? "fully" : "partially"} approved',
          context: context,
        );
      }
    } catch (e, s) {
      talker.error('Error finalizing approval', e, s);
      throw Exception('Failed to finalize approval');
    }
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
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
                          'Variant not found'); // Handle variant not found
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
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            _buildInfoRow(
              requested: item.quantityRequested ?? 0,
              approved: item.quantityApproved ?? 0,
              available: variant.stock!.currentStock!,
            ),
            SizedBox(height: 16),
            TextFormField(
              initialValue: _calculateInitialValue(
                requested: item.quantityRequested ?? 0,
                available: variant.stock!.currentStock!,
              ),
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
      child: Text(
        '$label: $value',
        style: TextStyle(fontSize: 12),
      ),
    );
  }

  String _calculateInitialValue({
    required num requested,
    required double available,
  }) {
    return (available < requested ? available : requested).toString();
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
  }) async {
    try {
      if (!approvedQuantities.any((qty) => qty != null && qty > 0)) {
        toast(
          'Please approve at least one item',
        );
        return;
      }

      _showLoadingDialog(context);

      // Process each item individually
      for (int i = 0; i < items.length; i++) {
        if (approvedQuantities[i] != null) {
          final TransactionItem item = items[i];
          final int approvedQuantity = approvedQuantities[
              i]!; // Correctly use the approved quantity from the dialog

          await _processPartialApprovalItem(
            item: item,
            approvedQuantity: approvedQuantity,
            request: request,
          );
        }
      }

      if (context.mounted) {
        Navigator.of(context).pop(); // Dismiss loading dialog
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

  Future<void> _processPartialApprovalItem({
    required TransactionItem item,
    required int approvedQuantity,
    required InventoryRequest request,
  }) async {
    try {
      final Variant? requestedVariant =
          await ProxyService.strategy.getVariant(id: item.variantId!);

      if (requestedVariant == null) {
        talker.error('Variant not found for ID: ${item.variantId!}');
        throw Exception('Variant not found');
      }

      await _handleVariantAndStockInternal(
        item: item,
        request: request,
        variant: requestedVariant,
        approvedQuantity: approvedQuantity,
      );

      // update main branch stock
      await _updateMainBranchStock(
        isDeducting: true,
        approvedQuantity: approvedQuantity,
        variantId: requestedVariant.id,
      );

      //lastly sync the transaction item to db.
      await ProxyService.strategy.updateTransactionItem(
        transactionItemId: item.id,
        quantityApproved: approvedQuantity,
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
    // Create a copy of the variant with a new ID
    final String newVariantId = const Uuid().v4();
    final String newModrId = const Uuid().v4().substring(0, 5);

    Variant newVariant;
    Variant? newM;
    Stock stock;
    VariantBranch? existingVariantOrderedBefore =
        await ProxyService.strategy.variantBranch(variantId: variant.id);
    if (existingVariantOrderedBefore != null) {
      // get actual variant
      newVariant = (await ProxyService.strategy
          .getVariant(id: existingVariantOrderedBefore.newVariantId))!;
      await _updateMainBranchStock(
        isDeducting: false,
        approvedQuantity: approvedQuantity,
        variantId: newVariant.id,
      );
    } else {
      newVariant = variant.copyWith(
          id: newVariantId,
          modrId: newModrId,
          isShared: true,
          branchId: request.subBranchId!);
      newM = await ProxyService.strategy.create<Variant>(data: newVariant);
      Branch? me =
          await ProxyService.strategy.branch(serverId: request.mainBranchId!);
      // Create VariantBranch record
      final VariantBranch variantBranch = VariantBranch(
          variantId: variant.id,
          newVariantId: newVariantId,
          sourceBranchId: me!.id,
          destinationBranchId: request.branch!.id);

      await ProxyService.strategy.create<VariantBranch>(data: variantBranch);
      stock = await _createNewStockForSharedVariant(
        item: item,
        variant: newVariant,
        destinationBranchId: request.branch!.serverId!,
      );
      if (newM != null) {
        newM.stock = stock;
        newM.stockId = stock.id;
        await ProxyService.strategy.updateVariant(updatables: [newM]);
      }
    }
    return newVariant;
  }

  Future<void> _updateMainBranchStock({
    required String variantId,
    required int approvedQuantity,
    required isDeducting,
  }) async {
    try {
      final Variant? variant = await ProxyService.strategy.getVariant(
        id: variantId,
      );

      if (variant?.stock != null) {
        final updatedStock = isDeducting
            ? (variant!.stock!.currentStock! - approvedQuantity.toDouble())
            : (variant!.stock!.currentStock! + approvedQuantity.toDouble());

        await ProxyService.strategy.updateStock(
          stockId: variant.stock!.id,
          currentStock: updatedStock,
          value: updatedStock * variant.retailPrice!,
          rsdQty: updatedStock,
          lastTouched: DateTime.now(),
          ebmSynced: false,
        );
      }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.only(
            left: 350.0,
            right: 350.0,
            bottom: 20.0,
          ),
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }
}
