import 'package:badges/badges.dart' as badges;
import 'package:flipper_dashboard/AddProductDialog.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';
import 'package:flipper_dashboard/BranchPerformance.dart';
import 'package:flipper_dashboard/BulkAddProduct.dart';
import 'package:flipper_dashboard/notice.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/responsive_layout.dart' as responsive;
import 'package:flipper_dashboard/umusada_helper.dart';
import 'package:flipper_models/helperModels/extensions.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/notice_provider.dart';
import 'package:flipper_models/providers/orders_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/notice.model.dart';

/// Left cluster of the desktop POS top bar: branding + "Point of Sale" + toolbar
/// icons (matches design: grid, notices, cart, monitor, add).
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

  Widget _noticesIcon(List<Notice> notices) {
    return badges.Badge(
      showBadge: notices.isNotEmpty,
      badgeContent: Text(
        notices.length.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      child: const Icon(Icons.notifications_outlined, color: Color(0xFF64748B)),
    );
  }

  Widget _orderIcon(int count) {
    return badges.Badge(
      showBadge: count > 0,
      badgeContent: Text(
        count.toString(),
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
      child: const Icon(FluentIcons.cart_24_regular, color: Color(0xFF64748B)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stringValue = ref.watch(searchStringProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo.png',
          package: 'flipper_dashboard',
          width: 26,
          height: 26,
        ),
        const SizedBox(width: 8),
        Text(
          'FLIPPER',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: Colors.black.withValues(alpha: 0.87),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 14),
        Text(
          'Point of Sale',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black.withValues(alpha: 0.72),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          tooltip: 'Apps',
          onPressed: _openAppPicker,
          icon: const Icon(Icons.grid_view_rounded, color: Color(0xFF64748B)),
        ),
        Consumer(
          builder: (context, ref, _) {
            final isAutoAdd = ref.watch(autoAddSearchProvider);
            return IconButton(
              tooltip: 'Toggle scan mode',
              onPressed: () {
                ref.read(autoAddSearchProvider.notifier).toggle();
              },
              icon: Icon(
                isAutoAdd
                    ? FluentIcons.barcode_scanner_24_filled
                    : FluentIcons.barcode_scanner_24_regular,
                color: isAutoAdd
                    ? PosLayoutBreakpoints.posAccentBlue
                    : const Color(0xFF64748B),
              ),
            );
          },
        ),
        Consumer(
          builder: (context, ref, _) {
            final notice = ref.watch(noticesProvider);
            return IconButton(
              tooltip: 'Notifications',
              onPressed: () => handleNoticeClick(context),
              icon: _noticesIcon(notice.value ?? []),
            );
          },
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
              data: (list) => IconButton(
                tooltip: 'Orders',
                onPressed: _toggleOrders,
                icon: _orderIcon(list.length),
              ),
              loading: () => IconButton(
                tooltip: 'Orders',
                onPressed: _toggleOrders,
                icon: _orderIcon(0),
              ),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        ),
        IconButton(
          tooltip: 'Locations',
          onPressed: _openBranchPerformance,
          icon: const Icon(
            FluentIcons.desktop_24_regular,
            color: Color(0xFF64748B),
          ),
        ),
        if (_hasText)
          IconButton(
            tooltip: 'Clear search',
            onPressed: () {
              if (!ref.read(toggleProvider)) {
                ref.read(searchStringProvider.notifier).emitString(value: '');
              }
              widget.searchController.clear();
              setState(() => _hasText = false);
            },
            icon: const Icon(
              FluentIcons.dismiss_24_regular,
              color: Color(0xFF64748B),
            ),
          )
        else
          IconButton(
            tooltip: 'Add product',
            onPressed: _openAddProduct,
            icon: const Icon(
              FluentIcons.add_20_regular,
              color: Color(0xFF64748B),
            ),
          ).eligibleToSeeIfYouAre(ref, [UserType.ADMIN]),
      ],
    );
  }

  void _openAddProduct() {
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
