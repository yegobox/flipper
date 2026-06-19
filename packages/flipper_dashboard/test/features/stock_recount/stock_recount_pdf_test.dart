import 'package:flipper_dashboard/features/stock_recount/stock_recount_helpers.dart';
import 'package:flipper_dashboard/features/stock_recount/stock_recount_pdf.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('StockRecountPdfExport.build produces a PDF for a mixed-variance session',
      () async {
    final recount = StockRecount(
      id: 'session-richard',
      branchId: 'branch-1',
      deviceName: 'Device richard-',
      status: 'draft',
    );
    final items = [
      StockRecountItem(
        recountId: recount.id,
        variantId: 'v1',
        stockId: 's1',
        productName: 'Umuceri (Rice 25kg)',
        previousQuantity: 3,
        countedQuantity: 12,
      ),
      StockRecountItem(
        recountId: recount.id,
        variantId: 'v2',
        stockId: 's2',
        productName: 'Inyange Water 1L',
        previousQuantity: 540,
        countedQuantity: 540,
      ),
      StockRecountItem(
        recountId: recount.id,
        variantId: 'v3',
        stockId: 's3',
        productName: 'Coca-Cola 50cl',
        previousQuantity: 288,
        countedQuantity: 274,
      ),
    ];

    final bytes = await StockRecountPdfExport.build(
      recount: recount,
      items: items,
      stats: RecountItemStats.fromItems(items),
      businessName: 'Kigali General Store',
      branchName: 'Nyabugogo Branch',
      counterName: 'Richard M.',
      variantSkus: const {'v1': '393993', 'v2': 'INY-1L', 'v3': 'CC-50'},
    );

    expect(bytes, isNotEmpty);
    // %PDF magic header.
    expect(bytes.sublist(0, 4), equals([0x25, 0x50, 0x44, 0x46]));
  });
}
