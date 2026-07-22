import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class BarSettleDesktopScreen extends ConsumerStatefulWidget {
  const BarSettleDesktopScreen({super.key});

  @override
  ConsumerState<BarSettleDesktopScreen> createState() =>
      _BarSettleDesktopScreenState();
}

class _BarSettleDesktopScreenState extends ConsumerState<BarSettleDesktopScreen> {
  String _method = 'Cash';
  double _tender = 0;
  bool _settling = false;
  final _tenderFocus = FocusNode();
  final _tenderController = TextEditingController(text: '0');
  final _receiptPhoneFocus = FocusNode();
  final _receiptPhoneController = TextEditingController();
  Timer? _phonePersistTimer;
  String? _phoneInitTabId;
  bool _phoneShowError = false;

  static final _rwMobilePhone = RegExp(r'^[1-9]\d{8}$');

  @override
  void dispose() {
    _phonePersistTimer?.cancel();
    _tenderFocus.dispose();
    _tenderController.dispose();
    _receiptPhoneFocus.dispose();
    _receiptPhoneController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tab = ref.read(barModeProvider).activeTab;
    if (tab == null || tab.id == _phoneInitTabId) return;
    _phoneInitTabId = tab.id;
    final fromTab = tab.customerPhone;
    final fromBox = ProxyService.box.currentSaleCustomerPhoneNumber();
    final raw = (fromTab != null && fromTab.isNotEmpty) ? fromTab : fromBox;
    if (raw != null && raw.isNotEmpty) {
      _receiptPhoneController.text = _localPhoneFromStored(raw);
    } else {
      _receiptPhoneController.clear();
    }
  }

  String _localPhoneFromStored(String raw) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length >= 12 && digits.startsWith('250')) {
      return digits.substring(3);
    }
    return digits;
  }

  String _receiptPhoneDigits() =>
      _receiptPhoneController.text.replaceAll(RegExp(r'\D'), '');

  bool _receiptPhoneIsValid() =>
      _rwMobilePhone.hasMatch(_receiptPhoneDigits());

  void _onReceiptPhoneChanged(String value, ITransaction tab) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    ProxyService.box.writeString(
      key: 'currentSaleCustomerPhoneNumber',
      value: digits,
    );
    setState(() {
      if (_receiptPhoneIsValid()) _phoneShowError = false;
    });
    _phonePersistTimer?.cancel();
    _phonePersistTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      unawaited(
        ProxyService.getStrategy(Strategy.capella).updateTransaction(
          transaction: tab,
          customerPhone: digits.isEmpty ? '' : digits,
        ),
      );
    });
  }

  void _setTender(double value) {
    final v = value < 0 ? 0.0 : value;
    setState(() => _tender = v);
    _tenderController.text = NumberFormat('#,###').format(v.round());
    _tenderController.selection = TextSelection.collapsed(
      offset: _tenderController.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bar = ref.watch(barModeProvider);
    final table = bar.activeTable;
    final tab = bar.activeTab;
    final cashier = bar.activeCashier;
    if (table == null || tab == null || cashier == null) {
      return const SizedBox.shrink();
    }

    final linesAsync = ref.watch(barTabLinesProvider(tab.id));
    final lines = linesAsync.value ?? [];
    final total = barTabTotal(lines);
    final vat = barVatBreakdown(total);
    final staff = ref.watch(barStaffProvider).value ?? [];

    final grouped = <String, List<TransactionItem>>{};
    for (final line in lines) {
      final key = line.loggedByTenantId ?? 'unknown';
      grouped.putIfAbsent(key, () => []).add(line);
    }

    final canConfirm = !_settling &&
        _receiptPhoneIsValid() &&
        (_method == 'Mobile Money' || _tender >= total - 0.01);
    final buttonLooksEnabled = canConfirm || _settling;
    final openedAt = tab.createdAt ?? DateTime.now();
    final openedTime = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(openedAt),
    );
    final elapsed = barFormatDuration(DateTime.now().difference(openedAt));

    return Container(
      color: BarTokens.posBg,
      child: Column(
        children: [
          _SettleTopBar(
            zoneName: table.zoneName,
            tableName: table.name,
            cashier: cashier,
            onBack: () =>
                ref.read(barModeProvider.notifier).setScreen(BarScreen.pos),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(28, 28, 20, 28),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: _BillSummaryCard(
                          tableName: table.name,
                          openedLabel: 'Opened $openedTime • $elapsed',
                          grouped: grouped,
                          staff: staff,
                          vat: vat,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 400,
                  decoration: const BoxDecoration(
                    color: BarTokens.surface,
                    border: Border(left: BorderSide(color: BarTokens.line)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(28, 28, 28, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Payment',
                                style: GoogleFonts.outfit(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.2,
                                  color: BarTokens.ink1,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Choose method and take payment to close the table.',
                                style: GoogleFonts.outfit(
                                  fontSize: 13.5,
                                  height: 1.35,
                                  color: BarTokens.ink3,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _PaymentMethodCard(
                                    label: 'Cash',
                                    icon: Icons.account_balance_wallet_outlined,
                                    selected: _method == 'Cash',
                                    onTap: () =>
                                        setState(() => _method = 'Cash'),
                                  ),
                                  const SizedBox(width: 12),
                                  _PaymentMethodCard(
                                    label: 'Mobile Money',
                                    icon: Icons.smartphone_outlined,
                                    selected: _method == 'Mobile Money',
                                    onTap: () => setState(
                                      () => _method = 'Mobile Money',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _ReceiptPhoneField(
                                controller: _receiptPhoneController,
                                focusNode: _receiptPhoneFocus,
                                showError: _phoneShowError,
                                onChanged: (v) =>
                                    _onReceiptPhoneChanged(v, tab),
                              ),
                              if (_method == 'Cash') ...[
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'ENTER AMOUNT TENDERED',
                                      style: GoogleFonts.outfit(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.55,
                                        color: BarTokens.ink3,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      'RWF ${NumberFormat('#,###').format(total)} due',
                                      style: GoogleFonts.outfit(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: BarTokens.ink3,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      Icons.remove,
                                      size: 14,
                                      color: BarTokens.ink4,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: BarTokens.surface,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                      color: BarTokens.blue,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _tenderController,
                                          focusNode: _tenderFocus,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          style: GoogleFonts.jetBrainsMono(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w700,
                                            color: BarTokens.ink1,
                                            height: 1.1,
                                          ),
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          onChanged: (raw) {
                                            final parsed = double.tryParse(
                                              raw.replaceAll(',', ''),
                                            );
                                            setState(
                                              () => _tender = parsed ?? 0,
                                            );
                                          },
                                        ),
                                      ),
                                      Text(
                                        'RWF',
                                        style: GoogleFonts.jetBrainsMono(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: BarTokens.ink4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    for (final chip in [
                                      (label: 'Exact', value: total),
                                      (label: '20,000', value: 20000.0),
                                      (label: '50,000', value: 50000.0),
                                      (label: '100,000', value: 100000.0),
                                    ])
                                      _QuickTenderChip(
                                        label: chip.label,
                                        onTap: () => _setTender(chip.value),
                                      ),
                                  ],
                                ),
                              ] else ...[
                                const SizedBox(height: 24),
                                Text(
                                  'A push request will be sent to the guest device.',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13.5,
                                    color: BarTokens.ink3,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(28, 0, 28, 28),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: canConfirm
                                    ? () => _confirm(
                                        ref,
                                        tab,
                                        total,
                                        lines,
                                      )
                                    : null,
                                borderRadius: BorderRadius.circular(14),
                                child: Ink(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    gradient: buttonLooksEnabled
                                        ? BarTokens.gradBtn
                                        : null,
                                    color: buttonLooksEnabled
                                        ? null
                                        : BarTokens.surface2,
                                    border: buttonLooksEnabled
                                        ? null
                                        : Border.all(color: BarTokens.line),
                                    boxShadow: buttonLooksEnabled
                                        ? [
                                            BoxShadow(
                                              color: BarTokens.blue.withValues(
                                                alpha: 0.28,
                                              ),
                                              offset: const Offset(0, 6),
                                              blurRadius: 18,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (_settling)
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: buttonLooksEnabled
                                                  ? Colors.white
                                                  : BarTokens.ink4,
                                            ),
                                          )
                                        else
                                          Icon(
                                            Icons.verified_user_outlined,
                                            color: buttonLooksEnabled
                                                ? Colors.white
                                                : BarTokens.ink4,
                                            size: 20,
                                          ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Confirm payment — RWF ${NumberFormat('#,###').format(total)}',
                                          style: GoogleFonts.outfit(
                                            color: buttonLooksEnabled
                                                ? Colors.white
                                                : BarTokens.ink4,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 15.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: BarTokens.ink4,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Closing the table saves the sale and frees it for new guests.',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12.5,
                                      height: 1.35,
                                      color: BarTokens.ink3,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(
    WidgetRef ref,
    ITransaction tab,
    double total,
    List<TransactionItem> lines,
  ) async {
    if (_settling) return;
    if (!_receiptPhoneIsValid()) {
      setState(() => _phoneShowError = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enter a valid 9-digit receipt phone number.'),
        ),
      );
      _receiptPhoneFocus.requestFocus();
      return;
    }
    setState(() => _settling = true);

    final sync = ProxyService.getStrategy(Strategy.capella);
    final cashReceived = _method == 'Cash' ? _tender : total;
    final change = (_tender - total).clamp(0, double.infinity).toDouble();
    final receiptPhone = _receiptPhoneDigits();

    try {
      ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: receiptPhone,
      );

      var txn = tab.copyWith(
        subTotal: total,
        cashReceived: cashReceived,
        customerChangeDue: change,
        paymentType: _method,
        customerPhone: receiptPhone,
      );

      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
      bool fiscalReceiptHandled = false;
      if (businessId != null && branchId != null) {
        final taxEnabled = await sync.isTaxEnabled(
          businessId: businessId,
          branchId: branchId,
        );
        final stopTax = ProxyService.box.stopTaxService() ?? false;
        final hasBhf = (await ProxyService.box.bhfId()) != null;

        if (taxEnabled && !stopTax && hasBhf) {
          final ebm = await sync.ebm(branchId: branchId);
          if (ebm?.taxServerUrl != null) {
            ProxyService.box.writeString(
              key: 'getServerUrl',
              value: ebm!.taxServerUrl!,
            );
            ProxyService.box.writeString(key: 'bhfId', value: ebm.bhfId);

            final filterType = ProxyService.box.isProformaMode()
                ? FilterType.PS
                : FilterType.NS;
            final receiptLines = await enrichBarTabLinesForRraReceipt(lines);
            final result = await TaxController(
              object: txn,
            ).handleReceipt(
              filterType: filterType,
              transactionItems: receiptLines,
            );
            if (result.response.resultCd != '000') {
              throw Exception(result.response.resultMsg);
            }
            fiscalReceiptHandled = true;
          }
        }
      }

      // Branch is not EBM-registered (or the tax checks above didn't apply):
      // there's no RRA-signed receipt, but the tab is still a real completed
      // sale, so print a plain, non-fiscal receipt instead.
      if (!fiscalReceiptHandled && lines.isNotEmpty) {
        try {
          await TaxController(object: txn).buildNonFiscalReceiptPdfBytes(
            transaction: txn,
            transactionItems: lines,
          );
        } catch (e) {
          debugPrint('Non-fiscal bar receipt print failed: $e');
        }
      }

      txn = await sync.settleBarTab(
        transaction: txn,
        paymentType: _method,
        cashReceived: cashReceived,
        customerChangeDue: change,
      );

      await sync.savePaymentType(
        singlePaymentOnly: true,
        amount: total,
        transactionId: tab.id,
        paymentMethod: _method,
        saleCompletionFastPath: true,
      );

      if (lines.isNotEmpty) {
        final allowBelow = await getIt<SettingsService>()
            .isAllowSellingBelowStock();
        final isProformaOrTraining =
            ProxyService.box.isProformaMode() ||
            ProxyService.box.isTrainingMode();
        final receiptType = ProxyService.box.isProformaMode() ? 'PS' : 'NS';
        schedulePostSaleStockDeductionAndRraSync(
          transactionItems: lines,
          allowSellingBelowStock: allowBelow,
          isProformaOrTraining: isProformaOrTraining,
          transactionId: tab.id,
          transaction: txn,
          receiptType: receiptType,
        );
      }

      if (!mounted) return;
      final tableName = ref.read(barModeProvider).activeTable?.name ?? '';
      ref.read(barModeProvider.notifier).afterSettle(
            tableName: tableName,
            message:
                '$tableName settled · RWF ${NumberFormat('#,###').format(total)} $_method',
          );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) setState(() => _settling = false);
    }
  }
}

class _SettleTopBar extends StatelessWidget {
  const _SettleTopBar({
    required this.zoneName,
    required this.tableName,
    required this.cashier,
    required this.onBack,
  });

  final String zoneName;
  final String tableName;
  final Tenant cashier;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final initials = barTenantInitials(cashier.name);
    final color = barColorForName(cashier.name ?? '?');
    final displayName = _shortName(cashier.name);

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: BarTokens.surface,
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          TextButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.chevron_left, size: 22),
            label: const Text('Back to tab'),
            style: TextButton.styleFrom(
              foregroundColor: BarTokens.ink2,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              textStyle: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: BarTokens.blue,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(
              tableName,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Settle bill · $zoneName',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              letterSpacing: -0.18,
              color: BarTokens.ink1,
            ),
          ),
          const Spacer(),
          BarCashierChip(
            name: displayName,
            role: 'Settling as manager',
            initials: initials,
            color: color,
          ),
        ],
      ),
    );
  }

  String _shortName(String? full) {
    if (full == null || full.trim().isEmpty) return 'Staff';
    final parts = full.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;
    final last = parts.last;
    final initial = last.isNotEmpty ? last[0].toUpperCase() : '';
    return '${parts.first} $initial.';
  }
}

class _BillSummaryCard extends StatelessWidget {
  const _BillSummaryCard({
    required this.tableName,
    required this.openedLabel,
    required this.grouped,
    required this.staff,
    required this.vat,
  });

  final String tableName;
  final String openedLabel;
  final Map<String, List<TransactionItem>> grouped;
  final List<Tenant> staff;
  final ({double subtotal, double vat, double total}) vat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
      decoration: BoxDecoration(
        color: BarTokens.surface,
        borderRadius: BorderRadius.circular(BarTokens.radiusLg),
        border: Border.all(color: BarTokens.line),
        boxShadow: BarTokens.shadow1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Table $tableName — running tab',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.16,
                    color: BarTokens.ink1,
                  ),
                ),
              ),
              Text(
                openedLabel,
                style: GoogleFonts.outfit(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: BarTokens.ink3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _DottedDivider(),
          const SizedBox(height: 18),
          ...grouped.entries.map((entry) {
            Tenant? tenant;
            for (final t in staff) {
              if (t.id == entry.key) {
                tenant = t;
                break;
              }
            }
            final fullName =
                tenant?.name ?? entry.value.first.loggedByName ?? 'Staff';
            final serverLabel = _serverLabel(fullName);
            final initials = barTenantInitials(fullName);
            final color = barColorForTenant(entry.key, staff);
            final sub = barTabTotal(entry.value);

            return Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          initials,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '$serverLabel · Server',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: BarTokens.ink2,
                          ),
                        ),
                      ),
                      Text(
                        'RWF ${NumberFormat('#,###').format(sub)}',
                        style: GoogleFonts.jetBrainsMono(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: BarTokens.ink2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ...entry.value.map((line) {
                    final lineTotal = line.price.toDouble() * line.qty.toDouble();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${line.qty.toInt()}× ${line.name} @ ${NumberFormat('#,###').format(line.price)}',
                              style: GoogleFonts.outfit(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w500,
                                color: BarTokens.ink2,
                                height: 1.35,
                              ),
                            ),
                          ),
                          Text(
                            NumberFormat('#,###').format(lineTotal),
                            style: GoogleFonts.jetBrainsMono(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: BarTokens.ink1,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          }),
          const Divider(height: 1, color: BarTokens.line),
          const SizedBox(height: 14),
          _TotalsRow(
            label: 'Subtotal (excl. VAT)',
            amount: vat.subtotal,
          ),
          const SizedBox(height: 8),
          _TotalsRow(label: 'VAT 18%', amount: vat.vat),
          const SizedBox(height: 12),
          const Divider(height: 1, color: BarTokens.line),
          const SizedBox(height: 12),
          _TotalsRow(
            label: 'Total due',
            amount: vat.total,
            emphasize: true,
          ),
        ],
      ),
    );
  }

  String _serverLabel(String fullName) {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first;
    final last = parts.last;
    final initial = last.isNotEmpty ? last[0].toUpperCase() : '';
    return '${parts.first} $initial.';
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({
    required this.label,
    required this.amount,
    this.emphasize = false,
  });

  final String label;
  final double amount;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: emphasize ? FontWeight.w800 : FontWeight.w500,
              fontSize: emphasize ? 16 : 14,
              color: BarTokens.ink1,
            ),
          ),
        ),
        Text(
          'RWF ${NumberFormat('#,###').format(amount)}',
          style: GoogleFonts.jetBrainsMono(
            fontWeight: emphasize ? FontWeight.w800 : FontWeight.w600,
            fontSize: emphasize ? 22 : 14,
            color: emphasize ? BarTokens.blue : BarTokens.ink1,
          ),
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({
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
        color: selected ? BarTokens.blueTint : BarTokens.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: selected ? BarTokens.blue : BarTokens.line,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 26,
                  color: selected ? BarTokens.blue : BarTokens.ink3,
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: selected ? BarTokens.blue : BarTokens.ink2,
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

class _ReceiptPhoneField extends StatelessWidget {
  const _ReceiptPhoneField({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.showError = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECEIPT PHONE NUMBER *',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.55,
            color: showError ? BarTokens.lossInk : BarTokens.ink3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Required — printed on the RRA receipt (TEL).',
          style: GoogleFonts.outfit(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: BarTokens.ink3,
          ),
        ),
        const SizedBox(height: 10),
        ListenableBuilder(
          listenable: focusNode,
          builder: (context, _) {
            final focused = focusNode.hasFocus;
            final borderColor = showError
                ? BarTokens.lossInk
                : (focused ? BarTokens.blue : BarTokens.line);
            return Container(
              decoration: BoxDecoration(
                color: BarTokens.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: borderColor,
                  width: showError || focused ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      '+250',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: BarTokens.blue,
                      ),
                    ),
                  ),
                  Container(width: 1, height: 28, color: BarTokens.line),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(9),
                      ],
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: BarTokens.ink1,
                      ),
                      decoration: InputDecoration(
                        hintText: '7XX XXX XXX',
                        hintStyle: GoogleFonts.jetBrainsMono(
                          fontSize: 16,
                          color: BarTokens.ink4,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                      onChanged: onChanged,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Icon(
                      Icons.phone_outlined,
                      size: 20,
                      color: BarTokens.ink4,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        if (showError) ...[
          const SizedBox(height: 6),
          Text(
            'Enter a valid 9-digit mobile number (e.g. 783054874).',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: BarTokens.lossInk,
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickTenderChip extends StatelessWidget {
  const _QuickTenderChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BarTokens.surface2,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: BarTokens.line),
          ),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: BarTokens.ink2,
            ),
          ),
        ),
      ),
    );
  }
}

class _DottedDivider extends StatelessWidget {
  const _DottedDivider();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          size: Size(constraints.maxWidth, 1),
          painter: _HorizontalDottedLinePainter(),
        );
      },
    );
  }
}

class _HorizontalDottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = BarTokens.lineStrong
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const dash = 5.0;
    const gap = 5.0;
    var x = 0.0;
    final y = size.height / 2;
    while (x < size.width) {
      final end = math.min(x + dash, size.width);
      canvas.drawLine(Offset(x, y), Offset(end, y), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
