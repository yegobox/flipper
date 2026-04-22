import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flipper_dashboard/widgets/connected_peers_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Unified top bar:
/// - Left: 80px rail-aligned logo (matches [EnhancedSideMenu])
/// - Center: contextual search
/// - Right: ribbon tabs + peers + user
class UnifiedTopBar extends ConsumerWidget {
  final TextEditingController searchController;

  const UnifiedTopBar({Key? key, required this.searchController})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
        child: Row(
          children: [
            SizedBox(
              width: PosLayoutBreakpoints.sideMenuWidth,
              child: _buildLogoRail(context),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: PosLayoutBreakpoints.contentSearchLeadingInset,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 200),
                  child: SearchFieldWidget(controller: searchController),
                ),
              ),
            ),
            const SizedBox(width: 16),
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
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: PosLayoutBreakpoints.posAccentBlue,
              letterSpacing: 0.8,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
