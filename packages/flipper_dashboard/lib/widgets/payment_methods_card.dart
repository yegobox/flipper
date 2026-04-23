import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

class PaymentMethodsCard extends StatefulHookConsumerWidget {
  const PaymentMethodsCard({
    Key? key,
    required this.transactionId,
    required this.totalPayable,
    this.isCardView = true,
  }) : assert(totalPayable >= 0, 'totalPayable must be non-negative'),
       super(key: key);

  final String transactionId;
  final double totalPayable;
  final bool isCardView;

  @override
  _PaymentMethodsCardState createState() => _PaymentMethodsCardState();
}

class _PaymentMethodsCardState extends ConsumerState<PaymentMethodsCard>
    with TransactionComputationMixin {
  bool _showPaymentMethods = false; // Toggle state for mobile
  Set<int> _userEditedFields =
      {}; // Track which fields user has manually edited
  double? _cachedNonCreditPaid;

  @override
  void initState() {
    super.initState();
    _loadNonCreditPaid();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        updatePaymentAmounts(transactionId: widget.transactionId);
      } catch (e) {
        talker.error(e);
      }
    });
  }

  Future<void> _loadNonCreditPaid() async {
    final paid = await fetchNonCreditPaid(widget.transactionId);
    if (mounted && paid > 0) {
      setState(() => _cachedNonCreditPaid = paid);
    }
  }

  @override
  void didUpdateWidget(PaymentMethodsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-update payment amounts when totalPayable changes
    if (oldWidget.totalPayable != widget.totalPayable) {
      talker.warning(
        "PaymentMethodsCard: Total changed from ${oldWidget.totalPayable} to ${widget.totalPayable}",
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updatePaymentAmounts(
          transactionId: widget.transactionId,
          oldTotalPayable: oldWidget.totalPayable,
        );
      });
    }
  }

  void updatePaymentAmounts({
    required String transactionId,
    int? focusedIndex,
    double? oldTotalPayable,
    ITransaction? transaction,
  }) {
    final payments = ref.read(paymentMethodsProvider);
    double totalPayable = widget.totalPayable;

    if (totalPayable == 0) return;

    if (payments.isEmpty) {
      // [totalPayable] is already outstanding (sale total − recorded non-credit paid).
      // Do not subtract [alreadyPaid] again via calculateCurrentRemainder.
      final initialAmount = totalPayable;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref
            .read(paymentMethodsProvider.notifier)
            .addPaymentMethod(
              Payment(
                amount: initialAmount,
                method: "Cash",
                controller: TextEditingController(
                  text: initialAmount.toString(),
                ),
              ),
            );
      });
      return;
    }

    if (payments.length == 1) {
      final bool shouldAutoUpdate =
          focusedIndex == null && !_userEditedFields.contains(0);

      if (shouldAutoUpdate) {
        final effectiveTransaction =
            transaction ??
            ref.read(transactionByIdProvider(transactionId)).value;

        if (effectiveTransaction != null) {
          final alreadyPaid =
              _cachedNonCreditPaid ?? effectiveTransaction.cashReceived ?? 0.0;
          updatePaymentRemainder(
            ref: ref,
            transaction: effectiveTransaction,
            total: totalPayable + alreadyPaid,
            overrideAlreadyPaid: _cachedNonCreditPaid,
            lastAutoSetAmount: oldTotalPayable ?? payments[0].amount,
            onAutoSetAmountChanged: (amount) {
              // No local state to update here, the mixin handles the provider
            },
          );
        }
      } else {
        // Manual update logic
        final newAmount = double.tryParse(payments[0].controller.text) ?? 0.0;
        if (newAmount != payments[0].amount) {
          ref
              .read(paymentMethodsProvider.notifier)
              .updatePaymentMethod(
                0,
                Payment(
                  amount: newAmount,
                  method: payments[0].method,
                  controller: payments[0].controller,
                  id: payments[0].id,
                ),
                transactionId: transactionId,
              );
        }
      }
    } else {
      // Multiple payment methods logic (still unique to the card for now as it involves multi-field coordination)
      double allocatedAmount = 0;
      int? autoFillIndex;

      if (payments.length > 1) {
        autoFillIndex = payments.length - 1;
        if (focusedIndex == autoFillIndex) {
          autoFillIndex = 0;
        }
      }

      for (int i = 0; i < payments.length; i++) {
        if (i == autoFillIndex) continue;
        double amount = double.tryParse(payments[i].controller.text) ?? 0.0;
        if (i == focusedIndex) {
          payments[i].amount = amount;
        } else {
          amount = amount.clamp(0.0, totalPayable - allocatedAmount);
          payments[i].amount = amount;
          // Update the controller text to match the clamped amount to avoid UI/model mismatch
          final newText = amount.toStringAsFixed(2);
          if (payments[i].controller.text != newText) {
            payments[i].controller.text = newText;
          }
        }
        allocatedAmount += amount;
      }

      if (autoFillIndex != null) {
        final remaining = (totalPayable - allocatedAmount).clamp(
          0.0,
          double.infinity,
        );
        payments[autoFillIndex].amount = remaining;
        if (focusedIndex != autoFillIndex) {
          final newText = remaining.toStringAsFixed(2);
          if (payments[autoFillIndex].controller.text != newText) {
            payments[autoFillIndex].controller.text = newText;
          }
        }
      }

      for (int i = 0; i < payments.length; i++) {
        ref
            .read(paymentMethodsProvider.notifier)
            .updatePaymentMethod(i, payments[i], transactionId: transactionId);
      }
    }
  }

  bool _hasUnusedPaymentType() {
    final selected = ref
        .read(paymentMethodsProvider)
        .map((p) => p.method)
        .toSet();
    return paymentTypes.any((m) => !selected.contains(m));
  }

  void _onAddPaymentPressed({required String transactionId}) {
    if (!_hasUnusedPaymentType()) {
      showErrorNotification(
        context,
        'All payment types are already added. Remove one to add another.',
      );
      return;
    }
    _addPaymentMethod(transactionId: transactionId);
  }

  /// Expands mobile panel when adding from collapsed state.
  void _handleAddPaymentTap({required String transactionId, required bool isMobile}) {
    if (isMobile && !_showPaymentMethods) {
      setState(() => _showPaymentMethods = true);
    }
    _onAddPaymentPressed(transactionId: transactionId);
  }

  Widget _buildCompactAddPaymentButton({required bool isMobile}) {
    final canAdd = _hasUnusedPaymentType();
    return Tooltip(
      message: canAdd
          ? 'Add payment method'
          : 'All payment types are in use — remove one to add another',
      child: Material(
        color: const Color(0xFFEFF6FF),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: canAdd
              ? () => _handleAddPaymentTap(
                    transactionId: widget.transactionId,
                    isMobile: isMobile,
                  )
              : null,
          child: const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(
              Icons.add_rounded,
              size: 22,
              color: PosLayoutBreakpoints.posAccentBlue,
            ),
          ),
        ),
      ),
    );
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
    // Clear user edited fields to allow re-balancing of remaining methods
    _userEditedFields.clear();
    ref.read(paymentMethodsProvider.notifier).removePaymentMethod(index);

    final transaction = ref.read(transactionByIdProvider(transactionId)).value;
    updatePaymentAmounts(
      transactionId: transactionId,
      transaction: transaction,
    );
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

    return Icon(icon, size: 16, color: color);
  }

  // Mobile-optimized layout (vertical stacking)
  Widget _buildMobilePaymentMethodRow(
    int index, {
    required String transactionId,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with remove button
            if (index > 0)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment ${index + 1}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _removePaymentMethod(
                        index,
                        transactionId: transactionId,
                      ),
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
            if (index > 0) const SizedBox(height: 8),

            // Payment method label
            Text(
              'Payment',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),

            // Payment method dropdown (full width)
            Container(
              width: double.infinity,
              height: 40,
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
                      final payment = ref.read(paymentMethodsProvider)[index];
                      final newPayment = Payment(
                        amount: payment.amount,
                        method: newValue,
                        id: payment.id,
                        controller: payment.controller,
                      );
                      ref
                          .read(paymentMethodsProvider.notifier)
                          .updatePaymentMethod(
                            index,
                            newPayment,
                            transactionId: transactionId,
                          );
                      ProxyService.box.writeString(
                        key: 'paymentType',
                        value: newValue,
                      );
                      final paymentMethodCode = ProxyService.box
                          .paymentMethodCode(newValue);
                      ProxyService.box.writeString(
                        key: 'pmtTyCd',
                        value: paymentMethodCode,
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Amount label
            Text(
              ref.watch(paymentMethodsProvider)[index].method == 'CASH'
                  ? 'Cash Received'
                  : 'Amount',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),

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
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
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
                    horizontal: 10,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
                onChanged: (value) {
                  // Mark this field as user-edited
                  _userEditedFields.add(index);

                  // Update the amount immediately from the text field
                  final newAmount = double.tryParse(value) ?? 0.0;
                  final payment = ref.read(paymentMethodsProvider)[index];
                  ref
                      .read(paymentMethodsProvider.notifier)
                      .updatePaymentMethod(
                        index,
                        Payment(
                          amount: newAmount,
                          method: payment.method,
                          controller: payment.controller,
                          id: payment.id,
                        ),
                        transactionId: widget.transactionId,
                      );

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
  // Desktop/tablet layout (horizontal layout)
  Widget _buildDesktopPaymentMethodRow(
    int index, {
    required String transactionId,
  }) {
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
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              // Wrap with Flexible
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 40,
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
                        items: _getAvailablePaymentMethods(index).map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: [
                                _getPaymentMethodIcon(value),
                                SizedBox(width: 8),
                                Flexible(
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
                            final payment = ref.read(
                              paymentMethodsProvider,
                            )[index];
                            final newPayment = Payment(
                              amount: payment.amount,
                              method: newValue,
                              id: payment.id,
                              controller: payment.controller,
                            );
                            ref
                                .read(paymentMethodsProvider.notifier)
                                .updatePaymentMethod(
                                  index,
                                  newPayment,
                                  transactionId: transactionId,
                                );
                            ProxyService.box.writeString(
                              key: 'paymentType',
                              value: newValue,
                            );
                            final paymentMethodCode = ProxyService.box
                                .paymentMethodCode(newValue);
                            ProxyService.box.writeString(
                              key: 'pmtTyCd',
                              value: paymentMethodCode,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            Flexible(
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
                      controller: ref
                          .watch(paymentMethodsProvider)[index]
                          .controller,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: PosLayoutBreakpoints.posAccentBlue,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Enter amount',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                        prefix: Text(
                          '${ProxyService.box.defaultCurrency()} ',
                          style: const TextStyle(
                            color: PosLayoutBreakpoints.posAccentBlue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        _userEditedFields.add(index);
                        final newAmount = double.tryParse(value) ?? 0.0;
                        final payment = ref.read(paymentMethodsProvider)[index];
                        ref
                            .read(paymentMethodsProvider.notifier)
                            .updatePaymentMethod(
                              index,
                              Payment(
                                amount: newAmount,
                                method: payment.method,
                                controller: payment.controller,
                                id: payment.id,
                              ),
                              transactionId: widget.transactionId,
                            );

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
            const SizedBox(width: 6),
            SizedBox(
              width: 28,
              height: 28,
              child: index == 0
                  ? const SizedBox.shrink()
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => _removePaymentMethod(
                          index,
                          transactionId: transactionId,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red[300]!,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.red[50],
                          ),
                          child: Icon(
                            Icons.close,
                            size: 14,
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
  // Helper to determine if we should use mobile layout
  bool _isMobile(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width < 600;
  }

  @override
  Widget build(BuildContext context) {
    // Rebuild when the transaction updates (e.g. cashReceived) while syncing amounts via listen.
    ref.watch(transactionByIdProvider(widget.transactionId));

    // Initial load/re-synchronization
    ref.listen(transactionByIdProvider(widget.transactionId), (previous, next) {
      if (previous?.value == null && next.value != null) {
        updatePaymentAmounts(
          transactionId: widget.transactionId,
          transaction: next.value,
        );
      }
    });

    return widget.isCardView ? _buildCardView() : _buildListView();
  }

  Widget _buildCardView() {
    final isMobile = _isMobile(context);
    final payments = ref.watch(paymentMethodsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title row: collapse (mobile) · label · count · spacer · add (+)
          Row(
            children: [
              if (isMobile)
                IconButton(
                  key: const Key('mobile_toggle_button'),
                  icon: Icon(
                    _showPaymentMethods
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: scheme.primary,
                    size: 22,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  visualDensity: VisualDensity.compact,
                  onPressed: () {
                    setState(() => _showPaymentMethods = !_showPaymentMethods);
                  },
                ),
              Text(
                'Payments',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
              ),
              if (payments.isNotEmpty) ...[
                const SizedBox(width: 6),
                Text(
                  '${payments.length}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
              const Spacer(),
              _buildCompactAddPaymentButton(isMobile: isMobile),
            ],
          ),

          // Body: rows (desktop always; mobile when expanded)
          if (!isMobile || _showPaymentMethods) ...[
            if (payments.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 2, left: 2),
                child: Text(
                  'Tap + to split across methods',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              )
            else ...[
              const SizedBox(height: 8),
              if (isMobile)
                for (int i = 0; i < payments.length; i++)
                  _buildMobilePaymentMethodRow(
                    i,
                    transactionId: widget.transactionId,
                  )
              else
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE5E7EB),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                'METHOD',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'AMOUNT',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(width: 28),
                          ],
                        ),
                      ),
                      for (int i = 0; i < payments.length; i++)
                        _buildDesktopPaymentMethodRow(
                          i,
                          transactionId: widget.transactionId,
                        ),
                    ],
                  ),
                ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildListView() {
    final isMobile = _isMobile(context);
    final payments = ref.watch(paymentMethodsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            if (isMobile)
              IconButton(
                icon: Icon(
                  _showPaymentMethods
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 22,
                  color: scheme.primary,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  setState(() => _showPaymentMethods = !_showPaymentMethods);
                },
              ),
            Text(
              'Payments',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (payments.isNotEmpty) ...[
              const SizedBox(width: 6),
              Text(
                '${payments.length}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            const Spacer(),
            _buildCompactAddPaymentButton(isMobile: isMobile),
          ],
        ),
        if (!isMobile || _showPaymentMethods) ...[
          if (payments.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Tap + to add a method',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            const SizedBox(height: 8),
            if (isMobile)
              for (int i = 0; i < payments.length; i++)
                _buildMobilePaymentMethodRow(
                  i,
                  transactionId: widget.transactionId,
                )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Method',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Amount',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  for (int i = 0; i < payments.length; i++)
                    _buildDesktopPaymentMethodRow(
                      i,
                      transactionId: widget.transactionId,
                    ),
                ],
              ),
          ],
        ],
      ],
    );
  }
}
