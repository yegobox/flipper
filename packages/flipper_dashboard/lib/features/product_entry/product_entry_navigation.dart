import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Opens add/edit product as a full-page route. [ProductEntryScreen] brings
/// its own header ([CustomAppBar]) on every layout, so callers must not wrap
/// it in another Scaffold or AppBar.
Future<void> openProductEntryScreen(BuildContext context, {String? productId}) {
  startFreshProductEntry(context);
  return Navigator.of(context).push(_route(productId));
}

/// "Add another" after a save: swaps the current page for a blank editor.
Future<void> replaceWithProductEntryScreen(BuildContext context) {
  startFreshProductEntry(context);
  return Navigator.of(context).pushReplacement(_route(null));
}

MaterialPageRoute<void> _route(String? productId) => MaterialPageRoute<void>(
  builder: (_) => ProductEntryScreen(productId: productId),
);

/// The combo switch is a global flag. Left on from the last product, it would
/// open the next one as a combo, so every editor starts as a plain product.
@visibleForTesting
void startFreshProductEntry(BuildContext context) {
  ProviderScope.containerOf(
    context,
    listen: false,
  ).read(isCompositeProvider.notifier).state = false;
}
