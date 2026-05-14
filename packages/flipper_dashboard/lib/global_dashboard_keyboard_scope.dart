import 'dart:async';

import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Copy the current pending sale transaction summary to the clipboard.
///
/// Bound globally from [GlobalDashboardKeyboardScope]; add more intents next
/// to this class and merge them into [shortcuts].
class CopyPendingTransactionIntent extends Intent {
  const CopyPendingTransactionIntent();
}

/// Default dashboard-level shortcuts. Merge with feature-specific maps when
/// you add more actions.
final Map<ShortcutActivator, Intent> globalDashboardShortcutShortcuts = {
  // Avoid plain Ctrl/Cmd+C — reserve Shift so normal text copy still works.
  const SingleActivator(LogicalKeyboardKey.keyT, control: true, shift: true):
      CopyPendingTransactionIntent(),
  const SingleActivator(LogicalKeyboardKey.keyT, meta: true, shift: true):
      CopyPendingTransactionIntent(),
};

/// Wraps the dashboard shell with app-wide [Shortcuts] / [Actions].
class GlobalDashboardKeyboardScope extends StatelessWidget {
  GlobalDashboardKeyboardScope({
    super.key,
    required this.child,
    Map<ShortcutActivator, Intent>? shortcuts,
    this.extraActions = const {},
  }) : shortcuts = shortcuts ?? globalDashboardShortcutShortcuts;

  final Widget child;

  /// Override or extend the default shortcut table.
  final Map<ShortcutActivator, Intent> shortcuts;

  /// Additional [Action]s keyed by [Intent] type (merged over defaults).
  final Map<Type, Action<Intent>> extraActions;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (ctx) {
        final defaultActions = <Type, Action<Intent>>{
          CopyPendingTransactionIntent: CallbackAction<CopyPendingTransactionIntent>(
            onInvoke: (_) {
              unawaited(_copyPendingSaleTransaction(ctx));
              return null;
            },
          ),
        };
        return Shortcuts(
          shortcuts: shortcuts,
          child: Actions(
            actions: {...defaultActions, ...extraActions},
            child: child,
          ),
        );
      },
    );
  }
}

Future<void> _copyPendingSaleTransaction(BuildContext context) async {
  final text =
      await ProxyService.globalAppShortcuts.buildPendingSaleTransactionClipboardText();
  await Clipboard.setData(ClipboardData(text: text));
  if (!context.mounted) return;
  showSuccessNotification(
    context,
    'Pending transaction copied to clipboard',
    duration: const Duration(seconds: 2),
  );
}
