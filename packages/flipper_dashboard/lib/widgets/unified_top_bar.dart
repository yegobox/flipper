import 'package:badges/badges.dart' as badges;
import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/notice.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/SearchFieldWidget.dart';
import 'package:flipper_dashboard/widgets/connected_peers_widget.dart';
import 'package:flipper_dashboard/widgets/pos_desktop_top_leading.dart';
import 'package:flipper_dashboard/widgets/pos_top_bar_widgets.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flipper_models/providers/notice_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/notice.model.dart';

/// Desktop top bar: POS handoff layout on inventory, search + ribbon elsewhere.
/// The shell ([DashboardLayout]) draws the logo column so this row aligns with
/// the sidebar logo on every page.
class UnifiedTopBar extends ConsumerWidget {
  final TextEditingController searchController;

  const UnifiedTopBar({Key? key, required this.searchController})
    : super(key: key);

  Widget _posNoticeBell(BuildContext context, WidgetRef ref) {
    final notice = ref.watch(noticesProvider);
    final notices = notice.value ?? <Notice>[];
    final count = notices.length;

    return PosTopCircleIconButton(
      iconName: 'bell',
      tooltip: 'Notifications',
      badge: count > 0 ? count.toString() : null,
      onPressed: () => handleNoticeClick(context),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPage = ref.watch(selectedPageProvider);
    final isInventoryShell = selectedPage == DashboardPage.inventory;

    if (isInventoryShell) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const PosDesktopTopLeading(),
            const Spacer(),
            const IconRow(),
            _posNoticeBell(context, ref),
            const ConnectedPeersWidget(handoffTopBarStyle: true),
            const UserInfoWidget(handoffTopBarStyle: true),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 12, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Row(
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
                IconButton(
                  tooltip: 'Notifications',
                  onPressed: () => handleNoticeClick(context),
                  icon: badges.Badge(
                    showBadge: (ref.watch(noticesProvider).value ?? [])
                        .isNotEmpty,
                    badgeContent: Text(
                      (ref.watch(noticesProvider).value ?? []).length
                          .toString(),
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
