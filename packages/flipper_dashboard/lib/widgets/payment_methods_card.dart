import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PaymentMethodsCard extends StatefulHookConsumerWidget {
  const PaymentMethodsCard({
    Key? key,
    required this.transactionId,
    required this.totalPayable,
    this.isCardView = true,
  }) : super(key: key);

  final String transactionId;
  final double totalPayable;
  final bool isCardView;

  @override
  _PaymentMethodsCardState createState() => _PaymentMethodsCardState();
}

class _PaymentMethodsCardState extends ConsumerState<PaymentMethodsCard> {
  bool _showPaymentMethods = false; // Toggle state for mobile

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        updatePaymentAmounts(transactionId: widget.transactionId);
      } catch (e) {
        talker.error(e);
      }
    });
  }

  void updatePaymentAmounts(
      {required String transactionId, int? focusedIndex}) {
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) return;

    double totalPayable = widget.totalPayable;
    double allocatedAmount = 0;
    int? autoFillIndex;

    // If there is more than one payment, the last one is for auto-fill
    if (payments.length > 1) {
      autoFillIndex = payments.length - 1;
      // If the user is editing the last one, we choose the first one to auto-fill
      if (focusedIndex == autoFillIndex) {
        autoFillIndex = 0;
      }
    }

    // Calculate allocated amount based on user input in other fields
    for (int i = 0; i < payments.length; i++) {
      if (i == autoFillIndex) continue;
      double amount = double.tryParse(payments[i].controller.text) ?? 0.0;
      amount = amount.clamp(0.0, totalPayable - allocatedAmount);
      payments[i].amount = amount;
      allocatedAmount += amount;
    }

    // Set the amount for the auto-fill field
    if (autoFillIndex != null) {
      final remaining =
          (totalPayable - allocatedAmount).clamp(0.0, double.infinity);
      payments[autoFillIndex].amount = remaining;
      // Update the controller text only if it's not being edited
      if (focusedIndex != autoFillIndex) {
        final newText = remaining.toStringAsFixed(2);
        if (payments[autoFillIndex].controller.text != newText) {
          payments[autoFillIndex].controller.text = newText;
        }
      }
    } else if (payments.length == 1) {
      // If only one payment, it should be the total amount
      payments[0].amount = totalPayable;
      if (focusedIndex != 0) {
        final newText = totalPayable.toStringAsFixed(2);
        if (payments[0].controller.text != newText) {
          payments[0].controller.text = newText;
        }
      }
    }

    // Update all payment methods in the provider
    for (int i = 0; i < payments.length; i++) {
      ref.read(paymentMethodsProvider.notifier).updatePaymentMethod(
            i,
            payments[i],
            transactionId: transactionId,
          );
    }
  }

  void _addPaymentMethod({required String transactionId}) {
    final payments = ref.read(paymentMethodsProvider);
    final selectedMethods = payments.map((p) => p.method).toSet();

    String? newMethod;
    for (final method in paymentTypes) {
      if (!selectedMethods.contains(method)) {
        newMethod = method;
        break;
      }
    }

    if (newMethod != null) {
      ref
          .read(paymentMethodsProvider.notifier)
          .addPaymentMethod(Payment(amount: 0.0, method: newMethod));
      updatePaymentAmounts(transactionId: transactionId);
    }
  }

  void _removePaymentMethod(int index, {required String transactionId}) {
    ref.read(paymentMethodsProvider.notifier).removePaymentMethod(index);
    updatePaymentAmounts(transactionId: transactionId);
  }

  List<String> _getAvailablePaymentMethods(int index) {
    final payments = ref.watch(paymentMethodsProvider);
    final currentMethod = payments[index].method;

    final otherSelectedMethods = <String>{};
    for (int i = 0; i < payments.length; i++) {
      if (i != index) {
        otherSelectedMethods.add(payments[i].method);
      }
    }

    final availableMethods = paymentTypes.toSet().where((method) {
      return !otherSelectedMethods.contains(method);
    }).toList();

    if (!availableMethods.contains(currentMethod)) {
      availableMethods.add(currentMethod);
    }

    return availableMethods;
  }

  Widget _getPaymentMethodIcon(String paymentMethod) {
    IconData icon;
    Color color;

    switch (paymentMethod.toUpperCase()) {
      case 'CASH':
        icon = Icons.money;
        color = Colors.green[600]!;
        break;
      case 'CREDIT CARD':
        icon = Icons.credit_card;
        color = Colors.blue[600]!;
        break;
      case 'DEBIT&CREDIT CARD':
        icon = Icons.payment;
        color = Colors.purple[600]!;
        break;
      case 'MOBILE MONEY':
        icon = Icons.phone_android;
        color = Colors.orange[600]!;
        break;
      case 'BANK CHECK':
        icon = Icons.account_balance;
        color = Colors.indigo[600]!;
        break;
      default:
        icon = Icons.payment;
        color = Colors.grey[600]!;
    }

    return Icon(
      icon,
      size: 16,
      color: color,
    );
  }

  // Mobile-optimized layout (vertical stacking)
  Widget _buildMobilePaymentMethodRow(int index,
      {required String transactionId}) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with remove button
            if (index > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Method ${index + 1}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _removePaymentMethod(index,
                          transactionId: transactionId),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red[300]!, width: 1),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.red[50],
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.red[600],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            if (index > 0) SizedBox(height: 12),

            // Payment method label
            Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6),

            // Payment method dropdown (full width)
            Container(
              width: double.infinity,
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: ref.watch(paymentMethodsProvider)[index].method,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                    size: 20,
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                  items: _getAvailablePaymentMethods(index).map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Row(
                        children: [
                          _getPaymentMethodIcon(value),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              value,
                              overflow: TextOverflow.visible,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      final payment = ref.read(paymentMethodsProvider)[index];
                      final newPayment = Payment(
                        amount: payment.amount,
                        method: newValue,
                        id: payment.id,
                        controller: payment.controller,
                      );
                      ref
                          .read(paymentMethodsProvider.notifier)
                          .updatePaymentMethod(index, newPayment,
                              transactionId: transactionId);
                      ProxyService.box
                          .writeString(key: 'paymentType', value: newValue);
                      final paymentMethodCode =
                          ProxyService.box.paymentMethodCode(newValue);
                      ProxyService.box.writeString(
                          key: 'pmtTyCd', value: paymentMethodCode);
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 16),

            // Amount label
            Text(
              'Amount',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 6),

            // Amount field (full width)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: TextFormField(
                controller: ref.watch(paymentMethodsProvider)[index].controller,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                  ),
                  prefix: Text(
                    '${ProxyService.box.defaultCurrency()} ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  updatePaymentAmounts(
                    transactionId: widget.transactionId,
                    focusedIndex: index,
                  );
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Desktop/tablet layout (horizontal layout)
  Widget _buildDesktopPaymentMethodRow(int index,
      {required String transactionId}) {
    final isLast = index == ref.watch(paymentMethodsProvider).length - 1;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: Colors.grey[200]!, width: 0.5),
        ),
      ),
      child: Padding(
        padding: widget.isCardView
            ? EdgeInsets.all(16)
            : EdgeInsets.only(bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 44,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: ref.watch(paymentMethodsProvider)[index].method,
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                        items: _getAvailablePaymentMethods(index).map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                _getPaymentMethodIcon(value),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    value,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            final payment =
                                ref.read(paymentMethodsProvider)[index];
                            final newPayment = Payment(
                              amount: payment.amount,
                              method: newValue,
                              id: payment.id,
                              controller: payment.controller,
                            );
                            ref
                                .read(paymentMethodsProvider.notifier)
                                .updatePaymentMethod(index, newPayment,
                                    transactionId: transactionId);
                            ProxyService.box.writeString(
                                key: 'paymentType', value: newValue);
                            final paymentMethodCode =
                                ProxyService.box.paymentMethodCode(newValue);
                            ProxyService.box.writeString(
                                key: 'pmtTyCd', value: paymentMethodCode);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.white,
                    ),
                    child: TextFormField(
                      controller:
                          ref.watch(paymentMethodsProvider)[index].controller,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        prefix: Text(
                          '${ProxyService.box.defaultCurrency()} ',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      onChanged: (value) {
                        updatePaymentAmounts(
                          transactionId: widget.transactionId,
                          focusedIndex: index,
                        );
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            Container(
              width: 36,
              height: 36,
              child: index == 0
                  ? SizedBox()
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => _removePaymentMethod(index,
                            transactionId: transactionId),
                        child: Container(
                          decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.red[300]!, width: 1),
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.red[50],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.red[600],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to determine if we should use mobile layout
  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCardView ? _buildCardView() : _buildListView();
  }

  Widget _buildCardView() {
    final isMobile = _isMobile(context);
    final payments = ref.watch(paymentMethodsProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with toggle for mobile
          Row(
            children: [
              Icon(
                Icons.payment,
                color: Colors.blue[600],
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Payment Methods',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Spacer(),
              if (payments.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${payments.length} method${payments.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              // Toggle button for mobile only
              if (isMobile) ...[
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(
                    _showPaymentMethods
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blue[600],
                  ),
                  onPressed: () {
                    setState(() {
                      _showPaymentMethods = !_showPaymentMethods;
                    });
                  },
                ),
              ],
            ],
          ),

          // Payment methods content - conditionally shown on mobile
          if ((!isMobile || _showPaymentMethods) &&
              payments.isNotEmpty) ...[
            SizedBox(height: 16),
            if (isMobile) ...[
              // Mobile layout - stacked vertically
              for (int i = 0; i < payments.length; i++)
                _buildMobilePaymentMethodRow(i,
                    transactionId: widget.transactionId),
            ] else ...[
              // Desktop layout - table format
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Column(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Payment Method',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Amount',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          SizedBox(width: 48),
                        ],
                      ),
                    ),
                    for (int i = 0;
                        i < payments.length;
                        i++)
                      _buildDesktopPaymentMethodRow(i,
                          transactionId: widget.transactionId),
                  ],
                ),
              ),
            ],
          ],

          // Add payment method button - always visible
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () =>
                  _addPaymentMethod(transactionId: widget.transactionId),
              icon: Icon(
                Icons.add,
                size: 18,
                color: Colors.blue[600],
              ),
              label: Text(
                'Add Payment Method',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue[600],
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.blue[300]!, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                backgroundColor: Colors.blue[50],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    final isMobile = _isMobile(context);
    final payments = ref.watch(paymentMethodsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Payment Methods',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Spacer(),
            // Toggle button for mobile only in list view
            if (isMobile)
              IconButton(
                icon: Icon(
                  _showPaymentMethods
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 20,
                ),
                onPressed: () {
                  setState(() {
                    _showPaymentMethods = !_showPaymentMethods;
                  });
                },
              ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '${payments.length} method${payments.length != 1 ? 's' : ''}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),

        // Conditionally show payment methods on mobile
        if ((!isMobile || _showPaymentMethods) &&
            payments.isNotEmpty) ...[
          SizedBox(height: 16),
          if (isMobile) ...[
            // Mobile layout - stacked vertically
            for (int i = 0; i < payments.length; i++)
              _buildMobilePaymentMethodRow(i,
                  transactionId: widget.transactionId),
          ] else ...[
            // Desktop layout - table format
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Amount',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                for (int i = 0;
                    i < payments.length;
                    i++)
                  _buildDesktopPaymentMethodRow(i,
                      transactionId: widget.transactionId),
              ],
            ),
          ],
        ],

        SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () =>
                _addPaymentMethod(transactionId: widget.transactionId),
            icon: Icon(Icons.add, size: 18),
            label: Text('Add Payment Method'),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}