// ignore_for_file: unused_result

import 'package:flipper_dashboard/SearchCustomer.dart';
import 'package:flipper_dashboard/widgets/payment_methods_card.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldProvider;
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'dart:async';

class BottomSheets {
  static void showBottom({
    required BuildContext context,
    required WidgetRef ref,
    required Function doneDelete,
    required Function onCharge,
    String? transactionId,
  }) {
    if (transactionId == null) {
      return; // Handle null case
    }

    WoltModalSheet.show<void>(
      onModalDismissedWithBarrierTap: () {
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        Navigator.of(context).pop();
      },
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            isTopBarLayerAlwaysVisible: false,
            hasSabGradient: false,
            hasTopBarLayer: false,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Container(
                    padding: EdgeInsets.only(left: 90, right: 90),
                    child: Row(
                      children: [
                        Text(
                          'Complete Your Sale',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[200]),
                  // Content
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _BottomSheetContent(
                        transactionIdInt: transactionId,
                        doneDelete: doneDelete,
                        onCharge: onCharge,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
    );
  }
}

class _BottomSheetContent extends ConsumerStatefulWidget {
  const _BottomSheetContent(
      {required this.transactionIdInt,
      required this.doneDelete,
      required this.onCharge});
  final String transactionIdInt;
  final Function doneDelete;
  final Function onCharge;

  @override
  ConsumerState<_BottomSheetContent> createState() =>
      _BottomSheetContentState();
}

class _BottomSheetContentState extends ConsumerState<_BottomSheetContent>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  late final TextEditingController _customerPhoneController;
  String? _customerPhoneError;
  late AnimationController _buttonAnimationController;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _customerPhoneController = TextEditingController(
      text: ProxyService.box.currentSaleCustomerPhoneNumber(),
    );

    _buttonAnimationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _buttonScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _buttonAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _customerPhoneController.dispose();
    _buttonAnimationController.dispose();
    super.dispose();
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a phone number';
    }
    // Must be 9 digits, starting with 7, 8, or 9, and no leading zero
    final phoneExp = RegExp(r'^[7-9]\d{8}$');
    if (!phoneExp.hasMatch(value)) {
      return 'Please enter a valid 9-digit phone number (e.g. 783054874)';
    }
    return null;
  }

  static Future<void> edit({
    required BuildContext context,
    required WidgetRef ref,
    required TransactionItem transactionItem,
    required Function doneDelete,
    required String transactionId,
  }) async {
    TextEditingController newQtyController = TextEditingController();
    newQtyController.text = transactionItem.qty.toString();

    // Create a completer to signal when the edit is complete
    final completer = Completer<bool>();

    WoltModalSheet.show<void>(
      context: context,
      pageListBuilder: (BuildContext context) {
        return [
          WoltModalSheetPage(
            hasSabGradient: false,
            isTopBarLayerAlwaysVisible: false,
            hasTopBarLayer: false,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Modal handle
                  Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  // Header
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, color: Colors.blue, size: 24),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Edit ${transactionItem.name}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey[200]),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: StatefulBuilder(
                      builder: (context, setModalState) {
                        double localQty =
                            double.tryParse(newQtyController.text) ??
                                transactionItem.qty.toDouble();
                        double localTotal = localQty * transactionItem.price;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Quantity input with improved styling
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Row(
                                children: [
                                  // Decrement button (-)
                                  IconButton(
                                    icon: Icon(Icons.remove, color: Colors.red),
                                    onPressed: () {
                                      double currentValue = double.tryParse(
                                              newQtyController.text) ??
                                          0.0;
                                      if (currentValue > 0) {
                                        newQtyController.text =
                                            (currentValue - 1).toString();
                                        if (newQtyController.text
                                            .endsWith('.0')) {
                                          newQtyController.text =
                                              newQtyController.text
                                                  .replaceAll('.0', '');
                                        }
                                        setModalState(() {});
                                      }
                                    },
                                  ),

                                  // Text field
                                  Expanded(
                                    child: TextFormField(
                                      controller: newQtyController,
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        labelText: 'Quantity',
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 16),
                                      ),
                                      onChanged: (val) {
                                        setModalState(() {
                                          // This will trigger a rebuild with updated values
                                        });
                                      },
                                    ),
                                  ),

                                  // Increment button (+)
                                  IconButton(
                                    icon: Icon(Icons.add, color: Colors.blue),
                                    onPressed: () {
                                      double currentValue = double.tryParse(
                                              newQtyController.text) ??
                                          0.0;
                                      newQtyController.text =
                                          (currentValue + 1).toString();
                                      if (newQtyController.text
                                          .endsWith('.0')) {
                                        newQtyController.text = newQtyController
                                            .text
                                            .replaceAll('.0', '');
                                      }
                                      setModalState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            // Price information card
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue[100]!),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Unit Price:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      Text(
                                        transactionItem.price.toString(),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                      Text(
                                        localTotal.toCurrencyFormatted(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 24),
                            // Action buttons
                            FlipperButton(
                              color: Colors.blue,
                              width: double.infinity,
                              text: 'Update Quantity',
                              onPressed: () async {
                                final qty =
                                    double.tryParse(newQtyController.text);
                                if (qty != null && qty != 0) {
                                  try {
                                    await ProxyService.strategy
                                        .updateTransactionItem(
                                      qty: qty,
                                      ignoreForReport: false,
                                      transactionItemId: transactionItem.id,
                                    );

                                    // Force refresh the provider
                                    await ref.refresh(transactionItemsProvider(
                                      transactionId: transactionId,
                                      branchId: ProxyService.box.getBranchId()!,
                                    ).future);

                                    // Complete with success
                                    completer.complete(true);

                                    if (Navigator.of(context).canPop())
                                      Navigator.of(context).pop();
                                  } catch (e) {
                                    completer.complete(false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Error updating quantity: ${e.toString()}')),
                                    );
                                  }
                                }
                              },
                            ),
                            SizedBox(height: 12),
                            FlipperIconButton(
                              icon: Icons.delete_outline,
                              iconColor: Colors.red[400],
                              textColor: Colors.red[400],
                              text: 'Remove Product',
                              onPressed: () {
                                ProxyService.strategy.deleteItemFromCart(
                                  transactionItemId: transactionItem,
                                  transactionId: transactionId,
                                );
                                Navigator.of(context).pop();
                                doneDelete();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ];
      },
    );

    // Wait for the edit to complete
    await completer.future;

    // Ensure the parent widget rebuilds with the updated data
    ref.invalidate(transactionItemsProvider(
      transactionId: transactionId,
      branchId: ProxyService.box.getBranchId()!,
    ));
  }

  Future<void> _handleCharge(String transactionId, double total) async {
    // Haptic feedback
    HapticFeedback.lightImpact();

    // Button animation
    _buttonAnimationController.forward().then((_) {
      _buttonAnimationController.reverse();
    });

    // Validate phone before charging
    final phoneError = _validatePhone(_customerPhoneController.text);
    setState(() {
      _customerPhoneError = phoneError;
    });
    if (phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text(phoneError)),
            ],
          ),
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });
      ref.read(oldProvider.loadingProvider.notifier).startLoading();

      await widget.onCharge(transactionId, total);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ref.read(oldProvider.loadingProvider.notifier).stopLoading();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.white),
                SizedBox(width: 8),
                Expanded(child: Text('Error: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Add a listener to the provider
    ref.listen<String?>(customerPhoneNumberProvider, (previous, next) {
      if (_customerPhoneController.text != next) {
        _customerPhoneController.text = next ?? '';
      }
    });

    final itemsAsync = ref.watch(transactionItemsProvider(
        transactionId: widget.transactionIdInt,
        branchId: ProxyService.box.getBranchId()!));

    double calculateTotal(List<TransactionItem> items) {
      return items.fold(0, (sum, item) => sum + (item.price * item.qty));
    }

    Widget _buildTransactionItem(TransactionItem transactionItem) {
      return Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.inventory_2_outlined,
              color: Colors.blue,
              size: 20,
            ),
          ),
          title: Text(
            transactionItem.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${transactionItem.price.toString()} × ${transactionItem.qty}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                (transactionItem.price * transactionItem.qty)
                    .toCurrencyFormatted(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.edit_outlined, color: Colors.blue),
                onPressed: () {
                  edit(
                    doneDelete: widget.doneDelete,
                    context: context,
                    ref: ref,
                    transactionItem: transactionItem,
                    transactionId: widget.transactionIdInt.toString(),
                  );
                },
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue[50],
                  padding: EdgeInsets.all(8),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildPhoneField() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        margin: const EdgeInsets.only(bottom: 16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  _customerPhoneError != null ? Colors.red : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: _customerPhoneController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              labelText: 'Customer Phone Number',
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
              hintText: 'Enter 9-digit phone number',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              prefixIcon: Icon(
                Icons.phone_outlined,
                color:
                    _customerPhoneError != null ? Colors.red : Colors.grey[600],
                size: 20,
              ),
              errorText: _customerPhoneError,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              counterText: '',
            ),
            onChanged: (value) {
              // Clear error when user starts typing
              if (_customerPhoneError != null && value.isNotEmpty) {
                setState(() {
                  _customerPhoneError = null;
                });
              }
            },
          ),
        ),
      );
    }

    Widget _buildItemsList(List<TransactionItem> items) {
      if (items.isEmpty) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              SizedBox(height: 16),
              Text(
                'No items in cart',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Items (${items.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          SizedBox(height: 12),
          ...items.map((item) => _buildTransactionItem(item)).toList(),
          PaymentMethodsCard(
            transactionId: widget.transactionIdInt,
            totalPayable: calculateTotal(items),
          ),
        ],
      );
    }

    Widget _buildTotalSection(List<TransactionItem> items) {
      final total = calculateTotal(items);

      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlipperButtonFlat(
                  textColor: Colors.red[600],
                  onPressed: items.isEmpty
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Clear All Items'),
                              content: Text(
                                  'Are you sure you want to remove all items from the cart?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    for (TransactionItem item in items) {
                                      ProxyService.strategy.deleteItemFromCart(
                                        transactionItemId: item,
                                        transactionId:
                                            widget.transactionIdInt.toString(),
                                      );
                                    }
                                    ref.refresh(transactionItemsProvider(
                                        transactionId: widget.transactionIdInt,
                                        branchId:
                                            ProxyService.box.getBranchId()!));
                                    widget.doneDelete();
                                    Navigator.pop(context);
                                  },
                                  child: Text('Clear All',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                  text: 'Clear All',
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      total.toCurrencyFormatted(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            AnimatedBuilder(
              animation: _buttonScaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _buttonScaleAnimation.value,
                  child: FlipperButton(
                    color: items.isEmpty ? Colors.grey : Colors.green,
                    width: double.infinity,
                    text: items.isEmpty
                        ? 'Add items to charge'
                        : 'Charge ${total.toCurrencyFormatted()}',
                    isLoading: _isLoading,
                    onPressed: items.isEmpty || _isLoading
                        ? null
                        : () => _handleCharge(
                            widget.transactionIdInt.toString(), total),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }

    Widget _buildContent(List<TransactionItem> items) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SearchInputWithDropdown(),
            SizedBox(height: 5),
            _buildPhoneField(),
            _buildItemsList(items),
            SizedBox(height: 20),
            _buildTotalSection(items),
          ],
        ),
      );
    }

    return itemsAsync.when(
      data: (items) => _buildContent(items),
      loading: () => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Loading items...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      error: (error, stack) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red[400],
              ),
              SizedBox(height: 16),
              Text(
                'Error loading items',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
