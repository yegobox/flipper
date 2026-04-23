import 'package:badges/badges.dart' as badges;
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/notice.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/widgets/connected_peers_widget.dart';
import 'package:flipper_dashboard/widgets/pos_desktop_top_leading.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flipper_models/providers/notice_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/notice.model.dart';

/// Desktop top bar: POS title + actions, ribbon tabs, peers + user.
/// The shell ([DashboardLayout]) draws the logo column and header chrome so this
/// row aligns with the sidebar logo.
class UnifiedTopBar extends ConsumerWidget {
  final TextEditingController searchController;

  const UnifiedTopBar({Key? key, required this.searchController})
    : super(key: key);

  Widget _noticeBell(BuildContext context, WidgetRef ref) {
    final notice = ref.watch(noticesProvider);
    final notices = notice.value ?? <Notice>[];

    return IconButton(
      tooltip: 'Notifications',
      onPressed: () => handleNoticeClick(context),
      icon: badges.Badge(
        showBadge: notices.isNotEmpty,
        badgeContent: Text(
          notices.length.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        child: const Icon(
          Icons.notifications_outlined,
          color: Color(0xFF64748B),
        ),
      ),
    );
  }

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
                        _noticeBell(context, ref),
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
                        _noticeBell(context, ref),
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
