import 'package:flipper_dashboard/product_view.dart';
import 'package:flipper_dashboard/checkout.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_host.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/Ai.dart';
import 'package:flipper_dashboard/TransactionWidget.dart';
import 'package:flipper_dashboard/bottom_sheets/preview_sale_bottom_sheet.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_dashboard/widgets/pos_shift_gate.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class InventoryApp extends HookConsumerWidget {
  final TextEditingController searchController;

  const InventoryApp({Key? key, required this.searchController})
    : super(key: key);

  Widget buildProductSection(WidgetRef ref) {
    return Expanded(
      child: ProductView.normalMode(linkedSearchController: searchController),
    ).shouldSeeTheApp(ref, featureName: AppFeature.Sales);
  }

  Widget _salesContent(bool isScanningMode, WidgetRef ref) {
    if (BarModeSettings.enabled) {
      return const BarModeHost()
          .shouldSeeTheApp(ref, featureName: AppFeature.Sales)
          .shouldSeeTheApp(ref, featureName: AppFeature.Inventory);
    }
    return isScanningMode
        ? buildReceiptUI().shouldSeeTheApp(
            ref,
            featureName: AppFeature.Sales,
          )
        : CheckOut(isBigScreen: true)
              .shouldSeeTheApp(ref, featureName: AppFeature.Sales)
              .shouldSeeTheApp(ref, featureName: AppFeature.Inventory);
  }

  Widget buildMainContent(bool isScanningMode, WidgetRef ref) {
    final selectedMenuItem = ref.watch(selectedMenuItemProvider);

    switch (selectedMenuItem) {
      case 0: // Sales (shift gated by [PosShiftGate] in build)
        return _salesContent(isScanningMode, ref);
      case 1: // Inventory
        return Center(child: Ai());
      case 2: // Tickets
        return const TransactionWidget();
      default:
        return _salesContent(isScanningMode, ref);
    }
  }

  Widget buildReceiptUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 400,
        child: PreviewSaleBottomSheet(reverse: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScanningMode = ref.watch(scanningModeProvider);
    final selectedMenuItem = ref.watch(selectedMenuItemProvider);
    final scaffoldKey = useMemoized(GlobalKey<ScaffoldState>.new);

    if (selectedMenuItem == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: buildMainContent(isScanningMode, ref)),
        ],
      );
    }

    if (selectedMenuItem == 2) {
      return buildMainContent(isScanningMode, ref);
    }

    // Sales (0 / default): require open shift before any POS interaction.
    final salesBody = () {
      if (isScanningMode) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: buildMainContent(isScanningMode, ref)),
            buildProductSection(ref),
          ],
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final useCartDrawer = constraints.maxWidth <
              PosLayoutBreakpoints.desktopSplitMinWidth;

          if (!useCartDrawer) {
            return ColoredBox(
              color: PosTokens.posBg,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildProductSection(ref),
                  Expanded(child: buildMainContent(isScanningMode, ref)),
                ],
              ),
            );
          }

          final drawerWidth =
              PosLayoutBreakpoints.cartDrawerWidth(constraints.maxWidth);

          return Scaffold(
            key: scaffoldKey,
            backgroundColor: PosTokens.posBg,
            body: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildProductSection(ref),
              ],
            ),
            endDrawer: Drawer(
              width: drawerWidth,
              child: Material(
                color: Colors.white,
                child: SafeArea(
                  child: buildMainContent(isScanningMode, ref),
                ),
              ),
            ),
            floatingActionButton: _CartFab(
              onPressed: () => scaffoldKey.currentState?.openEndDrawer(),
              isNarrow: constraints.maxWidth < 360,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      );
    }();

    return PosShiftGate(child: salesBody);
  }
}

class _CartFab extends ConsumerWidget {
  const _CartFab({required this.onPressed, required this.isNarrow});

  final VoidCallback onPressed;
  final bool isNarrow;

  static const _blue = Color(0xFF1D4ED8); // blue[700]
  static const _radius = BorderRadius.all(Radius.circular(4));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count =
        ref.watch(posCartSummaryProvider.select((s) => s.unitQtyTotal));

    final icon = Badge(
      isLabelVisible: count > 0,
      label: Text('$count'),
      child: const Icon(Icons.shopping_cart_outlined,
          color: Colors.white, size: 22),
    );

    if (isNarrow) {
      return Material(
        color: _blue,
        borderRadius: _radius,
        child: InkWell(
          onTap: onPressed,
          borderRadius: _radius,
          splashColor: Colors.blue.withValues(alpha: 0.3),
          child: SizedBox(width: 56, height: 56, child: Center(child: icon)),
        ),
      );
    }

    return Material(
      color: _blue,
      borderRadius: _radius,
      child: InkWell(
        onTap: onPressed,
        borderRadius: _radius,
        splashColor: Colors.blue.withValues(alpha: 0.3),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 10),
              Text(
                count > 0 ? 'Cart ($count)' : 'Cart',
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
