import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';

mixin StockRequestApprovalLogic {
  Future<void> approveRequest(
      {required StockRequest request, required BuildContext context}) async {
    List<TransactionItem> itemsNeedingApproval = [];
    bool isFullyApproved = true;

    ProxyService.realm.realm!.write(() {
      for (var item in request.items) {
        if (_canApproveItem(item: item)) {
          _approveItem(
              item: item, subBranchId: request.subBranchId!, context: context);
        } else {
          isFullyApproved = false;
          itemsNeedingApproval.add(item);
        }
      }
    });

    if (!isFullyApproved) {
      bool partialApprovalResult = await _handlePartialApproval(
          items: itemsNeedingApproval, request: request, context: context);
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

  bool _canApproveItem({required TransactionItem item}) {
    Stock? stock = ProxyService.realm.stockByVariantId(
      variantId: item.variantId!,
      branchId: ProxyService.box.getBranchId()!,
    );
    return stock != null && stock.currentStock >= item.quantityRequested!;
  }

  void _approveItem(
      {required TransactionItem item,
      required int subBranchId,
      required BuildContext context}) {
    item.quantityApproved = item.quantityRequested;
    _updateVariantBranch(variantId: item.variantId!, subBranchId: subBranchId);
    _updateOrCreateStock(
        item: item, subBranchId: subBranchId, context: context);
    _updateMainBranchStock(
        variantId: item.variantId!, approvedQuantity: item.quantityApproved!);
  }

  void _updateVariantBranch(
      {required int variantId, required int subBranchId}) {
    Variant? variant = ProxyService.realm.getVariantById(id: variantId);
    if (variant != null) {
      if (!variant.branchIds.contains(subBranchId)) {
        variant.branchIds.add(subBranchId);
      }
    }
  }

  void _updateOrCreateStock(
      {required TransactionItem item,
      required int subBranchId,
      required BuildContext context}) {
    Stock? stock = ProxyService.realm.stockByVariantId(
      variantId: item.variantId!,
      branchId: subBranchId,
    );
    Variant? variant = ProxyService.realm.getVariantById(id: item.variantId!);

    if (stock == null) {
      _createNewStock(
          item: item,
          variant: variant!,
          subBranchId: subBranchId,
          context: context);
    } else {
      _updateExistingStock(stock: stock, item: item, variant: variant!);
    }
  }

  void _createNewStock(
      {required TransactionItem item,
      required Variant variant,
      required int subBranchId,
      required BuildContext context}) {
    final newStock = Stock(
      ObjectId(),
      id: randomNumber(),
      lastTouched: DateTime.now(),
      branchId: subBranchId,
      variantId: variant.id!,
      action: AppActions.created,
      retailPrice: variant.retailPrice,
      supplyPrice: variant.supplyPrice,
      currentStock: item.quantityRequested!.toDouble(),
      rsdQty: item.quantityRequested!.toDouble(),
      value: (item.quantityRequested! * variant.retailPrice).toDouble(),
      productId: variant.productId,
      active: false,
    );
    ProxyService.realm.realm!.add(newStock);
  }

  void _updateExistingStock(
      {required Stock stock,
      required TransactionItem item,
      required Variant variant}) {
    stock.lastTouched = DateTime.now();
    stock.currentStock =
        stock.currentStock + item.quantityRequested!.toDouble();
    stock.rsdQty = stock.rsdQty + item.quantityRequested!.toDouble();
    stock.value = (stock.currentStock * variant.retailPrice);
    stock.action = AppActions.updated;
  }

  Future<bool> _handlePartialApproval(
      {required List<TransactionItem> items,
      required StockRequest request,
      required BuildContext context}) async {
    bool partialApprovalResult = await _showPartialApprovalDialog(
        items: items, request: request, context: context);
    if (!partialApprovalResult) {
      _showSnackBar(message: 'Approval cancelled', context: context);
      return false;
    }
    return true;
  }

  bool _atLeastOneItemApproved({required StockRequest request}) {
    return request.items.any((item) => (item.quantityApproved ?? 0) > 0);
  }

  void _finalizeApproval(
      {required StockRequest request,
      required bool isFullyApproved,
      required BuildContext context}) {
    ProxyService.realm.realm!.write(() {
      request.status = isFullyApproved
          ? RequestStatus.approved
          : RequestStatus.partiallyApproved;
      request.updatedAt = DateTime.now();
    });
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
      required BuildContext context}) async {
    List<int?> approvedQuantities = List.filled(items.length, null);

    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Partial Approval',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: _buildDialogContent(
                items: items, approvedQuantities: approvedQuantities),
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
      required List<int?> approvedQuantities}) {
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
      required int index}) {
    Stock? stock = ProxyService.realm.stockByVariantId(
      variantId: item.variantId!,
      branchId: ProxyService.box.getBranchId()!,
    );
    double availableStock = stock?.currentStock ?? 0;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.name ?? 'Unknown Item',
                style: TextStyle(fontWeight: FontWeight.bold)),
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
                Text('Available: $availableStock'),
              ],
            ),
            SizedBox(height: 12),
            TextFormField(
              initialValue: (availableStock < item.quantityRequested!
                      ? availableStock
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
                  availableStock: availableStock,
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

  void _handleApproveButtonPress(
      {required List<TransactionItem> items,
      required List<int?> approvedQuantities,
      required StockRequest request,
      required BuildContext context}) {
    if (approvedQuantities.any((qty) => qty != null && qty > 0)) {
      ProxyService.realm.realm!.write(() {
        for (int i = 0; i < items.length; i++) {
          if (approvedQuantities[i] != null) {
            _processApprovedItem(
                item: items[i],
                approvedQuantity: approvedQuantities[i]!,
                request: request);
          }
        }
      });
      Navigator.of(context).pop(true);
    } else {
      _showSnackBar(
          message: 'Please approve at least one item', context: context);
    }
  }

  void _processApprovedItem(
      {required TransactionItem item,
      required int approvedQuantity,
      required StockRequest request}) {
    item.quantityApproved = approvedQuantity;
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
      required int subBranchId}) {
    Variant? variant = ProxyService.realm.getVariantById(id: item.variantId!);
    if (variant == null) return;

    Stock? stock = ProxyService.realm
        .stockByVariantId(variantId: item.variantId!, branchId: subBranchId);
    if (stock == null) {
      _createNewStockForApprovedItem(
          item: item,
          variant: variant,
          approvedQuantity: approvedQuantity,
          subBranchId: subBranchId);
    } else {
      _updateExistingStockForApprovedItem(
          stock: stock, variant: variant, approvedQuantity: approvedQuantity);
    }

    _updateMainBranchStock(
        variantId: item.variantId!, approvedQuantity: approvedQuantity);
  }

  void _createNewStockForApprovedItem(
      {required TransactionItem item,
      required Variant variant,
      required int approvedQuantity,
      required int subBranchId}) {
    final newStock = Stock(
      ObjectId(),
      id: randomNumber(),
      lastTouched: DateTime.now(),
      branchId: variant.branchId!,
      variantId: variant.id!,
      action: AppActions.created,
      retailPrice: variant.retailPrice,
      supplyPrice: variant.supplyPrice,
      currentStock: approvedQuantity.toDouble(),
      rsdQty: approvedQuantity.toDouble(),
      value: (approvedQuantity * variant.retailPrice).toDouble(),
      productId: variant.productId,
      active: false,
    );
    ProxyService.realm.realm!.add(newStock);
  }

  void _updateExistingStockForApprovedItem(
      {required Stock stock,
      required Variant variant,
      required int approvedQuantity}) {
    stock.lastTouched = DateTime.now();
    stock.currentStock = stock.currentStock + approvedQuantity.toDouble();
    stock.rsdQty = stock.rsdQty + approvedQuantity.toDouble();
    stock.value = (stock.currentStock * variant.retailPrice);
    stock.action = AppActions.updated;
  }

  void _updateMainBranchStock(
      {required int variantId, required int approvedQuantity}) {
    Stock? mainBranchStock = ProxyService.realm.stockByVariantId(
      variantId: variantId,
      branchId: ProxyService.box.getBranchId()!,
    );
    Variant? variant = ProxyService.realm.getVariantById(id: variantId);

    if (mainBranchStock != null) {
      mainBranchStock.currentStock =
          mainBranchStock.currentStock - approvedQuantity.toDouble();
      mainBranchStock.lastTouched = DateTime.now();
      mainBranchStock.action = AppActions.updated;
      variant!.qty = mainBranchStock.currentStock;
      variant.rsdQty = mainBranchStock.currentStock;
    }
  }
}
