import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Unified top bar with SAP-style layout:
/// - Left: Logo/branding
/// - Center: Contextual search bar
/// - Right: Ribbon icons + User info
class UnifiedTopBar extends ConsumerWidget {
  final TextEditingController searchController;

  const UnifiedTopBar({Key? key, required this.searchController})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMultiUserEnabled = ProxyService.remoteConfig.isMultiUserEnabled();

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            // Left section: Logo/branding
            _buildLogo(),
            const SizedBox(width: 24),

            // Center section: Search bar
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SearchFieldWidget(controller: searchController),
              ),
            ),
            const SizedBox(width: 24),

            // Right section: Ribbon icons + User info
            if (isMultiUserEnabled) ...[
              const IconRow(),
              const SizedBox(width: 16),
              const UserInfoWidget(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/logo.png',
          package: 'flipper_dashboard',
          width: 32,
          height: 32,
        ),
        const SizedBox(width: 8),
        const Text(
          'FLIPPER',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
