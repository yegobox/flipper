import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PLUReport {
  Future<void> generatePLUReport({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);

    // Fetch transactions with their items
    final transactionsWithItems =
        await ProxyService.strategy.transactionsAndItems(
      startDate: startDate,
      endDate: endDate,
      status: COMPLETE,
    );

    // Extract all transaction items
    final List<TransactionItem> allItems = transactionsWithItems
        .expand((twi) => twi.items)
        .where((item) => item.variantId != null) // Skip items without variant
        .toList();

    // Group items by variant ID
    final Map<String, List<TransactionItem>> groupedItems = {};
    for (final item in allItems) {
      final variantId = item.variantId!;
      if (!groupedItems.containsKey(variantId)) {
        groupedItems[variantId] = [];
      }
      groupedItems[variantId]!.add(item);
    }

    // Prepare report data
    final List<Map<String, dynamic>> reportData = [];
    int i = 1;

    for (final entry in groupedItems.entries) {
      final items = entry.value;
      if (items.isEmpty) continue;

      // Use the first item's details (all items in the group share the same variant)
      final firstItem = items.first;

      // Calculate totals
      final soldQty = items.fold<double>(0, (sum, item) => sum + item.qty);
      final totalTax =
          items.fold<double>(0, (sum, item) => sum + (item.taxAmt ?? 0));
      final totalTaxable =
          items.fold<double>(0, (sum, item) => sum + (item.taxblAmt ?? 0));

      // Calculate tax rate (handle division by zero)
      double taxRate = 0.0;
      if (totalTaxable > 0) {
        taxRate = (totalTax / totalTaxable) * 100;
      }

      reportData.add({
        'No': i++,
        'Item Name': firstItem.name,
        'Item Code':
            firstItem.itemCd ?? firstItem.variantId?.substring(0, 8) ?? '',
        'Unit Price': firstItem.price,
        'Tax Rate': '${taxRate.toStringAsFixed(2)}%',
        'Sold Quantity': soldQty.toStringAsFixed(2),
        'Remain Quantity':
            firstItem.remainingStock?.toStringAsFixed(2) ?? '0.00',
      });
    }

    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            _buildHeader(business, startDate, endDate),
            pw.SizedBox(height: 20),
            _buildTable(reportData),
            pw.SizedBox(height: 20),
            _buildFooter(),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  pw.Widget _buildHeader(
      Business? business, DateTime startDate, DateTime endDate) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Center(
          child: pw.Text(
            'PLU REPORT',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 20),
        pw.Text(business?.name ?? 'N/A',
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
        pw.Text('TIN: ${business?.tinNumber ?? 'N/A'}'),
        pw.Text(
            'Date: ${DateFormat('yyyy-MM-dd').format(startDate)} - ${DateFormat('yyyy-MM-dd').format(endDate)}'),
      ],
    );
  }

  pw.Widget _buildTable(List<Map<String, dynamic>> data) {
    final headers = [
      'No',
      'Item Name',
      'Item Code',
      'Unit Price',
      'Tax Rate',
      'Sold Quantity',
      'Remain Quantity'
    ];

    return pw.Table.fromTextArray(
        headers: headers,
        data: data.map((row) {
          return [
            row['No'].toString(),
            row['Item Name'],
            row['Item Code'],
            row['Unit Price'].toStringAsFixed(2),
            row['Tax Rate'],
            row['Sold Quantity'].toString(),
            row['Remain Quantity'].toString(),
          ];
        }).toList(),
        headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: const pw.BoxDecoration(
          color: PdfColors.grey300,
        ),
        cellStyle: const pw.TextStyle(fontSize: 10),
        border: pw.TableBorder.all(),
        columnWidths: {
          0: const pw.FlexColumnWidth(0.5),
          1: const pw.FlexColumnWidth(2.5),
          2: const pw.FlexColumnWidth(1.5),
          3: const pw.FlexColumnWidth(1),
          4: const pw.FlexColumnWidth(1),
          5: const pw.FlexColumnWidth(1),
          6: const pw.FlexColumnWidth(1),
        });
  }

  pw.Widget _buildFooter() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 5),
        pw.Text(
            'Generated on: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now())}'),
        pw.Text('Sports Management System'),
      ],
    );
  }
}
