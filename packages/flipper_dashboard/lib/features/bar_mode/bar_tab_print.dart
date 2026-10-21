import 'package:flipper_dashboard/features/tickets/utils/order_form_pdf.dart';
import 'package:flipper_dashboard/features/tickets/utils/ticket_pdf_presenter.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Prints what is on an open bar tab, so a guest can see the bill before
/// settling. Same paper as a parked ticket's print: lines with prices, the
/// tab total, and "NOT A FISCAL RECEIPT" — no EBM/RRA, counters or tab
/// status change. The fiscal receipt still comes from Settle.
class BarTabPrint {
  BarTabPrint._();

  /// Tabs printing right now, so a double tap doesn't print twice.
  static final Set<String> _inFlight = {};

  /// "Main Bar · Muvinga": which table the paper belongs to.
  static String heading(BarTable table) {
    final zone = table.zoneName.trim();
    final name = table.name.trim();
    if (zone.isEmpty) return name;
    if (name.isEmpty) return zone;
    return '$zone · $name';
  }

  /// What the tab paper lists: exactly the tab screen — price × qty per line
  /// and [barTabTotal] under them. A discount rate the line copied from its
  /// variant is not applied, because the screen does not apply it either.
  static TicketBillBody bill(List<TransactionItem> lines) => (
    lines: [
      for (final line in lines)
        TicketBillLine.fromItem(line, applyDiscount: false),
    ],
    total: barTabTotal(lines),
  );

  static Future<void> printTab({
    required BuildContext context,
    required ITransaction tab,
    required BarTable table,
    required List<TransactionItem> lines,
  }) async {
    if (lines.isEmpty || !_inFlight.add(tab.id)) return;
    final l10n = context.flipperL10n;
    final messenger = ScaffoldMessenger.maybeOf(context);
    try {
      final bytes = await buildTicketBillPdfBytes(
        ticket: tab,
        items: lines,
        l10n: l10n,
        heading: heading(table),
        // A tab's stored subTotal can lag its lines; print what the screen
        // shows.
        body: bill(lines),
      );
      if (!context.mounted) return;
      final safeName = table.name.trim().replaceAll(RegExp(r'[^\w-]+'), '_');
      await presentTicketPdf(
        context,
        bytes: bytes,
        ticket: tab,
        items: lines,
        filename: 'tab-${safeName.isEmpty ? tab.id : safeName}.pdf',
        // Straight to the till's printer (built-in first); picker as fallback.
        autoPrint: true,
        notSentMessage: l10n.ticketPrintNotSent,
      );
    } catch (e, st) {
      talker.error('Print bar tab failed: $e', st);
      messenger?.showSnackBar(
        SnackBar(
          content: Text(l10n.ticketPrintFailed),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _inFlight.remove(tab.id);
    }
  }
}
