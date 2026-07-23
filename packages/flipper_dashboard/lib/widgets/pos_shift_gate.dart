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

/// Blocks POS Sales until an open shift exists.
///
/// Shows an intentional full-panel CTA (not a floating startup dialog).
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
    final shiftAsync = ref.watch(currentOpenShiftProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
  }
}
