import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
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

class BarSettleScreen extends ConsumerStatefulWidget {
  const BarSettleScreen({super.key});

  @override
  ConsumerState<BarSettleScreen> createState() => _BarSettleScreenState();
}

class _BarSettleScreenState extends ConsumerState<BarSettleScreen> {
  String _method = 'Cash';
  double _tender = 0;
  bool _settling = false;

  @override
  Widget build(BuildContext context) {
    final bar = ref.watch(barModeProvider);
    final table = bar.activeTable;
    final tab = bar.activeTab;
    if (table == null || tab == null) return const SizedBox.shrink();

    final linesAsync = ref.watch(barTabLinesProvider(tab.id));
    final lines = linesAsync.value ?? [];
    final total = barTabTotal(lines);
    final vat = barVatBreakdown(total);
    final staff = ref.watch(barStaffProvider).value ?? [];

    final grouped = <String, List<dynamic>>{};
    for (final line in lines) {
      final key = line.loggedByTenantId ?? 'unknown';
      grouped.putIfAbsent(key, () => []).add(line);
    }

    final due = (total - _tender).clamp(0, double.infinity);
    final change = (_tender - total).clamp(0, double.infinity);
    final canConfirm =
        !_settling && (_method == 'Mobile Money' || _tender >= total - 0.01);

    return Container(
      color: BarTokens.posBg,
      child: Column(
        children: [
          _topBar(ref, table.zoneName, table.name),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: BarTokens.surface,
                        borderRadius: BorderRadius.circular(BarTokens.radiusLg),
                        border: Border.all(color: BarTokens.line),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Table ${table.name} — running tab',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ...grouped.entries.map((entry) {
                            dynamic tenant;
                            for (final t in staff) {
                              if (t.id == entry.key) {
                                tenant = t;
                                break;
                              }
                            }
                            final name =
                                tenant?.name ??
                                entry.value.first.loggedByName ??
                                'Staff';
                            final sub = barTabTotal(entry.value.cast());
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$name · RWF ${NumberFormat('#,###').format(sub)}',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  ...entry.value.map(
                                    (line) => Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        '${line.qty.toInt()}× ${line.name} @ ${NumberFormat('#,###').format(line.price)}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          color: BarTokens.ink2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          const Divider(),
                          _moneyRow('Subtotal (excl. VAT)', vat.subtotal),
                          _moneyRow('VAT 18%', vat.vat),
                          _moneyRow('Total due', vat.total, bold: true),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 420,
                  padding: const EdgeInsets.all(24),
                  color: BarTokens.surface,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Choose method and take payment to close the table.',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: BarTokens.ink3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _methodCard('Cash', Icons.payments_outlined),
                          const SizedBox(width: 12),
                          _methodCard('Mobile Money', Icons.phone_android),
                        ],
                      ),
                      if (_method == 'Cash') ...[
                        const SizedBox(height: 20),
                        Text(
                          due > 0
                              ? 'Balance due: RWF ${NumberFormat('#,###').format(due)}'
                              : change > 0
                              ? 'Change to give: RWF ${NumberFormat('#,###').format(change)}'
                              : 'Exact — no change',
                          style: GoogleFonts.jetBrainsMono(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final chip in [
                              total,
                              20000.0,
                              50000.0,
                              100000.0,
                            ])
                              ActionChip(
                                label: Text(
                                  chip == total
                                      ? 'Exact'
                                      : NumberFormat('#,###').format(chip),
                                ),
                                onPressed: () => setState(() => _tender = chip),
                              ),
                          ],
                        ),
                      ] else
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            'A push request will be sent to the guest device.',
                            style: GoogleFonts.outfit(color: BarTokens.ink3),
                          ),
                        ),
                      const Spacer(),
                      FilledButton(
                        onPressed: canConfirm
                            ? () => _confirm(ref, tab, total, lines)
                            : null,
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                        ),
                        child: Text(
                          'Confirm payment · RWF ${NumberFormat('#,###').format(total)}',
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

  Widget _topBar(WidgetRef ref, String zone, String tableName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: BarTokens.surface,
        border: Border(bottom: BorderSide(color: BarTokens.line)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () =>
                ref.read(barModeProvider.notifier).setScreen(BarScreen.pos),
            icon: const Icon(Icons.chevron_left),
          ),
          Text(
            'Settle bill · $zone',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(width: 8),
          Chip(label: Text(tableName)),
          const Spacer(),
          Chip(
            avatar: const Icon(Icons.shield_outlined, size: 16),
            label: const Text('Settling as manager'),
          ),
        ],
      ),
    );
  }

  Widget _methodCard(String label, IconData icon) {
    final selected = _method == label;
    return Expanded(
      child: Material(
        color: selected ? BarTokens.blueTint : BarTokens.surface2,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () => setState(() => _method = label),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? BarTokens.blue : BarTokens.line,
              ),
            ),
            child: Column(
              children: [
                Icon(icon),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moneyRow(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
          ),
          Text(
            'RWF ${NumberFormat('#,###').format(amount)}',
            style: GoogleFonts.jetBrainsMono(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
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
    setState(() => _settling = true);

    final sync = ProxyService.getStrategy(Strategy.capella);
    final cashReceived = _method == 'Cash' ? _tender : total;
    final change = (_tender - total).clamp(0, double.infinity).toDouble();

    try {
      var txn = tab.copyWith(
        subTotal: total,
        cashReceived: cashReceived,
        customerChangeDue: change,
        paymentType: _method,
      );

      final businessId = ProxyService.box.getBusinessId();
      final branchId = ProxyService.box.getBranchId();
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
          }
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
      ref
          .read(barModeProvider.notifier)
          .afterSettle(
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
