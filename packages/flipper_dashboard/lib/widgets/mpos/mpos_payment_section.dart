import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_dashboard/maestro_semantics.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_dashboard/providers/mpos_momo_phone_provider.dart';
import 'package:flipper_dashboard/theme/mpos_tokens.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/utils/split_tender.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_card.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_split_rows.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/payment_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

enum MposPayChip {
  cash,
  momo,
  bank,
  card,
  credit;

  /// Settled for the exact total: no tender, no change.
  bool get isFullAmount => this == credit || this == bank || this == card;
}

/// The sale a split in [paymentMethodsProvider] was made for. The lines
/// outlive checkout (Back, Save Ticket), so a split must not be re-balanced
/// onto another cart's bill.
final mposSplitOwnerProvider = StateProvider<String?>((ref) => null);

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
    MposPayChip.momo: kMobileMoney,
    MposPayChip.bank: 'BANK CHECK',
    MposPayChip.card: 'DEBIT&CREDIT CARD',
    MposPayChip.credit: 'CREDIT',
  };

  void _syncAmountsFromTotal() {
    final current = ref.read(paymentMethodsProvider);
    if (current.length > 1) {
      // A split follows the bill: its last row absorbs the change in total.
      _applySplit(
        rebalanceSplit(mposSplitTenders(current), widget.totalPayable),
      );
      return;
    }
    if (_chip.isFullAmount) {
      _setFullAmount();
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
      if (!mounted) return;
      _dropSplitFromAnotherSale();
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

  /// Coming back to this sale keeps its split (re-balanced to the bill). A
  /// split left over from another sale starts this one on one cash line.
  void _dropSplitFromAnotherSale() {
    if (ref.read(paymentMethodsProvider).length < 2) return;
    if (ref.read(mposSplitOwnerProvider) == widget.transactionId) return;
    _applySplit([
      SplitTender(
        method: _chipMethods[MposPayChip.cash]!,
        amount: widget.totalPayable,
      ),
    ]);
    _userEditedCashAmount = false;
  }

  void _syncChipFromProvider() {
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) return;
    final m = payments.first.method.toUpperCase();
    if (m == 'CASH') {
      setState(() => _chip = MposPayChip.cash);
    } else if (m == 'CREDIT' || m == 'CASH/CREDIT') {
      setState(() => _chip = MposPayChip.credit);
    } else if (canonicalPaymentMethod(m) == kMobileMoney) {
      setState(() => _chip = MposPayChip.momo);
    } else if (m.contains('CARD')) {
      setState(() => _chip = MposPayChip.card);
    } else if (m.contains('BANK') ||
        m.contains('CHEQUE') ||
        m.contains('TRANSFER')) {
      setState(() => _chip = MposPayChip.bank);
    } else {
      setState(() => _chip = MposPayChip.cash);
    }
  }

  /// Locks the single payment line to the full total under the current chip's
  /// method (credit, bank or card).
  void _setFullAmount() {
    if (widget.totalPayable <= 0) return;
    final method = _chipMethods[_chip]!;
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) {
      ref
          .read(paymentMethodsProvider.notifier)
          .addPaymentMethod(
            Payment(
              amount: widget.totalPayable,
              method: method,
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
            method: method,
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
    } else if (chip.isFullAmount) {
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
    if (chip.isFullAmount) {
      _setFullAmount();
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

  /// Chip order doubles as the order split rows pick their next method in.
  List<String> get _splitMethods => _chipMethods.values.toList();

  /// Turns the single line into a split, or adds one more tender to it.
  void _addSplitTender() {
    final payments = ref.read(paymentMethodsProvider);
    if (payments.isEmpty) return;
    final next = addSplitTender(
      mposSplitTenders(payments),
      widget.totalPayable,
      methods: _splitMethods,
    );
    if (next != null) _applySplit(next);
  }

  void _onSplitAmountChanged(int index, String raw) {
    final tenders = mposSplitTenders(ref.read(paymentMethodsProvider));
    if (index >= tenders.length) return;
    tenders[index] = tenders[index].copyWith(amount: double.tryParse(raw) ?? 0);
    _applySplit(
      rebalanceSplit(tenders, widget.totalPayable, editedIndex: index),
      editedIndex: index,
    );
  }

  void _onSplitMethodChanged(int index, String method) {
    final tenders = mposSplitTenders(ref.read(paymentMethodsProvider));
    if (index >= tenders.length) return;
    tenders[index] = tenders[index].copyWith(method: method);
    _applySplit(tenders);
  }

  void _removeSplitTender(int index) {
    final tenders = mposSplitTenders(ref.read(paymentMethodsProvider));
    if (index >= tenders.length) return;
    FocusScope.of(context).unfocus();
    _applySplit(removeSplitTender(tenders, index, widget.totalPayable));
  }

  /// Writes [tenders] into [paymentMethodsProvider], keeping each row's id and
  /// controller. The row being typed into keeps its text so the caret stays.
  /// Down to one tender, the chips come back on that tender's method.
  void _applySplit(List<SplitTender> tenders, {int? editedIndex}) {
    final old = ref.read(paymentMethodsProvider);
    final next = <Payment>[
      for (var i = 0; i < tenders.length; i++)
        Payment(
          amount: tenders[i].amount,
          method: tenders[i].method,
          id: i < old.length ? old[i].id : null,
          controller: i < old.length ? old[i].controller : null,
        ),
    ];
    for (var i = 0; i < next.length; i++) {
      if (i == editedIndex) continue;
      final text = next[i].amount <= 0 ? '' : next[i].amount.round().toString();
      if (next[i].controller.text != text) next[i].controller.text = text;
    }
    ref.read(paymentMethodsProvider.notifier).setPaymentMethods(next);
    if (next.length > 1) {
      ref.read(mposSplitOwnerProvider.notifier).state = widget.transactionId;
    }
    if (next.length == 1) {
      _userEditedCashAmount = true;
      _syncChipFromProvider();
      if (_chip.isFullAmount || _chip == MposPayChip.momo) _setFullAmount();
    }
  }

  String _fullAmountTitle(BuildContext context) {
    final l10n = context.flipperL10n;
    final amount = mposMoneyLabel(widget.totalPayable);
    return switch (_chip) {
      MposPayChip.bank => '${l10n.paymentsTypeBank} · $amount',
      MposPayChip.card => '${l10n.paymentsTypeCard} · $amount',
      _ => l10n.mposCreditAmount(amount),
    };
  }

  String _fullAmountExplanation(BuildContext context) {
    final l10n = context.flipperL10n;
    return switch (_chip) {
      MposPayChip.bank => l10n.mposBankExplanation,
      MposPayChip.card => l10n.mposCardExplanation,
      _ => l10n.mposCreditExplanation,
    };
  }

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(paymentMethodsProvider);
    // Lines collapsed elsewhere (Charge saves a split net of change and can
    // drop an all-change cash row): the chips must follow the line left.
    ref.listen(paymentMethodsProvider, (prev, next) {
      if ((prev?.length ?? 0) > 1 && next.length == 1) _syncChipFromProvider();
    });
    final tender = payments.isNotEmpty
        ? double.tryParse(payments.first.controller.text) ?? 0.0
        : 0.0;

    final isSplit = payments.length > 1;
    final showMomoPhone = isSplit
        ? mposHasMomoTender(payments)
        : _chip == MposPayChip.momo;

    return MposCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isSplit)
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 4),
              child: MposSplitRows(
                payments: payments,
                total: widget.totalPayable,
                methods: _splitMethods,
                labelFor: (m) => mposTenderLabel(context.flipperL10n, m),
                onAmountChanged: _onSplitAmountChanged,
                onMethodChanged: _onSplitMethodChanged,
                onRemove: _removeSplitTender,
                onAdd: _addSplitTender,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
              child: Row(
                children: [
                  _PayChip(
                    semanticId: MaestroIds.mposPaymentCash,
                    label: context.flipperL10n.cash,
                    icon: Icons.payments_outlined,
                    selected: _chip == MposPayChip.cash,
                    onTap: () => _selectChip(MposPayChip.cash),
                  ),
                  const SizedBox(width: 6),
                  _PayChip(
                    semanticId: MaestroIds.mposPaymentMomo,
                    label: 'MoMo',
                    icon: Icons.phone_android_rounded,
                    selected: _chip == MposPayChip.momo,
                    onTap: () => _selectChip(MposPayChip.momo),
                  ),
                  const SizedBox(width: 6),
                  _PayChip(
                    semanticId: MaestroIds.mposPaymentBank,
                    label: context.flipperL10n.paymentsTypeBank,
                    icon: Icons.account_balance_outlined,
                    selected: _chip == MposPayChip.bank,
                    onTap: () => _selectChip(MposPayChip.bank),
                  ),
                  const SizedBox(width: 6),
                  _PayChip(
                    semanticId: MaestroIds.mposPaymentCard,
                    label: context.flipperL10n.paymentsTypeCard,
                    icon: Icons.credit_card_rounded,
                    selected: _chip == MposPayChip.card,
                    onTap: () => _selectChip(MposPayChip.card),
                  ),
                  const SizedBox(width: 6),
                  _PayChip(
                    semanticId: MaestroIds.mposPaymentCredit,
                    label: context.flipperL10n.credit,
                    icon: Icons.account_balance_wallet_outlined,
                    selected: _chip == MposPayChip.credit,
                    onTap: () => _selectChip(MposPayChip.credit),
                  ),
                ],
              ),
            ),
          if (showMomoPhone) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.flipperL10n.momoPayerPhone,
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
                          child: MaestroSemantics(
                            id: MaestroIds.mposPaymentMomoPhone,
                            label: context.flipperL10n.mposMomoPhoneNumber,
                            textField: true,
                            enabled: true,
                            child: TextField(
                              key: const Key(MaestroIds.mposPaymentMomoPhone),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.flipperL10n.momoPaymentRequestHint,
                    style: TextStyle(fontSize: 12, color: PosTokens.ink3),
                  ),
                ],
              ),
            ),
          ],
          if (!isSplit && _chip == MposPayChip.cash) ...[
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
                          child: MaestroSemantics(
                            id: MaestroIds.mposPaymentCashAmount,
                            label: context.flipperL10n.mposCashReceivedAmount,
                            textField: true,
                            enabled: true,
                            child: TextField(
                              key: const Key(MaestroIds.mposPaymentCashAmount),
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _QuickCash(
                        semanticId: MaestroIds.mposPaymentQuickExact,
                        label: context.flipperL10n.exact,
                        selected: tender.round() == widget.totalPayable.round(),
                        onTap: () => _setTender(widget.totalPayable),
                      ),
                      const SizedBox(width: 8),
                      _QuickCash(
                        semanticId: MaestroIds.mposPaymentQuick5000,
                        label: mposMoneyLabel(5000),
                        selected: tender.round() == 5000,
                        onTap: () => _setTender(5000),
                      ),
                      const SizedBox(width: 8),
                      _QuickCash(
                        semanticId: MaestroIds.mposPaymentQuick10000,
                        label: mposMoneyLabel(10000),
                        selected: tender.round() == 10000,
                        onTap: () => _setTender(10000),
                      ),
                      const SizedBox(width: 8),
                      _QuickCash(
                        semanticId: MaestroIds.mposPaymentQuick20000,
                        label: mposMoneyLabel(20000),
                        selected: tender.round() == 20000,
                        onTap: () => _setTender(20000),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ] else if (!isSplit && _chip.isFullAmount) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _fullAmountTitle(context),
                    style: mposMonoStyle(
                      Theme.of(context).textTheme,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _fullAmountExplanation(context),
                    style: const TextStyle(fontSize: 12, color: PosTokens.ink3),
                  ),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 8),
          if (!isSplit && payments.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: const Key('mposSplitPayment'),
                  onPressed: _addSplitTender,
                  icon: const Icon(Icons.call_split_rounded, size: 18),
                  label: Text(context.flipperL10n.paymentsSplitPayment),
                  style: TextButton.styleFrom(
                    foregroundColor: PosTokens.blue,
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PayChip extends StatelessWidget {
  const _PayChip({
    required this.semanticId,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String semanticId;
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaestroSemantics(
        id: semanticId,
        label: label,
        button: true,
        enabled: true,
        selected: selected,
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
                  // Five chips share a phone-width row: shrink long
                  // translations (sw "Fedha taslimu") instead of wrapping.
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: selected ? PosTokens.blue : PosTokens.ink2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickCash extends StatelessWidget {
  const _QuickCash({
    required this.semanticId,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String semanticId;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaestroSemantics(
        id: semanticId,
        label: label,
        button: true,
        enabled: true,
        selected: selected,
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
      ),
    );
  }
}
