import 'dart:typed_data';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

/// Builds an Order Receipt PDF for a reviewed ticket — receipt-style layout
/// on A4 with ticket, payment, and review summary. Item lines follow for stock pick.
///
/// A human-readable stock-pick document, not an RRA fiscal receipt, so its
/// labels follow [l10n] (the app's current language when omitted).
Future<Uint8List> buildOrderFormPdfBytes({
  required ITransaction ticket,
  required List<TransactionItem> items,
  FlipperAppLocalizations? l10n,
}) async {
  final strings = l10n ?? FlipperL10n.current;
  final basics = await _loadTicketPrintBasics(ticket);
  final paid = basics.paid;
  final currency = basics.currency;
  final reference = basics.reference;

  final reviewerName = await _reviewerDisplayName(ticket.reviewedBy);

  final customer = (ticket.customerName ?? ticket.ticketName ?? '').trim();

  final total = ticket.subTotal ?? 0.0;
  final balance = total - paid;
  final balanceClamped = balance < 0 ? 0.0 : balance;

  final businessName = (basics.businessName ?? strings.ticketOrderFormShop)
      .trim()
      .toUpperCase();
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
              child: Text(strings.ticketOrderReceipt, style: monoSubtitle),
            ),
            SizedBox(height: 16),
            _rule(),
            SizedBox(height: 12),
            _receiptRow(strings.ticketGeneric, '#$reference', mono, monoBold),
            _receiptRow(
              strings.customer,
              customer.isEmpty ? strings.ticketWalkIn : customer,
              mono,
              monoBold,
            ),
            if (ticket.createdAt != null)
              _receiptRow(
                strings.ticketCreated,
                _formatShortDateTime(ticket.createdAt!.toLocal()),
                mono,
                monoBold,
              ),
            if (ticket.dueDate != null)
              _receiptRow(
                strings.ticketDeliveryTime,
                _formatDeliveryTime(ticket.dueDate!.toLocal()),
                mono,
                monoBold,
              ),
            SizedBox(height: 12),
            _rule(),
            SizedBox(height: 12),
            _receiptRow(
              strings.ticketTotal,
              total.toCurrencyFormatted(symbol: currency),
              mono,
              monoBold,
            ),
            _receiptRow(
              strings.ticketStatusPaid,
              paid.toCurrencyFormatted(symbol: currency),
              mono,
              monoBold,
            ),
            _receiptRow(
              strings.ticketBalance,
              balanceClamped.toCurrencyFormatted(symbol: currency),
              mono,
              monoBold,
            ),
            if (ticket.reviewedAt != null || reviewerName != '—') ...[
              SizedBox(height: 12),
              _rule(),
              SizedBox(height: 12),
              _receiptRow(
                strings.ticketReviewedBy,
                reviewerName,
                mono,
                monoBold,
              ),
              if (ticket.reviewedAt != null)
                _receiptRow(
                  strings.ticketReviewedAt,
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
                strings.ticketThankYouForOrder,
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
      border: Border(bottom: BorderSide(color: PdfColors.grey400, width: 0.5)),
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
          child: Text(value, style: valueStyle, textAlign: TextAlign.right),
        ),
      ],
    ),
  );
}

Widget _itemRow(TransactionItem item, TextStyle mono, TextStyle monoBold) {
  final qtyLabel = _qtyLabel(item.qty);
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: Text(item.name, style: mono)),
        Text('x$qtyLabel', style: monoBold),
      ],
    ),
  );
}

String _qtyLabel(num qty) =>
    qty % 1 == 0 ? qty.toStringAsFixed(0) : qty.toStringAsFixed(2);

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

/// What both ticket prints read from the device: shop name, money paid so
/// far, currency, the short reference, and the receipt paper setting.
typedef _TicketPrintBasics = ({
  String? businessName,
  double paid,
  String currency,
  String reference,
  bool useA4,
  Customer? customer,
});

Future<_TicketPrintBasics> _loadTicketPrintBasics(
  ITransaction ticket, {
  bool withCustomer = false,
}) async {
  final box = ProxyService.box;
  final capella = ProxyService.getStrategy(Strategy.capella);
  final businessId = box.getBusinessId();
  final business = businessId == null
      ? null
      : await capella.getBusiness(businessId: businessId);

  final branchId = ticket.branchId ?? box.getBranchId() ?? '';
  final paid = await resolveTicketPaid(
    ticket,
    branchId: branchId,
    lookup: () => capella.getTotalPaidForTransaction(
      transactionId: ticket.id,
      branchId: branchId,
    ),
  );

  final refSource = ticket.reference?.trim();
  final reference = (refSource != null && refSource.isNotEmpty)
      ? refSource.toUpperCase()
      : ticket.id
            .substring(0, ticket.id.length >= 6 ? 6 : ticket.id.length)
            .toUpperCase();

  Customer? customer;
  final customerId = ticket.customerId?.trim();
  if (withCustomer && customerId != null && customerId.isNotEmpty) {
    try {
      customer = await capella.customerById(customerId);
    } catch (_) {
      // The ticket's own snapshot still prints; a missing record is not fatal.
    }
  }

  return (
    businessName: business?.name,
    paid: paid,
    currency: box.defaultCurrency(),
    reference: reference,
    useA4: box.A4(),
    customer: customer,
  );
}

/// What has been paid on [ticket]: the payment records when [lookup] can
/// read them, otherwise the ticket's own `cashReceived`. A lookup that throws
/// (Ditto not ready, query failed) is logged and falls back, so it never
/// stops the print.
@visibleForTesting
Future<double> resolveTicketPaid(
  ITransaction ticket, {
  required String branchId,
  required Future<double?> Function() lookup,
}) async {
  final fallback = ticket.cashReceived ?? 0.0;
  if (branchId.isEmpty) return fallback;
  try {
    return await lookup() ?? fallback;
  } catch (e, st) {
    talker.warning(
      'Ticket print: paid lookup failed for ${ticket.id}, '
      'using cashReceived: $e',
      st,
    );
    return fallback;
  }
}

/// Customer details printed on a ticket bill. The ticket's own snapshot
/// wins; the linked [Customer] record only fills what the ticket left empty.
class TicketPrintCustomer {
  const TicketPrintCustomer({
    this.name,
    this.phone,
    this.tin,
    this.email,
    this.address,
  });

  factory TicketPrintCustomer.resolve({
    required ITransaction ticket,
    Customer? customer,
  }) {
    return TicketPrintCustomer(
      name: _clean(ticket.customerName) ?? _clean(customer?.custNm),
      phone: _clean(ticket.customerPhone) ?? _clean(customer?.telNo),
      tin: _clean(ticket.customerTin) ?? _clean(customer?.custTin),
      email: _clean(customer?.email),
      address: _clean(customer?.adrs),
    );
  }

  final String? name;
  final String? phone;
  final String? tin;
  final String? email;
  final String? address;

  bool get isEmpty =>
      name == null &&
      phone == null &&
      tin == null &&
      email == null &&
      address == null;

  static String? _clean(String? value) {
    final v = value?.trim();
    return (v == null || v.isEmpty) ? null : v;
  }
}

/// One printed line: the item, how many, at what price, for how much.
class TicketBillLine {
  const TicketBillLine({
    required this.name,
    required this.qty,
    required this.unitPrice,
    required this.lineTotal,
  });

  /// Same math as the sale receipt: gross less the line's discount rate.
  factory TicketBillLine.fromItem(TransactionItem item) {
    final gross = (item.price * item.qty).toDouble();
    final rate = item.dcRt?.toDouble() ?? 0;
    return TicketBillLine(
      name: item.name,
      qty: item.qty,
      unitPrice: item.price.toDouble(),
      lineTotal: rate == 0 ? gross : gross * (1 - rate / 100),
    );
  }

  final String name;
  final num qty;
  final double unitPrice;
  final double lineTotal;
}

/// Everything a ticket bill shows, already loaded, so the layout can be
/// built (and tested) without any services.
class TicketBillData {
  const TicketBillData({
    required this.businessName,
    required this.reference,
    required this.customer,
    required this.lines,
    required this.total,
    required this.paid,
    required this.currency,
    this.ticketName,
    this.note,
    this.createdAt,
    this.dueDate,
    this.useA4 = false,
  });

  final String? businessName;
  final String reference;
  final String? ticketName;
  final String? note;
  final DateTime? createdAt;
  final DateTime? dueDate;
  final TicketPrintCustomer customer;
  final List<TicketBillLine> lines;
  final double total;
  final double paid;
  final String currency;
  final bool useA4;
}

/// Prints what is on a parked ticket: who it is for and every line with its
/// price, then the total, what was paid, and the balance.
///
/// Not a fiscal receipt — it never touches TaxController, EBM/RRA, counters
/// or ticket status, and says so at the bottom. Follows the till's receipt
/// paper: 80mm roll by default, A4 when receipts are set to A4.
Future<Uint8List> buildTicketBillPdfBytes({
  required ITransaction ticket,
  required List<TransactionItem> items,
  FlipperAppLocalizations? l10n,
}) async {
  final basics = await _loadTicketPrintBasics(ticket, withCustomer: true);
  final lines = items.map(TicketBillLine.fromItem).toList();
  final linesTotal = lines.fold<double>(0, (sum, l) => sum + l.lineTotal);
  final subTotal = ticket.subTotal ?? 0.0;
  return renderTicketBillPdf(
    TicketBillData(
      businessName: basics.businessName,
      reference: basics.reference,
      ticketName: ticket.ticketName,
      note: ticket.note,
      createdAt: ticket.createdAt,
      dueDate: ticket.dueDate,
      customer: TicketPrintCustomer.resolve(
        ticket: ticket,
        customer: basics.customer,
      ),
      lines: lines,
      // subTotal can lag the lines on a ticket another till just edited.
      total: subTotal > 0 ? subTotal : linesTotal,
      paid: basics.paid,
      currency: basics.currency,
      useA4: basics.useA4,
    ),
    l10n: l10n,
  );
}

Future<Uint8List> renderTicketBillPdf(
  TicketBillData data, {
  FlipperAppLocalizations? l10n,
}) async {
  final strings = l10n ?? FlipperL10n.current;
  final size = data.useA4 ? 10.0 : 8.5;
  final mono = TextStyle(font: Font.courier(), fontSize: size);
  final monoBold = TextStyle(
    font: Font.courierBold(),
    fontSize: size,
    fontWeight: FontWeight.bold,
  );
  final monoTitle = TextStyle(
    font: Font.courierBold(),
    fontSize: size + 4,
    fontWeight: FontWeight.bold,
  );
  String money(double v) => v.toCurrencyFormatted(symbol: data.currency);

  final businessName = (data.businessName ?? strings.ticketOrderFormShop)
      .trim()
      .toUpperCase();
  final ticketName = data.ticketName?.trim() ?? '';
  final note = data.note?.trim() ?? '';
  final customer = data.customer;
  final balance = data.total - data.paid;

  final doc = Document();
  doc.addPage(
    Page(
      pageFormat: data.useA4 ? PdfPageFormat.a4 : PdfPageFormat.roll80,
      margin: data.useA4
          ? const EdgeInsets.symmetric(horizontal: 48, vertical: 56)
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
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
            SizedBox(height: 4),
            Center(child: Text(strings.ticketBillTitle, style: mono)),
            if (ticketName.isNotEmpty && ticketName != customer.name) ...[
              SizedBox(height: 2),
              Center(
                child: Text(
                  ticketName,
                  style: monoBold,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            SizedBox(height: 10),
            _rule(),
            SizedBox(height: 8),
            _receiptRow(
              strings.ticketGeneric,
              '#${data.reference}',
              mono,
              monoBold,
            ),
            if (data.createdAt != null)
              _receiptRow(
                strings.ticketCreated,
                _formatShortDateTime(data.createdAt!.toLocal()),
                mono,
                monoBold,
              ),
            if (data.dueDate != null)
              _receiptRow(
                strings.ticketDeliveryTime,
                _formatDeliveryTime(data.dueDate!.toLocal()),
                mono,
                monoBold,
              ),
            SizedBox(height: 4),
            _rule(),
            SizedBox(height: 8),
            if (customer.isEmpty)
              _receiptRow(
                strings.customer,
                strings.ticketWalkIn,
                mono,
                monoBold,
              )
            else ...[
              if (customer.name != null)
                _receiptRow(strings.customer, customer.name!, mono, monoBold),
              if (customer.phone != null)
                _receiptRow(strings.phone, customer.phone!, mono, monoBold),
              if (customer.tin != null)
                _receiptRow(strings.tin, customer.tin!, mono, monoBold),
              if (customer.email != null)
                _receiptRow(strings.email, customer.email!, mono, monoBold),
              if (customer.address != null)
                _receiptRow(
                  strings.ticketCustomerAddress,
                  customer.address!,
                  mono,
                  monoBold,
                ),
            ],
            SizedBox(height: 4),
            _rule(),
            SizedBox(height: 8),
            for (final line in data.lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(line.name, style: monoBold),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${_qtyLabel(line.qty)} x ${money(line.unitPrice)}',
                            style: mono,
                          ),
                        ),
                        Text(money(line.lineTotal), style: monoBold),
                      ],
                    ),
                  ],
                ),
              ),
            _rule(),
            SizedBox(height: 8),
            _receiptRow(strings.ticketTotal, money(data.total), mono, monoBold),
            if (data.paid > 0) ...[
              _receiptRow(
                strings.ticketStatusPaid,
                money(data.paid),
                mono,
                monoBold,
              ),
              _receiptRow(
                strings.ticketBalance,
                money(balance < 0 ? 0.0 : balance),
                mono,
                monoBold,
              ),
            ],
            if (note.isNotEmpty) ...[
              SizedBox(height: 4),
              _rule(),
              SizedBox(height: 8),
              Text('${strings.ticketNote}: $note', style: mono),
            ],
            SizedBox(height: 10),
            _rule(),
            SizedBox(height: 10),
            Center(
              child: Text(
                strings.ticketNotFiscalReceipt,
                style: monoBold,
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
