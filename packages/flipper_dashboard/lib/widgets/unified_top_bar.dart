import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/widgets/connected_peers_widget.dart';
import 'package:flipper_dashboard/widgets/pos_desktop_top_leading.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Desktop top bar: POS title + actions, ribbon tabs, peers + user.
/// The shell ([DashboardLayout]) draws the logo column and header chrome so this
/// row aligns with the sidebar logo.
class UnifiedTopBar extends ConsumerWidget {
  final TextEditingController searchController;

  const UnifiedTopBar({Key? key, required this.searchController})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(selectedPageProvider);
    final isInventoryShell = selectedPage == DashboardPage.inventory;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 12, 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: isInventoryShell
                  ? Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: PosDesktopTopLeading(
                                searchController: searchController,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: const IconRow(),
                            ),
                          ),
                        ),
                        const ConnectedPeersWidget(),
                        const SizedBox(width: 8),
                        const UserInfoWidget(),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: PosLayoutBreakpoints.contentSearchLeadingInset,
                            ),
                            child: SearchFieldWidget(
                              controller: searchController,
                            ),
                          ),
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: const IconRow(),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const ConnectedPeersWidget(),
                        const SizedBox(width: 8),
                        const UserInfoWidget(),
                      ],
                    ),
            ),
        ],
      ),
    );
  }
}
