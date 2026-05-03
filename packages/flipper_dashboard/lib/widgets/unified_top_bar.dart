import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flipper_dashboard/widgets/connected_peers_widget.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Must match [EnhancedSideMenu] width so the product search lines up with the
/// main content column (POS fields, etc.).
const double _kSideMenuWidth = 80.0;

/// Horizontal inset of the search field from the content column edge — keep in
/// sync with [PosDefaultView] horizontal padding around the cart body.
const double _kContentSearchLeadingInset = 8.0;

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
        padding: EdgeInsets.fromLTRB(
          isMultiUserEnabled ? 0 : 16,
          8,
          16,
          8,
        ),
        child: Row(
          children: [
            if (isMultiUserEnabled) ...[
              // Rail aligns with [EnhancedSideMenu]; search then starts above
              // the same column as POS / inventory content.
              SizedBox(
                width: _kSideMenuWidth,
                child: _buildLogoRail(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: _kContentSearchLeadingInset,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 200),
                    child: SearchFieldWidget(controller: searchController),
                  ),
                ),
              ),
            ] else ...[
              _buildLogo(),
              const SizedBox(width: 24),
              Expanded(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 200),
                  child: SearchFieldWidget(controller: searchController),
                ),
              ),
            ],
            const SizedBox(width: 24),

            // Right section: Flexible so it can shrink when space is tight
            // (e.g. on narrower Windows windows). IconRow scrolls horizontally
            // instead of stealing width from the search bar.
            if (isMultiUserEnabled)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: const IconRow(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const ConnectedPeersWidget(),
                    const SizedBox(width: 16),
                    const UserInfoWidget(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Compact brand stack for the rail so the search can align with content.
  Widget _buildLogoRail(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/logo.png',
            package: 'flipper_dashboard',
            width: 28,
            height: 28,
          ),
          const SizedBox(height: 2),
          Text(
            'FLIPPER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.black87.withValues(alpha: 0.85),
              letterSpacing: 0.6,
              height: 1.0,
            ),
          ),
        ],
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
