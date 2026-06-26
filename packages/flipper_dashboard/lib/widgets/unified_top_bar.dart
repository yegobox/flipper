import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_dashboard/notice.dart';
import 'package:flipper_dashboard/ribbon.dart';
import 'package:flipper_dashboard/widgets/connected_peers_widget.dart';
import 'package:flipper_dashboard/widgets/pos_desktop_top_leading.dart';
import 'package:flipper_dashboard/widgets/pos_top_bar_widgets.dart';
import 'package:flipper_dashboard/widgets/user_info_widget.dart';
import 'package:flipper_models/providers/notice_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/notice.model.dart';

/// Desktop top bar: ribbon nav + account controls on every page.
/// The shell ([DashboardLayout]) draws the logo column so this row aligns with
/// the sidebar logo on every page. Product search lives in [ProductView], not here.
class UnifiedTopBar extends ConsumerWidget {
  const UnifiedTopBar({Key? key}) : super(key: key);

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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isInventoryShell)
            const Expanded(child: PosDesktopTopLeading())
          else
            const Spacer(),
          const IconRow(),
          _posNoticeBell(context, ref),
          const ConnectedPeersWidget(handoffTopBarStyle: true),
          const UserInfoWidget(handoffTopBarStyle: true),
        ],
      ),
    );
  }
}
