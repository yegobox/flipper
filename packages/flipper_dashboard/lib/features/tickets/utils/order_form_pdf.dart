import 'dart:typed_data';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart' as material;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

ImageProvider? _cachedLogo;
bool _logoLoadFailed = false;

/// Loads the Flipper wordmark once and caches it for subsequent Order Forms.
Future<ImageProvider?> _loadFlipperLogo() async {
  if (_cachedLogo != null) return _cachedLogo;
  if (_logoLoadFailed) return null;
  try {
    const asset = material.AssetImage(
      'assets/logo.png',
      package: 'flipper_dashboard',
    );
    _cachedLogo = await flutterImageProvider(
      asset,
      configuration: const material.ImageConfiguration(
        size: material.Size(200, 200),
      ),
    );
  } catch (_) {
    _logoLoadFailed = true;
  }
  return _cachedLogo;
}

/// Builds a simple Order Form for a reviewed ticket: item names and
/// quantities only, so stock staff can pick and hand over the physical
/// goods. This is NOT a receipt — no prices, totals, tax fields, or
/// RRA/SDC data — and is unrelated to [TaxController]'s receipt engine.
/// The real fiscal receipt is generated later, at handover.
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
  final logo = await _loadFlipperLogo();

  final customer = (ticket.customerName ?? ticket.ticketName ?? '').trim();
  final refSource = ticket.reference?.trim();
  final reference = (refSource != null && refSource.isNotEmpty)
      ? refSource.toUpperCase()
      : ticket.id
          .substring(0, ticket.id.length >= 6 ? 6 : ticket.id.length)
          .toUpperCase();
  final now = DateTime.now();

  final doc = Document();
  doc.addPage(
    Page(
      pageFormat: PdfPageFormat.roll80,
      build: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if ((business?.name ?? '').trim().isNotEmpty)
              Center(
                child: Text(
                  business!.name!.trim(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            Center(
              child: Text(
                'ORDER FORM',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 6),
            Divider(thickness: 0.5),
            _detailRow('Ticket', '#$reference'),
            _detailRow('Customer', customer.isEmpty ? 'Walk-in' : customer),
            _detailRow('Date', _formatDateTime(now)),
            Divider(thickness: 0.5),
            SizedBox(height: 4),
            Text(
              'ITEMS',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            for (final item in items) _itemRow(item),
            Divider(thickness: 0.5),
            SizedBox(height: 6),
            Center(
              child: Text(
                'Not a receipt — for stock handover only',
                style: TextStyle(fontSize: 7, fontStyle: FontStyle.italic),
              ),
            ),
            if (logo != null) ...[
              SizedBox(height: 8),
              Center(child: Image(logo, width: 25, height: 25)),
            ],
          ],
        );
      },
    ),
  );

  return doc.save();
}

Widget _detailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 8)),
        Text(value, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

Widget _itemRow(TransactionItem item) {
  final qty = item.qty;
  final qtyLabel =
      qty % 1 == 0 ? qty.toStringAsFixed(0) : qty.toStringAsFixed(2);
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Text(item.name, style: TextStyle(fontSize: 9)),
        ),
        Text(
          'x$qtyLabel',
          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}

String _formatDateTime(DateTime date) {
  String pad(int n) => n.toString().padLeft(2, '0');
  return '${pad(date.day)}/${pad(date.month)}/${date.year} '
      '${pad(date.hour)}:${pad(date.minute)}';
}
