import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/providers/mpos_momo_phone_provider.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_card.dart';
import 'package:flipper_models/providers/digital_payment_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum MposPayChip { cash, momo, credit }

/// Payment chips + cash tender UI; drives [paymentMethodsProvider].
class MposPaymentSection extends ConsumerStatefulWidget {
  const MposPaymentSection({
    super.key,
    required this.transactionId,
    required this.totalPayable,
  });

  final String transactionId;
  final double totalPayable;

  @override
  ConsumerState<MposPaymentSection> createState() => _MposPaymentSectionState();
}

class _MposPaymentSectionState extends ConsumerState<MposPaymentSection>
    with TransactionComputationMixin {
  MposPayChip _chip = MposPayChip.cash;
  late final TextEditingController _momoPhoneController;
  final FocusNode _cashAmountFocus = FocusNode();
  bool _userEditedCashAmount = false;

  static const _chipMethods = {
    MposPayChip.cash: 'CASH',
    MposPayChip.momo: 'MOBILE MONEY',
    MposPayChip.credit: 'CREDIT',
  };

  void _syncAmountsFromTotal() {
    if (_chip == MposPayChip.credit) {
      _setCreditAmount();
      return;
    }

    if (_cashAmountFocus.hasFocus || _userEditedCashAmount) return;

    final txn = ref.read(transactionByIdProvider(widget.transactionId)).value;
    if (txn == null || widget.totalPayable <= 0) return;

    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) {
      ref
          .read(paymentMethodsProvider.notifier)
          .addPaymentMethod(
            Payment(
              amount: widget.totalPayable,
              method: _chipMethods[_chip]!,
              controller: TextEditingController(
                text: widget.totalPayable.round().toString(),
              ),
            ),
          );
      return;
    }

    final alreadyPaid = txn.cashReceived ?? 0.0;
    updatePaymentRemainder(
      ref: ref,
      transaction: txn,
      total: widget.totalPayable + alreadyPaid,
      lastAutoSetAmount: payments.first.amount,
    );
  }

  @override
  void initState() {
    super.initState();
    _momoPhoneController = TextEditingController(
      text: ProxyService.box.currentSaleCustomerPhoneNumber() ?? '',
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncChipFromProvider();
      _syncAmountsFromTotal();
    });
  }

  @override
  void dispose() {
    _momoPhoneController.dispose();
    _cashAmountFocus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(MposPaymentSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.totalPayable != widget.totalPayable) {
      if (!_cashAmountFocus.hasFocus) {
        _userEditedCashAmount = false;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _syncAmountsFromTotal();
      });
    }
  }

  void _syncChipFromProvider() {
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) return;
    final m = payments.first.method.toUpperCase();
    if (m == 'CASH') {
      setState(() => _chip = MposPayChip.cash);
    } else if (m == 'CREDIT' || m == 'CASH/CREDIT') {
      setState(() => _chip = MposPayChip.credit);
    } else if (m.contains('MOMO') || m.contains('MOBILE')) {
      setState(() => _chip = MposPayChip.momo);
    } else if (m.contains('CARD')) {
      // Legacy card rows on a resumed sale → credit chip in mobile POS.
      setState(() => _chip = MposPayChip.credit);
    } else {
      setState(() => _chip = MposPayChip.cash);
    }
  }

  void _setCreditAmount() {
    if (widget.totalPayable <= 0) return;
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) {
      ref
          .read(paymentMethodsProvider.notifier)
          .addPaymentMethod(
            Payment(
              amount: widget.totalPayable,
              method: _chipMethods[MposPayChip.credit]!,
              controller: TextEditingController(
                text: widget.totalPayable.round().toString(),
              ),
            ),
          );
      return;
    }
    final p = payments.first;
    final text = widget.totalPayable.round().toString();
    if (p.controller.text != text) {
      p.controller.text = text;
    }
    ref
        .read(paymentMethodsProvider.notifier)
        .updatePaymentMethod(
          0,
          Payment(
            amount: widget.totalPayable,
            method: _chipMethods[MposPayChip.credit]!,
            id: p.id,
            controller: p.controller,
          ),
          transactionId: widget.transactionId,
        );
  }

  void _selectChip(MposPayChip chip) {
    setState(() => _chip = chip);
    if (chip == MposPayChip.cash) {
      _userEditedCashAmount = false;
    } else if (chip == MposPayChip.credit) {
      _userEditedCashAmount = false;
    }
    final method = _chipMethods[chip]!;
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) {
      ref
          .read(paymentMethodsProvider.notifier)
          .addPaymentMethod(
            Payment(amount: widget.totalPayable, method: method),
          );
    } else {
      final p = payments.first;
      ref
          .read(paymentMethodsProvider.notifier)
          .updatePaymentMethod(
            0,
            Payment(
              amount: p.amount,
              method: method,
              id: p.id,
              controller: p.controller,
            ),
            transactionId: widget.transactionId,
          );
    }
    ProxyService.box.writeString(key: 'paymentType', value: method);
    if (chip == MposPayChip.credit) {
      _setCreditAmount();
    } else {
      _syncAmountsFromTotal();
    }
  }

  void _setTender(double amount) {
    _userEditedCashAmount = true;
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) return;
    final p = payments.first;
    final text = amount.round().toString();
    if (p.controller.text != text) {
      p.controller.text = text;
    }
    ref
        .read(paymentMethodsProvider.notifier)
        .updatePaymentMethod(
          0,
          Payment(
            amount: amount,
            method: p.method,
            id: p.id,
            controller: p.controller,
          ),
          transactionId: widget.transactionId,
        );
  }

  void _onCashAmountChanged(String value) {
    _userEditedCashAmount = true;
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) return;
    final p = payments.first;
    final amount = double.tryParse(value) ?? 0.0;
    if ((p.amount - amount).abs() < 0.01) return;
    ref
        .read(paymentMethodsProvider.notifier)
        .updatePaymentMethod(
          0,
          Payment(
            amount: amount,
            method: p.method,
            id: p.id,
            controller: p.controller,
          ),
          transactionId: widget.transactionId,
        );
  }

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(paymentMethodsProvider);
    final digitalEnabled =
        ref.watch(isDigitalPaymentEnabledProvider).asData?.value ?? false;

    final tender = payments.isNotEmpty
        ? double.tryParse(payments.first.controller.text) ?? 0.0
        : 0.0;

    return MposCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
            child: Row(
              children: [
                _PayChip(
                  label: FLocalization.of(context).cash,
                  icon: Icons.payments_outlined,
                  selected: _chip == MposPayChip.cash,
                  onTap: () => _selectChip(MposPayChip.cash),
                ),
                const SizedBox(width: 9),
                _PayChip(
                  label: 'MoMo',
                  icon: Icons.phone_android_rounded,
                  selected: _chip == MposPayChip.momo,
                  onTap: () => _selectChip(MposPayChip.momo),
                ),
                const SizedBox(width: 9),
                _PayChip(
                  label: FLocalization.of(context).credit,
                  icon: Icons.account_balance_wallet_outlined,
                  selected: _chip == MposPayChip.credit,
                  onTap: () => _selectChip(MposPayChip.credit),
                ),
              ],
            ),
          ),
          if (_chip == MposPayChip.momo) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    FLocalization.of(context).momoPayerPhone,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: PosTokens.ink2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: PosTokens.surface2,
                      borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                      border: Border.all(color: PosTokens.line, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14),
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: PosTokens.blue,
                            size: 20,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _momoPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: '078X XXX XXX',
                              border: InputBorder.none,
                            ),
                            onChanged: (v) {
                              final digits = v.replaceAll(RegExp(r'\D'), '');
                              ref.read(mposMomoPhoneProvider.notifier).state =
                                  digits;
                              ProxyService.box.writeString(
                                key: 'currentSaleCustomerPhoneNumber',
                                value: digits,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    FLocalization.of(context).momoPaymentRequestHint,
                    style: TextStyle(fontSize: 12, color: PosTokens.ink3),
                  ),
                ],
              ),
            ),
          ],
          if (_chip == MposPayChip.cash) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: PosTokens.surface2,
                      borderRadius: BorderRadius.circular(MposTokens.radiusMd),
                      border: Border.all(color: PosTokens.line, width: 1.5),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: PosTokens.line),
                            ),
                          ),
                          child: const Text(
                            'RWF',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: PosTokens.ink3,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: payments.isNotEmpty
                                ? payments.first.controller
                                : null,
                            focusNode: _cashAmountFocus,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            style: mposMonoStyle(
                              Theme.of(context).textTheme,
                              fontSize: 20,
                            ),
                            decoration: const InputDecoration(
                              hintText: '0',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                            ),
                            onChanged: _onCashAmountChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _QuickCash(
                        label: FLocalization.of(context).exact,
                        selected: tender.round() == widget.totalPayable.round(),
                        onTap: () => _setTender(widget.totalPayable),
                      ),
                      const SizedBox(width: 8),
                      _QuickCash(
                        label: mposMoneyLabel(5000),
                        selected: tender.round() == 5000,
                        onTap: () => _setTender(5000),
                      ),
                      const SizedBox(width: 8),
                      _QuickCash(
                        label: mposMoneyLabel(10000),
                        selected: tender.round() == 10000,
                        onTap: () => _setTender(10000),
                      ),
                      const SizedBox(width: 8),
                      _QuickCash(
                        label: mposMoneyLabel(20000),
                        selected: tender.round() == 20000,
                        onTap: () => _setTender(20000),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (_chip == MposPayChip.credit) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Credit amount · ${mposMoneyLabel(widget.totalPayable)}',
                    style: mposMonoStyle(
                      Theme.of(context).textTheme,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'This sale is recorded on the customer\'s credit balance. '
                    'Attach a customer before completing.',
                    style: TextStyle(fontSize: 12, color: PosTokens.ink3),
                  ),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 8),
          if (digitalEnabled && payments.length > 1)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Text(
                '${payments.length} payment lines · use split in desktop mode',
                style: const TextStyle(fontSize: 12, color: PosTokens.ink3),
              ),
            ),
        ],
      ),
    );
  }
}

class _PayChip extends StatelessWidget {
  const _PayChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? PosTokens.blueTint : PosTokens.surface,
        borderRadius: BorderRadius.circular(MposTokens.radiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(MposTokens.radiusMd),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 13),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(MposTokens.radiusMd),
              border: Border.all(
                color: selected ? PosTokens.blue : PosTokens.line,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: selected ? PosTokens.blue : PosTokens.ink2,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: selected ? PosTokens.blue : PosTokens.ink2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickCash extends StatelessWidget {
  const _QuickCash({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? PosTokens.blueTint : PosTokens.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: selected ? PosTokens.blue : PosTokens.line,
              ),
            ),
            child: Text(
              label,
              style: mposMonoStyle(
                Theme.of(context).textTheme,
                fontSize: 12.5,
                fontWeight: FontWeight.w700,
                color: selected ? PosTokens.blue : PosTokens.ink2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
