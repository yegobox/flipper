import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';

class AppChoiceDialog extends StatefulHookConsumerWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AppChoiceDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  _AppChoiceDialogState createState() => _AppChoiceDialogState();
}

class _AppChoiceDialogState extends ConsumerState<AppChoiceDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  late final List<_AppChoiceItem> _apps = [
    _AppChoiceItem(
      id: 'POS',
      title: 'POS',
      subtitle: 'Point of Sale',
      iconSvg: DashboardQuickAccessSvgs.appSwitcherPosIcon(),
      iconBg: const Color.fromRGBO(24, 95, 165, 0.10),
      onSelect: () => _handleAppSelection('POS', DashboardPage.inventory),
    ),
    _AppChoiceItem(
      id: 'Reports',
      title: 'Reports',
      subtitle: 'Analytics',
      iconSvg: DashboardQuickAccessSvgs.appSwitcherReportsIcon(),
      iconBg: const Color.fromRGBO(83, 74, 183, 0.10),
      onSelect: () => _handleAppSelection('Reports', DashboardPage.reports),
    ),
    _AppChoiceItem(
      id: 'Orders',
      title: 'Orders',
      subtitle: 'Management',
      iconSvg: DashboardQuickAccessSvgs.appSwitcherOrdersIcon(),
      iconBg: const Color.fromRGBO(133, 79, 11, 0.10),
      onSelect: () => _handleAppSelection('Orders', DashboardPage.orders),
    ),
    _AppChoiceItem(
      id: 'Inventory',
      title: 'Inventory',
      subtitle: 'Stock tracking',
      iconSvg: DashboardQuickAccessSvgs.appSwitcherInventoryIcon(),
      iconBg: const Color.fromRGBO(59, 109, 17, 0.10),
      onSelect: () => _handleAppSelection('Inventory', DashboardPage.inventory),
    ),
    _AppChoiceItem(
      id: 'Customers',
      title: 'Customers',
      subtitle: 'CRM',
      iconSvg: DashboardQuickAccessSvgs.appSwitcherCustomersIcon(),
      iconBg: const Color.fromRGBO(153, 53, 86, 0.10),
      onSelect: () => _handleAppSelection('Customers', null),
    ),
    _AppChoiceItem(
      id: 'Settings',
      title: 'Settings',
      subtitle: 'Configuration',
      iconSvg: DashboardQuickAccessSvgs.appSwitcherSettingsIcon(),
      iconBg: const Color.fromRGBO(95, 94, 90, 0.10),
      onSelect: () => _handleAppSelection('Settings', null),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeOutBack,
    );
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentDefaultApp = ProxyService.box.getDefaultApp() ?? 'POS';
    final activeItem = _apps
        .where((a) => a.id == currentDefaultApp)
        .cast<_AppChoiceItem?>()
        .firstWhere((a) => a != null, orElse: () => null);

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WORKSPACE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: Colors.black.withValues(alpha: 0.55),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Switch app',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Colors.black.withValues(alpha: 0.90),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          widget.completer(DialogResponse(confirmed: false)),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: const Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final w = constraints.maxWidth;
                    final crossAxisCount = w >= 560 ? 3 : 2;

                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        // Use a fixed height to avoid pixel-overflow across
                        // platforms/fonts (some tiles have an extra "Active" row).
                        mainAxisExtent: 160,
                      ),
                      itemCount: _apps.length,
                      itemBuilder: (context, idx) {
                        final item = _apps[idx];
                        final isActive = item.id == currentDefaultApp;
                        return _AppChoiceTile(
                          item: item,
                          isActive: isActive,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 18),
                const Divider(height: 1, color: Color(0xFFE5E7EB)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Currently in: ${activeItem?.title ?? currentDefaultApp}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black.withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAppSelection(String appName, DashboardPage? page) async {
    try {
      await ProxyService.box.writeString(key: 'defaultApp', value: appName);
      if (page != null) {
        ref.read(selectedPageProvider.notifier).state = page;
      }

      widget.completer(
        DialogResponse(confirmed: true, data: {'defaultApp': appName}),
      );
    } catch (e) {
      debugPrint('Error saving app selection: $e');
    }
  }
}

class _AppChoiceItem {
  final String id;
  final String title;
  final String subtitle;
  final String iconSvg;
  final Color iconBg;
  final Future<void> Function() onSelect;

  const _AppChoiceItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.iconSvg,
    required this.iconBg,
    required this.onSelect,
  });
}

class _AppChoiceTile extends StatelessWidget {
  final _AppChoiceItem item;
  final bool isActive;

  const _AppChoiceTile({
    required this.item,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isActive ? const Color(0xFF16A34A) : const Color(0xFFE5E7EB);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.onSelect,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: isActive ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.string(
                    item.iconSvg,
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withValues(alpha: 0.88),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withValues(alpha: 0.55),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (isActive) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF16A34A),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Active',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF16A34A),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
