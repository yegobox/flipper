import 'package:flipper_models/helpers/pos_payment_role_tenant.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/sync/shift_sync.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/shift.model.dart';

/// Whether the current user has an open shift in Ditto.
final currentOpenShiftProvider =
    FutureProvider.autoDispose<Shift?>((ref) async {
  final userId = ProxyService.box.getUserId();
  if (userId == null) return null;
  return shiftSync.getCurrentShift(userId: userId);
});

/// Whether the signed-in user must open a shift before selling.
///
/// Only Cashiers work a shift — Admins, Owners, Managers, and other roles
/// are never blocked or prompted.
final requiresOpenShiftProvider = FutureProvider.autoDispose<bool>((ref) async {
  final userId = ProxyService.box.getUserId();
  if (userId == null) return false;
  final tenant = await ref.watch(tenantProvider(userId).future);
  return tenantIsCashier(tenant);
});

/// Blocks POS Sales until an open shift exists.
///
/// Only applies to Cashiers who can sell — view-only staff browse without a
/// shift, and Admins/Owners/Managers are never blocked. Shows an intentional
/// full-panel CTA (not a floating startup dialog).
class PosShiftGate extends ConsumerWidget {
  const PosShiftGate({super.key, required this.child});

  final Widget child;

  Future<void> _openStartShift(WidgetRef ref) async {
    final userId = ProxyService.box.getUserId();
    if (userId == null) return;

    final dialogService = locator<DialogService>();
    final response = await dialogService.showCustomDialog(
      variant: DialogType.startShift,
      title: 'Start New Shift',
    );
    if (response != null && response.confirmed) {
      ref.invalidate(currentOpenShiftProvider);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // View-only staff cannot sell, so they browse the catalog without needing
    // an open shift; the shift gate only applies to users who can transact.
    if (!ref.watch(canSellProvider)) return child;

    final requiresShiftAsync = ref.watch(requiresOpenShiftProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return requiresShiftAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      // Fail open — a role-lookup error shouldn't block a non-Cashier's sale.
      error: (_, __) => child,
      data: (requiresShift) {
        if (!requiresShift) return child;

        final shiftAsync = ref.watch(currentOpenShiftProvider);

        return shiftAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Could not load shift status',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('$e', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => ref.invalidate(currentOpenShiftProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
          data: (shift) {
            if (shift != null) return child;

            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        size: 56,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Start a shift to sell',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Open your cash drawer shift before ringing up sales. '
                        'You can also open a shift from the sidebar.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () => _openStartShift(ref),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Open Shift'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
