import 'package:flipper_dashboard/layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Container(
            padding: const EdgeInsets.all(24),
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
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.apps_rounded,
                        color: Color(0xFF007AFF),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.request.title ?? 'Choose Default App',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          widget.completer(DialogResponse(confirmed: false)),
                      icon: const Icon(Icons.close),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Select your preferred application to launch',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Apps Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildAppTile(
                        context: context,
                        title: 'POS',
                        subtitle: 'Point of Sale',
                        icon: Icons.point_of_sale_rounded,
                        color: const Color(0xFF007AFF),
                        onTap: () =>
                            _handleAppSelection('POS', DashboardPage.inventory),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildAppTile(
                        context: context,
                        title: 'Reports',
                        subtitle: 'Analytics',
                        icon: Icons.analytics_rounded,
                        color: const Color(0xFFAF52DE),
                        onTap: () => _handleAppSelection(
                          'Reports',
                          DashboardPage.reports,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildAppTile(
                        context: context,
                        title: 'Orders',
                        subtitle: 'Management',
                        icon: Icons.shopping_cart_rounded,
                        color: const Color(0xFFFF9500),
                        onTap: () =>
                            _handleAppSelection('Orders', DashboardPage.orders),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Future<void> Function() onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D1D1F),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleAppSelection(String appName, DashboardPage page) async {
    try {
      await ProxyService.box.writeString(key: 'defaultApp', value: appName);
      ref.read(selectedPageProvider.notifier).state = page;

      widget.completer(
        DialogResponse(confirmed: true, data: {'defaultApp': appName}),
      );
    } catch (e) {
      debugPrint('Error saving app selection: $e');
    }
  }
}
