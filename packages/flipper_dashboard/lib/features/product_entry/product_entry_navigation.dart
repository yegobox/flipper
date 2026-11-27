import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
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

/// The page a product route shows. Tests swap in a light page, since the real
/// editor loads the product through ProxyService.
@visibleForTesting
Widget Function(String? productId) productEntryPageBuilder = (productId) =>
    ProductEntryScreen(productId: productId);

MaterialPageRoute<void> _route(String? productId) => MaterialPageRoute<void>(
  builder: (_) =>
      ProductEntrySaveGuard(child: productEntryPageBuilder(productId)),
);

/// Holds the editor open while a save runs. The top-bar back is disabled then,
/// and this stops Android's system back, the back gesture and Esc too: leaving
/// mid-save would drop a half-written product. Every product route wraps both
/// the phone and the desktop editor in it.
class ProductEntrySaveGuard extends ConsumerWidget {
  const ProductEntrySaveGuard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saving = ref.watch(loadingProvider.select((s) => s.isLoading));
    return PopScope(canPop: !saving, child: child);
  }
}

/// The combo switch and the combo's component lines are global. Left over
/// from the last product, they would open the next one as a combo, or with
/// another combo's components, so every editor starts as a plain product with
/// no lines (an edited combo loads its own).
@visibleForTesting
void startFreshProductEntry(BuildContext context) {
  final container = ProviderScope.containerOf(context, listen: false);
  container.read(isCompositeProvider.notifier).state = false;
  container
      .read(selectedVariantsLocalProvider.notifier)
      .loadComponents(const []);
}

/// Editing: the editor opens in the product's own mode, so a combo stays a
/// combo (opening reset the switch to plain).
void showProductInItsOwnMode(WidgetRef ref, Product product) {
  ref.read(isCompositeProvider.notifier).state = product.isComposite ?? false;
}
