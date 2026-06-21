import 'package:flipper_web/core/ditto/accounting_cloud_sync.dart';
import 'package:flipper_web/core/ditto/ditto_bootstrap.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/theme/accounting_tokens.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Re-pulls GL/POS from Ditto cloud without signing out (web stale-tab recovery).
final accountingCloudRefreshProvider = FutureProvider.autoDispose<void>((ref) async {
  debugPrint('[Accounting] manual refresh from cloud');
  resetAccountingCloudSubscriptionKeys();
  invalidateAccountingDataStreams(ref);
  ref.invalidate(accountingRepositoryProvider);
  ref.invalidate(accountingLedgerRepositoryProvider);
  ref.invalidate(accountingPostSyncBootstrapProvider);

  if (!ref.read(dittoReadyProvider)) {
    await DittoBootstrap.kickoffIfNeeded(ref);
  }

  final profile = ref.read(userProfileCacheProvider);
  if (profile != null && DittoService.instance.isCloudReady()) {
    try {
      await ref.read(userRepositoryProvider).syncProfileToDittoCloud(profile);
    } catch (e) {
      debugPrint('[Accounting] profile re-sync during refresh: $e');
    }
  }

  await ref.read(accountingPostSyncBootstrapProvider.future);
});

Future<bool> confirmBooksSignOut(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(
        'Sign out?',
        style: AccountingTokens.sans(fontWeight: FontWeight.w700),
      ),
      content: Text(
        'Ends your session and clears Ditto sync for this tab. '
        'Choose “Refresh from cloud” if you only need to reload Books data.',
        style: AccountingTokens.sans(fontSize: 14, color: AccountingTokens.ink2),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Sign out'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

Future<void> signOutFromBooks(BuildContext context, WidgetRef ref) async {
  if (!await confirmBooksSignOut(context)) return;
  await ref.read(authServiceProvider).signOut();
  if (context.mounted) {
    context.goNamed(AppRoute.login.name);
  }
}

enum AccountingAccountMenuAction { refresh, signOut }

Future<AccountingAccountMenuAction?> showAccountingAccountMenu(
  BuildContext context, {
  required Offset position,
}) {
  return showMenu<AccountingAccountMenuAction>(
    context: context,
    position: RelativeRect.fromLTRB(
      position.dx,
      position.dy,
      position.dx + 1,
      position.dy + 1,
    ),
    items: const [
      PopupMenuItem(
        value: AccountingAccountMenuAction.refresh,
        child: ListTile(
          leading: Icon(Icons.cloud_sync_outlined, size: 20),
          title: Text('Refresh from cloud'),
          subtitle: Text('Re-sync Ditto data'),
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ),
      PopupMenuItem(
        value: AccountingAccountMenuAction.signOut,
        child: ListTile(
          leading: Icon(Icons.logout, size: 20),
          title: Text('Sign out'),
          contentPadding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
        ),
      ),
    ],
  );
}
