import 'package:flipper_models/helperModels/talker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';

mixin StockRequestApprovalLogic {
  Future<void> approveRequest(
      {required StockRequest request, required BuildContext context}) async {
    List<TransactionItem> itemsNeedingApproval = [];
    bool isFullyApproved = true;

    for (var item in request.items) {
      if (await _canApproveItem(item: item)) {
        _approveItem(
            item: item, subBranchId: request.subBranchId!, context: context);
      } else {
        isFullyApproved = false;
        itemsNeedingApproval.add(item);
      }
    }
    // TODO: re-implement this as using request.items.first.variantId! is not the right way.
    Variant? variant = await ProxyService.strategy
        .getVariant(id: request.items.first.variantId!);

    if (!isFullyApproved) {
      bool partialApprovalResult = await _handlePartialApproval(
          variant: variant!,
          items: itemsNeedingApproval,
          request: request,
          context: context);
      if (!partialApprovalResult) return;
    }

    if (!_atLeastOneItemApproved(request: request)) {
      _showSnackBar(
          message: 'At least one item must be approved', context: context);
      return;
    }

    _finalizeApproval(
        request: request, isFullyApproved: isFullyApproved, context: context);
  }

  Future<bool> _canApproveItem({required TransactionItem item}) async {
    Variant? variant = await ProxyService.strategy.getVariant(
      id: item.variantId!,
    );
    return variant != null &&
        variant.stock!.currentStock! >= item.quantityRequested!;
  }

  Future<void> _approveItem(
      {required TransactionItem item,
      required int subBranchId,
      required BuildContext context}) async {
    try {
      await ProxyService.strategy.updateTransactionItem(
        transactionItemId: item.id,
        quantityApproved: item.quantityRequested,
      );
      _updateVariantBranch(
          variantId: item.variantId!, subBranchId: subBranchId);
      _updateOrCreateStock(item: item, subBranchId: subBranchId);
      _updateMainBranchStock(
          variantId: item.variantId!, approvedQuantity: item.quantityApproved!);
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
    }
  }

  void _updateVariantBranch(
      {required String variantId, required int subBranchId}) async {
    Variant? variant = await ProxyService.strategy.getVariant(id: variantId);
    if (variant != null) {
      // if (!variant.branchIds.contains(subBranchId)) {
      // TODO: this logic will change in new version of flipper

      //   variant.branchIds.add(subBranchId);
      // }
    }
  }

  void _updateOrCreateStock(
      {required TransactionItem item, required int subBranchId}) async {
    Variant? variant = await ProxyService.strategy.getVariant(
      id: item.variantId!,
    );

    /// stock for this item should be available in our location then creating item in new location
    /// we check that this item is not from location we would like to copy it to.
    if (variant!.stock == null) {
      ProxyService.strategy.createNewStock(
          item: item, variant: variant, subBranchId: subBranchId);
    } else {
      _updateExistingStock(stock: variant.stock!, item: item, variant: variant);
    }
  }

  Future<void> _updateExistingStock(
      {required Stock stock,
      required TransactionItem item,
      required Variant variant}) async {
    await ProxyService.strategy.updateStock(
      stockId: stock.id,
      currentStock: stock.currentStock! + item.quantityRequested!.toDouble(),
      rsdQty: stock.rsdQty! + item.quantityRequested!.toDouble(),
      value: (stock.currentStock! * variant.retailPrice!),
      ebmSynced: false,
    );
  }

  Future<bool> _handlePartialApproval(
      {required List<TransactionItem> items,
      required StockRequest request,
      required Variant variant,
      required BuildContext context}) async {
    bool partialApprovalResult = await _showPartialApprovalDialog(
        variant: variant, items: items, request: request, context: context);
    if (!partialApprovalResult) {
      _showSnackBar(message: 'Approval cancelled', context: context);
      return false;
    }
    return true;
  }

  bool _atLeastOneItemApproved({required StockRequest request}) {
    return request.items.any((item) => (item.quantityApproved ?? 0) > 0);
  }

  Future<void> _finalizeApproval(
      {required StockRequest request,
      required bool isFullyApproved,
      required BuildContext context}) async {
    await ProxyService.strategy.updateStockRequest(
        stockRequestId: request.id,
        updatedAt: DateTime.now(),
        status: isFullyApproved
            ? RequestStatus.approved
            : RequestStatus.partiallyApproved);
    _showSnackBar(
        message:
            'Request #${request.id} has been ${isFullyApproved ? "fully" : "partially"} approved',
        context: context);
  }

  void _showSnackBar({required String message, required BuildContext context}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<bool> _showPartialApprovalDialog(
      {required List<TransactionItem> items,
      required StockRequest request,
      required Variant variant,
      required BuildContext context}) async {
    List<int?> approvedQuantities = List.filled(items.length, null);

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Partial Approval',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildDialogContent(
                variant: variant,
                items: items,
                approvedQuantities: approvedQuantities),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              FilledButton.tonal(
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  minimumSize: Size(100, 40),
                ),
                child: Text(
                  'Approve',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                onPressed: () => _handleApproveButtonPress(
                  items: items,
                  approvedQuantities: approvedQuantities,
                  request: request,
                  context: context,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildDialogContent(
      {required List<TransactionItem> items,
      required List<int?> approvedQuantities,
      required Variant variant}) {
    return Container(
      width: double.maxFinite,
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
              itemBuilder: (context, index) => _buildItemCard(
                  variant: variant,
                  item: items[index],
                  approvedQuantities: approvedQuantities,
                  index: index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      {required TransactionItem item,
      required List<int?> approvedQuantities,
      required Variant variant,
      required int index}) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                // A Row to contain "Requested" and "Approved" texts
                Row(
                  children: [
                    Text('Requested: ${item.quantityRequested}'),
                    SizedBox(width: 16),
                    Text('Approved: ${item.quantityApproved}'),
                  ],
                ),
                Spacer(),
                Text('Available: ${variant.stock!.currentStock}'),
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              initialValue:
                  (variant.stock!.currentStock! < item.quantityRequested!
                          ? variant.stock!.currentStock
                          : item.quantityRequested)
                      .toString(),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: 'Approve Quantity',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              ),
              onChanged: (value) => _updateApprovedQuantity(
                  value: value,
                  availableStock: variant.stock!.currentStock!,
                  approvedQuantities: approvedQuantities,
                  index: index),
            ),
          ],
        ),
      ),
    );
  }

  void _updateApprovedQuantity(
      {required String value,
      required double availableStock,
      required List<int?> approvedQuantities,
      required int index}) {
    int? approvedQty = int.tryParse(value);
    if (approvedQty != null && approvedQty <= availableStock) {
      approvedQuantities[index] = approvedQty;
    }
  }

  Future<void> _handleApproveButtonPress(
      {required List<TransactionItem> items,
      required List<int?> approvedQuantities,
      required StockRequest request,
      required BuildContext context}) async {
    if (approvedQuantities.any((qty) => qty != null && qty > 0)) {
      for (int i = 0; i < items.length; i++) {
        if (approvedQuantities[i] != null) {
          await _processApprovedItem(
              item: items[i],
              approvedQuantity: approvedQuantities[i]!,
              request: request);
        }
      }
      Navigator.of(context).pop(true);
    } else {
      _showSnackBar(
          message: 'Please approve at least one item', context: context);
    }
  }

  Future<void> _processApprovedItem(
      {required TransactionItem item,
      required int approvedQuantity,
      required StockRequest request}) async {
    // item.quantityApproved = approvedQuantity;
    await ProxyService.strategy.updateTransactionItem(
      transactionItemId: item.id,
      quantityApproved: approvedQuantity,
    );
    _updateVariantBranch(
        variantId: item.variantId!, subBranchId: request.subBranchId!);
    _updateStockForApprovedItem(
        item: item,
        approvedQuantity: approvedQuantity,
        subBranchId: request.subBranchId!);
  }

  void _updateStockForApprovedItem(
      {required TransactionItem item,
      required int approvedQuantity,
      required int subBranchId}) async {
    Variant? variant =
        await ProxyService.strategy.getVariant(id: item.variantId!);
    if (variant == null) return;

    if (variant.stock == null) {
      _createNewStockForApprovedItem(
          item: item,
          variant: variant,
          approvedQuantity: approvedQuantity,
          subBranchId: subBranchId);
    } else {
      _updateExistingStockForApprovedItem(
          stock: variant.stock!,
          variant: variant,
          approvedQuantity: approvedQuantity);
    }

    _updateMainBranchStock(
        variantId: item.variantId!, approvedQuantity: approvedQuantity);
  }

  void _createNewStockForApprovedItem(
      {required TransactionItem item,
      required Variant variant,
      required int approvedQuantity,
      required int subBranchId}) {
    ProxyService.strategy.saveStock(
      rsdQty: approvedQuantity.toDouble(),
      currentStock: approvedQuantity.toDouble(),
      value: (approvedQuantity * variant.retailPrice!).toDouble(),
      productId: variant.productId!,
      variantId: variant.id,
      branchId: variant.branchId!,
    );
  }

  void _updateExistingStockForApprovedItem(
      {required Stock stock,
      required Variant variant,
      required int approvedQuantity}) {
    stock.lastTouched = DateTime.now();
    stock.currentStock = stock.currentStock! + approvedQuantity.toDouble();
    stock.rsdQty = stock.rsdQty! + approvedQuantity.toDouble();
    stock.value = (stock.currentStock! * variant.retailPrice!);
  }

  Future<void> _updateMainBranchStock(
      {required String variantId, required int approvedQuantity}) async {
    Variant? mainBranchStock = await ProxyService.strategy.getVariant(
      id: variantId,
    );

    if (mainBranchStock != null) {
      mainBranchStock.stock!.currentStock =
          mainBranchStock.stock!.currentStock! - approvedQuantity.toDouble();
      mainBranchStock.lastTouched = DateTime.now();
    }
  }
}
