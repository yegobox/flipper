import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/responsive_layout.dart' as responsive;
import 'package:flutter/material.dart';

/// Opens add/edit product as a full-page route (desktop) or Scaffold (phone).
Future<void> openProductEntryScreen(
  BuildContext context, {
  String? productId,
}) {
  final isPhone =
      responsive.ResponsiveLayout.isPhone(context) ||
      responsive.ResponsiveLayout.isTinyLimit(context);

  if (isPhone) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (ctx) => Scaffold(
          appBar: AppBar(
            title: Text(
              productId == null ? 'Add New Product' : 'Edit Product',
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(ctx).maybePop(),
            ),
          ),
          body: SafeArea(child: ProductEntryScreen(productId: productId)),
        ),
      ),
    );
  }

  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ProductEntryScreen(productId: productId),
    ),
  );
}
