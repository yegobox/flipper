import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/payment_method_labels.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
    if (mounted) {
      setState(() => _cachedNonCreditPaid = paid);
    }
  }

  @override
  void didUpdateWidget(PaymentMethodsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-update payment amounts when totalPayable changes
    if (oldWidget.totalPayable != widget.totalPayable) {
      // Stale Ditto stream can briefly report a lower total while qty +/- is
      // still optimistic — do not downgrade auto-filled tender (QuickSellingView
      // owns received-amount sync during that window).
      if (widget.totalPayable < oldWidget.totalPayable - 0.01) {
        final payments = ref.read(paymentMethodsProvider);
        if (payments.length == 1 &&
            (payments[0].amount - oldWidget.totalPayable).abs() <= 0.01) {
          return;
        }
      }
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
          final alreadyPaid = _cachedNonCreditPaid ?? 0.0;
          updatePaymentRemainder(
            ref: ref,
            transaction: effectiveTransaction,
            total: totalPayable + alreadyPaid,
            overrideAlreadyPaid: alreadyPaid,
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
        context.flipperL10n.allPaymentTypesAdded,
      );
      return;
    }
    _addPaymentMethod(transactionId: transactionId);
  }

  /// Expands mobile panel when adding from collapsed state.
  void _handleAddPaymentTap({
    required String transactionId,
    required bool isMobile,
  }) {
    if (isMobile && !_showPaymentMethods) {
      setState(() => _showPaymentMethods = true);
    }
    _onAddPaymentPressed(transactionId: transactionId);
  }

  Widget _buildCompactAddPaymentButton({required bool isMobile}) {
    final canAdd = _hasUnusedPaymentType();
    final accent = PosLayoutBreakpoints.posAccentBlue;
    return Tooltip(
      message: canAdd
          ? context.flipperL10n.splitAcrossAnotherMethod
          : context.flipperL10n.allPaymentTypesInUse,
      child: Material(
        color: canAdd ? PosTokens.blueTint : PosTokens.surface2,
        borderRadius: BorderRadius.circular(999),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: canAdd
              ? () => _handleAddPaymentTap(
                  transactionId: widget.transactionId,
                  isMobile: isMobile,
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(9, 5, 11, 5),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.add_rounded,
                  size: 17,
                  color: canAdd ? accent : PosTokens.ink4,
                ),
                const SizedBox(width: 3),
                Text(
                  context.flipperL10n.split,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                    color: canAdd ? accent : PosTokens.ink4,
                  ),
                ),
              ],
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

  /// Icon + accent for a payment method. Purely presentational — every entry in
  /// [paymentTypes] gets its own colour so a split payment is scannable at a
  /// glance instead of a column of identical grey rows.
  ({IconData icon, Color color}) _methodVisual(String paymentMethod) {
    switch (paymentMethod.toUpperCase()) {
      case 'CASH':
        return (icon: Icons.payments_rounded, color: const Color(0xFF16A34A));
      case 'CREDIT':
        return (icon: Icons.schedule_rounded, color: const Color(0xFFE08600));
      case 'CASH/CREDIT':
        return (icon: Icons.call_split_rounded, color: const Color(0xFF0891B2));
      case 'BANK CHECK':
        return (
          icon: Icons.account_balance_rounded,
          color: const Color(0xFF4F46E5),
        );
      case 'CREDIT CARD':
      case 'DEBIT&CREDIT CARD':
        return (
          icon: Icons.credit_card_rounded,
          color: const Color(0xFF7C3AED),
        );
      case 'MOBILE MONEY':
        return (
          icon: Icons.phone_android_rounded,
          color: const Color(0xFF2563EB),
        );
      case 'MTN MOMO':
        return (icon: Icons.smartphone_rounded, color: const Color(0xFFCA8A04));
      case 'AIRTEL MONEY':
        return (icon: Icons.smartphone_rounded, color: const Color(0xFFDC2626));
      default:
        return (icon: Icons.payment_rounded, color: PosTokens.ink2);
    }
  }

  Widget _getPaymentMethodIcon(String paymentMethod) {
    final visual = _methodVisual(paymentMethod);
    return Icon(visual.icon, size: 16, color: visual.color);
  }

  /// Shared method-change handler — identical for every layout.
  void _onMethodChanged(
    int index,
    String newValue, {
    required String transactionId,
  }) {
    final payment = ref.read(paymentMethodsProvider)[index];
    final newPayment = Payment(
      amount: payment.amount,
      method: newValue,
      id: payment.id,
      controller: payment.controller,
    );
    ref
        .read(paymentMethodsProvider.notifier)
        .updatePaymentMethod(index, newPayment, transactionId: transactionId);
    ProxyService.box.writeString(key: 'paymentType', value: newValue);
    final paymentMethodCode = ProxyService.box.paymentMethodCode(newValue);
    ProxyService.box.writeString(key: 'pmtTyCd', value: paymentMethodCode);
  }

  /// Shared amount-change handler — identical for every layout.
  void _onAmountChanged(int index, String value) {
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
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return context.flipperL10n.pleaseEnterAnAmount;
    }
    if (double.tryParse(value) == null) {
      return context.flipperL10n.pleaseEnterValidNumber;
    }
    return null;
  }

  /// Method selector rendered as a tinted chip. Same [DropdownButton]
  /// semantics as before — only the skin changed.
  Widget _buildMethodChip(
    int index, {
    required String transactionId,
    required bool compact,
  }) {
    final method = ref.watch(paymentMethodsProvider)[index].method;
    final visual = _methodVisual(method);
    final options = _getAvailablePaymentMethods(index);

    return Tooltip(
      message: method,
      waitDuration: const Duration(milliseconds: 600),
      child: Container(
        height: compact ? 44 : 40,
        padding: const EdgeInsets.symmetric(horizontal: 9),
        decoration: BoxDecoration(
          color: visual.color.withValues(alpha: 0.09),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: visual.color.withValues(alpha: 0.24)),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            isDense: true,
            value: method,
            borderRadius: BorderRadius.circular(10),
            focusColor: Colors.transparent,
            icon: Icon(
              Icons.expand_more_rounded,
              size: 18,
              color: visual.color.withValues(alpha: 0.8),
            ),
            style: TextStyle(fontSize: 13, color: visual.color),
            // Collapsed state: coloured icon + method, tinted to match.
            selectedItemBuilder: (context) => options.map((value) {
              final selectedVisual = _methodVisual(value);
              return Row(
                children: [
                  Icon(
                    selectedVisual.icon,
                    size: compact ? 17 : 16,
                    color: selectedVisual.color,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      paymentMethodDisplayName(context.flipperL10n, value),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: compact ? 12.5 : 12.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.1,
                        color: selectedVisual.color,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Row(
                  children: [
                    _getPaymentMethodIcon(value),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        paymentMethodDisplayName(context.flipperL10n, value),
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
                _onMethodChanged(index, newValue, transactionId: transactionId);
              }
            },
          ),
        ),
      ),
    );
  }

  /// Amount cell: fixed currency on the left, right-aligned figure so digits
  /// line up across split rows. Height is intentionally unconstrained so
  /// validator text can push the row taller instead of overflowing.
  Widget _buildAmountCell(int index, {required bool compact}) {
    final payment = ref.watch(paymentMethodsProvider)[index];
    return Container(
      decoration: BoxDecoration(
        color: PosTokens.surface2,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: PosTokens.line),
      ),
      padding: EdgeInsets.only(left: compact ? 10 : 9),
      child: Row(
        children: [
          Text(
            ProxyService.box.defaultCurrency(),
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: PosTokens.ink3,
            ),
          ),
          Expanded(
            child: Semantics(
              label: payment.method == 'CASH'
                  ? context.flipperL10n.cashReceived
                  : context.flipperL10n.amount,
              child: TextFormField(
                controller: payment.controller,
                textAlign: TextAlign.right,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                style: TextStyle(
                  fontSize: compact ? 17 : 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: PosLayoutBreakpoints.posAccentBlue,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: const TextStyle(
                    color: PosTokens.ink4,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(
                    6,
                    compact ? 12 : 10,
                    compact ? 12 : 10,
                    compact ? 12 : 10,
                  ),
                  isDense: true,
                ),
                onChanged: (value) => _onAmountChanged(index, value),
                validator: _validateAmount,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Remove control — only rendered for the rows that can be removed.
  Widget _buildRemoveButton(int index, {required String transactionId}) {
    return Tooltip(
      message: context.flipperL10n.removeThisPayment,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          hoverColor: PosTokens.lossTint,
          onTap: () =>
              _removePaymentMethod(index, transactionId: transactionId),
          child: const SizedBox(
            width: 30,
            height: 30,
            child: Icon(Icons.close_rounded, size: 16, color: PosTokens.ink3),
          ),
        ),
      ),
    );
  }

  /// One payment line: [method chip] [amount] [remove]. Shared by every
  /// layout so compact and wide panes stay visually identical.
  Widget _buildPaymentMethodRow(
    int index, {
    required String transactionId,
    required bool compact,
  }) {
    final showRemove = ref.watch(paymentMethodsProvider).length > 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: compact ? 1 : 3,
          child: _buildMethodChip(
            index,
            transactionId: transactionId,
            compact: compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: compact ? 1 : 4,
          child: _buildAmountCell(index, compact: compact),
        ),
        if (showRemove) ...[
          const SizedBox(width: 2),
          Padding(
            padding: EdgeInsets.only(top: compact ? 7 : 5),
            child: index == 0
                ? const SizedBox(width: 30, height: 30)
                : _buildRemoveButton(index, transactionId: transactionId),
          ),
        ],
      ],
    );
  }

  /// Vertically stacked payment lines with hairline separators.
  List<Widget> _buildPaymentRows({required bool compact}) {
    final payments = ref.watch(paymentMethodsProvider);
    final rows = <Widget>[];
    for (int i = 0; i < payments.length; i++) {
      if (i > 0) {
        rows.add(
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1, thickness: 1, color: PosTokens.line),
          ),
        );
      }
      rows.add(
        _buildPaymentMethodRow(
          i,
          transactionId: widget.transactionId,
          compact: compact,
        ),
      );
    }
    return rows;
  }

  /// Header: [collapse] Payments (n) ······················ [+ Split]
  Widget _buildHeader({required bool isMobile, required int count}) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
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
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            visualDensity: VisualDensity.compact,
            onPressed: () {
              setState(() => _showPaymentMethods = !_showPaymentMethods);
            },
          ),
        if (isMobile) const SizedBox(width: 4),
        Text(
          context.flipperL10n.payments,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
        if (count > 0) ...[
          const SizedBox(width: 7),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: PosTokens.blueTint,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$count',
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: PosTokens.blue,
              ),
            ),
          ),
        ],
        const Spacer(),
        _buildCompactAddPaymentButton(isMobile: isMobile),
      ],
    );
  }

  /// Compact payment UI when the checkout **pane** is narrow (not full window).
  bool _isCompactPane(double width) =>
      width < PosLayoutBreakpoints.mobileLayoutMaxWidth;

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

    return LayoutBuilder(
      builder: (context, constraints) {
        final paneWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final isCompact = _isCompactPane(paneWidth);
        return widget.isCardView
            ? _buildCardView(isCompact: isCompact)
            : _buildListView(isCompact: isCompact);
      },
    );
  }

  Widget _buildCardView({required bool isCompact}) {
    final isMobile = isCompact;
    final payments = ref.watch(paymentMethodsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: PosTokens.line),
      ),
      padding: const EdgeInsets.fromLTRB(10, 6, 8, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(isMobile: isMobile, count: payments.length),

          // Body: rows (desktop always; mobile when expanded)
          if (!isMobile || _showPaymentMethods) ...[
            if (payments.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, bottom: 2, left: 2),
                child: Text(
                  context.flipperL10n.tapSplitToPayWithMoreThanOneMethod,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              )
            else ...[
              const SizedBox(height: 6),
              ..._buildPaymentRows(compact: isMobile),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildListView({required bool isCompact}) {
    final isMobile = isCompact;
    final payments = ref.watch(paymentMethodsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(isMobile: isMobile, count: payments.length),
        if (!isMobile || _showPaymentMethods) ...[
          if (payments.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                context.flipperL10n.tapSplitToAddMethod,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          else ...[
            const SizedBox(height: 6),
            ..._buildPaymentRows(compact: isMobile),
          ],
        ],
      ],
    );
  }
}
