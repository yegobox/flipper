import 'dart:async';

import 'package:badges/badges.dart' as badges;
import 'package:flipper_dashboard/AddProductDialog.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/BranchPerformance.dart';
import 'package:flipper_dashboard/BulkAddProduct.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/responsive_layout.dart' as responsive;
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_dashboard/umusada_helper.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flipper_dashboard/widgets/pos_top_bar_widgets.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';

/// Left cluster of the desktop POS top bar (handoff): logo + tools.
class PosDesktopTopLeading extends StatefulHookConsumerWidget {
  final TextEditingController searchController;

  const PosDesktopTopLeading({super.key, required this.searchController});

  @override
  ConsumerState<PosDesktopTopLeading> createState() =>
      _PosDesktopTopLeadingState();
}

class _PosDesktopTopLeadingState extends ConsumerState<PosDesktopTopLeading> {
  final _routerService = locator<RouterService>();
  final _dialogService = locator<DialogService>();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onText);
    _hasText = widget.searchController.text.isNotEmpty;
  }

  @override
  void didUpdateWidget(covariant PosDesktopTopLeading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchController != widget.searchController) {
      oldWidget.searchController.removeListener(_onText);
      widget.searchController.addListener(_onText);
      _hasText = widget.searchController.text.isNotEmpty;
    }
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_onText);
    super.dispose();
  }

  void _onText() {
    final next = widget.searchController.text.isNotEmpty;
    if (next != _hasText && mounted) setState(() => _hasText = next);
  }

  void _openAppPicker() {
    _dialogService.showCustomDialog(
      variant: DialogType.appChoice,
      title: 'Choose Your Default App',
    );
  }

  void _openBranchPerformance() {
    showDialog<void>(
      barrierDismissible: true,
      context: context,
      builder: (_) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: SizedBox(
                    width: double.infinity,
                    child: BranchPerformance(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleOrders() {
    UmusadaHelper.handleOrderingFlow(context, () {
      try {
        ProxyService.box.writeBool(key: 'isOrdering', value: true);
        _routerService.navigateTo(OrdersRoute());
      } catch (e) {
        debugPrint('$e');
      }
    });
  }

  Widget _cartTool(int count) {
    final button = PosTopToolButton(
      iconName: 'cart',
      tooltip: 'Orders',
      onPressed: _toggleOrders,
    );
    if (count <= 0) return button;
    return badges.Badge(
      showBadge: true,
      position: badges.BadgePosition.topEnd(top: 4, end: 4),
      badgeContent: Text(
        count.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 9),
      ),
      child: button,
    );
  }

  @override
  Widget build(BuildContext context) {
    final stringValue = ref.watch(searchStringProvider);
    final isAutoAdd = ref.watch(autoAddSearchProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        PosHandoffIcons.svg('flipper-logo', size: 30),
        const SizedBox(width: 11),
        const Text(
          'FLIPPER',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: PosTokens.ink1,
            letterSpacing: -0.01,
          ),
        ),
        const SizedBox(width: 11),
        const Text(
          'Point of Sale',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: PosTokens.ink3,
          ),
        ),

        PosTopToolButton(
          iconName: 'barcode',
          tooltip: 'Toggle scan mode',
          isActive: isAutoAdd,
          onPressed: () => ref.read(autoAddSearchProvider.notifier).toggle(),
        ),
        Consumer(
          builder: (context, ref, _) {
            final orders = ref.watch(
              stockRequestsProvider(
                status: RequestStatus.pending,
                search: stringValue.isNotEmpty ? stringValue : null,
              ),
            );
            return orders.when(
              data: (list) => _cartTool(list.length),
              loading: () => _cartTool(0),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        ),
        PosTopToolButton(
          iconName: 'monitor',
          tooltip: 'Locations',
          onPressed: _openBranchPerformance,
        ),
        if (_hasText)
          Tooltip(
            message: 'Clear search',
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (!ref.read(toggleProvider)) {
                    ref
                        .read(searchStringProvider.notifier)
                        .emitString(value: '');
                  }
                  widget.searchController.clear();
                  setState(() => _hasText = false);
                },
                borderRadius: BorderRadius.circular(PosTokens.radiusSm),
                hoverColor: PosTokens.surface2,
                child: const SizedBox(
                  width: 38,
                  height: 38,
                  child: Icon(Icons.close, size: 20, color: PosTokens.ink2),
                ),
              ),
            ),
          )
        else
          PosTopToolButton(
            iconName: 'plus',
            tooltip: 'Add product',
            onPressed: () => unawaited(_openAddProduct()),
          ).eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
      ],
    );
  }

  Future<void> _openAddProduct() async {
    final settingsService = ProxyService.settings;
    if (settingsService.isAdminPinEnabled) {
      final setting = await settingsService.settings();
      final confirmed = await showAdminPinDialog(
        context: context,
        mode: AdminPinMode.verify,
        expectedPin: setting?.adminPin,
      );
      if (confirmed != true || !mounted) return;
    }

    final rootContext = context;
    showDialog<void>(
      barrierDismissible: true,
      context: rootContext,
      builder: (dialogContext) => AddProductDialog(
        onChoiceSelected: (choice) {
          if (choice == 'bulk') {
            showDialog<void>(
              barrierDismissible: true,
              context: rootContext,
              builder: (context) => OptionModal(child: BulkAddProduct()),
            );
          } else if (choice == 'single') {
            Navigator.of(dialogContext).maybePop();

            final isPhone =
                responsive.ResponsiveLayout.isPhone(rootContext) ||
                responsive.ResponsiveLayout.isTinyLimit(rootContext);

            if (isPhone) {
              Navigator.of(rootContext).push(
                MaterialPageRoute<void>(
                  builder: (ctx) => Scaffold(
                    appBar: AppBar(
                      title: const Text('Add New Product'),
                      leading: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(ctx).maybePop(),
                      ),
                    ),
                    body: const SafeArea(child: ProductEntryScreen()),
                  ),
                ),
              );
            } else {
              showDialog<void>(
                barrierDismissible: true,
                context: rootContext,
                builder: (context) => OptionModal(child: ProductEntryScreen()),
              );
            }
          }
        },
      ),
    );
  }
}
