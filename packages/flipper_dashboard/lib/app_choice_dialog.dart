import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class AppChoiceDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const AppChoiceDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 24,
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF0078D4), // Microsoft Blue
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.apps_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.title ?? 'Choose Default App',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Select your preferred application to launch',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(24),
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: [
                  _buildAppOption(
                    context: context,
                    title: 'POS (Point of Sale)',
                    subtitle: 'Process transactions and manage sales',
                    icon: Icons.point_of_sale,
                    color: const Color(0xFF0078D4),
                    onTap: () => completer(DialogResponse(
                      confirmed: true,
                      data: {'defaultApp': 'POS'},
                    )),
                  ),
                  _buildAppOption(
                    context: context,
                    title: 'Inventory',
                    subtitle: 'Track stock levels and manage products',
                    icon: Icons.inventory_2,
                    color: const Color(0xFF107C10),
                    onTap: () => completer(DialogResponse(
                      confirmed: true,
                      data: {'defaultApp': 'Inventory'},
                    )),
                  ),
                  _buildAppOption(
                    context: context,
                    title: 'Reports',
                    subtitle: 'View analytics and business insights',
                    icon: Icons.analytics,
                    color: const Color(0xFF8764B8),
                    onTap: () => completer(DialogResponse(
                      confirmed: true,
                      data: {'defaultApp': 'Reports'},
                    )),
                  ),
                  _buildAppOption(
                    context: context,
                    title: 'Orders',
                    subtitle: 'Manage incoming orders',
                    icon: Icons.shopping_cart,
                    color: const Color(0xFF8764B8),
                    onTap: () => completer(DialogResponse(
                      confirmed: true,
                      data: {'defaultApp': 'Orders'},
                    )),
                  ),
                  _buildAppOption(
                    context: context,
                    title: 'Settings',
                    subtitle: 'Configure app preferences and account',
                    icon: Icons.settings,
                    color: const Color(0xFF6B6B6B),
                    onTap: () => completer(DialogResponse(
                      confirmed: true,
                      data: {'defaultApp': 'Settings'},
                    )),
                  ),
                ],
              ),
            ),

            // Footer Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        completer(DialogResponse(confirmed: false)),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF323130),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
