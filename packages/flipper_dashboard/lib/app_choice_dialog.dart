import 'package:flipper_dashboard/layout.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'dart:ui';

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
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 520,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white.withValues(alpha: 0.95),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Section
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 32, 32, 24),
                      child: Column(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF007AFF),
                                  Color(0xFF5AC8FA),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF007AFF)
                                      .withValues(alpha: .3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.apps_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.request.title ?? 'Choose Default App',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D1D1F),
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Select your preferred application to launch',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Apps Grid Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildAppTile(
                                  context: context,
                                  title: 'POS',
                                  subtitle: 'Point of Sale',
                                  description: 'Process transactions',
                                  icon: Icons.point_of_sale_rounded,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF007AFF),
                                      Color(0xFF5AC8FA)
                                    ],
                                  ),
                                  onTap: () => _handleAppSelection(
                                      'POS', DashboardPage.inventory),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildAppTile(
                                  context: context,
                                  title: 'Reports',
                                  subtitle: 'Analytics',
                                  description: 'Business insights',
                                  icon: Icons.analytics_rounded,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFAF52DE),
                                      Color(0xFFFF2D92)
                                    ],
                                  ),
                                  onTap: () => _handleAppSelection(
                                      'Reports', DashboardPage.reports),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildAppTile(
                                  context: context,
                                  title: 'Orders',
                                  subtitle: 'Management',
                                  description: 'Handle orders',
                                  icon: Icons.shopping_cart_rounded,
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFFF9500),
                                      Color(0xFFFF6B35)
                                    ],
                                  ),
                                  onTap: () => _handleAppSelection(
                                      'Orders', DashboardPage.orders),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                  child:
                                      Container()), // Empty space for symmetry
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Footer Section
                    Container(
                      padding: const EdgeInsets.fromLTRB(32, 20, 32, 32),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade200,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFooterButton(
                            text: 'Cancel',
                            isPrimary: false,
                            onPressed: () => widget
                                .completer(DialogResponse(confirmed: false)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
    required String description,
    required IconData icon,
    required LinearGradient gradient,
    required Future<void> Function() onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.8 + (0.2 * value),
          child: Opacity(
            opacity: value,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 120,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: gradient,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color:
                                  gradient.colors.first.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D1D1F),
                          letterSpacing: -0.1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooterButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor:
              isPrimary ? const Color(0xFF007AFF) : Colors.grey.shade100,
          foregroundColor: isPrimary ? Colors.white : Colors.grey.shade700,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Future<void> _handleAppSelection(String appName, DashboardPage page) async {
    try {
      await ProxyService.box.writeString(key: 'defaultApp', value: appName);
      ref.read(selectedPageProvider.notifier).state = page;

      widget.completer(DialogResponse(
        confirmed: true,
        data: {'defaultApp': appName},
      ));
    } catch (e) {
      // Handle error if needed
      debugPrint('Error saving app selection: $e');
    }
  }
}
