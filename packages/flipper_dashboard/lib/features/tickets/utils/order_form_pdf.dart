import 'dart:typed_data';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

/// Builds an Order Receipt PDF for a reviewed ticket — receipt-style layout
/// on A4 with ticket, payment, and review summary. Item lines follow for stock pick.
Future<Uint8List> buildOrderFormPdfBytes({
  required ITransaction ticket,
  required List<TransactionItem> items,
}) async {
  final businessId = ProxyService.box.getBusinessId();
  final business = businessId == null
      ? null
      : await ProxyService.getStrategy(
          Strategy.capella,
        ).getBusiness(businessId: businessId);

  final branchId = ticket.branchId ?? ProxyService.box.getBranchId() ?? '';
  final paid = branchId.isEmpty
      ? (ticket.cashReceived ?? 0.0)
      : (await ProxyService.getStrategy(Strategy.capella)
                .getTotalPaidForTransaction(
                  transactionId: ticket.id,
                  branchId: branchId,
                ) ??
            ticket.cashReceived ??
            0.0);

  final reviewerName = await _reviewerDisplayName(ticket.reviewedBy);
  final currency = ProxyService.box.defaultCurrency();

  final customer = (ticket.customerName ?? ticket.ticketName ?? '').trim();
  final refSource = ticket.reference?.trim();
  final reference = (refSource != null && refSource.isNotEmpty)
      ? refSource.toUpperCase()
      : ticket.id
          .substring(0, ticket.id.length >= 6 ? 6 : ticket.id.length)
          .toUpperCase();

  final total = ticket.subTotal ?? 0.0;
  final balance = total - paid;
  final balanceClamped = balance < 0 ? 0.0 : balance;

  final businessName = (business?.name ?? 'Shop').trim().toUpperCase();
  final mono = TextStyle(font: Font.courier(), fontSize: 10);
  final monoBold = TextStyle(
    font: Font.courierBold(),
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );
  final monoTitle = TextStyle(
    font: Font.courierBold(),
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );
  final monoSubtitle = TextStyle(font: Font.courier(), fontSize: 11);
  final monoFooter = TextStyle(font: Font.courier(), fontSize: 10);

  final doc = Document();
  doc.addPage(
    Page(
      pageFormat: PdfPageFormat.a4,
      margin: const EdgeInsets.symmetric(horizontal: 48, vertical: 56),
      theme: ThemeData.withFont(base: Font.courier(), bold: Font.courierBold()),
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                businessName,
                style: monoTitle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 6),
            Center(
              child: Text('Order receipt', style: monoSubtitle),
            ),
            SizedBox(height: 16),
            _rule(),
            SizedBox(height: 12),
            _receiptRow('Ticket', '#$reference', mono, monoBold),
            _receiptRow(
              'Customer',
              customer.isEmpty ? 'Walk-in' : customer,
              mono,
              monoBold,
            ),
            if (ticket.createdAt != null)
              _receiptRow(
                'Created',
                _formatShortDateTime(ticket.createdAt!.toLocal()),
                mono,
                monoBold,
              ),
            if (ticket.dueDate != null)
              _receiptRow(
                'Delivery time',
                _formatDeliveryTime(ticket.dueDate!.toLocal()),
                mono,
                monoBold,
              ),
            SizedBox(height: 12),
            _rule(),
            SizedBox(height: 12),
            _receiptRow(
              'Total',
              total.toCurrencyFormatted(symbol: currency),
              mono,
              monoBold,
            ),
            _receiptRow(
              'Paid',
              paid.toCurrencyFormatted(symbol: currency),
              mono,
              monoBold,
            ),
            _receiptRow(
              'Balance',
              balanceClamped.toCurrencyFormatted(symbol: currency),
              mono,
              monoBold,
            ),
            if (ticket.reviewedAt != null || reviewerName != '—') ...[
              SizedBox(height: 12),
              _rule(),
              SizedBox(height: 12),
              _receiptRow('Reviewed by', reviewerName, mono, monoBold),
              if (ticket.reviewedAt != null)
                _receiptRow(
                  'Reviewed at',
                  _formatShortDateTime(ticket.reviewedAt!.toLocal()),
                  mono,
                  monoBold,
                ),
            ],
            if (items.isNotEmpty) ...[
              SizedBox(height: 12),
              _rule(),
              SizedBox(height: 12),
              for (final item in items) _itemRow(item, mono, monoBold),
            ],
            SizedBox(height: 16),
            _rule(),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Thank you for your order',
                style: monoFooter,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        );
      },
    ),
  );

  return doc.save();
}

Widget _rule() {
  return Container(
    height: 0.5,
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(color: PdfColors.grey400, width: 0.5),
      ),
    ),
  );
}

Widget _receiptRow(
  String label,
  String value,
  TextStyle labelStyle,
  TextStyle valueStyle,
) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: labelStyle)),
        Expanded(
          child: Text(
            value,
            style: valueStyle,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}

Widget _itemRow(TransactionItem item, TextStyle mono, TextStyle monoBold) {
  final qty = item.qty;
  final qtyLabel =
      qty % 1 == 0 ? qty.toStringAsFixed(0) : qty.toStringAsFixed(2);
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(item.name, style: mono),
        ),
        Text('x$qtyLabel', style: monoBold),
      ],
    ),
  );
}

String _formatShortDateTime(DateTime date) {
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(date.month)}/${pad(date.day)} ${pad(date.hour)}:${pad(date.minute)}';
}

String _formatDeliveryTime(DateTime date) {
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(date.month)}/${pad(date.day)} · ${pad(date.hour)}:${pad(date.minute)}';
}

Future<String> _reviewerDisplayName(String? userId) async {
  if (userId == null || userId.trim().isEmpty) return '—';
  try {
    final tenant = await ProxyService.strategy.tenant(
      userId: userId.trim(),
      fetchRemote: false,
    );
    final name = tenant?.name?.trim();
    if (name != null && name.isNotEmpty) return name;
  } catch (_) {}
  final id = userId.trim();
  return id.length > 12 ? '${id.substring(0, 12)}…' : id;
}
