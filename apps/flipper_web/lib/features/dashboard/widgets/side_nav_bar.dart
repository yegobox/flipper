import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/dashboard/widgets/branch_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideNavBar extends ConsumerWidget {
  const SideNavBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the selected branch
    final selectedBranch = ref.watch(selectedBranchProvider);

    return Container(
      width: 250,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .05),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile dropdown menu
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: InkWell(
              onTap: () {
                showBranchSelectionDialog(context, ref);
              },
              child: Row(
                children: [
                  // User avatar/icon
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(
                      Icons.person_outline,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // User info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedBranch?.name ?? 'No Branch Selected',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Dropdown arrow
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 24,
                    color: Colors.grey[600],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Search box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.search, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Navigation items
          _buildNavItem(
            Icons.dashboard_outlined,
            'Dashboard',
            isSelected: true,
          ),
          _buildNavItem(Icons.shopping_bag_outlined, 'Products'),
          _buildNavItem(Icons.receipt_outlined, 'Orders'),
          _buildNavItem(Icons.people_outline, 'Customers'),
          _buildNavItem(Icons.analytics_outlined, 'Analytics'),
          _buildNavItem(Icons.settings_outlined, 'Settings'),

          const Spacer(),

          // Take Payment Button
          ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.payment_outlined,
              size: 18,
              color: Colors.grey[800],
            ),
            label: Text(
              'Take payment',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey.shade100,
              elevation: 0,
              minimumSize: const Size(double.infinity, 40),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Bottom Icons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(Icons.notifications_none, color: Colors.grey[600], size: 22),
              Icon(Icons.list_alt, color: Colors.grey[600], size: 22),
              Icon(Icons.help_outline, color: Colors.grey[600], size: 22),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, {bool isSelected = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFE7F2FD) : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -1),
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF2196F3) : Colors.grey[700],
          size: 22,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? const Color(0xFF2196F3) : Colors.black87,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        onTap: () {},
      ),
    );
  }
}
