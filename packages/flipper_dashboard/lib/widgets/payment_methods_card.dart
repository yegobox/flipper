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

  void updatePaymentAmounts({required String transactionId}) {
    if (ref.read(paymentMethodsProvider).isEmpty) return;
    double remainingAmount = widget.totalPayable.clamp(0, double.infinity);
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isNotEmpty) {
      double firstAmount = double.tryParse(payments[0].controller.text) ?? 0.0;
      if (firstAmount < 0) firstAmount = 0;
      if (firstAmount > remainingAmount) firstAmount = remainingAmount;
      remainingAmount -= firstAmount;
      payments[0].amount = firstAmount;
      ref.read(paymentMethodsProvider.notifier).updatePaymentMethod(
            0,
            Payment(amount: payments[0].amount, method: payments[0].method),
            transactionId: transactionId,
          );
    }
    for (int i = 1; i < payments.length; i++) {
      if (i == payments.length - 1) {
        final last = remainingAmount.clamp(0, double.infinity);
        payments[i].amount = last.toDouble();
        payments[i].controller.text = last.toStringAsFixed(2);
      } else {
        double enteredAmount =
            double.tryParse(payments[i].controller.text) ?? 0.0;
        if (enteredAmount < 0) enteredAmount = 0;
        if (enteredAmount > remainingAmount) enteredAmount = remainingAmount;
        payments[i].amount = enteredAmount;
        remainingAmount -= enteredAmount;
      }
      ref.read(paymentMethodsProvider.notifier).updatePaymentMethod(
            i, // Positional argument
            payments[i], // Pass the existing/mutated object
            transactionId: transactionId, // Named argument
          );
    }
  }

  void _addPaymentMethod({required String transactionId}) {
    setState(() {
      ref
          .read(paymentMethodsProvider)
          .add(Payment(amount: 0.0, method: 'CASH'));

      updatePaymentAmounts(transactionId: transactionId);
    });
  }

  void _removePaymentMethod(int index, {required String transactionId}) {
    setState(() {
      ref.read(paymentMethodsProvider)[index];
      ref.read(paymentMethodsProvider.notifier).removePaymentMethod(index);
      updatePaymentAmounts(transactionId: transactionId);
    });
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
            color: Colors.grey.withValues(alpha: 0.05),
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
                  value: ref.read(paymentMethodsProvider)[index].method,
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
                  items: paymentTypes.map((String value) {
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
                      setState(() {
                        final payment = ref.read(paymentMethodsProvider)[index];
                        payment.method = newValue;
                        ref
                            .read(paymentMethodsProvider.notifier)
                            .updatePaymentMethod(
                                index, payment, // Pass the mutated object
                                transactionId: transactionId);
                        ProxyService.box
                            .writeString(key: 'paymentType', value: newValue);
                        final paymentMethodCode =
                            ProxyService.box.paymentMethodCode(newValue);
                        ProxyService.box.writeString(
                            key: 'pmtTyCd', value: paymentMethodCode);
                      });
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
                controller: ref.read(paymentMethodsProvider)[index].controller,
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
                  final amount = double.tryParse(value) ?? 0.0;
                  ref.read(paymentMethodsProvider)[index].amount = amount;

                  if (index < ref.read(paymentMethodsProvider).length - 1) {
                    updatePaymentAmounts(transactionId: transactionId);
                  }
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
    final isLast = index == ref.read(paymentMethodsProvider).length - 1;

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
                        value: ref.read(paymentMethodsProvider)[index].method,
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
                        items: paymentTypes.map((String value) {
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
                            setState(() {
                              final payment =
                                  ref.read(paymentMethodsProvider)[index];
                              payment.method =
                                  newValue; // Mutate the existing object
                              ref
                                  .read(paymentMethodsProvider.notifier)
                                  .updatePaymentMethod(
                                      index, payment, // Pass the mutated object
                                      transactionId: transactionId);
                              ProxyService.box.writeString(
                                  key: 'paymentType', value: newValue);
                              final paymentMethodCode =
                                  ProxyService.box.paymentMethodCode(newValue);
                              ProxyService.box.writeString(
                                  key: 'pmtTyCd', value: paymentMethodCode);
                            });
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
                          ref.read(paymentMethodsProvider)[index].controller,
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
                        final amount = double.tryParse(value) ?? 0.0;
                        ref.read(paymentMethodsProvider)[index].amount = amount;

                        if (index <
                            ref.read(paymentMethodsProvider).length - 1) {
                          updatePaymentAmounts(transactionId: transactionId);
                        }
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
              if (ref.read(paymentMethodsProvider).isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${ref.read(paymentMethodsProvider).length} method${ref.read(paymentMethodsProvider).length != 1 ? 's' : ''}',
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
              ref.read(paymentMethodsProvider).isNotEmpty) ...[
            SizedBox(height: 16),
            if (isMobile) ...[
              // Mobile layout - stacked vertically
              for (int i = 0; i < ref.read(paymentMethodsProvider).length; i++)
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
                        i < ref.read(paymentMethodsProvider).length;
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
          '${ref.read(paymentMethodsProvider).length} method${ref.read(paymentMethodsProvider).length != 1 ? 's' : ''}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),

        // Conditionally show payment methods on mobile
        if ((!isMobile || _showPaymentMethods) &&
            ref.read(paymentMethodsProvider).isNotEmpty) ...[
          SizedBox(height: 16),
          if (isMobile) ...[
            // Mobile layout - stacked vertically
            for (int i = 0; i < ref.read(paymentMethodsProvider).length; i++)
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
                    i < ref.read(paymentMethodsProvider).length;
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
