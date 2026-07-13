import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/utils/pos_product_tile.dart';
import 'package:flipper_dashboard/widgets/pos_catalog_grid_card.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

/// Bar POS catalog tile — mirrors [RowItem] desktop grid card.
class BarPosVariantTile extends StatelessWidget {
  const BarPosVariantTile({
    super.key,
    required this.variant,
    required this.onTap,
    this.liveStock,
  });

  final Variant variant;
  final VoidCallback? onTap;
  final Stock? liveStock;

  @override
  Widget build(BuildContext context) {
    final physical =
        liveStock?.currentStock ?? variant.stock?.currentStock ?? 0;
    final threshold = variant.stock?.lowStock ?? 10.0;
    final visual = posStockVisual(
      currentStock: physical,
      lowStockThreshold: threshold,
    );
    final isOut = visual == PosStockVisual.out;
    final productName = (variant.productName?.trim().isNotEmpty == true
            ? variant.productName
            : variant.name) ??
        'Unnamed Product';
    final bcd = variant.bcd;
    final bcdLabel = bcd != null && bcd.isNotEmpty ? 'BCD: $bcd' : null;

    return PosCatalogGridCard(
      productName: productName,
      bcdLabel: bcdLabel,
      currencySymbol: ProxyService.box.defaultCurrency(),
      priceAmount: variant.retailPrice ?? 0,
      stockVisual: visual,
      stockLabel: posStockLabel(visual, physical),
      inCartQty: 0,
      showSelectionBorder: false,
      isOutOfStock: isOut,
      thumb: posCatalogThumb(
        name: productName,
        hasImage: false,
        image: null,
        isOutOfStock: isOut,
      ),
      onTap: isOut ? null : onTap,
      onLongPress: () {},
    );
  }
}

/// POS grid delegate for the bar catalog pane (matches [ProductView]).
SliverGridDelegate barPosCatalogGridDelegate(double paneWidth) {
  final crossAxisCount =
      PosLayoutBreakpoints.productGridCrossAxisCountForPaneWidth(paneWidth);
  final spacing = PosLayoutBreakpoints.desktopGridSpacing(paneWidth);
  final aspectRatio =
      PosLayoutBreakpoints.desktopGridChildAspectRatioForPane(paneWidth);

  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: crossAxisCount,
    mainAxisSpacing: spacing,
    crossAxisSpacing: spacing,
    childAspectRatio: aspectRatio,
  );
}
